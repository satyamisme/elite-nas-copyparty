#!/system/bin/sh
# Elite NAS Pro v6.0 - module-restart.sh
M="/data/adb/modules/elite-nas-copyparty"
killall -9 python3 2>/dev/null
rm -f "$M/.pid" "$M/.ip" "$M/.port" "$M/.storage" 2>/dev/null
sh "$M/service.sh" &
echo "NAS Restarted."
