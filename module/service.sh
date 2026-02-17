#!/system/bin/sh
# Elite NAS Pro v5.3 - Fixed: logging, OOM, watchdog
MODDIR=/data/adb/modules/elite-nas-copyparty
LOG="$MODDIR/nas.log"
PYTHON=/data/data/com.termux/files/usr/bin/python3

# Basic environment
export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib
export PATH=$PATH:/data/data/com.termux/files/usr/bin

# Rotate log so it never grows unbounded (keep last 500 lines)
if [ -f "$LOG" ] && [ "$(wc -l < "$LOG")" -gt 500 ]; then
    tail -n 400 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
fi

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"; }

log "--- service.sh starting ---"

# Firewall
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT 2>/dev/null \
    && log "iptables: port 8080 opened" \
    || log "iptables: WARNING - rule may not have applied"

# Kill any leftover instances cleanly
if [ -f "$MODDIR/.pid" ]; then
    OLD=$(cat "$MODDIR/.pid")
    if ps -p "$OLD" >/dev/null 2>&1; then
        kill -15 "$OLD" 2>/dev/null
        sleep 1
        ps -p "$OLD" >/dev/null 2>&1 && kill -9 "$OLD" 2>/dev/null
        log "Killed old instance PID $OLD"
    fi
    rm -f "$MODDIR/.pid"
fi
# Belt-and-suspenders: catch any strays not tracked by .pid
killall -9 python3 2>/dev/null
sleep 1

# Verify python3 is actually there before trying to start
if [ ! -x "$PYTHON" ]; then
    log "FATAL: python3 not found at $PYTHON - is Termux installed?"
    exit 1
fi

# Verify the storage is actually mounted
if ! mountpoint -q /mnt/media_rw/4E04-D72A 2>/dev/null; then
    log "WARNING: /mnt/media_rw/4E04-D72A does not appear to be mounted"
fi

# Start copyparty - stdout+stderr now go to nas.log
log "Starting copyparty..."
cd "$MODDIR"
"$PYTHON" "$MODDIR/copyparty.py" \
    -p 8080 \
    --home "$MODDIR" \
    --no-idx . \
    --unsafe-state \
    -v /mnt/media_rw/4E04-D72A/:nas:rw \
    >> "$LOG" 2>&1 &

PID=$!
echo "$PID" > "$MODDIR/.pid"
log "copyparty started with PID $PID"

# OOM Protection - retry loop because the process needs a moment to exist
# and the write must be done as root (which we are here via su/magisk)
OOM_SET=0
for i in 1 2 3 4 5; do
    sleep 1
    if ps -p "$PID" >/dev/null 2>&1; then
        if echo -1000 > /proc/$PID/oom_score_adj 2>/dev/null; then
            OOM_SET=1
            log "OOM protection set to -1000 for PID $PID (attempt $i)"
            break
        else
            log "OOM write attempt $i failed (permission?), retrying..."
        fi
    else
        log "FATAL: copyparty (PID $PID) died within ${i}s of starting - check log above"
        rm -f "$MODDIR/.pid"
        exit 1
    fi
done

[ "$OOM_SET" = "0" ] && log "WARNING: Could not set OOM protection - process may be killed under memory pressure"

# Wake lock
if echo "elite_nas_v53" > /sys/power/wake_lock 2>/dev/null; then
    log "Wake lock acquired"
else
    log "WARNING: Wake lock not acquired (may be OK on some kernels)"
fi

# Save IP and port for nas-open.sh
IP=$(ifconfig 2>/dev/null | grep "inet addr:" | grep -v "127.0.0.1" | awk '{print $2}' | cut -d: -f2 | head -n1)
[ -z "$IP" ] && IP=$(ifconfig 2>/dev/null | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | head -n1)
[ -n "$IP" ] && echo "$IP" > "$MODDIR/.ip" && log "IP saved: $IP"
echo "8080" > "$MODDIR/.port"

log "--- startup complete. NAS available at http://$IP:8080/nas/ ---"

# Watchdog - checks every 5 minutes after an initial 60s grace period
(
    sleep 60
    while true; do
        sleep 300
        if [ -f "$MODDIR/.pid" ]; then
            WPID=$(cat "$MODDIR/.pid")
            if ! ps -p "$WPID" >/dev/null 2>&1; then
                log "Watchdog: copyparty (PID $WPID) is dead - restarting"
                sh "$MODDIR/service.sh"
                exit 0
            fi
        else
            log "Watchdog: .pid file missing - restarting"
            sh "$MODDIR/service.sh"
            exit 0
        fi
    done
) &
echo $! > "$MODDIR/.watchdog_pid"
log "Watchdog started (PID $!)"
