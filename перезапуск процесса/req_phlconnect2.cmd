@echo off
setlocal

set PROCESS_NAME="PHLConnect.exe"
tasklist /FI "IMAGENAME eq %PROCESS_NAME%" 2>NUL | find /I "%PROCESS_NAME%" >NUL

if %errorlevel%==0 (
    echo Process %PROCESS_NAME% launched
    echo Checking the status...

    tasklist /FI "IMAGENAME eq %PROCESS_NAME%" 2>NUL | find /I "%PROCESS_NAME%" | find /I "Running" >NUL

    if %errorlevel%==0 (
        echo Process %PROCESS_NAME% working.
        echo Completion of the process...

        taskkill /F /IM %PROCESS_NAME% >NUL

        echo Restarting the process...
        start "" "C:\PHL-connect\src\dist\PHLConnect.exe"
    ) else (
        echo Process %PROCESS_NAME% it is frozen and does not work.
        echo Restarting the process...
	taskkill /IM %PROCESS_NAME% /F
        start "" "C:\PHL-connect\src\dist\PHLConnect.exe"
    )
) else (
    echo Process %PROCESS_NAME% not found.
    echo starting the process...

    start "" "C:\PHL-connect\src\dist\PHLConnect.exe"
)

endlocal