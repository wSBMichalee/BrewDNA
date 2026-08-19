-- migration to add scan tracking

ALTER TABLE users 
ADD COLUMN IF NOT EXISTS scan_count INT DEFAULT 0;

ALTER TABLE users 
ADD COLUMN IF NOT EXISTS scan_count_reset_at TIMESTAMPTZ DEFAULT NOW();
