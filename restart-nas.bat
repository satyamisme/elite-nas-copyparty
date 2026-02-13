@echo off
REM Elite NAS Pro v5.3 - Quick Restart Script

set TVBOX_IP=192.168.0.241

echo Restarting Elite NAS Pro...
adb connect %TVBOX_IP% >nul 2>&1
timeout /t 1 /nobreak >nul
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/module-restart.sh"
echo.
echo Done! Service restarted.
pause
