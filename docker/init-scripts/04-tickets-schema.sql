-- ============================================
-- VivaEventos Tickets - Schema y Tablas
-- ============================================

\c vivaeventos_tickets;

CREATE TABLE IF NOT EXISTS tickets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL,
    ticket_type_id UUID NOT NULL,
    order_id UUID NOT NULL,
    user_id UUID NOT NULL,
    qr_code VARCHAR(255) UNIQUE NOT NULL,
    sequential_number INT NOT NULL,
    status VARCHAR(50) DEFAULT 'VALID' CHECK (status IN ('VALID', 'USED', 'CANCELLED', 'REFUNDED')),
    used_at TIMESTAMP,
    used_by UUID,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ticket_validations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id UUID NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
    validated_by UUID NOT NULL,
    venue_id UUID,
    validation_time TIMESTAMP DEFAULT NOW(),
    device_info VARCHAR(255),
    success BOOLEAN DEFAULT TRUE,
    failure_reason VARCHAR(255)
);

CREATE INDEX idx_tickets_event_id ON tickets(event_id);
CREATE INDEX idx_tickets_order_id ON tickets(order_id);
CREATE INDEX idx_tickets_qr_code ON tickets(qr_code);
CREATE INDEX idx_tickets_status ON tickets(status);