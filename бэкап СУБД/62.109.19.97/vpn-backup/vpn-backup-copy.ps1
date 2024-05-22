$VpnName = "VPN"
$VpnLogin = "SRV"
$VpnPwd = "password"
$errorLogPath = "C:\errorlogconnectvpn"
New-Item -ItemType Directory -Force -Path $errorLogPath | Out-Null

$vpnConnection = Get-VpnConnection -Name $VpnName

if (!$vpnConnection) {
    # if error to connect vpn
    $errorText = $_.Exception.Message
    $errorLogFile = Join-Path $errorLogPath "errorlog.txt"
    $errorText | Out-File -FilePath $errorLogFile -Force
    Write-Error "VPN connection error: $errorText"
}

rasdial $vpnName /DISCONNECT;
Start-Sleep -Seconds 5

try {
    rasdial $vpnName $VpnLogin $VpnPwd;
    Write-Host "The VPN connection has been successfully established"
    Start-Sleep -Seconds 5

    $networkPath = "\\192.168.16.16\sql_backup"
    $USERNAME = "ServerSql"
    $PASSWORD = "P@ssw0rd"
    Write-Host "Establishing a connection to the disk...."
    New-PSDrive -Name "Z" -PSProvider FileSystem -Root $networkPath -Persist -Credential $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $USERNAME, ($PASSWORD | ConvertTo-SecureString -AsPlainText -Force))
    Start-Sleep -Seconds 5
    while (-not (Test-Path $networkPath)) {
        Write-Host "Waiting for connection to a network drive..."
        Start-Sleep -Seconds 5
    }
    Write-Host "A connection to the disk has been established"

    $sourceFile = "C:\backup"

    # Get today day
    $today = Get-Date
    Write-Host "Start to copy...."

    # We get all the files in the source folder
    $files = Get-ChildItem -Path $sourceFile -File
    
    # We find the files saved yesterday
    $oldFiles = $files | Where-Object { $_.LastWriteTime -ge ($today.AddDays(-1)).Date -and $_.LastWriteTime -lt $today.Date }
    Write-Host "OldFiles: $oldFiles"
 
    # Copying files to a network drive
    foreach ($file in $oldFiles) {
        try {
            # $newPath = Join-Path -Path "Z:\" -ChildPath $file.Name 
            Copy-Item -Path $file.FullName -Destination "Z:\" -Force
            Write-Host "Name of file: $FullName"
        }
        catch {
            $errorText = $_.exception.message
            $errorLogFile = join-path $errorLogPath "errorlog.txt"
            $errorText | out-file -filepath $errorLogFile -force
            Write-Error "file copy error: $errorText"
        }
         
    }
    rasdial $vpnName /DISCONNECT;
    Write-Host "The VPN connection has been successfully closed"

    $backupReportFile = "C:\successbackup.txt"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $endTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $status = "Success"

    $reportContent = "Backup time: $timestamp"
    $reportContent += "Completion status: $status"
    $reportContent += "Backup end time: $endTime"

    $reportContent | Out-File -FilePath $backupReportFile -Force
    Write-Host "The report file has been created successfully: $backupReportFile"
}
catch {
    $errorText = $_.Exception.Message
    $errorLogFile = Join-Path $errorLogPath "errorlog.txt"
    $errorText | Out-File -FilePath $errorLogFile -Force
    Write-Error "VPN connection error: $errorText"
}

Start-Sleep -Seconds 45
