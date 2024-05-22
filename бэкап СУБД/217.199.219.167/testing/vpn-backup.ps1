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
    Add-Content -Path $vpnErrorLogFile -Value "Ошибка подключения к VPN, время $backupDateTime"
}
else {
    rasdial $vpnName /DISCONNECT;
    if ($vpnConnection.ConnectionStatus -eq "Disconnected") {
        Write-Host "Connect VPN"
        rasdial $vpnName $VpnLogin $VpnPwd;
    }
    
    # to connect net disk
    $DRIVEPATH = "\\192.168.16.16\name-dir"
    $USERNAME = "USERNAME"
    $PASSWORD = "PASSWORD"
    
    New-PSDrive -Name "Z" -PSProvider FileSystem -Root $DRIVEPATH -Persist -Credential $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $USERNAME, ($PASSWORD | ConvertTo-SecureString -AsPlainText -Force))
    
    # init names of pg sql
    $DATABASES = "steri-pack", "phs-testing"
    
    # connect pg sql and backup
    # $backupFolder = "Z:\Backup"
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

    $oldFileDate = (Get-Date).AddDays(-7)
    Get-ChildItem -Path $DRIVEPATH | Where-Object { $_.LastWriteTime -lt $oldFileDate } | Remove-Item
    
    $logContent = "Status: $backupStatus. Time of backup: $backupDateTime"
    
    New-Item -Path $successBackupLogFile -ItemType File -Force
    Add-Content -Path $successBackupLogFile -Value $logContent
}

# Закрытие VPN соединения

    if ($vpnConnection.ConnectionStatus -eq "Connected") {
        Write-Host "Disconnected VPN"
        rasdial $vpnName /DISCONNECT;
    }
    Write-Host "VPN соединение успешно закрыто"

Start-Sleep -Seconds 20