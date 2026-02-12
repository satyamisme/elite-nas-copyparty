#!/system/bin/sh
MODDIR="/data/adb/modules/elite-nas-copyparty"
BB="$MODDIR/busybox"

IP=$(cat "$MODDIR/.ip" 2>/dev/null)
PID=$(cat "$MODDIR/.pid" 2>/dev/null)
PORT=$(cat "$MODDIR/.port" 2>/dev/null)
STORAGE=$(cat "$MODDIR/.storage" 2>/dev/null)

echo "========================================"
echo "  ELITE NAS PRO v5.2 DASHBOARD"
echo "========================================"
if [ -n "$PID" ] && ps -p "$PID" >/dev/null 2>&1; then
    echo "STATUS:   RUNNING (PID: $PID)"
    echo "URL:      http://$IP:$PORT"
    OOM=$("$BB" cat /proc/$PID/oom_score_adj 2>/dev/null || echo "N/A")
    echo "OOM ADJ:  $OOM"
else
    echo "STATUS:   DEAD"
fi
echo "STORAGE:  $STORAGE"
"$BB" df -h "$STORAGE" 2>/dev/null | "$BB" tail -1
CLIENTS=$("$BB" netstat -an 2>/dev/null | "$BB" grep -c ":$PORT.*ESTABLISHED" || echo 0)
echo "CLIENTS:  $CLIENTS active"
echo "========================================"