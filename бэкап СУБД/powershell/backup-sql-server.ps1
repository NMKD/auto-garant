# Задайте значения переменных
$serverName = "Название_сервера"
$backupLocation = "Путь_к_папке_для_сохранения_бэкапов"

# Подключение к серверу SQL Server
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = "Server=$serverName;Database=master;Trusted_Connection=True;"
$sqlConnection.Open()

# Получение списка баз данных
$sqlCommand = $sqlConnection.CreateCommand()
$sqlCommand.CommandText = "SELECT name FROM sys.databases WHERE state = 0 AND name NOT IN ('master', 'model', 'tempdb', 'msdb')"
$databases = $sqlCommand.ExecuteReader()

# Создание бэкапов для каждой базы данных
while ($databases.Read()) {
    $databaseName = $databases.GetValue(0)

    # Формирование имени бэкапа с текущей датой и временем
    $backupName = "$databaseName" + "_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".bak"
    $backupPath = Join-Path -Path $backupLocation -ChildPath $backupName

    # Создание SQL-запроса для создания бэкапа
    $backupQuery = "BACKUP DATABASE [$databaseName] TO DISK = N'$backupPath' WITH NOFORMAT, NOINIT, NAME = N'$backupName', SKIP, REWIND, NOUNLOAD, COMPRESSION, STATS = 10"
    $sqlCommand.CommandText = $backupQuery
    $sqlCommand.ExecuteNonQuery()

    Write-Host "Бэкап базы данных $databaseName создан в $backupPath"
}

# Закрытие соединения с сервером
$sqlConnection.Close()