---
type: memory_index
id: MEMORY-INDEX
updated_at: 2026-03-15
---

# Memory Map

> Always keep this index current. Agents use it to know what exists before calling `memory-retrieve`.
> Update when files are added, archived, or compacted.

---

## Active Files

| File | Category | ID | Last updated |
|---|---|---|---|
| `project/context.md` | project | PROJECT-001 | 2026-03-15 |
| `patterns/conventions.md` | patterns | PATTERNS-001 | 2026-03-15 |
| `patterns/design-system.md` | patterns | DESIGN-SYSTEM-001 | 2026-03-15 |
| `decisions/_log.md` | decisions | DECISIONS-LOG | 2026-03-15 |
| `decisions/DEC-001.md` | decisions | DEC-001 | 2026-03-15 |
| `decisions/DEC-002.md` | decisions | DEC-002 | 2026-03-15 |
| `decisions/DEC-003.md` | decisions | DEC-003 | 2026-03-15 |
| `decisions/DEC-004.md` | decisions | DEC-004 | 2026-03-15 |
| `decisions/DEC-005.md` | decisions | DEC-005 | 2026-03-15 |
| `decisions/DEC-006.md` | decisions | DEC-006 | 2026-03-15 |
| `decisions/DEC-007.md` | decisions | DEC-007 | 2026-03-15 |
| `decisions/DEC-008.md` | decisions | DEC-008 | 2026-03-15 |
| `decisions/DEC-009.md` | decisions | DEC-009 | 2026-03-15 |
| `decisions/DEC-010.md` | decisions | DEC-010 | 2026-03-15 |
| `decisions/DEC-011.md` | decisions | DEC-011 | 2026-03-15 |
| `decisions/DEC-012.md` | decisions | DEC-012 | 2026-03-15 |
| `decisions/DEC-013.md` | decisions | DEC-013 | 2026-03-15 |

---

## Decision Registry

| DEC ID | Domain | Level | Description |
|---|---|---|---|
| DEC-001 | architecture | strategic | n8n as primary automation engine |
| DEC-002 | infrastructure | strategic | Supabase as database and auth layer |
| DEC-003 | architecture | architectural | HTTP Request nodes over native Supabase nodes (n8n v2.6.4) |
| DEC-004 | infrastructure | architectural | Netlify static hosting — single index.html per Playbook play |
| DEC-005 | infrastructure | operational | Service Account auth for Google Sheets |
| DEC-006 | infrastructure | operational | Twilio A2P 10DLC — native n8n Twilio node (not HTTP Request) |
| DEC-007 | strategy | strategic | Website builds as a service ruled out |
| DEC-008 | strategy | strategic | GoHighLevel / Lovable / WordPress evaluated and rejected |
| DEC-009 | billing | strategic | Pricing: $199 setup + $97/month recurring |
| DEC-010 | infrastructure | strategic | Resend for transactional email (not Gmail) |
| DEC-011 | architecture | architectural | Parameterized n8n workflows — one set handles all clients |
| DEC-012 | architecture | architectural | Subdomain via hidden form field (not Host header) |
| DEC-013 | architecture | architectural | Magic link auth for technicians |

---

## Shared Categories

| Category | Path | File Count |
|---|---|---|
| project | `project/` | 1 |
| patterns | `patterns/` | 2 (conventions + design-system) |
| decisions | `decisions/` | 14 (log + 13 ADRs) |

---

## Memory Principles

- **Retrieve selectively** — never load entire folders
- **Prefer summaries** over raw session notes
- **Archive aggressively** — move compacted content to `archive/`
- **Sessions are temporary** — always summarize before closing
- **Memory is distilled knowledge — not history**
