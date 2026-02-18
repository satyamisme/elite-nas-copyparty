#!/system/bin/sh
# Elite NAS Pro v6.0 - service.sh
MODDIR="/data/adb/modules/elite-nas-copyparty"
LOG="$MODDIR/nas.log"
PORT=3923

# BUG #8 FIX: Clear firewall bloat
while iptables -D INPUT -p tcp --dport $PORT -j ACCEPT 2>/dev/null; do :; done
iptables -I INPUT -p tcp --dport $PORT -j ACCEPT

# Port Conflict Cleanup
"$MODDIR/busybox" fuser -k $PORT/tcp 2>/dev/null
killall -9 python3 2>/dev/null

# Dynamic USB Detection (Wait 120s)
STORAGE=""
for i in $(seq 1 60); do
    STORAGE=$(grep "/mnt/media_rw/" /proc/mounts | awk '{print $2}' | head -n1)
    [ -n "$STORAGE" ] && break
    sleep 2
done

if [ -z "$STORAGE" ]; then
    echo "[$(date)] FATAL: No USB found after 120s" >> "$LOG"
    exit 1
fi
echo "$STORAGE" > "$MODDIR/.storage"

# Start NAS with --home fix for write access on Mi TV Box
export HOME="$MODDIR"
export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib
/data/data/com.termux/files/usr/bin/python3 "$MODDIR/copyparty.py" \
    -p $PORT --home "$MODDIR" --no-idx . --unsafe-state \
    -v "$STORAGE/":nas:rw >> "$LOG" 2>&1 &

PID=$!
echo $PID > "$MODDIR/.pid"
echo $PORT > "$MODDIR/.port"

# Robust OOM -1000 Loop
for i in $(seq 1 10); do
    sleep 1
    echo -1000 > "/proc/$PID/oom_score_adj" 2>/dev/null && break
done
