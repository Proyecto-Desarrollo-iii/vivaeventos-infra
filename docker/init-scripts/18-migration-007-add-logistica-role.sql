-- ============================================
-- Migration: Agregar rol LOGISTICA al CHECK
-- ============================================

\c vivaeventos_auth;

ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_check;
ALTER TABLE users ADD CONSTRAINT users_role_check CHECK (role IN ('CLIENT', 'ORGANIZER', 'ADMIN', 'LOGISTICA'));
