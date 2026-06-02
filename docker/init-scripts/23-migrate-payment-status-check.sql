-- ============================================================
-- VivaEventos Payments - Actualización de CHECK constraint
-- Razón: Sincronizar estados admitidos con el Enum PaymentStatus de Java (PAID)
-- ============================================================

\c vivaeventos_payments;

-- 1. Eliminamos la restricción antigua que bloqueaba el estado PAID
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_status_check;

-- 2. Creamos la nueva restricción incluyendo el estado oficial del backend
ALTER TABLE payments ADD CONSTRAINT payments_status_check
    CHECK (status IN ('PENDING', 'PAID', 'SUCCESSFUL', 'FAILED', 'REFUNDED'));
