-- Asegurar que se conecte a la BD de eventos antes de alterar la tabla
\c vivaeventos_events;

ALTER TABLE events ADD COLUMN IF NOT EXISTS social_links TEXT;
