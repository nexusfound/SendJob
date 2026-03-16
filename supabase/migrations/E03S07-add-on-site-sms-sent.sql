-- E03S07: Add on_site_sms_sent sentinel column to jobs table
-- Story: N8N On Site Customer SMS + Status Update
--
-- Purpose: Deduplication sentinel for the On Site SMS polling workflow.
-- The workflow polls for jobs where status='On Site' AND on_site_sms_sent=false.
-- After sending (or skipping on null phone), the workflow PATCHes on_site_sms_sent=true.
--
-- IF NOT EXISTS: prevents failure if column was already added manually.
-- DEFAULT false: all existing rows treated as not-yet-sent.
--
-- RLS NOTE: jobs table anon UPDATE policy already exists (confirmed E03S05, E03S06).
-- No new RLS policy required.
--
-- Rollback: ALTER TABLE jobs DROP COLUMN on_site_sms_sent;

ALTER TABLE jobs ADD COLUMN IF NOT EXISTS on_site_sms_sent boolean DEFAULT false;
