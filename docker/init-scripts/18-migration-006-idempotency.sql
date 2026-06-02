-- ============================================================
-- Migración: Idempotencia en Pagos
-- Descripción: Agrega soporte para idempotency keys en pagos y
--              refunds, más deduplicación de webhooks Stripe.
-- ============================================================

-- 1. Payment: nuevas columnas + índices únicos parciales

\c vivaeventos_payments;

ALTER TABLE payments ADD COLUMN IF NOT EXISTS idempotency_key VARCHAR(255);
ALTER TABLE payments ADD COLUMN IF NOT EXISTS version BIGINT DEFAULT 0;
ALTER TABLE payments ADD COLUMN IF NOT EXISTS refund_idempotency_key VARCHAR(255);

CREATE UNIQUE INDEX IF NOT EXISTS uk_payments_idempotency_key
    ON payments(idempotency_key)
    WHERE idempotency_key IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uk_payments_refund_idempotency_key
    ON payments(refund_idempotency_key)
    WHERE refund_idempotency_key IS NOT NULL;

-- 2. Webhook deduplication table
CREATE TABLE IF NOT EXISTS webhook_events (
    event_id VARCHAR(255) PRIMARY KEY,
    payment_intent_id VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_webhook_events_created_at
    ON webhook_events(created_at);

COMMENT ON TABLE webhook_events IS 'Tracking de eventos Stripe ya procesados para evitar duplicados';
COMMENT ON COLUMN payments.idempotency_key IS 'Key de idempotencia del cliente para creación de pagos';
COMMENT ON COLUMN payments.version IS 'Version de optimistic locking para concurrencia';
COMMENT ON COLUMN payments.refund_idempotency_key IS 'Key de idempotencia del cliente para refunds';
