powershell
# Указываем параметры подключения к SQL Server
$serverName = "Имя_сервера"
$backupPath = "Путь_к_сохранению_копии"

# Создаем массив с именами баз данных
$databases = @("db-1", "db-2", "db-3")

# Перебираем базы данных и создаем копии
foreach ($database in $databases) {
    # Генерируем имя файла для копии
    $backupFileName = $backupPath + $database + "_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".bak"

    # Создаем объект SMO для подключения к SQL Server
    $smoServer = New-Object Microsoft.SqlServer.Management.Smo.Server($serverName)

    # Получаем объект базы данных
    $db = $smoServer.Databases[$database]

    # Создаем объект резервной копии базы данных
    $backup = New-Object Microsoft.SqlServer.Management.Smo.Backup

    # Устанавливаем свойства резервной копии
    $backup.Action = [Microsoft.SqlServer.Management.Smo.BackupActionType]::Database
    $backup.Database = $database
    $backup.Devices.AddDevice($backupFileName, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)
    $backup.Incremental = $false
    $backup.BackupSetName = $database + " Backup"
    $backup.BackupSetDescription = "Backup created on " + (Get-Date -Format "dd/MM/yyyy HH:mm:ss")

    # Выполняем резервное копирование
    $backup.SqlBackup($smoServer)
}
