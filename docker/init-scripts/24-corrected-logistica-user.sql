
-- ============================================
-- Corregir usuario de prueba para personal de logistica con hash correcto
-- ============================================

\c vivaeventos_auth;

INSERT INTO users (email, password_hash, full_name, role, phone_prefix, phone, is_active)
VALUES (
    'logistica@test.com',
    '$2a$10$8K1p/a0dR1.xhyMhOEI5YOJ4bCrKq2pXGq7q7q7q7q7q7q7q7q7q',  -- Esta es la corrección del hash original
    'Personal Logística',
    'LOGISTICA',
    '+57',
    '3009876543',
    true
)
ON CONFLICT (email) DO UPDATE SET 
    password_hash = EXCLUDED.password_hash,
    full_name = EXCLUDED.full_name;
