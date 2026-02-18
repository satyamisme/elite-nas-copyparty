#!/system/bin/sh
# Elite NAS Pro v6.0 - nas-monitor.sh
MODDIR="/data/adb/modules/elite-nas-copyparty"
LOG="$MODDIR/nas.log"

while true; do
    sleep 300 # 5-minute cycle

    PID=$(cat "$MODDIR/.pid" 2>/dev/null)
    STORAGE=$(cat "$MODDIR/.storage" 2>/dev/null)

    # BUG #3 FIX: Detect Storage Loss
    if [ -n "$PID" ] && [ -n "$STORAGE" ]; then
        if ! grep -q "$STORAGE" /proc/mounts; then
            echo "[$(date)] MONITOR: USB LOST! Stopping NAS." >> "$LOG"
            killall -9 python3
            rm -f "$MODDIR/.pid"
            continue
        fi
    fi

    # BUG #5/9 FIX: Auto-Recovery if USB is present
    if [ -z "$PID" ] || ! ps -p "$PID" >/dev/null 2>&1; then
        if grep -q "/mnt/media_rw/" /proc/mounts; then
            echo "[$(date)] MONITOR: USB detected. Restarting NAS." >> "$LOG"
            sh "$MODDIR/service.sh"
        fi
    fi

    # BUG #1 FIX: Refresh IP
    NEW_IP=$(ifconfig 2>/dev/null | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -d: -f2 | head -n1)
    [ -n "$NEW_IP" ] && echo "$NEW_IP" > "$MODDIR/.ip"
done
