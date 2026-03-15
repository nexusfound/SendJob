---
type: memory
category: patterns
id: DESIGN-SYSTEM-001
tags:
  - playbook
  - design
  - html
  - css
  - frontend
  - netlify
created_at: 2026-03-15
updated_at: 2026-03-15
source: PLAYBOOK_DESIGN_SYSTEM.md
---

# SendJob Playbook Design System

> Load for every Playbook HTML build. Every playbook must follow this exactly.
> Reference implementation: AC Express at `hvac.sendjob.app`

---

## Fonts

```html
<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800&family=Barlow:wght@300;400;500;600&display=swap" rel="stylesheet">
```

| Role | Font | Weight |
|---|---|---|
| Display / Headers | Barlow Condensed | 800 |
| Subheads / Card titles | Barlow Condensed | 700 |
| Body | Barlow | 400 |
| Labels / Field text | Barlow | 500–600 |
| Hero subtitle | Barlow | 300 |

**Never substitute** Inter, Roboto, Arial, or system fonts.

---

## Color System

```css
:root {
  --navy:        #0A1628;   /* page background */
  --navy-mid:    #0F2040;   /* input/card background */
  --navy-light:  #162A4A;   /* hover states */
  --card:        rgba(15, 32, 64, 0.9);
  --border:      rgba(0, 200, 255, 0.2);
  --text:        #E8F4FD;
  --text-muted:  #7BA7C4;
  --urgent:      #FF4444;
  --urgent-glow: rgba(255, 68, 68, 0.15);
  --warn:        #FFB800;
  --success:     #00D68F;

  /* Trade accent — CHANGE PER PLAYBOOK */
  --ice:         #00C8FF;
  --ice-dark:    #0099CC;
  --ice-glow:    rgba(0, 200, 255, 0.15);
}
```

### Trade Accent Colors

| Trade | --ice | --ice-dark | --ice-glow | Emoji |
|---|---|---|---|---|
| HVAC / AC | `#00C8FF` | `#0099CC` | `rgba(0,200,255,0.15)` | ❄️ |
| Plumbing | `#3B9EFF` | `#1A7FE0` | `rgba(59,158,255,0.15)` | 🔧 |
| Pool Service | `#00D4AA` | `#00A880` | `rgba(0,212,170,0.15)` | 🏊 |
| Lawn | `#4CAF50` | `#388E3C` | `rgba(76,175,80,0.15)` | 🌿 |
| Cleaning | `#E040FB` | `#B000D0` | `rgba(224,64,251,0.15)` | ✨ |
| Electrical | `#FFB800` | `#CC9200` | `rgba(255,184,0,0.15)` | ⚡ |
| Pest Control | `#8BC34A` | `#689F38` | `rgba(139,195,74,0.15)` | 🐛 |
| Pressure Washing | `#29B6F6` | `#0288D1` | `rgba(41,182,246,0.15)` | 💦 |

---

## Mobile-First Rules

Base CSS written for 390px. Desktop is enhancement.

```html
<!-- Required viewport meta — prevents iOS zoom bugs -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<meta name="theme-color" content="#0A1628">
<meta name="apple-mobile-web-app-capable" content="yes">
```

```css
:root {
  --tap-min:     52px;   /* minimum tap target — Apple/Google standard */
  --radius-card: 16px;
  --radius-input: 12px;
  --pad-page:    16px;
  --font-input:  16px;   /* CRITICAL: prevents iOS auto-zoom */
  --font-label:  11px;
}
```

- All inputs/buttons: `min-height: 52px`
- Input font size: **16px minimum** — below this triggers iOS keyboard zoom
- Every `<input>` needs correct `inputmode` attribute (`tel`, `email`, `text`)

---

## Page Structure (All Playbooks)

```
1. Demo Banner       — purple, always present on demos
2. Nav               — sticky, brand + trade name + "Licensed & Insured"
3. Hero              — headline + trust badges
4. Urgent Banner     — hidden, shows on emergency card selection
5. Form (.page)
   ├── Section 01: Service Type (2-column card grid)
   ├── Priority Pill (hidden, shows on card selection)
   ├── Section 02: Your Information
   └── Section 03: Location & Issue
6. Submit Button
7. Success Screen    — replaces form on submit
8. Footer            — "Powered by SendJob"
```

---

## Webhook Payload (Fixed — Do Not Change Field Names)

```javascript
const WEBHOOK_URL = 'https://nexusfound.cloud/webhook/sendjob-intake';

const payload = {
  subdomain:         getSubdomain(),   // read from URL automatically
  customer_name:     '...',
  customer_phone:    '...',
  customer_email:    '...',            // null if not provided
  service_address:   '...',
  service_type:      selectedService,
  preferred_contact: 'sms' | 'email',
  issue_description: '...',
};
```

Subdomain is read from `window.location.hostname` — never hardcoded.

---

## New Playbook Checklist

Change ONLY these per playbook:
- [ ] `<title>`
- [ ] `--ice`, `--ice-dark`, `--ice-glow` (trade accent)
- [ ] Nav emoji + business name
- [ ] Hero headline + subtitle
- [ ] Trust badges
- [ ] Service cards (types, names, descriptions — keep emergency first, Other last)
- [ ] Urgent banner tips
- [ ] Demo banner business name

**Never change:** fonts, navy/text/border/status tokens, field names, webhook URL/payload shape, section numbering, submit button sizing, breakpoints, footer.

---

## Service Card Reference

| Trade | Emergency | Standard Cards |
|---|---|---|
| HVAC/AC | ⚡ No AC / Emergency | 🌡️ AC Not Cooling · 🔧 Tune-Up · 🔥 Heating Issue · 📦 New Install |
| Plumbing | ⚡ Burst Pipe / Emergency | 🚿 Leak · 🚽 Clog · 🔧 Fixture Repair · 🏠 New Install |
| Pool | ⚡ Equipment Failure | 🧪 Water Chemistry · 🔧 Equipment Repair · 🌿 Cleaning · 📅 Weekly |
| Lawn | ⚡ Storm Damage | ✂️ Mowing · 🌱 Fertilize · 🌳 Tree Work · 💧 Irrigation |
| Cleaning | ⚡ Move-Out / Urgent | 🏠 Standard · ✨ Deep · 🛏️ Move-In · 📅 Recurring |
| Electrical | ⚡ No Power | 💡 Outlet/Switch · 🔌 Panel · 🏠 New Install · 🔍 Inspection |
| Pest | ⚡ Active Infestation | 🐜 General · 🪳 Roaches · 🐭 Rodents · 📅 Preventive |
| Pressure Washing | ⚡ Storm Cleanup | 🏠 Exterior · 🚗 Driveway · 🪵 Deck · 🏢 Commercial |
