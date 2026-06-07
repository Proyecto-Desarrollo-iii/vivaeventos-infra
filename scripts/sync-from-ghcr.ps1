param(
    [switch]$NoRestart
)

$ComposeDir = Join-Path $PSScriptRoot "..\docker"
$ComposeFile = Join-Path $ComposeDir "docker-compose.yml"

if (!(Test-Path $ComposeFile)) {
    Write-Host "ERROR: No se encuentra docker-compose.yml en $ComposeDir" -ForegroundColor Red
    exit 1
}

# Verificar si hay sesión en ghcr.io
$DockerConfig = "$env:USERPROFILE\.docker\config.json"
$LoggedIn = $false
if (Test-Path $DockerConfig) {
    $Config = Get-Content $DockerConfig | ConvertFrom-Json
    if ($Config.auths.'ghcr.io') { $LoggedIn = $true }
}

if (-not $LoggedIn) {
    Write-Host "No hay sesión activa en ghcr.io" -ForegroundColor Yellow
    $User = $env:GHCR_USER
    $TokenB64 = $env:GHCR_TOKEN_B64
    if ($User -and $TokenB64) {
        $Token = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($TokenB64))
        Write-Host "Iniciando sesión desde variables de entorno..." -ForegroundColor Cyan
        docker login ghcr.io -u $User -p $Token
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERROR: No se pudo autenticar. Ejecuta primero: .\scripts\setup-ghcr.ps1" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "No hay credenciales guardadas." -ForegroundColor Red
        Write-Host "Ejecuta primero: .\scripts\setup-ghcr.ps1" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "Descargando últimas imágenes desde GitHub Container Registry..." -ForegroundColor Cyan
Set-Location $ComposeDir
docker compose pull

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: No se pudieron descargar las imágenes" -ForegroundColor Red
    exit 1
}

if (-not $NoRestart) {
    Write-Host "Reiniciando contenedores con las nuevas imágenes..." -ForegroundColor Cyan
    docker compose up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Contenedores actualizados y corriendo" -ForegroundColor Green
    }
} else {
    Write-Host "✓ Imágenes descargadas (usa --NoRestart para solo descargar)" -ForegroundColor Green
}
