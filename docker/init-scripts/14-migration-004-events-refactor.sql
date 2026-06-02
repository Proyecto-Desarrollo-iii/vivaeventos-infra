-- Migration 004: Refactor esquema de eventos (tablas tickets y columnas faltantes)
-- Ejecutar contra BD existente: psql -d vivaeventos_events -f 14-migration-004-events-refactor.sql

\c vivaeventos_events;

-- Agregar columnas nuevas a events
-- Agregar columnas nuevas a events de manera segura para entornos limpios
ALTER TABLE events ADD COLUMN IF NOT EXISTS event_date_time TIMESTAMP;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='events' AND column_name='event_date') THEN
        UPDATE events SET event_date_time = event_date WHERE event_date_time IS NULL;
    END IF;
END $$;

ALTER TABLE events ALTER COLUMN event_date_time SET NOT NULL;

ALTER TABLE events ADD COLUMN IF NOT EXISTS thumbnail_url TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS venue_name VARCHAR(255);
ALTER TABLE events ADD COLUMN IF NOT EXISTS address VARCHAR(255);
ALTER TABLE events ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION;
ALTER TABLE events ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;
ALTER TABLE events ADD COLUMN IF NOT EXISTS maps_embed_url TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS maps_link_url TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS artist_name VARCHAR(255);
ALTER TABLE events ADD COLUMN IF NOT EXISTS spotify_url TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS instagram_url TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS twitter_url TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS is_published BOOLEAN DEFAULT FALSE;

ALTER TABLE events ALTER COLUMN category SET NOT NULL;
ALTER TABLE events DROP CONSTRAINT IF EXISTS events_status_check;

-- Crear tabla tickets
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

-- Crear tabla ticket_conditions
CREATE TABLE IF NOT EXISTS ticket_conditions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id UUID NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
    type VARCHAR(100) NOT NULL,
    value VARCHAR(500) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_events_organizer_id ON events(organizer_id);
CREATE INDEX IF NOT EXISTS idx_tickets_event_id ON tickets(event_id);
CREATE INDEX IF NOT EXISTS idx_conditions_ticket_id ON ticket_conditions(ticket_id);
