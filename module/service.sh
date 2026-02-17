#!/system/bin/sh
# Elite NAS Pro v5.3 - Simple Working Version
MODDIR=/data/adb/modules/elite-nas-copyparty

# Basic environment
export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib
export PATH=$PATH:/data/data/com.termux/files/usr/bin

# Firewall
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT 2>/dev/null

# Kill old
killall -9 python3 2>/dev/null
sleep 1

# Start - EXACT working command
cd $MODDIR
/data/data/com.termux/files/usr/bin/python3 $MODDIR/copyparty.py -p 8080 --no-idx . --unsafe-state -v /mnt/media_rw/4E04-D72A/:nas:rw > /dev/null 2>&1 &

# Save PID
echo $! > $MODDIR/.pid

# OOM Protection
sleep 2
PID=$(cat $MODDIR/.pid)
if [ -n "$PID" ] && ps -p $PID >/dev/null 2>&1; then
  echo -1000 > /proc/$PID/oom_score_adj 2>/dev/null
fi

# Wake lock
echo "elite_nas_v53" > /sys/power/wake_lock 2>/dev/null

# Watchdog
(
  sleep 60
  while true; do
    sleep 300
    if [ -f "$MODDIR/.pid" ]; then
      WPID=$(cat "$MODDIR/.pid")
      if ! ps -p "$WPID" >/dev/null 2>&1; then
        sh "$MODDIR/service.sh" &
        break
      fi
    fi
  done
) &
echo $! > $MODDIR/.watchdog_pid
