-- Migration 005: Agregar columnas para 2FA
-- Ejecutar contra BD existente: psql -d vivaeventos_auth -f 15-migration-005-add-2fa.sql

\c vivaeventos_auth;

ALTER TABLE users ADD COLUMN IF NOT EXISTS two_factor_secret VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS two_factor_enabled BOOLEAN NOT NULL DEFAULT FALSE;
