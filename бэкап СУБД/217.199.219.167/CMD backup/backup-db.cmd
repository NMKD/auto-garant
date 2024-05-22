CHCP 1251
SET PGBIN=C:\Program Files\PostgreSQL 1C\15\bin
SET PGHOST=localhost
SET PGPORT=5432
SET PGUSER=postgres
SET PGPASSWORD=Password
SET DATETIME=%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%
SET PGDATABASE=NAME_DB
CALL "%PGBIN%\pg_dump.exe" --format=custom --verbose --file=C:\postgres_backup\%PGDATABASE%_%DATETIME%.dump
forfiles /p C:\postgres_backup /m *.dump /s /d -28 /c "cmd /c del @path /q"