#!/system/bin/sh
# Elite NAS Pro v6.0 - deploy.sh
M="/data/adb/modules/elite-nas-copyparty"
chmod 755 "$M/"*.sh
killall -9 python3 2>/dev/null
sh "$M/service.sh" &
sh "$M/nas-monitor.sh" &
echo "GOLDEN Setup Finished."
