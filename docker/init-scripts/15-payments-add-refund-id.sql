-- Add refund_id column to payments table
\c vivaeventos_payments;

ALTER TABLE payments ADD COLUMN IF NOT EXISTS refund_id VARCHAR(255);