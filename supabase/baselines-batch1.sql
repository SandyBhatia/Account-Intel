-- ============================================================
--  BASELINES · BATCH 1 — CPKC, Union Pacific, CSX, J.B. Hunt
--  Evidence: Q2 2026 earnings disclosures (July 2026)
--  Run in Supabase SQL Editor AFTER schema.sql + seed.sql.
--  Safe to re-run: archives any existing baseline for these
--  accounts, then inserts the new version.
-- ============================================================

update public.baselines set active = false
where account_id in (select id from public.accounts where slug in ('cpkc','unp','csx','jbht'));

-- ============================================================
--  CPKC · QUALIFY
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'QUALIFY',
'Record revenue and a worsening operating ratio in the same quarter — the merger synergy story is being carried by volume, not by cost discipline. Open question is who owns the technology agenda.',
$$[
 {"n":"01","text":"<b>Revenue up 13%, operating ratio worse by 90 basis points.</b> Q2 2026 revenue of $4.2B against a reported OR of 64.6% (from 63.7%). Core adjusted OR also deteriorated 90bps to 61.6%. Growth is not converting to efficiency."},
 {"n":"02","text":"<b>Reported EPS fell 14%</b> to $1.15 even as core adjusted EPS rose 13% to $1.27 — the gap between reported and adjusted is where integration cost still lives, three years after the merger closed."},
 {"n":"03","text":"<b>The three-nation network is a data problem before it is a rail problem.</b> Canada–US–Mexico single-line service means customs, currency, language, and three regulatory regimes across one operating plan — integration complexity that AI-native operations is well shaped to address."},
 {"n":"04","text":"<b>Management has committed publicly to accelerating in H2 2026</b> — mid-single-digit volume growth and double-digit earnings growth. That is a stated commitment with a clock on it, and the OR trend is not currently supporting it."}
]$$::jsonb,
$$[
 {"no":"A","title":"Operating ratio vs revenue","headline":"Revenue grew 13% while the operating ratio moved 90 basis points the wrong way — on both reported and core adjusted measures.",
  "chart":{"kind":"grouped","y_label":"OR %","y_min":55,
    "labels":["Reported OR","Core adjusted OR"],
    "series":[{"name":"Q2 2025","tone":"dim","values":[63.7,60.7]},{"name":"Q2 2026","tone":"stop","values":[64.6,61.6]}]},
  "body_html":"<p>CPKC characterised the quarter as strong, and on revenue and volume it was: revenues of <b>$4.2 billion</b>, up 13% from $3.7 billion, with revenue ton-miles up 4%. But both operating-ratio measures deteriorated by 90 basis points, and reported diluted EPS <b>fell 14%</b> to $1.15. Core adjusted diluted EPS rose 13% to $1.27.</p>",
  "sowhat":"A railroad running Precision Scheduled Railroading whose OR degrades during a volume upcycle has a cost-structure question it has not yet answered. That is the opening: <b>efficiency framed as decision automation</b>, the same wedge that works at CN.",
  "sources":[{"label":"CPKC Q2 2026 earnings release (SEC Exhibit 99.1)","url":"https://www.sec.gov/Archives/edgar/data/16875/000001687526000024/exhibit991-q22026earningsr.htm"},{"label":"CPKC investor relations","url":"https://investor.cpkcr.com/news/press-release-details/2026/CPKC-reports-strong-Q2-results-poised-for-accelerated-growth-in-second-half-of-2026/default.aspx"}]},
 {"no":"B","title":"The commitment","headline":"Leadership has staked H2 2026 on accelerating volume and double-digit earnings growth — a public promise the current cost trend does not support.",
  "body_html":"<p>CEO Keith Creel framed the quarter around disciplined PSR execution and stated CPKC is positioned to accelerate volume and earnings growth in the second half. CFO Nadeem Velani pointed to continued merger synergy realisation and cost control. On the call, management reaffirmed confidence in <b>mid-single-digit volume growth</b> for 2026 and kept the full-year <b>double-digit earnings growth</b> message intact.</p>",
  "sowhat":"Public commitments create internal urgency. Between now and the Q3 release, someone at CPKC owns closing the gap between the promise and the OR trend — that person is the buyer, and the window is this quarter.",
  "sources":[{"label":"CPKC Q2 2026 earnings release","url":"https://www.sec.gov/Archives/edgar/data/16875/000001687526000024/exhibit991-q22026earningsr.htm"},{"label":"CPKC Q2 2026 earnings call transcript","url":"https://www.investing.com/news/transcripts/earnings-call-transcript-cpkc-tops-q2-2026-estimates-as-shares-rise-after-hours-93CH-4821956"}]}
]$$::jsonb,
'2026-07-29', true, 'current'
from public.accounts a where slug = 'cpkc';

