-- E03S06: Add en_route_sms_sent sentinel to jobs table
-- Purpose: Prevents duplicate customer SMS sends when n8n polling workflow
--          finds multiple En Route jobs across consecutive poll cycles.
-- Story:   E03S06 — N8N En Route Customer SMS + Status Update
-- Date:    2026-03-16

-- Additive migration — safe to run on existing tables with live data.
-- Default FALSE ensures all existing rows are treated as unsent (correct behavior:
-- any job that was already En Route before this column existed has not had the
-- n8n en-route SMS sent, so it should be eligible on the next poll cycle).

ALTER TABLE jobs ADD COLUMN IF NOT EXISTS en_route_sms_sent boolean DEFAULT false;

-- Apply to the run in Supabase Dashboard:
--   Supabase → SQL Editor → paste and run
-- Or via Supabase CLI: supabase db push
