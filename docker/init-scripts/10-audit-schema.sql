-- ============================================
-- VivaEventos Audit - Schema y Tablas
-- ============================================

\c vivaeventos_audit;

CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_name VARCHAR(100) NOT NULL,
    user_id UUID,
    user_role VARCHAR(50),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(50),
    user_agent TEXT,
    request_id UUID,
    correlation_id UUID,
    status VARCHAR(50),
    error_message VARCHAR(500),
    duration_ms INT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS audit_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    filters JSONB,
    generated_by UUID NOT NULL,
    generated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS compliance_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(100) NOT NULL,
    user_id UUID,
    data JSONB NOT NULL,
    retention_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sensitive_data_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    data_type VARCHAR(100) NOT NULL,
    entity_id UUID,
    access_reason VARCHAR(255),
    ip_address VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_service ON audit_logs(service_name);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);