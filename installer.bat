@echo off
setlocal

echo ==========================================================
echo      G++ Compiler (MinGW-w64) Installer for Windows
echo ==========================================================
echo.

:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    echo Right-click and choose "Run as administrator."
    pause
    exit /b
)

:: Define MinGW install directory
set "MINGW_DIR=%ProgramFiles%\mingw-w64"
set "MINGW_URL=https://sourceforge.net/projects/mingw-w64/files/latest/download"

:: Create temp folder
set "TEMP_DIR=%TEMP%\mingw_install"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

cd /d "%TEMP_DIR%"

echo Downloading MinGW-w64 installer...
powershell -Command "Invoke-WebRequest -Uri '%MINGW_URL%' -OutFile 'mingw-w64-setup.exe'"

if not exist "mingw-w64-setup.exe" (
    echo Failed to download the installer.
    pause
    exit /b
)

echo.
echo Running MinGW-w64 installer...
start /wait mingw-w64-setup.exe

echo.
echo Checking for g++ installation...
where g++ >nul 2>&1
if %errorLevel% neq 0 (
    echo g++ not found in PATH. Adding MinGW to system PATH...
    
    :: Find g++ path
    for /f "delims=" %%i in ('dir /b /s "%ProgramFiles%\mingw-w64\*\bin\g++.exe" 2^>nul') do set "GPP_PATH=%%~dpi"
    
    if defined GPP_PATH (
        setx PATH "%PATH%;%GPP_PATH%"
        echo Added %GPP_PATH% to PATH.
    ) else (
        echo Could not find g++.exe. Please check the MinGW installation.
        pause
        exit /b
    )
)

echo.
echo Verifying installation...
g++ --version

if %errorLevel% equ 0 (
    echo.
    echo ✅ G++ compiler installed successfully!
) else (
    echo.
    echo ❌ Installation failed. Please reinstall manually.
)

echo.
pause
endlocal
exit /b
