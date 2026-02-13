@echo off
echo ==========================================
echo Elite NAS Pro v5.5 - ZIP Creator
echo Based on Tested & Verified Logs
echo ==========================================
echo.

if exist "elite-nas-pro-v5.5.zip" del /Q "elite-nas-pro-v5.5.zip"

set ZIP_EXE=
if exist "C:\Program Files\7-Zip\7z.exe" set ZIP_EXE=C:\Program Files\7-Zip\7z.exe
if exist "C:\Program Files (x86)\7-Zip\7z.exe" set ZIP_EXE=C:\Program Files (x86)\7-Zip\7z.exe

if not defined ZIP_EXE (
    echo ERROR: 7-Zip not found!
    echo.
    echo Install from: https://www.7-zip.org/
    echo.
    echo Or create ZIP manually:
    echo 1. Select all files in this folder
    echo 2. Right-click - Send to - Compressed folder
    echo 3. Rename to: elite-nas-pro-v5.5.zip
    pause
    exit /b 1
)

echo Creating ZIP...
echo.

"%ZIP_EXE%" a -tzip "elite-nas-pro-v5.5.zip" ^
    module.prop ^
    service.sh ^
    post-fs-data.sh ^
    customize.sh ^
    config_speed_optimized.sh ^
    module-status.sh ^
    module-restart.sh ^
    nas-open.sh ^
    busybox ^
    copyparty.py ^
    termux.apk ^
    bootstrap-aarch64.zip ^
    bootstrap-arm.zip ^
    META-INF\ >nul

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo SUCCESS: elite-nas-pro-v5.5.zip created!
    echo ==========================================
    echo.
    echo Size: 
    dir elite-nas-pro-v5.5.zip | find "elite-nas"
    echo.
    echo NEXT STEPS:
    echo 1. Copy elite-nas-pro-v5.5.zip to your Android TV
    echo 2. Install via Magisk app
    echo 3. Reboot
    echo 4. Browser auto-opens with QR code!
    echo.
    echo Based on YOUR 282 pages of successful tests!
) else (
    echo.
    echo ERROR: Failed to create ZIP
    echo.
    echo Check that you have:
    echo - busybox (downloaded)
    echo - copyparty.py (downloaded)
    echo - termux.apk (downloaded)
    echo - bootstrap zips (optional)
    echo - All module files
)

echo.
pause
