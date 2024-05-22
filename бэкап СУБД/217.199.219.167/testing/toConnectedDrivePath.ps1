 $DRIVEPATH = "\\192.168.0.100\name-dir"
        $USERNAME = "USERNAME"
        $PASSWORD = "PASSWORD"
    
        New-PSDrive -Name "Z" -PSProvider FileSystem -Root $DRIVEPATH -Persist -Credential $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $USERNAME, ($PASSWORD | ConvertTo-SecureString -AsPlainText -Force))

        while (-not (Test-Path $DRIVEPATH)) {
            Write-Host "Waiting for connection to a network drive..."
            Start-Sleep -Seconds 1
        }

        Write-Host "network drive connected."