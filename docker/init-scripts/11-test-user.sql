-- ============================================
-- Usuario de prueba para verificar login
-- ============================================

INSERT INTO users (email, password_hash, full_name, role, phone, is_active)
VALUES (
    'test@example.com',
    '$2a$10$8K1p/a0dR1.xhyMhOEI5YOJ4bCrKq2pXGq7q7q7q7q7q7q7q7q7q',  -- password: test1234
    'Usuario Prueba',
    'CLIENT',
    '3001234567',
    true
)
ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name;

-- Password: test1234 (BCrypt hash valido)
-- Para generar tu propio hash, usa:
-- docker exec -i vivaeventos-postgres psql -U devdb -d vivaeventos_auth -c "SELECT crypt('tu_password', gen_salt('bf'));"