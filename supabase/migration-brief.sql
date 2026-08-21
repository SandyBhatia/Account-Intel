-- ============================================================
--  Account brief structure. Run once in Supabase -> SQL Editor.
--  Additive: nothing existing is altered or dropped.
--
--  brief — signals, foresight, stakeholders, agenda, pressure,
--          play, discussion points, how-we-lose. Shape and rules
--          in lib/brief.ts.
--  card  — the portfolio landing summary: a standing insight plus
--          the latest dated signal.
-- ============================================================
alter table public.baselines add column if not exists brief jsonb;
alter table public.baselines add column if not exists card  jsonb;
