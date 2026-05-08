-- Migration 002: Agregar campos de perfil adicionales
-- Ejecutar contra BD existente: psql -d vivaeventos_auth -f 12-migration-002-add-profile-fields.sql

\c vivaeventos_auth;

ALTER TABLE users ADD COLUMN IF NOT EXISTS phone_prefix VARCHAR(10) DEFAULT '';
ALTER TABLE users ADD COLUMN IF NOT EXISTS country VARCHAR(100) DEFAULT '';
ALTER TABLE users ADD COLUMN IF NOT EXISTS birth_date DATE;
