---
type: memory
category: project
id: PROJECT-001
tags:
  - sendjob
  - nexusfound
  - trades-automation
  - n8n
  - supabase
created_at: 2026-03-15
updated_at: 2026-03-15
---

# SendJob — Project Context

> Core memory for every Claude Code session on this project.
> Load this first. Do not skip.

---

## Product

**SendJob** is the client-facing product of Nexus Found LLC.
Tagline: *"We Replace Tasks, Not People."*
Target: Small trades businesses — HVAC, plumbing, pool service, cleaning, lawn care.
Model: $199 setup + $97/month recurring. Beta clients locked at $97/month permanently.
Contact: hello@sendjob.app

---

## Domain Architecture

| Domain | Purpose |
|---|---|
| `nexusfound.com` | Company brand, legal docs |
| `sendjob.app` | Client-facing product (registered 5 years) |
| `nexusfound.cloud` | Infrastructure — n8n self-hosted (Hostinger KVM2 VPS) |

Playbook subdomains: `{client}.sendjob.app` (e.g. `joesplumbing.sendjob.app`)

Live demos: `hvac.sendjob.app`, `plumbing.sendjob.app`, `pool.sendjob.app`, `cleaning.sendjob.app`, `lawn.sendjob.app`

---

## Tech Stack

| Layer | Tool | Notes |
|---|---|---|
| Automation | n8n (self-hosted at nexusfound.cloud, v2.6.4) | Hostinger KVM2 VPS |
| Database | Supabase (project ID: `tmoxppuxrwlabqzfzvin`) | Auth, real-time, REST |
| Payments | Stripe | SendJob billing only ($199 + $97/mo). NOT end-customer payments. |
| SMS | Twilio (A2P 10DLC registered, Low Volume Mixed) | +13212489804 primary |
| Email | Resend (dispatch@sendjob.app) | Transactional email |
| Deploy | Netlify | Playbook plays + dashboards |
| DNS | Porkbun | — |

**Important:** Stripe handles Nexus Found's billing from clients only. End-customer payment links (Square/Stripe/Venmo etc.) come from the client themselves — stored in `clients.payment_link`.

---

## The Nexus Playbook

Library of industry-specific demo sites — each a sales tool and deployment template.
Each play: customer-facing intake form + dispatcher dashboard + tech dashboard in a single `index.html`.
Deployed as subdomain on `sendjob.app` via Netlify.

**Completed plays:** HVAC (AC Express), plumbing, pool, cleaning, lawn
**Canonical template:** AC Express at `hvac.sendjob.app`
**Design system:** Barlow Condensed + Barlow fonts, navy dark UI (`#0A1628`), trade accent colors — see `patterns/design-system.md`

---

## Job Lifecycle (Full Flow)

```
1.  Customer submits form at [client].sendjob.app
2.  n8n webhook fires → reads clients table by subdomain (from body field)
3.  n8n scans issue_description for urgency keywords → sets is_urgent
4.  n8n writes new job record to jobs table (status = New)
5.  Twilio SMS → customer confirmation
6.  Twilio SMS → dispatcher alert (with URGENT flag if applicable)
7.  Dispatcher replies to SMS with tech name  ──OR──  opens dashboard and assigns
8.  n8n parses reply → matches tech in techs table → updates job.status = Assigned
9.  n8n generates magic link token → stores in techs.magic_link_token
10. Twilio SMS → tech: full job details + magic link URL
11. Tech taps "En Route" → n8n → Twilio → customer SMS → job.status = En Route
12. Tech taps "On Site" → n8n → Twilio → customer SMS → job.status = On Site
13. Tech taps "Job Complete" → n8n → Twilio → customer SMS + payment link → job.status = Complete
```

**Job # format:** Last 6 chars of UUID, uppercased. e.g. `A1B2C3`. Full UUID stored in DB.

---

## Sprint Status

| Sprint | Goal | Status |
|---|---|---|
| Pre-sprint | VPS production readiness | ✅ Complete |
| Sprint 1 | Supabase schema + core n8n loop | ✅ Complete |
| Sprint 2 | Dispatcher assignment | 🔄 In progress |
| Sprint 3 | Tech flow | Pending |
| Sprint 4 | Job Complete + E2E test | Pending |
| Sprint 5 | Pilot client live | Pending |

**Sprint 1 delivered:** 3-table Supabase schema, n8n 7-node webhook workflow, urgency detection, Twilio SMS nodes (A2P approval pending).

---

## Critical n8n Patterns (Never Deviate)

- Use **HTTP Request nodes** for Supabase — NOT native Supabase nodes (type-handling bugs in v2.6.4)
- Use **native n8n Twilio node** for SMS — NOT HTTP Request (credential type: Twilio, Account SID + Auth Token)
- Supabase HTTP Request returns first element directly in n8n 2.x — access as `$('Node Name').item.json.id` (not `$json[0].id`)
- Add `Prefer: return=representation` header on Supabase POST to get inserted row back
- Subdomain passed as **hidden form field** in request body (`subdomain`) — NOT Host header
- Node references: `$('Node Name').item.json.field` — never `$json.field` for upstream nodes
- Code node output: always `return [{ json: { ... } }]`
- Expression mode must be explicitly toggled on (orange `=` icon) per field
- Google Sheets via Service Account credentials (not OAuth)
- Anthropic API calls use base64 encoding to handle special characters

---

## Owner Context

Brian — founder, Cocoa FL. Hands-on, technically capable.
Limited daytime availability → prefers self-serve, automated systems over sales-call models.
Direct communication style. Wants honest feedback, not validation.
