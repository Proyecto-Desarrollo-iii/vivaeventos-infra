-- ============================================================
-- Usuarios de prueba adicionales: Cliente y Organizador
-- Contraseña para ambos: 123123123
-- ============================================================

\c vivaeventos_auth;

-- 1. Insertar usuario con rol CLIENT
INSERT INTO users (email, password_hash, full_name, role, phone_prefix, phone, is_active)
VALUES (
    'prueba@gmail.com',
    '$2a$10$f36WJqZsc.qUf4qO2wMWeuG.49hLgqAepS9Y8v2Vq4gK.fDbe6A6i',  -- password: 123123123
    'Usuario Cliente Prueba',
    'CLIENT',
    '+57',
    '3151234567',
    true
)
ON CONFLICT (email) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    role = EXCLUDED.role;

-- 2. Insertar usuario con rol ORGANIZER
INSERT INTO users (email, password_hash, full_name, role, phone_prefix, phone, is_active)
VALUES (
    'prueba2@gmail.com',
    '$2a$10$f36WJqZsc.qUf4qO2wMWeuG.49hLgqAepS9Y8v2Vq4gK.fDbe6A6i', -- password: 123123123
    'Usuario Organizador Prueba',
    'ORGANIZER',
    '+57',
    '3169876543',
    true
)
ON CONFLICT (email) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    role = EXCLUDED.role;
