@echo off
:: =====================================================================
:: Dual Hue Sync Launch Script
:: Optimized for high-speed NVMe/RTX 5090 systems
:: =====================================================================

set "ROAM_REAL=%AppData%\HueSync"
set "ROAM_ALT=%AppData%\HueSync2"
set "LOCAL_REAL=%LocalAppData%\Signify"
set "LOCAL_ALT=%LocalAppData%\Signify2"

:: 1. Force close any existing instances
taskkill /f /im HueSync.exe /t >nul 2>&1
timeout /t 5 /nobreak >nul

:: 2. Launch Instance 1 (Monitor A / Bridge A)
start /min "" "C:\Program Files\Hue Sync\HueSync.exe"
timeout /t 15 /nobreak >nul

:: 3. Kill the 'Mutant' single-instance lock handle
:: Uses Sysinternals handle64.exe
for /f "tokens=3,6 delims=: " %%I in ('handle64.exe -accepteula -a -p HueSync.exe "Philips Hue Sync" ^| findstr /i "Mutant"') do (
    handle64.exe -accepteula -c %%J -y -p %%I >nul 2>&1
)

:: 4. THE SWAP: Switch folder identities for Instance 2
ren "%ROAM_REAL%" "HueSync_Temp"
ren "%ROAM_ALT%" "HueSync"
ren "%LOCAL_REAL%" "Signify_Temp"
ren "%LOCAL_ALT%" "Signify"

:: 5. Launch Instance 2 (Monitor B / Bridge B)
start /min "" "C:\Program Files\Hue Sync\HueSync.exe"

:: 6. THE STABILITY SHIELD
:: This prevents Monitor A from writing settings into Monitor B's folders
timeout /t 40 /nobreak >nul

:: 7. REVERSE SWAP: Return folders to original state
ren "%AppData%\HueSync" "HueSync2"
ren "%AppData%\HueSync_Temp" "HueSync"
ren "%LocalAppData%\Signify" "Signify2"
ren "%LocalAppData%\Signify_Temp" "Signify"

exit
