#!/system/bin/sh
MODDIR="/data/adb/modules/elite-nas-copyparty"
BB="$MODDIR/busybox"

PID=$(cat "$MODDIR/.pid" 2>/dev/null)
PORT=8080
STORAGE="/mnt/media_rw/4E04-D72A"

echo "========================================"
echo "  ELITE NAS PRO v5.3 (Fixed)"
echo "========================================"
if [ -n "$PID" ] && ps -p "$PID" >/dev/null 2>&1; then
    echo "STATUS:   RUNNING (PID: $PID)"
    
    # Get IP
    IP=$("$BB" ifconfig 2>/dev/null | "$BB" grep "inet addr:" | "$BB" grep -v "127.0.0.1" | "$BB" awk '{print $2}' | "$BB" cut -d: -f2 | "$BB" head -n1)
    [ -z "$IP" ] && IP=$("$BB" ifconfig 2>/dev/null | "$BB" grep "inet " | "$BB" grep -v "127.0.0.1" | "$BB" awk '{print $2}' | "$BB" head -n1)
    [ -z "$IP" ] && IP="Unknown"
    
    echo "URL:      http://$IP:$PORT/nas/"
    
    OOM=$(cat /proc/$PID/oom_score_adj 2>/dev/null || echo "N/A")
    if [ "$OOM" = "-1000" ]; then
        echo "OOM ADJ:  PROTECTED (-1000)"
    else
        echo "OOM ADJ:  $OOM (at risk)"
    fi
else
    echo "STATUS:   DEAD"
fi
echo "STORAGE:  $STORAGE"
"$BB" df -h "$STORAGE" 2>/dev/null | "$BB" tail -1
CLIENTS=$("$BB" netstat -an 2>/dev/null | "$BB" grep -c ":$PORT.*ESTABLISHED" || echo 0)
echo "CLIENTS:  $CLIENTS active"
echo "========================================"
