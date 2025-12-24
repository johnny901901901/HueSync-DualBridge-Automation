@echo off
setlocal

:: ======================================================================
:: USER CONFIGURATION
:: ======================================================================
:: Folder where you keep your scripts and handle64.exe
set "SCRIPT_DIR=C:\Scripts"

:: Tool name: handle64.exe (64-bit) or handle.exe (32-bit)
set "HANDLE_EXE=handle64.exe"

:: Path to Hue Sync installation
set "HUE_APP=C:\Program Files\Hue Sync\HueSync.exe"
:: ======================================================================

set "ROAM_REAL=%AppData%\HueSync"
set "ROAM_ALT=%AppData%\HueSync2"
set "LOCAL_REAL=%LocalAppData%\Signify"
set "LOCAL_ALT=%LocalAppData%\Signify2"

:: 1. Force close silently
taskkill /f /im HueSync.exe /t >nul 2>&1
timeout /t 5 /nobreak >nul

:: 2. Launch Instance 1
start /min "" "%HUE_APP%"
timeout /t 15 /nobreak >nul

:: 3. Kill the 'Mutant' lock handle
for /f "tokens=3,6 delims=: " %%I in ('%SCRIPT_DIR%\%HANDLE_EXE% -accepteula -a -p HueSync.exe "Philips Hue Sync" ^| findstr /i "Mutant"') do (
    %SCRIPT_DIR%\%HANDLE_EXE% -accepteula -c %%J -y -p %%I >nul 2>&1
)

:: 4. THE FOLDER SWAP (Identity Shift)
ren "%ROAM_REAL%" "HueSync_Temp"
ren "%ROAM_ALT%" "HueSync"
ren "%LOCAL_REAL%" "Signify_Temp"
ren "%LOCAL_ALT%" "Signify"

:: 5. Launch Instance 2
start /min "" "%HUE_APP%"

:: 6. THE STABILITY SHIELD (40s wait)
:: This is set to 40s to try and prevent settings drift, but it remains finicky.
timeout /t 40 /nobreak >nul

:: 7. REVERSE SWAP (Restore Folders)
ren "%AppData%\HueSync" "HueSync2"
ren "%AppData%\HueSync_Temp" "HueSync"
ren "%LocalAppData%\Signify" "Signify2"
ren "%LocalAppData%\Signify_Temp" "Signify"

exit
