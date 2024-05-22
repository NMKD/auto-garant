# to connect vpn
$VpnName = "VpnName"
$VpnLogin = "VpnLogin"
$VpnPwd = "VpnPwd"
$vpnErrorLogFile = "C:\errorlogconnectvpn\errorlog.txt"

$vpnConnection = Get-VpnConnection -Name $VpnName -AllUserConnection
# to create success file
$successBackupLogFile = "C:\successbackup\successbackup.txt"
$backupDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$backupStatus = "Success"

if (!$vpnConnection) {
    # if error to connect vpn
    New-Item -Path $vpnErrorLogFile -ItemType File -Force
    Add-Content -Path $vpnErrorLogFile -Value "VPN connection error, time $backupDateTime"
}
else {
    Write-Host "To disconnect VPN....."
    rasdial $vpnName /DISCONNECT;
    Start-Sleep -Seconds 5
    Write-Host "To connect VPN....."
    rasdial $vpnName $VpnLogin $VpnPwd;
    Start-Sleep -Seconds 5

    if ($vpnConnection.ConnectionStatus -eq "Connected") {
        Write-Host "VPN connected"
        $DRIVEPATH = "\\192.168.16.16\postgres_backup"
        $USERNAME = "ServerPg"
        $PASSWORD = "P@ssw0rd"
    
        New-PSDrive -Name "Z" -PSProvider FileSystem -Root $DRIVEPATH -Persist -Credential $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $USERNAME, ($PASSWORD | ConvertTo-SecureString -AsPlainText -Force))
        Start-Sleep -Seconds 5

        while (-not (Test-Path $DRIVEPATH)) {
            Write-Host "Waiting for connection to a network drive..."
            Start-Sleep -Seconds 3
        }

        Write-Host "network drive connected."

        # init names of pg sql
        $DATABASES = "steri-pack", "phs-testing"
        $GBIN = "C:\Program Files\PostgreSQL 1C\15\bin"
        $PGHOST = "localhost"
        $PGPORT = 5432
        $PGUSER = "postgres"
        $env:PGPASSWORD = "PGPASSWORD"
        $DateTime = Get-Date -Format "yyyy-MM-dd"
    
        foreach ($database in $DATABASES) {
            $BackUpFileName = "$DRIVEPATH\$database-$DateTime.dump"
            & "$GBIN\pg_dump.exe" -h $PGHOST -p $PGPORT -U $PGUSER -f $BackUpFileName $database
        }

        $oldFileDate = (Get-Date).AddDays(-28)
        Get-ChildItem -Path $DRIVEPATH | Where-Object { $_.LastWriteTime -lt $oldFileDate } | Remove-Item
    
        $logContent = "Status: $backupStatus. Time of backup: $backupDateTime"
    
        New-Item -Path $successBackupLogFile -ItemType File -Force
        Add-Content -Path $successBackupLogFile -Value $logContent
        rasdial $vpnName /DISCONNECT;
        Write-Host "The VPN connection has been successfully closed"
    }
}

Start-Sleep -Seconds 30