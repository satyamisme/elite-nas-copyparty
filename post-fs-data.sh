#!/system/bin/sh
# Elite NAS Pro v5.3 - Boot script with USB wait
MODDIR=${0%/*}

# Wait for USB to be mounted (30 seconds after boot)
(
  sleep 30
  sh "$MODDIR/service.sh" &
) &
