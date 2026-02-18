@echo off
REM Elite NAS Pro v5.3 - Get Logs and Diagnostics

set TVBOX_IP=192.168.0.241
set LOG_FILE=nas-diagnostics-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%.txt
set LOG_FILE=%LOG_FILE: =0%

echo ========================================
echo   Elite NAS Pro v5.3 Diagnostics
echo ========================================
echo.
echo Collecting logs to: %LOG_FILE%
echo.

adb connect %TVBOX_IP% >nul 2>&1
timeout /t 1 /nobreak >nul

echo [1/9] Device Info... > %LOG_FILE%
echo ========================================== >> %LOG_FILE%
echo DEVICE INFORMATION >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%
adb shell getprop ro.product.model >> %LOG_FILE% 2>&1
adb shell getprop ro.build.version.release >> %LOG_FILE% 2>&1
adb shell getprop ro.product.cpu.abi >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%

echo [2/9] Current Status...
echo ========================================== >> %LOG_FILE%
echo CURRENT STATUS >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%
adb shell su -c "sh /data/adb/modules/elite-nas-copyparty/module-status.sh" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%

echo [3/9] Service Log...
echo ========================================== >> %LOG_FILE%
echo SERVICE LOG (last 50 lines) >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%
adb shell su -c "tail -50 /data/adb/modules/elite-nas-copyparty/nas.log 2>/dev/null || echo 'No nas.log found'" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%

echo [4/9] Start Log...
echo ========================================== >> %LOG_FILE%
echo START LOG >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%
adb shell su -c "cat /data/adb/modules/elite-nas-copyparty/start.log 2>/dev/null || echo 'No start.log found'" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%

echo [5/9] Running Processes...
echo ========================================== >> %LOG_FILE%
echo PYTHON PROCESSES >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%
adb shell su -c "ps | grep python" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%

echo [6/9] Network Status...
echo ========================================== >> %LOG_FILE%
echo NETWORK STATUS >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%
adb shell su -c "netstat -ln | grep 3923" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%
echo Active Connections: >> %LOG_FILE%
adb shell su -c "netstat -an | grep 3923 | grep ESTABLISHED" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%

echo [7/9] USB Storage...
echo ========================================== >> %LOG_FILE%
echo USB STORAGE >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%
adb shell su -c "ls -la /mnt/media_rw/" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%
adb shell su -c "df -h /mnt/media_rw/4E04-D72A" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%

echo [8/9] Module Files...
echo ========================================== >> %LOG_FILE%
echo MODULE FILES >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%
adb shell su -c "ls -la /data/adb/modules/elite-nas-copyparty/" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%

echo [9/9] State Files...
echo ========================================== >> %LOG_FILE%
echo STATE FILES >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%
echo .pid file: >> %LOG_FILE%
adb shell su -c "cat /data/adb/modules/elite-nas-copyparty/.pid 2>/dev/null || echo 'No .pid file'" >> %LOG_FILE% 2>&1
echo .watchdog_pid file: >> %LOG_FILE%
adb shell su -c "cat /data/adb/modules/elite-nas-copyparty/.watchdog_pid 2>/dev/null || echo 'No .watchdog_pid file'" >> %LOG_FILE% 2>&1
echo Wake lock: >> %LOG_FILE%
adb shell su -c "cat /sys/power/wake_lock | grep elite" >> %LOG_FILE% 2>&1
echo. >> %LOG_FILE%

echo ========================================== >> %LOG_FILE%
echo END OF DIAGNOSTICS >> %LOG_FILE%
echo ========================================== >> %LOG_FILE%

echo.
echo ========================================
echo Diagnostics complete!
echo.
echo Log saved to: %LOG_FILE%
echo.
echo Opening log file...
notepad %LOG_FILE%
echo ========================================
pause
