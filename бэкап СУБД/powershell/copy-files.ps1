# Specify the paths to the source and network folders
$sourceFile = "Z:\"
$targetFile = "E:\postgres_backup"

# Get today day
$today = Get-Date
Write-Host "Start...."

try {
    # We get all the files in the source folder
    $files = Get-ChildItem -Path $sourceFile -File
    
    # We find the files saved yesterday
    $oldFiles = $files | Where-Object { $_.LastWriteTime -ge ($today.AddDays(-1)).Date -and $_.LastWriteTime -lt $today.Date }
    
    # Copying files to a network drive
    foreach ($file in $oldFiles) {
        $newPath = Join-Path -Path $targetFile -ChildPath $file.Name
        Copy-Item -Path $file.FullName -Destination $newPath -Force
    }
    
} catch {
    Write-Host "ERROR of script:"
    Write-Host $_.Exception.Message
}

# This script retrieves all files in the source folder and finds those files 
# that were saved yesterday. It then transfers these files to the specified network drive 