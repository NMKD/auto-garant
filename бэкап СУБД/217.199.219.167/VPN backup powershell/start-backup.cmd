@echo off
set PowerShellScript=C:\scripts\VPN backup\vpn-backup.ps1

powershell.exe -ExecutionPolicy Bypass -File "%PowerShellScript%"