-- ============================================================
--  UNION PACIFIC · QUALIFY
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'QUALIFY',
'Best-in-class operator, so the efficiency pitch does not land. The real opening is integration: merger activity with Norfolk Southern would be the largest systems consolidation in North American rail. Verify status before investing pursuit cost.',
$$[
 {"n":"01","text":"<b>UP runs the best operating ratio on the roster</b> — 59.7% reported, 59.2% adjusted in Q2 2026. Any pitch built on <i>we can make you more efficient</i> will be dismissed, and rightly."},
 {"n":"02","text":"<b>Even here, the ratio worsened</b> — up 70bps reported and 110bps adjusted — but management attributed 120bps of drag to higher fuel price, an exogenous factor. Underlying execution improved."},
 {"n":"03","text":"<b>Operational records across the board:</b> workforce productivity, train length, fuel consumption rate, and freight car terminal dwell. Freight car velocity 231 daily miles per car (+5%); terminal dwell 19.7 hours (−7%). Injury and derailment rates both improved."},
 {"n":"04","text":"<b>The opening is consolidation, not optimisation.</b> Norfolk Southern's Q2 2026 disclosure references merger-related expenses, indicating live transaction activity. A UP–NS combination would be the largest network and systems integration in modern North American rail — <b>this needs verification before it drives strategy.</b>"}
]$$::jsonb,
$$[
 {"no":"A","title":"Operating performance","headline":"Record freight revenue and a 59.7% operating ratio — the strongest operator in the peer set, with fuel price explaining most of the ratio move.",
  "chart":{"kind":"bar","y_label":"OR %","y_min":55,
    "labels":["Union Pacific","CPKC (core adj.)","CN","CPKC (reported)","Norfolk Southern"],
    "series":[{"name":"Q2 2026 operating ratio","tone":"struct","values":[59.7,61.6,62.5,64.6,67.6]}]},
  "body_html":"<p>Operating revenue of <b>$6.9 billion</b>, up 12%, driven by fuel surcharge, volume growth and core pricing. Reported OR 59.7% and adjusted OR 59.2%, up 70 and 110 basis points respectively — but higher fuel price alone accounted for <b>120 basis points</b> of unfavourable impact, meaning underlying operations improved. UP set records in workforce productivity, train length, fuel consumption rate and freight car terminal dwell.</p>",
  "sowhat":"Do not lead with efficiency. UP is the benchmark others are measured against. Lead with <b>scale, integration, and complexity</b> — problems that get harder as the network grows, not cheaper.",
  "sources":[{"label":"Union Pacific Q2 2026 8-K earnings release (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0000100885/000010088526000249/a2026-07x238xkex991earning.htm"},{"label":"CPKC Q2 2026 earnings release","url":"https://www.sec.gov/Archives/edgar/data/16875/000001687526000024/exhibit991-q22026earningsr.htm"},{"label":"Norfolk Southern Q2 2026 8-K (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0000702165/000119312526313393/nsc-ex99_1.htm"}]},
 {"no":"B","title":"The open question","headline":"Norfolk Southern's Q2 filing references merger-related expenses — transaction status must be verified before this account gets pursuit investment.",
  "body_html":"<p>Norfolk Southern's second-quarter 2026 results were adjusted to exclude <b>merger-related expenses</b>, alongside restructuring charges and the effects of the Eastern Ohio incident. NS reported record quarterly revenue of $3.5 billion, a 67.6% operating ratio (65.5% adjusted), under CEO Mark George. The existence of merger costs on the NS books is a hard fact from a primary filing; the counterparty, structure, and regulatory status are <b>not yet verified in this baseline</b> and are the single question that determines whether this account is a WATCH or the largest opportunity on the roster.</p>",
  "sowhat":"This is precisely what QUALIFY means: one open question could flip the answer. Resolve the transaction status first — a live Class I merger creates a multi-year systems integration mandate; a dead one leaves us pitching efficiency to the efficiency leader.",
  "sources":[{"label":"Norfolk Southern Q2 2026 8-K (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0000702165/000119312526313393/nsc-ex99_1.htm"},{"label":"Union Pacific Q2 2026 8-K (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0000100885/000010088526000249/a2026-07x238xkex991earning.htm"}]}
]$$::jsonb,
'2026-07-23', true, 'current'
from public.accounts a where slug = 'unp';

