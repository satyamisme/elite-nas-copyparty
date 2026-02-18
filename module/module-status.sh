#!/system/bin/sh
# Elite NAS Pro v6.0 - module-status.sh
MODDIR="/data/adb/modules/elite-nas-copyparty"
IP=$(cat "$MODDIR/.ip" 2>/dev/null)
PID=$(cat "$MODDIR/.pid" 2>/dev/null)
PORT=$(cat "$MODDIR/.port" 2>/dev/null || echo "3923")

echo "--- Elite NAS Status ---"
if [ -n "$PID" ] && ps -p "$PID" >/dev/null 2>&1; then
    if grep -q "copyparty" /proc/$PID/cmdline 2>/dev/null; then
        echo "STATUS:   RUNNING"
        # BUG #2 FIX: Ping Check
        if ! ping -c 1 -W 1 "$IP" >/dev/null 2>&1; then
            echo "NETWORK:  ERROR (WiFi Down)"
        else
            echo "URL:      http://$IP:$PORT/nas/"
        fi
    else
        echo "STATUS:   STALE PID (Not NAS)"
    fi
else
    echo "STATUS:   DEAD"
fi
