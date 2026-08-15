-- ============================================================
--  ACCOUNT INTELLIGENCE — schema + Row-Level Security
--  Run once in Supabase -> SQL Editor -> New query -> Run.
--  Single-team tool: every authenticated user shares the same
--  portfolio. RLS gates on "signed in", not per-row ownership.
-- ============================================================

-- ---------------- accounts (the roster) ----------------
create table if not exists public.accounts (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,            -- 'cn', 'yeg', 'cpkc' ...
  name          text not null,                   -- 'CN Rail'
  full_name     text,
  relationship  text not null check (relationship in ('customer','prospect')),
  sector        text,
  is_public     boolean default true,            -- public filer vs private company
  cadence       text,                            -- 'quarterly-earnings' | 'private-90d' | 'annual-report'
  next_report   date,                            -- expected next disclosure event
  created_at    timestamptz default now()
);
alter table public.accounts enable row level security;
drop policy if exists "accounts_auth" on public.accounts;
create policy "accounts_auth" on public.accounts for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ---------------- baselines (versioned deep research) ----------------
-- One active row per account. Re-baselining inserts a new version and
-- flips the old one to active=false — history is never destroyed.
create table if not exists public.baselines (
  id            uuid primary key default gen_random_uuid(),
  account_id    uuid not null references public.accounts on delete cascade,
  version       int not null default 1,
  verdict       text not null check (verdict in ('PURSUE','QUALIFY','WATCH','NO_BASELINE')),
  verdict_line  text,                            -- one-line why
  thesis        jsonb,                           -- [{n, text}]
  exhibits      jsonb,                           -- [{no, title, headline, body_html?, table?, chart?, sowhat, sources:[{label,url,date}]}]
  financials    jsonb,                           -- standard 8-quarter series, see components/FinancialsPanel.tsx
  as_of         date not null,                   -- evidence date (e.g. filing date)
  built_at      timestamptz default now(),
  active        boolean default true,
  review_status text default 'current' check (review_status in ('current','review_due','stale')),
  last_reviewed timestamptz default now()
);
create index if not exists baselines_account on public.baselines(account_id, active);
alter table public.baselines enable row level security;
drop policy if exists "baselines_auth" on public.baselines;
create policy "baselines_auth" on public.baselines for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ---------------- signals (dated, sourced events) ----------------
-- The verified-sources rule is enforced in the API layer: a signal
-- without a working source_url is rejected before it reaches this table.
create table if not exists public.signals (
  id            uuid primary key default gen_random_uuid(),
  account_id    uuid not null references public.accounts on delete cascade,
  headline      text not null,
  detail        text,
  category      text check (category in ('filing','earnings','leadership','guidance','safety','contract','merger','rating','technology','market','other')),
  source_name   text not null,
  source_url    text not null,
  published_on  date,
  gathered_at   timestamptz default now(),
  contradicts_baseline boolean default false     -- set true when a signal undercuts a standing baseline claim
);
create index if not exists signals_account on public.signals(account_id, gathered_at desc);
alter table public.signals enable row level security;
drop policy if exists "signals_auth" on public.signals;
create policy "signals_auth" on public.signals for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- ---------------- actions (decision-engine output) ----------------
create table if not exists public.actions (
  id            uuid primary key default gen_random_uuid(),
  account_id    uuid not null references public.accounts on delete cascade,
  rule_id       text not null,                   -- which deterministic rule fired
  title         text not null,
  narrative     text,                            -- Claude-drafted language, citing signals
  due_by        date,
  priority      int default 3,                   -- 1 highest
  status        text default 'proposed' check (status in ('proposed','accepted','done','dismissed','reaffirmed')),
  evidence      jsonb,                           -- [{signal_id?|baseline_field, note}]
  created_at    timestamptz default now(),
  resolved_at   timestamptz
);
create index if not exists actions_account on public.actions(account_id, status);
alter table public.actions enable row level security;
drop policy if exists "actions_auth" on public.actions;
create policy "actions_auth" on public.actions for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
