@echo off
REM Elite NAS Pro v5.3 - Auto Update Script
REM Place this file in: C:\Users\genesislap\Downloads\files\

echo ========================================
echo   Elite NAS Pro v5.3 Auto Updater
echo ========================================
echo.

REM Change this to your TV Box IP
set TVBOX_IP=192.168.0.241

echo [1/7] Connecting to TV Box...
adb connect %TVBOX_IP%
timeout /t 2 /nobreak >nul

echo [2/7] Stopping current service...
adb shell su -c "killall -9 python3"
timeout /t 3 /nobreak >nul

echo [3/7] Pushing files to /sdcard/...
adb push service.sh /sdcard/
adb push module-restart.sh /sdcard/
adb push module-status.sh /sdcard/
adb push customize.sh /sdcard/
adb push post-fs-data.sh /sdcard/
adb push nas-open.sh /sdcard/
adb push config_speed_optimized.sh /sdcard/
adb push module.prop /sdcard/

echo [4/7] Copying files to module directory...
adb shell su -c "cp /sdcard/service.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/module-restart.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/module-status.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/customize.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/post-fs-data.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/nas-open.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/config_speed_optimized.sh /data/adb/modules/elite-nas-copyparty/"
adb shell su -c "cp /sdcard/module.prop /data/adb/modules/elite-nas-copyparty/"

echo [5/7] Setting permissions...
adb shell su -c "chmod 755 /data/adb/modules/elite-nas-copyparty/*.sh"

echo [6/7] Starting service...
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/service.sh > /dev/null 2>&1 &"
timeout /t 5 /nobreak >nul

echo [7/7] Checking status...
echo.
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/module-status.sh"
echo.

echo ========================================
echo Update complete!
echo.
echo Test in browser: http://%TVBOX_IP%:8080/nas/
echo.
echo Commands:
echo   nas-restart - Restart service
echo   nas-status  - Check status
echo ========================================
echo.
pause
