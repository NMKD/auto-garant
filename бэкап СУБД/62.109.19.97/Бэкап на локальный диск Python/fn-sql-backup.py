
import pyodbc
import os
import datetime
# Функция для создания бэкапа базы данных
server = 'localhost'
username = 'SA'
password = 'password$'


def create_backup(db_name, backup_folder):
    # Строка подключения к SQL Server
    connection_string = f'DRIVER={{SQL Server}};SERVER={server};DATABASE={db_name};UID={username};PWD={password}'

    # Подключение к SQL Server
    conn = pyodbc.connect(connection_string)
    conn.autocommit = True

    # Формирование SQL-запроса для создания бэкапа
    TODAY = datetime.date.today()
    sql_query = f"BACKUP DATABASE [{db_name}] TO DISK='{backup_folder}\\{db_name}_{TODAY}.bak'"

    try:
        # Выполнение SQL-запроса
        cursor = conn.cursor().execute(sql_query)
        while cursor.nextset():
            pass
        cursor.close()
        print(f"Бэкап базы данных '{db_name}' успешно создан.")
    except Exception as e:
        print(f"Ошибка при создании бэкапа базы данных '{db_name}': {str(e)}")
    finally:
        conn.close()


# Путь к папке для сохранения бэкапов
backup_folder = "C:\\backup"

# Проверка существования папки для сохранения бэкапов
if not os.path.exists(backup_folder):
    os.makedirs(backup_folder)
    print(f"Создана папка для сохранения бэкапов: {backup_folder}")

# Создание бэкапов баз данных
databases = ["mg", "gkod", "MGU",]
for db in databases:
    create_backup(db, backup_folder)
