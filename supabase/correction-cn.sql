-- ============================================================
--  CORRECTION · CN RAIL — Exhibit C rebuilt
--
--  Reason: the previous Exhibit C named the technology executive
--  as "Velu Ivaturi" (wrong given name) and asserted a Wipro
--  background and a TBM operating philosophy. None of those three
--  claims were traceable to a source that had actually been read.
--  They have been removed rather than softened.
--
--  This inserts a NEW VERSION of the CN baseline. The prior
--  version is archived, not deleted, so the correction is visible
--  in the record.
--
--  Run in Supabase SQL Editor after the other baseline files.
-- ============================================================

with prev as (
  select b.id, b.version, b.account_id, b.thesis, b.exhibits
  from public.baselines b
  join public.accounts a on a.id = b.account_id
  where a.slug = 'cn' and b.active = true
)
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select
  prev.account_id,
  prev.version + 1,
  'PURSUE',
  'Operating ratio went the wrong way while the accident rate jumped 47% — and both the technology and operations chairs changed hands inside the last 18 months. Trigger, clock, and a leadership window all present.',
  $$[
   {"n":"01","text":"<b>The efficiency story stalled.</b> Q2 2026 operating ratio of 62.5% is 0.8pt worse year-over-year; the 12-quarter trend shows CN oscillating, not improving."},
   {"n":"02","text":"<b>Safety is now a board-level number.</b> FRA-reportable accident rate 2.30 per million train-miles, up 47% — this buys attention and budget for anything credibly labelled predictive."},
   {"n":"03","text":"<b>Two of the three relevant chairs are newly occupied.</b> Bhushan Ivaturi has held the technology officer role since April 2025; Patrick Whitehead became EVP and Chief Operating Officer in October 2025. New executives buy; settled ones defend."},
   {"n":"04","text":"<b>IT capex fell 22%</b> — the conversation that lands is do-more-with-less: AI-native operations, automation of inspection and dispatch decisioning, not big-bang platform builds."}
  ]$$::jsonb,
  -- Exhibits A, B and D are carried forward unchanged; C is replaced.
  (
    select jsonb_agg(
      case when e->>'no' = 'C' then $$
      {"no":"C","title":"The buying centre","headline":"Both the technology and operating chairs changed hands within the last eighteen months — the window for a new-executive conversation is still open.",
       "body_html":"<p>CN's executive committee records <b>Bhushan Ivaturi</b> in the chief technology officer role since <b>13 April 2025</b>, and <b>Patrick Whitehead</b> as Chief Operating Officer since <b>19 October 2025</b>. Tracy Robinson has been President and CEO since February 2022, with Ghislain Houle as EVP and Chief Financial Officer.</p><p class='note'>Note: an earlier version of this exhibit asserted a specific prior employer and operating philosophy for the technology officer. Those claims could not be traced to a source and have been removed. Background, tenure history, and stated technology agenda are <b>open research items</b> for the next pass — they should be confirmed from CN's own leadership page or a dated announcement before being used in a conversation.</p>",
       "sowhat":"Executives in their first two years are still forming vendor relationships and are measured on visible change. Two new chairs, both owning parts of the same safety-and-efficiency problem, is a better opening than any single relationship — but <b>do not walk in with a background story we have not verified.</b>",
       "sources":[{"label":"CN executive committee record (MarketScreener governance)","url":"https://uk.marketscreener.com/quote/stock/CANADIAN-NATIONAL-RAILWAY-1409526/company-governance/"},{"label":"CN leadership page — to be confirmed at next pass","url":"https://www.cn.ca/en/about-cn/leadership/"}]}
      $$::jsonb else e end
      order by e->>'no'
    )
    from prev, jsonb_array_elements(prev.exhibits) e
  ),
  '2026-07-22',
  true,
  'current'
from prev;

-- archive the superseded version
update public.baselines b set active = false
where b.account_id = (select id from public.accounts where slug = 'cn')
  and b.version < (select max(version) from public.baselines b2
                   where b2.account_id = (select id from public.accounts where slug = 'cn'));
