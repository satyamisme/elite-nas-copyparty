#!/system/bin/sh
# Elite NAS Pro v5.5 - module-restart.sh
# Commands: echo, cat, kill, killall, ps, sleep, rm, sh - all proven
M="/data/adb/modules/elite-nas-copyparty"
BB="$M/busybox"
LOG="$M/nas.log"

log() { echo "$*" >> "$LOG"; }

echo "Stopping Elite NAS Pro..."
log "===== manual restart triggered ====="

# Stop watchdog first
if [ -f "$M/.watchdog_pid" ]; then
    WDOG=$(cat "$M/.watchdog_pid")
    if [ -n "$WDOG" ]; then
        kill -9 "$WDOG" 2>/dev/null
        log "Watchdog PID $WDOG stopped"
    fi
    rm -f "$M/.watchdog_pid"
fi

# Stop main process
if [ -f "$M/.pid" ]; then
    MPID=$(cat "$M/.pid")
    if [ -n "$MPID" ]; then
        kill -9 "$MPID" 2>/dev/null
        log "Main process PID $MPID stopped"
    fi
    rm -f "$M/.pid"
fi

# Clear state files so nas-status never shows a stale IP/URL while dead
rm -f "$M/.ip" "$M/.port" "$M/.storage" 2>/dev/null
log "State files cleared"

# Kill by port
PORT=$(cat "$M/.port" 2>/dev/null || echo "8080")
"$BB" fuser -k "${PORT}/tcp" 2>/dev/null && log "fuser: cleared port $PORT"

# Belt-and-suspenders
killall -9 python3 2>/dev/null

# Release wake lock
echo "elite_nas_v53" > /sys/power/wake_unlock 2>/dev/null

sleep 2
echo "Starting..."
log "Launching service.sh - will auto-detect USB"

sh "$M/service.sh" </dev/null &

# Wait long enough for OOM retry loop (up to 10s) + startup
sleep 15

if [ -f "$M/.pid" ] && ps -p "$(cat "$M/.pid")" >/dev/null 2>&1; then
    STORAGE=$(cat "$M/.storage" 2>/dev/null || echo "unknown")
    echo "NAS restarted OK."
    echo "PID:     $(cat "$M/.pid")"
    echo "Storage: $STORAGE"
    echo "URL:     http://$(cat "$M/.ip" 2>/dev/null || echo "?"):$PORT/nas/"
    log "Restart confirmed OK"
else
    echo "WARNING: NAS did not start. Check: tail -30 $LOG"
    log "WARNING: process not detected after restart"
fi
