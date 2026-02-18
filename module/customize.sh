#!/system/bin/sh
# Elite NAS Pro v6.0 - customize.sh
MODPATH=${0%/*}
ui_print "- Installing Elite NAS Pro v6.0..."

# 1. Background Termux Install
if ! pm list packages | grep -q com.termux; then
    ui_print "- Installing Termux APK..."
    pm install -r "$MODPATH/termux.apk" >/dev/null 2>&1
fi

# 2. Bootstrap Extraction
TERMUX_DATA="/data/data/com.termux/files"
mkdir -p "$TERMUX_DATA/usr" "$TERMUX_DATA/home"
ABI=$(getprop ro.product.cpu.abi)
[ "$ABI" = "arm64-v8a" ] && B_ZIP="bootstrap-aarch64.zip" || B_ZIP="bootstrap-arm.zip"
if [ -f "$MODPATH/$B_ZIP" ]; then
    ui_print "- Extracting Python Base ($B_ZIP)..."
    unzip -o "$MODPATH/$B_ZIP" -d "$TERMUX_DATA/" >/dev/null 2>&1
    T_UID=$(stat -c %u "$TERMUX_DATA" 2>/dev/null || echo 10227)
    chown -R "$T_UID:$T_UID" "$TERMUX_DATA/usr"
    chmod -R 755 "$TERMUX_DATA/usr/bin"
fi

# 3. Create global commands
mkdir -p "$MODPATH/system/bin"
ln -sf "$MODPATH/module-restart.sh" "$MODPATH/system/bin/nas-restart"
ln -sf "$MODPATH/module-status.sh" "$MODPATH/system/bin/nas-status"
ln -sf "$MODPATH/nas-open.sh" "$MODPATH/system/bin/nas-open"
chmod 755 "$MODPATH/system/bin/"*
chmod 755 "$MODPATH/"*.sh
