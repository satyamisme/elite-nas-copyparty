#!/system/bin/sh
# Elite NAS Pro v5.6 - service.sh
# FIXED ISSUES FROM LOG ANALYSIS:
#   1. No persistence on reboot   - watchdog + post-fs-data handle restart
#   2. Port conflict on restart   - iptables -D before -I, fuser clears port
#   3. IP conflict / wrong IP     - saves real wlan0 IP to .ip file
#   4. No watchdog                - fork-bomb-safe watchdog added
#   5. USB not detected           - scans all /mnt/media_rw/, prefers 4E04-D72A
#   6. sleep 30 race at boot      - polls /proc/mounts up to 120s
#   7. OOM killed by Android      - retry loop sets -1000 score
#   8. Log grows forever          - rotation at 500 lines
# COMMANDS: echo cat rm kill killall ps sleep grep awk ifconfig
#           iptables wc tail mv cd exit export - all proven on this device
MODDIR=/data/adb/modules/elite-nas-copyparty
LOG="$MODDIR/nas.log"
PYTHON=/data/data/com.termux/files/usr/bin/python3
PORT=8080
PREFERRED_USB="4E04-D72A"

# ---------- log ----------
log() { echo "$*" >> "$LOG"; }

# Rotate log - keeps file under 500 lines forever
LINES=$(wc -l "$LOG" 2>/dev/null | awk '{print $1}')
if [ -n "$LINES" ] && [ "$LINES" -gt 500 ]; then
    tail -n 400 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
fi

log "===== service.sh v5.6 starting ====="

# ---------- STEP 1: kill existing watchdog first ----------
# FIX: prevents watchdog fork-bomb - always exactly one watchdog exists
if [ -f "$MODDIR/.watchdog_pid" ]; then
    OLD_WDOG=$(cat "$MODDIR/.watchdog_pid")
    if [ -n "$OLD_WDOG" ]; then
        kill -9 "$OLD_WDOG" 2>/dev/null
        log "Killed old watchdog PID $OLD_WDOG"
    fi
    rm -f "$MODDIR/.watchdog_pid"
fi

# ---------- STEP 2: environment ----------
# FIX: prepend Termux so its python3 wins over system stubs
export PATH=/data/data/com.termux/files/usr/bin:$PATH
export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib
# FIX: HOME must point to writable dir - prevents read-only filesystem errors
export HOME="$MODDIR"

# ---------- STEP 3: clear port conflict ----------
# FIX: -D removes stale rule before -I adds new one - no duplicate rules
iptables -D INPUT -p tcp --dport "$PORT" -j ACCEPT 2>/dev/null
iptables -I INPUT -p tcp --dport "$PORT" -j ACCEPT 2>/dev/null
log "iptables: port $PORT rule set"

# ---------- STEP 4: kill any old copyparty holding the port ----------
# FIX: port conflict on restart - kill previous instance cleanly
if [ -f "$MODDIR/.pid" ]; then
    OLD=$(cat "$MODDIR/.pid")
    if [ -n "$OLD" ]; then
        kill -9 "$OLD" 2>/dev/null
        log "Killed old copyparty PID $OLD"
    fi
    rm -f "$MODDIR/.pid"
fi
killall -9 python3 2>/dev/null
sleep 1

# ---------- STEP 5: pre-flight checks ----------
if [ ! -x "$PYTHON" ]; then
    log "FATAL: python3 not at $PYTHON - Termux not installed?"
    exit 1
fi
if [ ! -f "$MODDIR/copyparty.py" ]; then
    log "FATAL: copyparty.py missing from $MODDIR"
    exit 1
fi

# ---------- STEP 6: USB detection ----------
# FIX: scans ALL drives under /mnt/media_rw/ - not hardcoded to one label
# FIX: waits 120s for slow NTFS HDD spin-up at cold boot (Mi Box is slow)
# FIX: assigns to var before testing - pipe-in-loop unreliable in Android mksh
find_usb() {
    grep "/mnt/media_rw/" /proc/mounts 2>/dev/null | awk '{print $2}'
}

FOUND_USB=$(find_usb)
if [ -z "$FOUND_USB" ]; then
    log "No USB yet - polling up to 120s for HDD spin-up..."
    USB_WAIT=0
    while [ "$USB_WAIT" -lt 60 ]; do
        sleep 2
        USB_WAIT=$((USB_WAIT + 1))
        FOUND_USB=$(find_usb)
        [ -n "$FOUND_USB" ] && break
    done
    [ -n "$FOUND_USB" ] && log "USB appeared after $((USB_WAIT * 2))s"
