@echo off
REM Elite NAS Pro v5.3 - View Service Log

set TVBOX_IP=192.168.0.241

echo Connecting to TV Box...
adb connect %TVBOX_IP% >nul 2>&1
timeout /t 1 /nobreak >nul

echo ========================================
echo   Service Log (last 30 lines)
echo ========================================
echo.
adb shell su -c "tail -30 /data/adb/modules/elite-nas-copyparty/service.log 2>/dev/null || echo 'No log file found'"
echo.
echo ========================================
pause
