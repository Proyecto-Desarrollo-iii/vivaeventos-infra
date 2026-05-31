-- ============================================
-- VivaEventos Payments - Add promotions table
-- ============================================

\c vivaeventos_payments;

CREATE TABLE IF NOT EXISTS promotions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    code VARCHAR(50) NOT NULL,
    discount VARCHAR(255) NOT NULL,
    event_name VARCHAR(255),
    expires_at TIMESTAMP NOT NULL,
    used_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