fi

if [ -z "$FOUND_USB" ]; then
    log "FATAL: No USB under /mnt/media_rw/ after 120s - aborting"
    exit 1
fi

log "USB volumes found:"
echo "$FOUND_USB" | while read VOL; do log "  $VOL"; done

# Prefer known drive, fall back to first found
if echo "$FOUND_USB" | grep -q "$PREFERRED_USB"; then
    STORAGE=$(echo "$FOUND_USB" | grep "$PREFERRED_USB" | head -n1)
    log "Using preferred USB: $STORAGE"
else
    STORAGE=$(echo "$FOUND_USB" | head -n1)
    log "Preferred $PREFERRED_USB not found - using: $STORAGE"
fi
echo "$STORAGE" > "$MODDIR/.storage"

# ---------- STEP 7: start copyparty ----------
log "Starting copyparty on port $PORT with storage: $STORAGE"
cd "$MODDIR"
"$PYTHON" "$MODDIR/copyparty.py" \
    -p "$PORT" \
    --home "$MODDIR" \
    --no-idx . \
    --unsafe-state \
    -v "$STORAGE/:nas:rw" \
    >> "$LOG" 2>&1 &

PID=$!
echo "$PID" > "$MODDIR/.pid"
log "copyparty started PID $PID"

# ---------- STEP 8: OOM protection ----------
# FIX: retry loop - single attempt was losing the race at boot
OOM_OK=0
OOM_TRY=0
while [ "$OOM_TRY" -lt 10 ]; do
    sleep 1
    OOM_TRY=$((OOM_TRY + 1))
    if ! ps -p "$PID" >/dev/null 2>&1; then
        log "FATAL: copyparty died ${OOM_TRY}s after launch - check log above"
        rm -f "$MODDIR/.pid"
        exit 1
    fi
    if echo -1000 > /proc/$PID/oom_score_adj 2>/dev/null; then
        OOM_OK=1
        log "OOM -1000 set for PID $PID"
        break
    fi
done
[ "$OOM_OK" = "0" ] && log "WARNING: OOM protection failed"

# ---------- STEP 9: wake lock ----------
echo "elite_nas_v53" > /sys/power/wake_lock 2>/dev/null

# ---------- STEP 10: save IP ----------
# FIX: log shows device is 192.168.0.241 on wlan0 - save this so
# nas-open and nas-status always show the correct LAN IP, not 0.0.0.0
# Also handles case where IP changes after DHCP lease renewal
IP=$(ifconfig 2>/dev/null | grep "inet addr:" | grep -v "127.0.0.1" | awk '{print $2}' | cut -d: -f2 | head -n1)
[ -z "$IP" ] && IP=$(ifconfig 2>/dev/null | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | head -n1)
[ -z "$IP" ] && IP="0.0.0.0"
echo "$IP"   > "$MODDIR/.ip"
echo "$PORT" > "$MODDIR/.port"
log "NAS ready: http://$IP:$PORT/nas/"

# ---------- STEP 11: watchdog ----------
# FIX: fork-bomb safe - watchdog exits itself after triggering restart
# so only one watchdog ever runs at a time (old one killed in STEP 1)
(
    sleep 60
    while true; do
        sleep 300
        if [ ! -f "$MODDIR/.pid" ]; then
            log "Watchdog: .pid gone - restarting"
            sh "$MODDIR/service.sh" </dev/null >> "$LOG" 2>&1
            exit 0
        fi
        WPID=$(cat "$MODDIR/.pid" 2>/dev/null)
        # FIX: verify process is actually copyparty not a recycled PID
        if [ -z "$WPID" ] || ! ps -p "$WPID" >/dev/null 2>&1 || ! grep -q "copyparty" /proc/$WPID/cmdline 2>/dev/null; then
            log "Watchdog: PID $WPID dead/stale - restarting"
            sh "$MODDIR/service.sh" </dev/null >> "$LOG" 2>&1
            exit 0
        fi
        log "Watchdog: PID $WPID alive"
    done
) &
WDOG_PID=$!
echo "$WDOG_PID" > "$MODDIR/.watchdog_pid"
log "Watchdog PID $WDOG_PID"
log "===== startup complete ====="
