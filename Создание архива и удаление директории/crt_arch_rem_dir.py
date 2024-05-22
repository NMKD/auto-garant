import shutil
import zipfile
import os
import datetime

# Путь к директории, которую нужно архивировать
path = 'c:/users/k.kryazheva/desktop/test archive py'

# Создание имени архива с текущей датой
now = datetime.datetime.now()
archive_name = now.strftime("%Y-%m-%d") + '.zip'

# Создание архива
with zipfile.ZipFile(archive_name, 'w') as zipf:
    # Рекурсивно добавляем все файлы и каталоги в архив
    for root, dirs, files in os.walk(path):
        for file in files:
            file_path = os.path.join(root, file)
            zipf.write(file_path, os.path.relpath(file_path, path))

# Удаление всех файлов и каталогов в указанной директории
for root, dirs, files in os.walk(path, topdown=False):
    for file in files:
        file_path = os.path.join(root, file)
        os.remove(file_path)
    for dir in dirs:
        dir_path = os.path.join(root, dir)
        os.rmdir(dir_path)

# Перемещение архива в указанную директорию
shutil.move(archive_name, path)