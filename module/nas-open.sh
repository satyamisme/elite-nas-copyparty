#!/system/bin/sh
# Elite NAS Pro v6.0 - nas-open.sh
MODDIR="/data/adb/modules/elite-nas-copyparty"
PID=$(cat "$MODDIR/.pid" 2>/dev/null)
if [ -n "$PID" ] && ps -p "$PID" >/dev/null 2>&1; then
    IP=$(cat "$MODDIR/.ip" 2>/dev/null || echo "0.0.0.0")
    PORT=$(cat "$MODDIR/.port" 2>/dev/null || echo "3923")
    am start -a android.intent.action.VIEW -d "http://$IP:$PORT/nas/" >/dev/null 2>&1
else
    echo "ERROR: NAS is not running."
fi
