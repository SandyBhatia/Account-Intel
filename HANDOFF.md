# Account Intel — Handoff Brief

Read this first. It is the state of the project, the standards it is built to, and the mistakes already made so they are not repeated.

---

## What this is

An account-intelligence app for the Mphasis Logistics sub-vertical: a briefing tool plus a deterministic next-best-action engine covering 18 Transportation & Logistics accounts. Owner: Sandy, who heads the Logistics sub-vertical ($75M FY29 target from ~$18M today). Audience for the deployed app includes Ravi Vasantraj, Mphasis President and Global Delivery Leader.

**Live.** Deployed on Vercel, backed by Supabase, currently in trial with executive leadership.

## Stack

Next.js (App Router) · Supabase (Postgres + Auth) · Anthropic API · Vercel · GitHub.
Local repo: `C:\Sandy\Personal\Projects\Account-Intel`. Windows, Cursor, PowerShell.

## Architecture

**Two lanes.**
- *Lane 1 — baselines.* Deep research happens in Claude sessions, arrives as JSON in `data/baselines/*.json`, published through the app's Import screen. Versioned: publishing archives the prior version rather than deleting it.
- *Lane 2 — signals.* `/api/refresh` calls Claude with web search to gather dated events since the baseline. A signal without a working `http(s)` source URL is **rejected at the API layer**.

**Decision engine.** `lib/rules.ts` holds seven deterministic rules (R1–R7). They fire from data; Claude only writes a one-sentence narrative for each. The model cannot invent actions or change priorities. Every proposed action shows its rule ID and evidence.

**Refresh cadence.** Public companies trigger on filing detection; private companies on a 90-day timer; either can be triggered early by a signal that contradicts the standing baseline. Outcomes are *reaffirm* (10-minute check, review clock reset, no new version) or *rebuild*.

Design principle: **knowing is automatic, doing is deliberate.**

## Verdicts

Four states, meaning pursuit priority only — never relationship health or account value.

- **PURSUE** — trigger with a clock, a named owner, a viable commercial shape. Act this quarter.
- **QUALIFY** — credible signal but one open question could flip it. Spend a little to resolve it.
- **WATCH** — researched and understood, no active trigger.
- **NO BASELINE** — not yet researched, so no verdict earned. Stays visibly empty.

Current split: 9 PURSUE, 7 QUALIFY, 2 WATCH.

## The evidence standard — non-negotiable

This is the whole value of the tool. Read this twice.

1. **Nothing appears unless it was read from a source.** Not inferred, not estimated, not recalled.
2. **Primary sources only for financials**: company earnings releases, SEC EDGAR filings, SEDAR+ for Canadian issuers, audited annual reports. **Never** data scrapers (ZoomInfo, LeadIQ, Owler) or AI-generated profile sites (Grokipedia) for a financial figure or a person's name.
3. **A missing cell is acceptable. A wrong cell is not.** Unverified periods render as an em dash and are never interpolated.
4. **Claims about named people are the highest-risk category.** A fabricated executive name has already happened on this project (see below). Only state a name, title, tenure or prior employer if found on the company's own leadership page, in a dated company announcement, or a credible dated news report.
5. Every exhibit must carry at least one working source URL — enforced in `app/api/import-baseline/route.ts` and `app/api/import-all/route.ts`.

## Mistakes already made — do not repeat

- **Fabricated a first name.** Recorded CN's technology chief as "Velu Ivaturi". Correct: **Bhushan Ivaturi, EVP and Chief Information and Technology Officer since April 2025** (previously SVP and CIO at Enbridge). The surname was right and the given name was invented to fill a gap. Sandy caught it.
- **Published three unsourceable TTX figures** ($17B assets, $900M maintenance, $345M industry savings). Removed. Replaced with what is actually in a filing: UP's 37.03% stake and ~$1.8B equity investment per its Q1 2026 10-Q.
- **Currency error on Bison.** Transport Topics reports in **US dollars**; it was labelled C$, understating a customer by roughly 40%. Sandy caught it. Group revenue remains genuinely uncertain — the ranked entity may exclude Britton, Hartt, Searcy and Pottle's, and James Richardson & Sons publishes nothing consolidated. **Confirm through the account relationship before quoting a number.**
- **Currency error on CPKC.** Labelled US$ when CPKC reports in Canadian dollars.
- **Trusted a scraper for a CEO name.** Merchants Fleet's permanent chief executive is *not established* from a primary source. A secondary listing names Matt Dyer; that is not good enough to act on.
- **Chart design failures.** Shipped single-data-point bar charts, mixed-magnitude axes (350 next to 39,000), and a formatter that rounded 62.5% to "63%" — a chart contradicting its own exhibit. All fixed in `components/ExhibitChart.tsx`; the rules are documented in its header comment. Do not reintroduce them.
- **SQL loading via the Supabase editor.** The editor could not digest a 70KB file and produced a misleading `relation "the" does not exist` error. Roughly seven failed attempts. **Never load baselines through the SQL editor again** — use the Import screen's bulk loader.

