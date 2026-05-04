-- ============================================
-- VivaEventos Events - Schema y Tablas
-- ============================================

\c vivaeventos_events;

CREATE TABLE IF NOT EXISTS organizers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    company_name VARCHAR(255),
    nit VARCHAR(50),
    address VARCHAR(500),
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS venues (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    address VARCHAR(500) NOT NULL,
    city VARCHAR(100),
    capacity INT,
    amenities TEXT[],
    contact_phone VARCHAR(50),
    contact_email VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organizer_id UUID NOT NULL,
    venue_id UUID REFERENCES venues(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    event_date TIMESTAMP NOT NULL,
    event_end_date TIMESTAMP,
    location VARCHAR(500),
    city VARCHAR(100),
    banner_url VARCHAR(500),
    status VARCHAR(50) DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'PUBLISHED', 'CANCELLED', 'COMPLETED')),
    category VARCHAR(100),
    age_restriction INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ticket_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    quantity_sold INT DEFAULT 0,
    max_per_user INT DEFAULT 10,
    sale_start TIMESTAMP,
    sale_end TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS event_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_events_organizer_id ON events(organizer_id);
CREATE INDEX idx_events_status ON events(status);
CREATE INDEX idx_events_date ON events(event_date);
CREATE INDEX idx_ticket_types_event_id ON ticket_types(event_id);