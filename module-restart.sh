#!/system/bin/sh
M="/data/adb/modules/elite-nas-copyparty"
BB="$M/busybox"
echo "Stopping Elite NAS..."
killall -9 python3 2>/dev/null
[ -f "$M/.pid" ] && kill -9 $(cat "$M/.pid") 2>/dev/null
[ -f "$M/.port" ] && "$BB" fuser -k "$(cat "$M/.port")/tcp" 2>/dev/null
rm -f "$M/.pid" 2>/dev/null
sleep 3
echo "Starting..."
sh "$M/service.sh" </dev/null >/dev/null 2>&1 &
sleep 5
echo "Sentinel Restarted."