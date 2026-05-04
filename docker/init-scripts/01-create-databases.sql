-- ============================================
-- VivaEventos - Setup completo de bases de datos
-- Ejecutar: docker exec -i vivaeventos-postgres psql -U devdb -d postgres
-- ============================================

-- Crear bases de datos por microservicio
CREATE DATABASE vivaeventos_auth;
CREATE DATABASE vivaeventos_events;
CREATE DATABASE vivaeventos_tickets;
CREATE DATABASE vivaeventos_orders;
CREATE DATABASE vivaeventos_payments;
CREATE DATABASE vivaeventos_checkin;
CREATE DATABASE vivaeventos_notifications;
CREATE DATABASE vivaeventos_analytics;
CREATE DATABASE vivaeventos_audit;