param(
    [string]$GitHubUser = $(Read-Host "Usuario de GitHub"),
    [string]$GitHubToken = $(Read-Host "GitHub PAT (token con permiso 'read:packages')" -AsSecureString)
)

$Bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($GitHubToken)
$PlainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Bstr)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Bstr)

Write-Host "Iniciando sesión en GitHub Container Registry..." -ForegroundColor Cyan
docker login ghcr.io -u $GitHubUser -p $PlainToken

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: No se pudo iniciar sesión en ghcr.io" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Login exitoso" -ForegroundColor Green

# Guardar en variable de entorno de usuario para el script de sync
[Environment]::SetEnvironmentVariable("GHCR_USER", $GitHubUser, "User")
$Encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($PlainToken))
[Environment]::SetEnvironmentVariable("GHCR_TOKEN_B64", $Encoded, "User")

Write-Host @"

  Configuración completada.

  Para sincronizar las imágenes manualmente:
    .\scripts\sync-from-ghcr.ps1

  Para sincronización automática cada 5 minutos:
    docker compose up watchtower -d

  Para volver a correr desde código fuente (sin GHCR):
    docker compose up -d --build
"@ -ForegroundColor Yellow
