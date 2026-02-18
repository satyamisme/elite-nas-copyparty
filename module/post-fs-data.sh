#!/system/bin/sh
# Elite NAS Pro v6.0 - post-fs-data.sh
MODDIR="/data/adb/modules/elite-nas-copyparty"

# Start the NAS service starter
sh "$MODDIR/service.sh" &

# Start the external Protector loop independently
sh "$MODDIR/nas-monitor.sh" &
