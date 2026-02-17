@echo off
REM Elite NAS Pro v5.3 - Status Check Script

set TVBOX_IP=192.168.0.241

echo Checking Elite NAS Pro status...
echo.
adb connect %TVBOX_IP% >nul 2>&1
timeout /t 1 /nobreak >nul
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/module-status.sh"
echo.
pause
