#!/system/bin/sh
M="/data/adb/modules/elite-nas-copyparty"
BB="$M/busybox"
echo "Stopping Elite NAS..."

# Stop watchdog
[ -f "$M/.watchdog_pid" ] && kill -9 $(cat "$M/.watchdog_pid") 2>/dev/null
rm -f "$M/.watchdog_pid" 2>/dev/null

# Kill by PID (safer than killall)
[ -f "$M/.pid" ] && kill -9 $(cat "$M/.pid") 2>/dev/null

# Kill by port
[ -f "$M/.port" ] && "$BB" fuser -k "$(cat "$M/.port")/tcp" 2>/dev/null

# Backup: kill any python3
killall -9 python3 2>/dev/null

# Release wake lock
echo "elite_nas_v53" > /sys/power/wake_unlock 2>/dev/null

rm -f "$M/.pid" 2>/dev/null
sleep 3

echo "Starting..."
sh "$M/service.sh" </dev/null >/dev/null 2>&1 &
sleep 5
echo "Elite NAS Restarted."
