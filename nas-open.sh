#!/system/bin/sh
MODDIR="/data/adb/modules/elite-nas-copyparty"
IP=$(cat "$MODDIR/.ip" 2>/dev/null || echo "0.0.0.0")
PORT=$(cat "$MODDIR/.port" 2>/dev/null || echo "8080")
am start -a android.intent.action.VIEW -d "http://$IP:$PORT" >/dev/null 2>&1
echo "Opening Dashboard: http://$IP:$PORT"