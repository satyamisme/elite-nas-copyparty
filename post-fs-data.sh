#!/system/bin/sh
MODDIR=${0%/*}
nohup sh "$MODDIR/service.sh" >/dev/null 2>&1 &