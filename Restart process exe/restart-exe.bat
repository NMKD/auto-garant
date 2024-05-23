@echo off
:loop
tasklist | findstr /i "phlconnect.exe" > nul

if %errorlevel% equ 0 (
    echo Process is running.

    wmic process where name="phlconnect.exe" get status | findstr /i "not responding" > nul

    if %errorlevel% equ 0 (
        echo Process is not responding. Killing and restarting...
        taskkill /f /im phlconnect.exe
        start "" "C:\PHL-connect\src\dist\PHLConnect.exe"
    )
) else (
    echo Process not found. Starting...
    start "" "C:\PHL-connect\src\dist\PHLConnect.exe"
)

timeout /t 10800 > nul
goto loop