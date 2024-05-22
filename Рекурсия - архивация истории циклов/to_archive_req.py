import os
import zipfile
import tempfile
import shutil

def remove_from_zip(zipfname, *filenames):
    tempdir = tempfile.mkdtemp()
    try:
        tempname = os.path.join(tempdir, 'new.zip')
        with zipfile.ZipFile(zipfname, 'r') as zipread:
            with zipfile.ZipFile(tempname, 'w') as zipwrite:
                for item in zipread.infolist():
                    if item.filename not in filenames:
                        data = zipread.read(item.filename)
                        zipwrite.writestr(item, data)
        shutil.move(tempname, zipfname)
    finally:
        shutil.rmtree(tempdir)

def check_dir(path):
    if os.path.exists(path):
        directories = os.listdir(path)
        return directories
    else:
        return []

def archive_directories(path):
    directories = check_dir(path)
    for directory in directories:
        directory_path = os.path.join(path, directory)
        if os.path.isdir(directory_path):
            archive_directories(directory_path)
        else:
            file_name, file_extention = os.path.splitext(directory_path)
            if os.path.isfile(directory_path) and file_extention.lower() != ".zip":
                archive_path = path + ".zip"
                if os.path.exists(archive_path):
                    remove_from_zip(archive_path, directory)
                    with zipfile.ZipFile(archive_path, "a") as zip_file:
                        zip_file.write(filename=directory_path, arcname=os.path.basename(directory_path))
                else:
                    with zipfile.ZipFile(archive_path, "w") as zip_file:
                        zip_file.write(filename=directory_path, arcname=os.path.basename(directory_path))
                os.remove(directory_path)
    
    print("All directories have been archived successfully!")

# Пример использования:
directory_path = "C:\\Users\\k.kryazheva\\Desktop\\test archive py"
archive_directories(directory_path)

