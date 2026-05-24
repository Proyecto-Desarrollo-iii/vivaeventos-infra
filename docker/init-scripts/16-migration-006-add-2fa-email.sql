-- Migration 006: Agregar columna two_factor_method y tabla two_factor_codes
-- Ejecutar contra BD existente: psql -d vivaeventos_auth -f 16-migration-006-add-2fa-email.sql

\c vivaeventos_auth;

ALTER TABLE users ADD COLUMN IF NOT EXISTS two_factor_method VARCHAR(10) DEFAULT 'APP';

CREATE TABLE IF NOT EXISTS two_factor_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    code VARCHAR(10) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_two_factor_codes_user_id ON two_factor_codes(user_id);
