@echo off
echo ==========================================
echo Elite NAS Pro - Release ZIP Creator
echo ==========================================
echo.

set "REPO_ROOT=%~dp0..\.."
set "MODULE_DIR=%REPO_ROOT%\module"
set "OUTPUT_ZIP=%REPO_ROOT%\elite-nas-pro-release.zip"

if exist "%OUTPUT_ZIP%" del /Q "%OUTPUT_ZIP%"

set ZIP_EXE=
if exist "C:\Program Files\7-Zip\7z.exe" set ZIP_EXE=C:\Program Files\7-Zip\7z.exe
if exist "C:\Program Files (x86)\7-Zip\7z.exe" set ZIP_EXE=C:\Program Files (x86)\7-Zip\7z.exe

if not defined ZIP_EXE (
    echo ERROR: 7-Zip not found!
    echo.
    echo Please install 7-Zip or manually zip the contents of the 'module' directory.
    pause
    exit /b 1
)

echo Creating ZIP from %MODULE_DIR%...
echo Output: %OUTPUT_ZIP%
echo.

pushd "%MODULE_DIR%"
"%ZIP_EXE%" a -tzip "%OUTPUT_ZIP%" * -xr!*.git*
popd

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo SUCCESS: Release zip created!
    echo ==========================================
    echo.
    echo File: %OUTPUT_ZIP%
    echo.
) else (
    echo.
    echo ERROR: Failed to create ZIP
    echo.
)

echo.
pause
