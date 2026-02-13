#!/system/bin/sh
MODPATH=${0%/*}

ui_print "--- Elite NAS Pro v5.3 (Fixed) ---"

# 1. Background Termux Install
if ! pm list packages | grep -q com.termux; then
    ui_print "- Installing Termux APK..."
    pm install -r "$MODPATH/termux.apk" >/dev/null 2>&1
fi

# 2. System-Wide Utility Linking (Symlink Method)
mkdir -p "$MODPATH/system/bin"
ln -sf "$MODPATH/busybox" "$MODPATH/system/bin/busybox"
chmod 755 "$MODPATH/busybox"
ln -sf "$MODPATH/module-restart.sh" "$MODPATH/system/bin/nas-restart"
ln -sf "$MODPATH/module-status.sh" "$MODPATH/system/bin/nas-status"
ln -sf "$MODPATH/nas-open.sh" "$MODPATH/system/bin/nas-open"
chmod 755 "$MODPATH/system/bin/"*

# 3. Headless Bootstrap Extraction & Ownership Alignment
TERMUX_DATA="/data/data/com.termux/files"
if [ -d "$TERMUX_DATA" ]; then
    mkdir -p "$TERMUX_DATA/usr" "$TERMUX_DATA/home"
    ABI=$(getprop ro.product.cpu.abi)
    if echo "$ABI" | grep -q "64"; then 
        B_ZIP="bootstrap-aarch64.zip"
    else 
        B_ZIP="bootstrap-arm.zip"
    fi
    
    if [ -f "$MODPATH/$B_ZIP" ]; then
        ui_print "- Extracting Python Base ($B_ZIP)..."
        "$MODPATH/busybox" unzip -o "$MODPATH/$B_ZIP" -d "$TERMUX_DATA/" >/dev/null 2>&1
        
        T_UID=$(stat -c %u "$TERMUX_DATA" 2>/dev/null || echo 10227)
        chown -R "$T_UID:$T_UID" "$TERMUX_DATA/usr" 2>/dev/null
        chmod -R 755 "$TERMUX_DATA/usr/bin" 2>/dev/null
    fi
fi

ui_print "- Setup Complete. Reboot now."
