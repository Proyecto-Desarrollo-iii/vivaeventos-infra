-- ============================================
-- Usuario de prueba para personal de logistica
-- ============================================

\c vivaeventos_auth;

INSERT INTO users (email, password_hash, full_name, role, phone_prefix, phone, is_active)
VALUES (
    'logistica@test.com',
    '$2a$10$KhXc8G1w9WB6OzXLSLQ5buFmn5zUqYhWDX51g3rEBBUOSrjkQFYnO',  -- password: test1234
    'Personal Logística',
    'LOGISTICA',
    '+57',
    '3009876543',
    true
)
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name;
