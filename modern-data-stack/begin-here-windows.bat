@echo off
setlocal

REM Check and download nifi-hadoop-libraries-nar-2.4.0.nar
if not exist ".\configs\nifi\nifi-hadoop-libraries-nar-2.4.0.nar" (
    powershell -Command "Invoke-WebRequest -Uri https://repo.maven.apache.org/maven2/org/apache/nifi/nifi-hadoop-libraries-nar/2.4.0/nifi-hadoop-libraries-nar-2.4.0.nar -OutFile .\configs\nifi\nifi-hadoop-libraries-nar-2.4.0.nar"
    if errorlevel 1 (
        echo Failed to download nifi-hadoop-libraries-nar-2.4.0.nar
        exit /b 1
    )
) else (
    echo nifi-hadoop-libraries-nar-2.4.0.nar already exists, skipping download.
)

REM Check and download nifi-parquet-nar-2.4.0.nar
if not exist ".\configs\nifi\nifi-parquet-nar-2.4.0.nar" (
    powershell -Command "Invoke-WebRequest -Uri https://repo.maven.apache.org/maven2/org/apache/nifi/nifi-parquet-nar/2.4.0/nifi-parquet-nar-2.4.0.nar -OutFile .\configs\nifi\nifi-parquet-nar-2.4.0.nar"
    if errorlevel 1 (
        echo Failed to download nifi-parquet-nar-2.4.0.nar
        exit /b 1
    )
) else (
    echo nifi-parquet-nar-2.4.0.nar already exists, skipping download.
)
echo Checked required NAR files.

REM Check and download postgresql-42.7.5.jar
if not exist ".\configs\nifi\postgresql-42.7.5.jar" (
    powershell -Command "Invoke-WebRequest -Uri https://jdbc.postgresql.org/download/postgresql-42.7.5.jar -OutFile .\configs\nifi\postgresql-42.7.5.jar"
    if errorlevel 1 (
        echo Failed to download postgresql-42.7.5.jar
        exit /b 1
    )
) else (
    echo postgresql-42.7.5.jar already exists, skipping download.
)
echo Checked PostgreSQL JDBC driver.

REM Check and download pagila-schema.sql
if not exist ".\configs\pagila\pagila-schema.sql" (
    powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/devrimgunduz/pagila/refs/heads/master/pagila-schema.sql -OutFile .\configs\pagila\pagila-schema.sql"
    if errorlevel 1 (
        echo Failed to download pagila-schema.sql
        exit /b 1
    )
) else (
    echo pagila-schema.sql already exists, skipping download.
)
echo Checked Pagila database schema.

REM Check and download pagila-data.sql
if not exist ".\configs\pagila\pagila-data.sql" (
    powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/devrimgunduz/pagila/refs/heads/master/pagila-data.sql -OutFile .\configs\pagila\pagila-data.sql"
    if errorlevel 1 (
        echo Failed to download pagila-data.sql
        exit /b 1
    )
) else (
    echo pagila-data.sql already exists, skipping download.
)
echo Checked Pagila database data.

REM Start Docker Compose
docker compose -f docker-compose.yml up -d
echo Modern Data Stack is starting up...

endlocal