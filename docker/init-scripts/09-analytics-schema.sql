-- ============================================
-- VivaEventos Analytics - Schema y Tablas
-- ============================================

\c vivaeventos_analytics;

CREATE TABLE IF NOT EXISTS events_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL,
    metric_date DATE NOT NULL,
    views INT DEFAULT 0,
    unique_visitors INT DEFAULT 0,
    tickets_added_to_cart INT DEFAULT 0,
    cart_abandoned INT DEFAULT 0,
    checkout_started INT DEFAULT 0,
    checkout_completed INT DEFAULT 0,
    total_revenue DECIMAL(12,2) DEFAULT 0,
    conversion_rate DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS hourly_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL,
    stat_hour TIMESTAMP NOT NULL,
    tickets_sold INT DEFAULT 0,
    revenue DECIMAL(12,2) DEFAULT 0,
    page_views INT DEFAULT 0,
    unique_sessions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_activity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    event_id UUID,
    activity_type VARCHAR(50) NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dashboard_cache (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cache_key VARCHAR(255) UNIQUE NOT NULL,
    data JSONB NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS incidents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID,
    incident_type VARCHAR(100) NOT NULL,
    severity VARCHAR(50) DEFAULT 'LOW',
    description TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_events_metrics_event_id ON events_metrics(event_id);
CREATE INDEX idx_events_metrics_date ON events_metrics(metric_date);
CREATE INDEX idx_hourly_stats_event_id ON hourly_stats(event_id);
CREATE INDEX idx_user_activity_user_id ON user_activity(user_id);
CREATE INDEX idx_incidents_event_id ON incidents(event_id);