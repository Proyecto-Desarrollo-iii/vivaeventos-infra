-- ============================================
-- VivaEventos Notifications - Schema y Tablas
-- ============================================

\c vivaeventos_notifications;

CREATE TABLE IF NOT EXISTS notification_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    channel VARCHAR(50) NOT NULL CHECK (channel IN ('EMAIL', 'SMS', 'PUSH', 'WHATSAPP')),
    subject VARCHAR(255),
    body_template TEXT NOT NULL,
    variables TEXT[],
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    template_id UUID REFERENCES notification_templates(id),
    channel VARCHAR(50) NOT NULL,
    recipient VARCHAR(255) NOT NULL,
    subject VARCHAR(255),
    body TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'QUEUED', 'SENT', 'DELIVERED', 'FAILED', 'READ')),
    priority INT DEFAULT 0,
    scheduled_for TIMESTAMP,
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    read_at TIMESTAMP,
    error_message VARCHAR(255),
    retry_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS notification_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID NOT NULL REFERENCES notifications(id) ON DELETE CASCADE,
    provider VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    attempts INT DEFAULT 0,
    last_attempt TIMESTAMP,
    next_attempt TIMESTAMP,
    error_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL,
    email_notifications BOOLEAN DEFAULT TRUE,
    sms_notifications BOOLEAN DEFAULT TRUE,
    whatsapp_notifications BOOLEAN DEFAULT TRUE,
    marketing_opt_in BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_status ON notifications(status);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);