-- ============================================================
--  CSX · QUALIFY
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'QUALIFY',
'Intermodal is the fastest-moving line in the business — 26% revenue growth on 9% volume. That is the Intermodal-as-Horizontal pillar with a live customer attached. Thin baseline; needs a deeper pass before pursuit.',
$$[
 {"n":"01","text":"<b>Intermodal revenue grew 26% year over year to $620 million</b> in Q2 2026, on 9% volume growth and a 16% increase in revenue per unit. Price and volume moving together is unusual and signals genuine modal demand."},
 {"n":"02","text":"<b>Revenue per unit outpaced volume by 7 points</b> — CSX is capturing yield, not buying share. Yield capture at scale is a pricing-and-mix data problem."},
 {"n":"03","text":"<b>Direct pillar alignment.</b> Intermodal is the designated horizontal beachhead connecting railroad anchors to 3PL and forwarder relationships; CSX's intermodal franchise is the eastern half of that map."},
 {"n":"04","text":"<b>This baseline is deliberately thin.</b> Segment data is verified; enterprise financials, technology leadership, and current vendor landscape are not yet researched. Verdict reflects evidence available, not the account's potential."}
]$$::jsonb,
$$[
 {"no":"A","title":"Intermodal momentum","headline":"Intermodal revenue up 26% on 9% volume — CSX is capturing yield rather than discounting for share.",
  "chart":{"kind":"bar","y_label":"% change YoY","labels":["Intermodal revenue","Revenue per unit","Volume"],
    "series":[{"name":"Q2 2026 vs Q2 2025","tone":"go","values":[26,16,9]}]},
  "body_html":"<p>CSX second-quarter 2026 intermodal revenues rose <b>26% year over year to $620 million</b>, ahead of analyst estimates. Segment volumes increased 9% while revenue per unit rose 16%. Quarterly earnings and revenues beat estimates and the company raised its EPS outlook.</p>",
  "sowhat":"When yield rises faster than volume, the constraint moves from capacity to <b>decisioning</b> — pricing, mix, equipment allocation. That is a data and AI conversation, and it is happening now rather than next planning cycle.",
  "sources":[{"label":"CSX Q2 2026 results coverage","url":"https://ca.finance.yahoo.com/news/csx-q2-earnings-revenues-beat-172900827.html"}]}
]$$::jsonb,
'2026-07-22', true, 'current'
from public.accounts a where slug = 'csx';

