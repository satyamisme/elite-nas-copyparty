#!/system/bin/sh
# Elite NAS Pro v5.6 - post-fs-data.sh
# Commands: echo, grep, sleep, sh, awk - all proven
MODDIR=${MODDIR:-/data/adb/modules/elite-nas-copyparty}
LOG="$MODDIR/nas.log"

log() { echo "$*" >> "$LOG"; }
log "===== post-fs-data v5.6 triggered ====="

(
    # Wait for ANY USB volume under /mnt/media_rw/ - not just one label.
    # service.sh will pick the preferred one (4E04-D72A) or fall back.
    USB_WAIT=0
    if grep -q "/mnt/media_rw/" /proc/mounts 2>/dev/null; then
        log "post-fs-data: USB already mounted at boot"
    else
        # Extended to 120s - matches service.sh timeout for slow NTFS HDDs
        # FIX: assign to var before testing - more reliable than pipe in mksh
        log "post-fs-data: waiting for USB (up to 120s)"
        while [ "$USB_WAIT" -lt 60 ]; do
            sleep 2
            USB_WAIT=$((USB_WAIT + 1))
            FOUND=$(grep "/mnt/media_rw/" /proc/mounts 2>/dev/null)
            [ -n "$FOUND" ] && break
        done
        if grep -q "/mnt/media_rw/" /proc/mounts 2>/dev/null; then
            log "post-fs-data: USB appeared after $((USB_WAIT * 2))s"
        else
            log "post-fs-data: no USB after 120s - service.sh will handle it"
        fi
    fi
    sh "$MODDIR/service.sh" </dev/null >> "$LOG" 2>&1
) &
