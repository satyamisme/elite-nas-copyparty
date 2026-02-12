#!/system/bin/sh
MODDIR=/data/adb/modules/elite-nas-copyparty
export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib
export PATH=$PATH:/data/data/com.termux/files/usr/bin
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
/data/data/com.termux/files/usr/bin/python3 $MODDIR/copyparty.py -p 8080 --no-idx . --unsafe-state -v /mnt/media_rw/4E04-D72A/:nas:rw > /dev/null 2>&1 &