-- Migration 005: Add social_links column to events table
ALTER TABLE events ADD COLUMN IF NOT EXISTS social_links TEXT;
