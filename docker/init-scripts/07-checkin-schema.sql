-- ============================================
-- VivaEventos Checkin - Schema y Tablas
-- ============================================

\c vivaeventos_checkin;

CREATE TABLE IF NOT EXISTS venues (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    address VARCHAR(500),
    event_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS checkin_points (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    entrance_type VARCHAR(50) DEFAULT 'MAIN',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS checkin_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id UUID NOT NULL,
    event_id UUID NOT NULL,
    venue_id UUID,
    checkin_point_id UUID,
    validated_by UUID NOT NULL,
    qr_scanned VARCHAR(255),
    validation_result VARCHAR(50) NOT NULL,
    failure_reason VARCHAR(255),
    device_info VARCHAR(255),
    network_status VARCHAR(50),
    response_time_ms INT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS checkin_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    event_id UUID NOT NULL,
    checkin_point_id UUID,
    started_at TIMESTAMP DEFAULT NOW(),
    ended_at TIMESTAMP,
    tickets_validated INT DEFAULT 0
);

CREATE INDEX idx_checkin_logs_ticket_id ON checkin_logs(ticket_id);
CREATE INDEX idx_checkin_logs_event_id ON checkin_logs(event_id);
CREATE INDEX idx_checkin_logs_created_at ON checkin_logs(created_at);