-- ============================================================
--  J.B. HUNT · PURSUE
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'PURSUE',
'Record intermodal volumes, an operating ratio stuck flat at 88.9%, and a bid season that opens in October. Growth without margin expansion, on a clock — the clearest trigger on the roster.',
$$[
 {"n":"01","text":"<b>Revenue up 19.4% to $3.50 billion, EPS up 45.8% to $1.91</b> — yet the intermodal operating ratio was <b>flat</b> at 88.9% against the prior-year quarter. Record volume is not producing margin."},
 {"n":"02","text":"<b>Intermodal set a volume record:</b> loads up 10% year over year, outpacing the 8% growth in total intermodal carloads across US Class I railroads. Segment revenue $1.75B (+22%), segment operating income $150.9M (+58%)."},
 {"n":"03","text":"<b>Mix is masking yield.</b> Eastern volumes rose 16% against transcontinental at 5%; shorter eastern hauls cut length of haul 3%, and excluding fuel, yields rose just 1%. Managing profitability through a mix shift is a pricing-science problem."},
 {"n":"04","text":"<b>The bid season opens in October</b> — annual intermodal contracts are priced then. Any decision-support capability has to be in place before bids, which makes this a this-quarter conversation, not a next-year one."}
]$$::jsonb,
$$[
 {"no":"A","title":"Growth without margin","headline":"Every growth metric is up double digits; the operating ratio did not move at all.",
  "chart":{"kind":"bar","y_label":"% change YoY","labels":["Operating income","EPS","Intermodal revenue","Revenue","Intermodal loads","Intermodal OR"],
    "series":[{"name":"Q2 2026 vs Q2 2025","tone":"struct","values":[32,45.8,22,19.4,10,0]}]},
  "body_html":"<p>J.B. Hunt reported Q2 2026 net earnings of <b>$181.0 million</b> ($1.91 diluted, up from $1.31), on operating revenue of <b>$3.50 billion</b>, up 19% from $2.93 billion. Operating income rose 32% to $259.5 million. Intermodal revenue increased 22% to $1.75 billion with segment operating income up 58% to $150.9 million. Brokerage turned an operating profit <b>for the first time in 14 quarters</b>, with revenue up 49%. Despite all of it, the intermodal operating ratio held at 88.9%, level with the year-ago quarter — management flagged lagging fuel surcharges as a 100 basis point headwind.</p>",
  "sowhat":"An 88.9% OR means under twelve cents of every intermodal dollar survives as operating profit. At that thinness, <b>marginal decisions decide the year</b> — which loads to accept, how to reposition boxes, where to price. Precisely where applied AI pays for itself.",
  "sources":[{"label":"J.B. Hunt Q2 2026 results","url":"https://www.ajot.com/news/jb-hunt-reports-second-quarter-2026-results"},{"label":"FreightWaves — intermodal shift analysis","url":"https://www.freightwaves.com/news/massive-opportunities-for-j-b-hunt-in-intermodal-shift"}]},
 {"no":"B","title":"The clock","headline":"Capacity is tightening on regulatory enforcement, and the intermodal bid season opens in October.",
  "body_html":"<p>Executives said on 15 July that the freight market is structurally changing at an accelerated rate. Stricter CDL and language enforcement, plus rising costs, are accelerating capacity reductions and driving higher spot rates and tender rejections. Management expects growth tied to <b>intermodal conversion, mini bids and consolidation toward large providers</b>, and reported gaining share across services with expanding pipelines. Monthly intermodal loads accelerated through the quarter — up 9% in April and May, then 12% in June. The company's intermodal bid season begins every October.</p>",
  "sowhat":"Two clocks running together: a tightening market that rewards whoever prices fastest, and a bid season eight weeks out. This is the trigger-plus-clock condition PURSUE is defined by — and the pitch writes itself as <b>bid-season decision support</b>.",
  "sources":[{"label":"Transport Topics — J.B. Hunt Q2 2026","url":"https://www.ttnews.com/articles/jb-hunt-earnings-q2-2026"},{"label":"FreightWaves — intermodal shift analysis","url":"https://www.freightwaves.com/news/massive-opportunities-for-j-b-hunt-in-intermodal-shift"}]}
]$$::jsonb,
'2026-07-15', true, 'current'
from public.accounts a where slug = 'jbht';
