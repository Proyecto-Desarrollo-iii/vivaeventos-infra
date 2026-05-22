-- ============================================
-- VivaEventos Events - Schema y Tablas
-- ============================================

\c vivaeventos_events;

CREATE TABLE IF NOT EXISTS events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organizer_id UUID NOT NULL,
    venue_id UUID,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    event_end_date TIMESTAMP,
    event_date_time TIMESTAMP NOT NULL DEFAULT NOW(),
    location VARCHAR(500),
    city VARCHAR(100),
    banner_url VARCHAR(500),
    status VARCHAR(50) DEFAULT 'DRAFT',
    category VARCHAR(100) NOT NULL,
    age_restriction INT DEFAULT 0,
    thumbnail_url TEXT,
    venue_name VARCHAR(255),
    address VARCHAR(255),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    maps_embed_url TEXT,
    maps_link_url TEXT,
    artist_name VARCHAR(255),
    spotify_url TEXT,
    instagram_url TEXT,
    twitter_url TEXT,
    social_links TEXT,
    is_published BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tickets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    type VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    capacity INT NOT NULL,
    sold_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ticket_conditions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id UUID NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
    type VARCHAR(100) NOT NULL,
    value VARCHAR(500) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_events_organizer_id ON events(organizer_id);
CREATE INDEX idx_tickets_event_id ON tickets(event_id);
CREATE INDEX idx_conditions_ticket_id ON ticket_conditions(ticket_id);