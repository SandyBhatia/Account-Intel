# Account Intel — Transportation & Logistics

Briefing tool + next-best-action engine for the Mphasis Logistics sub-vertical.
Verified sources only: every exhibit and every signal carries a checkable URL, enforced in code.

**Stack:** Next.js (App Router) · Supabase (Postgres + Auth) · Anthropic API (signals gathering + action narration) · Vercel.
Same architecture as Training Ledger — if you deployed that, this is the identical 15-minute path.

---

## How it works (two lanes)

**Lane 1 — Baselines (deep research).** Done in working sessions with Claude to the evidence standard
(primary sources, audited arithmetic, verdict earned not asserted). The result is pasted into
**Import** as JSON. Versioned: a re-baseline archives the old version, never deletes it.
Validation rejects any baseline where an exhibit lacks a source URL.

**Lane 2 — Signals (automated refresh).** The **Refresh** button on any account calls Claude with
web search to gather dated events *since the baseline*. Signals without a working source URL are
rejected at the API layer. Signals never modify baselines — they accumulate alongside, and can be
flagged as contradicting the standing view.

**Decision engine.** Deterministic rules (R1–R7 in `lib/rules.ts`) fire from the data — earnings within
21 days, filing newer than baseline, private account past 90 days, contradiction flagged, leadership
window, QUALIFY stalled, no baseline on record. Claude narrates each fired rule in one sentence,
citing only the attached evidence. The model cannot invent actions or priorities. Every card on the
Actions page shows its rule ID and evidence — fully auditable.

**Re-baseline outcomes.** When a review action fires, the outcome is either *reaffirm* (10-minute check,
baseline holds, review clock resets — no new version) or *rebuild* (new research session, new version).
Knowing is automatic; doing is deliberate.

---

## Setup (~15 minutes)

### 1 · Supabase (~5 min)
1. [supabase.com](https://supabase.com) → New project (free tier is fine).
2. SQL Editor → paste **`supabase/schema.sql`** → Run.
3. SQL Editor → paste **`supabase/seed.sql`** → Run. (17 accounts; CN + Edmonton baselines included.)
4. Settings → API → copy the **Project URL** and **anon public key**.
5. Authentication → Providers → Email: leave enabled. Optionally disable "Confirm email" for instant sign-up.

### 2 · Anthropic (~2 min)
1. [console.anthropic.com](https://console.anthropic.com) → API keys → create one.
2. This powers the Refresh (web-search signals) and engine narration. The app runs without it —
   rules still fire; you just lose gathered signals and narrative phrasing.

### 3 · Deploy on Vercel (~5 min)
1. Push this folder to a GitHub repo.
2. [vercel.com](https://vercel.com) → Add New Project → import the repo (Next.js auto-detected).
3. Environment variables:
   | Name | Value |
   |---|---|
   | `NEXT_PUBLIC_SUPABASE_URL` | from step 1.4 |
   | `NEXT_PUBLIC_SUPABASE_ANON_KEY` | from step 1.4 |
   | `ANTHROPIC_API_KEY` | from step 2 |
   | `ANTHROPIC_MODEL` | `claude-sonnet-4-5` |
   | `NEXT_PUBLIC_SITE_URL` | your Vercel URL after first deploy |
4. Deploy. Open the URL → create your account on the sign-in screen → you're in.

### Local dev
```bash
npm install
cp .env.example .env.local   # fill in the same variables
npm run dev
```

---

## Daily use

- **Portfolio** — the briefing view. Customers first, verdict-sorted. Cards without research say so.
- **Account page** — verdict, thesis, exhibits with sources, proposed actions, signal feed, Refresh.
- **Actions** — run the engine; accept / done / dismiss. This page is the research calendar:
  it tells you *which* account needs a session and *why*, ordered by priority.
- **Import** — paste baseline JSON from a research session. Template built into the page.

## Baseline JSON shape

```json
{
  "slug": "cpkc",
  "verdict": "PURSUE | QUALIFY | WATCH | NO_BASELINE",
  "verdict_line": "One-line why.",
  "as_of": "2026-08-12",
  "thesis": [{ "n": "01", "text": "Point, <b>bold</b> allowed." }],
  "exhibits": [{
    "no": "A", "title": "Label", "headline": "Finding as a sentence.",
    "body_html": "<p>Narrative.</p>",
    "table": { "head": ["", "FY25"], "rows": [["Revenue", "1,100"]] },
    "sowhat": "Why it matters.",
    "sources": [{ "label": "FY25 10-K p.30", "url": "https://..." }]
  }]
}
```

Reaffirm mode: same endpoint with `"mode": "reaffirm"` — stamps `last_reviewed`, no new version.
