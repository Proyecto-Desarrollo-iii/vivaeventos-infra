-- ============================================
-- VivaEventos Orders - Schema y Tablas
-- ============================================

\c vivaeventos_orders;

CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    event_id UUID NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PROCESSING', 'PAID', 'FAILED', 'CANCELLED', 'REFUNDED')),
    promo_code VARCHAR(50),
    promo_code_id UUID,
    notes TEXT,
    client_ip VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    paid_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    event_id UUID,
    event_name VARCHAR(255),
    ticket_type_id UUID NOT NULL,
    ticket_type_name VARCHAR(255),
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS promo_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    discount_type VARCHAR(50) CHECK (discount_type IN ('PERCENTAGE', 'FIXED')),
    discount_value DECIMAL(10,2) NOT NULL,
    min_purchase DECIMAL(10,2) DEFAULT 0,
    max_uses INT,
    uses_count INT DEFAULT 0,
    event_id UUID,
    starts_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    version BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS promo_code_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    promo_code_id UUID NOT NULL REFERENCES promo_codes(id) ON DELETE CASCADE,
    order_id UUID NOT NULL,
    user_id UUID NOT NULL,
    used_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_event_id ON orders(event_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_promo_codes_code ON promo_codes(code);