## How to load data now

`data/baselines/*.json` → app → **Import** → **"Load all bundled baselines"**. Publishes all 18 server-side in one request, admin-gated by the `ADMIN_EMAILS` environment variable. No SQL, no size limit.

Schema change needed only once (already applied):
```sql
alter table public.baselines add column if not exists financials jsonb;
```

## Presentation standards

- Palette is "Graphite & Copper" — tokens at the top of `app/globals.css`. Do not introduce new colours.
- Every account carries the **same** financial exhibit so the portfolio is comparable: KPI strip for the latest period, trend charts grouped by unit type, then the full table. Bespoke exhibits sit alongside it, not instead of it.
- **Eight quarters** (Q3'24–Q2'26) for quarterly reporters; five fiscal years for annual reporters like Edmonton Airports.
- Series declare their own `kind` (`currency` / `percent` / `ratio` / `count`) and the component groups them so units never share an axis. Fewer than three verified periods renders as a table only.
- Canadian reporters (CN, CPKC) carry an explicit warning that figures are not comparable with US-dollar accounts without conversion.

## Data completeness — the current gap

343 verified data points. Complete at 8/8 quarters: **CN, CPKC, UPS**. FedEx Freight at 4/8 by Sandy's decision (pre-spin quarters are FedEx *segment* results on a 31 May fiscal year — mapping documented in its basis note).

**The remaining 14 accounts carry only their Q2 2026 and Q2 2025 pairs.** Filling them is mechanical: each quarterly release states the quarter *and* its year-ago comparative, so three searches per company completes eight quarters. Suggested next block: **Union Pacific, Norfolk Southern, CSX, J.B. Hunt** — completes the Class I set and both sides of the merger.

## The accounts

**Customers (6):** CN Rail, Edmonton Airports, CPKC, Bison Transport, FedEx Freight, Merchants Fleet
**Prospects (12):** Norfolk Southern, TQL, UPS, CSX, Union Pacific, C.H. Robinson, TTX, J.B. Hunt, XPO, GXO, Expeditors, Dart Container

**The three biggest opportunities, with dated triggers:**
1. **Union Pacific / Norfolk Southern merger** — $85B enterprise value for NS, ~$2.75B targeted synergies, STB decision expected 2027, currently in abeyance. Largest rail systems integration in decades. UP already booked $35M of acquisition costs in Q2 2026.
2. **FedEx Freight carve-out** — independent since 1 June 2026; transition services agreement with FedEx expires ~June 2028; CEO John Smith has publicly called untangling the parcel-centric technology stack "a massive effort." Segment operating margin fell 18.8% → 6.6% across four verified quarters.
3. **TTX** — owned by all seven Class I railroads (UP 37.03%, NS 19.78%, CSX 19.78%, BNSF 17.4%, CN 3.2%, CPKC 2.2%, Ferromex 0.6%), ~177,000 pooled cars, majority of North American intermodal well cars. The merger forces UP+NS to divest below 49%.

**Competitive intelligence worth knowing:** Cognizant announced a strategic automation partnership with **Merchants Fleet** in December 2025 — a competitor is already inside a customer. And **C.H. Robinson** is the best available proof point for the AI-operations pitch (60%+ productivity gains since 2022, headcount down ~28.7% since mid-2023, volumes still growing) — more useful as a reference when pitching TQL, J.B. Hunt ICS and XPO brokerage than as a target itself.

## Strategic frame

Pillars: Railroad-as-Anchor · Intermodal-as-Horizontal · AI-Native Operations as Differentiator · Domain + Tech as Moat · Delivery Excellence as Sales Engine.

Intermodal is the horizontal beachhead because it cuts across railroad, 3PL and forwarder relationships. Bison and CPKC share a cross-border intermodal lane and neither owns the data that joins it — the only place on the roster where one capability sells into two customer relationships.

## Working style

Sandy validates decisions explicitly before locking them in, prefers structured sequenced delivery, and spot-checks facts — correctly and repeatedly. Ask clarifying questions before large pieces of work rather than guessing. When a figure is challenged, verify it against a source rather than defending it.
