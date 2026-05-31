-- ============================================
-- VivaEventos Events - Add reminder_sent column
-- ============================================

\c vivaeventos_events;

ALTER TABLE events ADD COLUMN IF NOT EXISTS reminder_sent BOOLEAN DEFAULT FALSE;
