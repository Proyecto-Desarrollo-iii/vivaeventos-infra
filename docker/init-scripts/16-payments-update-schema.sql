-- ============================================
-- Actualizar schema de payments para nuevo modelo
-- ============================================

\c vivaeventos_payments;

-- Hacer user_id nullable
ALTER TABLE payments ALTER COLUMN user_id DROP NOT NULL;

-- Agregar columna user_email
ALTER TABLE payments ADD COLUMN IF NOT EXISTS user_email VARCHAR(255);

-- Agregar columna refund_id (si no existe)
ALTER TABLE payments ADD COLUMN IF NOT EXISTS refund_id VARCHAR(255);

-- Verificar estructura final
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'payments' 
ORDER BY ordinal_position;