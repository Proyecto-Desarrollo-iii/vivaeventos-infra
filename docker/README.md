# VivaEventos - Base de Datos

## Requisitos

- Docker Desktop instalado y corriendo
- Docker Compose v2+ (`docker compose` o `docker-compose`)

## Setup Rápido

### 1. Levantar PostgreSQL con Docker

```bash
cd vivaeventos-infra/docker
docker compose up -d
```

### 2. Esperar a que PostgreSQL esté listo

```bash
docker compose ps
# Verificar que dice "healthy"
```

### 3. Verificar conexión

```bash
docker exec -it vivaeventos-postgres psql -U devdb -d postgres -c "SELECT version();"
```

## Bases de Datos Creadas

| Microservicio | Base de Datos |
|--------------|---------------|
| Auth | vivaeventos_auth |
| Events | vivaeventos_events |
| Tickets | vivaeventos_tickets |
| Orders | vivaeventos_orders |
| Payments | vivaeventos_payments |
| Checkin | vivaeventos_checkin |
| Notifications | vivaeventos_notifications |
| Analytics | vivaeventos_analytics |
| Audit | vivaeventos_audit |

## Comandos Útiles

### Conectar directamente a una base de datos

```bash
docker exec -it vivaeventos-postgres psql -U devdb -d vivaeventos_auth
```

### Ver todas las bases de datos

```bash
docker exec -it vivaeventos-postgres psql -U devdb -l
```

### Ver tablas de una base de datos

```bash
docker exec -it vivaeventos-postgres psql -U devdb -d vivaeventos_auth -c "\dt"
```

### Detener los servicios

```bash
docker compose down
```

### Detener y eliminar datos

```bash
docker compose down -v
```

### Ver logs

```bash
docker compose logs -f postgres
```

## Configuración de Conexión (Spring Boot)

### vivaeventos-auth

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/vivaeventos_auth
spring.datasource.username=devdb
spring.datasource.password=a1b2c3d4
```

### Cambiar segun el microservicio

Para cada servicio, cambia solo el nombre de la base de datos:

```properties
# vivaeventos-events
spring.datasource.url=jdbc:postgresql://localhost:5432/vivaeventos_events

# vivaeventos-tickets
spring.datasource.url=jdbc:postgresql://localhost:5432/vivaeventos_tickets

# etc...
```

## Datos de Conexión por Defecto

```
Host: localhost
Port: 5432
Database: postgres (admin), o la BD del servicio
Username: devdb
Password: a1b2c3d4
```

## Solución de Problemas

### "Port 5432 is already in use"

Hay otro PostgreSQL corriendo. Puedes:

1. Detener el otro servicio, o
2. Cambiar el puerto en docker-compose.yml:

```yaml
ports:
  - "5433:5432"  # Ahora accedes por puerto 5433
```

Y luego cambiar tu application.properties:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5433/vivaeventos_auth
```

### "Connection refused"

```bash
# Verificar que Docker está corriendo
docker compose ps

# Reiniciar
docker compose restart postgres
```

### "Database does not exist"

Espera más tiempo - a veces PostgreSQL tarda en crear las bases de datos. Verifica:

```bash
docker exec -it vivaeventos-postgres psql -U devdb -l | grep vivaeventos
```

Si no aparece, puedes crearla manualmente:

```bash
docker exec -it vivaeventos-postgres psql -U devdb -c "CREATE DATABASE vivaeventos_auth;"
```

## Para Companeros de Equipo

1. Instalar Docker Desktop
2. Clonar el repositorio
3. Copiar este directorio `vivaeventos-infra/docker` a su proyecto
4. Seguir los pasos de "Setup Rápido"

Todo estará funcionando en minutos, sin necesidad de instalar PostgreSQL localmente.