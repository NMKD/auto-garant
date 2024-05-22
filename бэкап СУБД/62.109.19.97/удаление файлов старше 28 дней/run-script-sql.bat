@echo off
setlocal

set "targetDirectory=C:\backup"

forfiles /p "%targetDirectory%" /m "*.bak" /d -28 /c "cmd /c del @path"

endlocal