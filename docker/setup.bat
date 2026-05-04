@echo off
REM ============================================
REM VivaEventos - Script de Setup de Base de Datos
REM Ejecutar desde la carpeta vivaeventos-infra/docker
REM ============================================

echo.
echo  ================================
echo  VivaEventos - Setup de Base de Datos
echo  ================================
echo.

REM Verificar si Docker esta instalado
docker --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker no esta instalado o no esta en el PATH
    echo Instala Docker Desktop desde: https://docker.com/get-started
    pause
    exit /b 1
)

REM Verificar si Docker esta corriendo
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker Desktop no esta corriendo
    echo Abre Docker Desktop y espera a que este listo
    pause
    exit /b 1
)

echo [1/4] Verificando contenedores existentes...
docker compose ps >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    docker compose down >nul 2>&1
)

echo [2/4] Levantando PostgreSQL...
docker compose up -d

echo [3/4] Esperando a que PostgreSQL este listo...
timeout /t 10 /nobreak >nul

REM Verificar que este corriendo
for /f "tokens=*" %%i in ('docker compose ps -q postgres') do set CONTAINER_ID=%%i
if "%CONTAINER_ID%"=="" (
    echo ERROR: No se pudo iniciar PostgreSQL
    echo Revisa los logs con: docker compose logs
    pause
    exit /b 1
)

REM Esperar a que este healthy
set /a attempts=0
:wait_loop
if %attempts% GEQ 30 (
    echo ERROR: Tiempo de espera agotado
    echo PostgreSQL no respondio a tiempo
    echo Revisa los logs con: docker compose logs
    pause
    exit /b 1
)

docker exec vivaeventos-postgres pg_isready -U devdb >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    set /a attempts+=1
    echo Verificando... (%attempts%/30)
    timeout /t 2 /nobreak >nul
    goto wait_loop
)

echo [4/4] Verificando bases de datos...
docker exec -i vivaeventos-postgres psql -U devdb -d postgres -c "SELECT datname FROM pg_database WHERE datname LIKE 'vivaeventos%';" >nul 2>&1

echo.
echo  ================================
echo  Setup completado!
echo  ================================
echo.
echo Bases de datos creadas:
docker exec -i vivaeventos-postgres psql -U devdb -d postgres -c "SELECT datname FROM pg_database WHERE datname LIKE 'vivaeventos%' ORDER BY datname;"
echo.
echo Comandos utiles:
echo   - Conectar a una BD: docker exec -it vivaeventos-postgres psql -U devdb -d vivaeventos_auth
echo   - Ver logs: docker compose logs -f
echo   - Detener: docker compose down
echo.
pause