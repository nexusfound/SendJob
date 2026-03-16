---
type: memory
category: decisions
id: DECISIONS-LOG
tags:
  - decisions
  - governance
created_at: 2026-03-15
updated_at: 2026-03-15
next_available_id: DEC-017
---

# Decision Log

> Append-only. Never delete or overwrite decisions.
> Only the Discovery Agent may add entries (or Bootstrap Agent during initialization).
> Format: one entry per decision, newest at top.

---

## Decision Registry

| DEC ID | Domain | Level | Description |
|---|---|---|---|
| DEC-016 | architecture | operational | n8n customer notification pattern: Schedule Trigger (30s) polls Supabase for jobs matching status + boolean sentinel (en_route_sms_sent/on_site_sms_sent=false); native Twilio node sends SMS; PATCH sets sentinel=true; continueOnFail on both Twilio and PATCH nodes — SMS failure never reverts job status |
| DEC-015 | architecture | operational | n8n workflow chaining via webhook: downstream workflow (E03S03) triggered by HTTP Request POST from upstream workflow (E03S02) true-branch; all context passed in POST body — no shared state, no modifying delivered workflows |
| DEC-014 | architecture | operational | Dashboard writes to Supabase via browser fetch PATCH (same apikey/Bearer pattern as reads; Prefer: return=representation; inline error on failure) |
| DEC-013 | architecture | architectural | Magic link auth for technicians (token in techs table) |
| DEC-012 | architecture | architectural | Subdomain identity via hidden form field (not Host header) |
| DEC-011 | architecture | architectural | Parameterized n8n workflows — one set handles all clients |
| DEC-010 | infrastructure | strategic | Resend for transactional email (not Gmail) |
| DEC-009 | billing | strategic | Pricing model: $199 setup + $97/month recurring |
| DEC-008 | strategy | strategic | GoHighLevel, Lovable, and WordPress evaluated and rejected |
| DEC-007 | strategy | strategic | Website builds as a service ruled out |
| DEC-006 | infrastructure | operational | Twilio A2P 10DLC for SMS — native n8n Twilio node (CORRECTED from HTTP Request) |
| DEC-005 | infrastructure | operational | Service Account auth for Google Sheets (not OAuth) |
| DEC-004 | infrastructure | architectural | Netlify for Playbook static hosting — single index.html per play |
| DEC-003 | architecture | architectural | HTTP Request nodes over native Supabase nodes in n8n v2.6.4 |
| DEC-002 | infrastructure | strategic | Supabase as database and auth layer |
| DEC-001 | architecture | strategic | n8n as primary automation engine (self-hosted at nexusfound.cloud) |

---

---

## DEC-014 — Dashboard Supabase PATCH Pattern

**Date:** 2026-03-15
**Story:** E02S07
**Domain:** architecture
**Level:** operational

**Decision:** Dashboard-side writes to Supabase use browser `fetch` with the same `apikey` + `Authorization: Bearer` headers as reads. PATCH requests include `Prefer: return=representation` and `Content-Type: application/json`. On failure, the UI shows an inline error and re-enables the control for retry — never silently shows incorrect state.

**Rationale:** Consistent with the existing GET pattern from E02S05. No additional client libraries needed. Pattern is repeatable for all future dashboard writes (auth callbacks, status buttons, etc.).

---

## DEC-016 — N8N Customer Notification: Polling + Deduplication Sentinel

**Date:** 2026-03-16
**Story:** E03S06
**Domain:** architecture
**Level:** operational

**Decision:** Customer notification workflows (En Route, On Site) use a Schedule Trigger (30s) polling pattern with a boolean deduplication sentinel column per notification type (`en_route_sms_sent`, `on_site_sms_sent`). The poll filter is `status=eq.[Status]&[sentinel]=eq.false`. After sending, the PATCH sets only the sentinel to `true` — `jobs.status` is never modified. Both the Twilio node and the PATCH node use `continueOnFail: true` so SMS delivery failures cannot revert or corrupt job status. Null `customer_phone` is guarded by an IF node that routes directly to the PATCH, skipping the Twilio node entirely.

**Rationale:** Polling was chosen over Supabase webhook (pg_net) per Story Notes: simpler to implement, acceptable for Sprint 3, no additional infrastructure required. The sentinel pattern is idempotent — if the PATCH fails after SMS send, the next poll cycle retries safely (canonical template is the same message). This pattern is reused by E03S07 (On Site SMS) with only three changes: status filter, sentinel column name, and SMS template text.

---

<!-- Add decisions above this line, newest first -->
