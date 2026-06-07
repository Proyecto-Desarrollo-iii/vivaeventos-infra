# vivaeventos-infra

Infraestructura como código para el sistema VivaEventos.

## Descripción

Encargado de:
- Dockerfiles
- Kubernetes manifests
- Terraform
- Scripts de despliegue

## Sincronización con GitHub Container Registry

Cada servicio tiene CI/CD que construye imágenes Docker y las publica en
`ghcr.io/proyecto-desarrollo-iii/vivaeventos-{servicio}:main`.

### 1. Autenticación (una sola vez)

Crea un GitHub Personal Access Token con permiso `read:packages` en:
https://github.com/settings/tokens

```powershell
.\scripts\setup-ghcr.ps1
```

### 2. Sincronización manual

Para descargar las últimas imágenes y reiniciar contenedores:

```powershell
.\scripts\sync-from-ghcr.ps1
```

### 3. Sincronización automática (Watchtower)

```powershell
docker compose --profile auto-update up watchtower -d
```

Watchtower revisa cada 5 minutos si hay nuevas imágenes en GHCR y actualiza
los contenedores automáticamente.

### 4. Desarrollo local (construir desde código)

Si prefieres compilar localmente sin usar GHCR:

```powershell
docker compose up -d --build
```

### 5. Modo mixto

Puedes tener Watchtower corriendo y aún así forzar una compilación local:

```powershell
docker compose up -d --build auth  # solo reconstruye auth local
```

## Documentación

Ver [MULTIREPO.md](../MULTIREPO.md)