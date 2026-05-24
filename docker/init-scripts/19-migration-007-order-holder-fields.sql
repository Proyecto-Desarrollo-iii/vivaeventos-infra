-- ============================================
-- VivaEventos Orders - Add holder fields to order_items
-- ============================================

\c vivaeventos_orders;

ALTER TABLE order_items ADD COLUMN IF NOT EXISTS holder_name VARCHAR(255);
ALTER TABLE order_items ADD COLUMN IF NOT EXISTS holder_email VARCHAR(255);
ALTER TABLE order_items ADD COLUMN IF NOT EXISTS holder_document VARCHAR(50);
