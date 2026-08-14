-- ============================================================
--  BASELINES · BATCH 2 — UPS, XPO, GXO, C.H. Robinson, Expeditors
--  Evidence: Q2 2026 disclosures (July–August 2026)
--  Run AFTER schema.sql + seed.sql. Safe to re-run.
-- ============================================================

update public.baselines set active = false
where account_id in (select id from public.accounts where slug in ('ups','xpo','gxo','chrw','expd'));

-- ============================================================
--  UPS · PURSUE
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'PURSUE',
'A deliberate structural reset just completed: 2 million daily packages removed, $4.5B of expense out, and a CEO publicly committed to AI and RFID as the next lever. The network is rebuilt and the software conversation is open now.',
$$[
 {"n":"01","text":"<b>UPS just finished rebuilding its own network.</b> The Amazon glide-down is complete — roughly 2 million pieces per day of lower-quality volume eliminated and about $4.5 billion of related expense removed. Tomé describes the result as leaner, more automated, more agile."},
 {"n":"02","text":"<b>The reset cost real money and is still running.</b> Q2 2026 GAAP operating profit was $930M against $2.1B adjusted — an $891M after-tax transformation charge, $1.05 per share, mostly separation costs. $1.8B incurred to date across these initiatives."},
 {"n":"03","text":"<b>Efficiency Reimagined is an explicit end-to-end process redesign programme</b> — $1.2B of benefits banked in H1 2026 against a $3B full-year target. A named, funded, in-flight transformation is the single best qualifying signal there is."},
 {"n":"04","text":"<b>The CEO named the technology.</b> Tomé cited investment in RFID and artificial intelligence for tracking, calling it the most significant package-visibility advancement in a decade. That is the buying centre stating its own agenda."}
]$$::jsonb,
$$[
 {"no":"A","title":"The cost of the reset","headline":"GAAP operating profit of $930M against $2.1B adjusted — the gap is the transformation still being paid for.",
  "chart":{"kind":"bar","y_label":"$ billions","labels":["Revenue","Adj. operating profit","GAAP operating profit","Transformation charge"],
    "series":[{"name":"Q2 2026","tone":"struct","values":[22.8,2.1,0.93,0.891]}]},
  "body_html":"<p>Second-quarter 2026 consolidated revenue was <b>$22.8 billion</b>. Diluted EPS of $0.71 against non-GAAP adjusted diluted EPS of $1.76. The GAAP figures carried after-tax transformation charges of <b>$891 million</b>, primarily employee separation costs from the completed Driver Choice Program. UPS raised full-year guidance to roughly $91.2 billion revenue, $8.65 billion adjusted operating profit, and $7.22 adjusted diluted EPS, with capex confirmed at about $3.0 billion.</p>",
  "sowhat":"An organisation absorbing this much restructuring cost has already accepted disruption. The hard part — deciding to change — is done. What follows a physical network reconfiguration is always a <b>systems and decisioning</b> reconfiguration, and that phase is starting now.",
  "sources":[{"label":"UPS 2Q 2026 earnings release","url":"https://about.ups.com/us/en/newsroom/press-releases/financials/ups-releases-2q-2026-earnings.html"},{"label":"UPS 2Q 2026 release (PDF, investor relations)","url":"https://investors.ups.com/_assets/_c53d8bf327c039b6881e8488f7b20256/ups/news/2026-07-28_UPS_Releases_2Q_2026_2164.pdf"}]},
 {"no":"B","title":"Segment quality shift","headline":"US Domestic revenue rose 6.0% on a 9.3% increase in revenue per piece — UPS is now selling yield, not volume.",
  "chart":{"kind":"grouped","y_label":"% change YoY","labels":["US Domestic","International"],
    "series":[{"name":"Revenue","tone":"struct","values":[6.0,12.5]},{"name":"Revenue per piece","tone":"go","values":[9.3,18.9]}]},
  "body_html":"<p>US Domestic operating margin was 0.1% on a GAAP basis and <b>8.0% adjusted</b> — the gap again being transformation cost. International revenue rose 12.5% on an 18.9% increase in revenue per piece, with margin of 12.4% on both bases. Management has said the business is now more selective, more balanced across industries, and focused on <b>revenue quality rather than volume</b>. Asia-to-Asia export volume grew 13.6%.</p>",
  "sowhat":"Revenue per piece rising faster than revenue in both segments means the whole company is being run on mix and pricing decisions. That is a data problem at a scale few companies have, and it is now the stated strategy rather than a side initiative.",
  "sources":[{"label":"UPS 2Q 2026 earnings release","url":"https://about.ups.com/us/en/newsroom/press-releases/financials/ups-releases-2q-2026-earnings.html"},{"label":"UPS — five takeaways from Q2 2026","url":"https://about.ups.com/us/en/our-stories/innovation-driven/top-5-takeaways-from-ups-s-q2-2026-earnings-announcement.html"}]},
 {"no":"C","title":"The stated agenda","headline":"Network Reconfiguration and Efficiency Reimagined: a funded, named, in-flight redesign with $3B of targeted benefit.",
  "body_html":"<p>In its own filing language, UPS describes Network Reconfiguration as an expansion of Network of the Future, driving continued reductions in facilities, vehicles, aircraft and workforce alongside an <b>end-to-end process redesign</b>. Efficiency Reimagined is the programme carrying that redesign. Approximately <b>$1.2 billion of program benefits</b> were achieved in the first six months of 2026, with roughly $3 billion expected by year end. Q3 guidance anticipates mid-single-digit decline in domestic average daily volume and flat revenue.</p>",
  "sowhat":"Named programmes have owners, budgets and reporting lines. The entry point is not a UPS-wide pitch but a specific contribution to Efficiency Reimagined's remaining $1.8B of target benefit — measurable, attributable, and already on someone's scorecard.",
  "sources":[{"label":"UPS 2Q 2026 earnings release","url":"https://investors.ups.com/news-events/press-releases/detail/2164/ups-releases-2q-2026-earnings"},{"label":"CNBC — UPS Q2 2026","url":"https://www.cnbc.com/2026/07/28/ups-ups-q2-2026-earnings.html"}]}
]$$::jsonb,
'2026-07-28', true, 'current'
from public.accounts a where slug = 'ups';

-- ============================================================
--  XPO · WATCH
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'WATCH',
'They are already winning with AI and saying so publicly — record 79.9% operating ratio, labour productivity above target on new AI capability. There is no problem to solve here yet, and pretending otherwise would be transparent.',
$$[
 {"n":"01","text":"<b>Record operating ratio of 79.9%</b> in North American LTL, improved 300 basis points year over year, with adjusted operating income up 36%. This is a company executing, not struggling."},
 {"n":"02","text":"<b>The CEO attributed cost performance to AI specifically</b> — Harik cited labour productivity above target from implementing new AI capabilities across the network. They have an AI story and it is working."},
 {"n":"03","text":"<b>Service quality is a company best</b> — damage claims ratio below 0.2%. The usual operational wedge (service failures create urgency) is closed."},
 {"n":"04","text":"<b>WATCH is the honest verdict.</b> No trigger, no clock, no visible gap. Revisit at Q3, or if AI programme scope expands beyond productivity into planning and pricing."}
]$$::jsonb,
$$[
 {"no":"A","title":"Performance","headline":"Adjusted EPS up 56%, adjusted EBITDA up 25%, and a record LTL operating ratio — XPO is outperforming on every disclosed measure.",
  "chart":{"kind":"grouped","y_label":"$ per share","labels":["Diluted EPS","Adjusted diluted EPS"],
    "series":[{"name":"Q2 2025","tone":"dim","values":[0.89,1.05]},{"name":"Q2 2026","tone":"go","values":[1.36,1.70]}]},
  "body_html":"<p>Revenue of <b>$2.36 billion</b> against $2.08 billion a year earlier, with operating income of $271 million. Diluted EPS $1.36 (from $0.89); adjusted diluted EPS $1.70 (from $1.05). In North American LTL, adjusted operating income rose 36% and the adjusted operating ratio improved 300 basis points to a record <b>79.9%</b>. Yield and revenue per shipment excluding fuel improved both sequentially and year over year. The European segment was weaker — revenue $927 million against $841 million, but an operating loss of $6 million versus $11 million income, driven by restructuring.</p>",
  "sowhat":"The one soft spot is Europe, where restructuring pushed the segment to an operating loss. If a wedge exists at XPO, it is European integration and restructuring execution — <b>not</b> North American operations, where they are the ones to beat.",
  "sources":[{"label":"XPO Q2 2026 results (SEC Exhibit 99.1)","url":"https://www.sec.gov/Archives/edgar/data/0001166003/000110465926088438/tm2616097d5_ex99-1.htm"},{"label":"XPO Q2 2026 press release","url":"https://investors.xpo.com/news-releases/news-release-details/xpo-reports-second-quarter-2026-results"}]}
]$$::jsonb,
'2026-07-30', true, 'current'
from public.accounts a where slug = 'xpo';

-- ============================================================
--  GXO · PURSUE
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'PURSUE',
'Strongest new business wins in three years and over $1 billion of incremental 2026 revenue to stand up — every new contract logistics site is an integration, and they are signing faster than sites get built.',
$$[
 {"n":"01","text":"<b>$410 million of new business signed in the quarter, up 34% year over year</b> — the strongest new-win performance in three years, under a CEO in his first full cycle."},
 {"n":"02","text":"<b>Over $1 billion of incremental 2026 revenue, up 29%,</b> plus $353 million of 2027 revenue already secured. That is a large book of work that has to be physically and digitally stood up on deadline."},
 {"n":"03","text":"<b>In contract logistics, every win is an implementation.</b> New sites mean WMS configuration, client system integration, automation commissioning and data flows — the delivery-heavy work that suits an offshore-capable partner with domain depth."},
 {"n":"04","text":"<b>Growth verticals are named:</b> aerospace and defence, technology, industrial, life sciences. Those are compliance-heavy, integration-heavy sectors where implementation quality decides margin."}
]$$::jsonb,
$$[
 {"no":"A","title":"The implementation backlog","headline":"$410M of new business in one quarter and $1B+ of incremental 2026 revenue — a signing rate that outpaces most delivery organisations.",
  "chart":{"kind":"bar","y_label":"$ millions","labels":["New business signed (Q2)","Incremental 2026 revenue","Incremental 2027 secured"],
    "series":[{"name":"Q2 2026","tone":"go","values":[410,1000,353]}]},
  "body_html":"<p>Revenue of <b>$3.4 billion</b>, up 4.3% year over year with organic growth of 3.4%, and all three regions growing organically. CEO Patrick Kelleher marked five years since GXO's separation and described the strongest new business wins in three years, led by marquee brands and deeper penetration of the strategic growth verticals. GXO maintained the mid-points of full-year 2026 guidance for adjusted EBITDA and adjusted diluted EPS.</p>",
  "sowhat":"Revenue growth of 4.3% against new signings up 34% means the gap between <b>sold</b> and <b>live</b> is widening. That gap is implementation capacity — the most direct services opportunity on the roster, and it compounds every quarter they keep winning.",
  "sources":[{"label":"GXO Q2 2026 results (investor relations)","url":"https://investors.gxo.com/news-releases/news-release-details/gxo-reports-second-quarter-2026-results"},{"label":"GXO Q2 2026 release (PDF)","url":"https://investors.gxo.com/static-files/1183723b-dd51-4f53-b876-8d87510632ad"}]}
]$$::jsonb,
'2026-08-04', true, 'current'
from public.accounts a where slug = 'gxo';

-- ============================================================
--  C.H. ROBINSON · QUALIFY
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'QUALIFY',
'Revenue up 19.3% and the stock fell 14.7% on the day — the market read something in the quarter that the top line does not show. Worth understanding before we call on them.',
$$[
 {"n":"01","text":"<b>Revenue grew 19.3% year over year, beating expectations by 12.7%</b> — and the shares fell 14.7% following the results. That divergence is the most interesting fact about this account."},
 {"n":"02","text":"<b>A negative market reaction to a revenue beat usually means margin, mix, or guidance</b> — brokerage economics turn on gross margin per load, not revenue. The answer is in the segment detail, which this baseline does not yet contain."},
 {"n":"03","text":"<b>Brokerage is the most exposed model to AI disintermediation</b> in the freight sector, and also the one with the most to gain from applying it. C.H. Robinson has been public about technology-led productivity for several years."},
 {"n":"04","text":"<b>Thin baseline, honestly labelled.</b> Verified: revenue growth, beat magnitude, market reaction. Not yet verified: segment margins, headcount trend, technology leadership, guidance. Resolve before pursuit spend."}
]$$::jsonb,
$$[
 {"no":"A","title":"The divergence","headline":"A 19.3% revenue beat met with a 14.7% share price fall — the story is in what the top line conceals.",
  "chart":{"kind":"bar","y_label":"%","labels":["Revenue growth YoY","Beat vs expectations","Share price move"],
    "series":[{"name":"Q2 2026","tone":"struct","values":[19.3,12.7,-14.7]}]},
  "body_html":"<p>C.H. Robinson reported second-quarter 2026 results on 29 July 2026 from Eden Prairie, Minnesota. Peer coverage records revenue growth of <b>19.3% year over year</b>, ahead of analyst expectations by 12.7%, with the shares trading down <b>14.7%</b> after the release. For comparison, UPS reported revenue up 7.6% in the same period and also traded down, by 7.4%.</p>",
  "sowhat":"When revenue beats and the stock falls hard, management is under pressure to explain profitability rather than growth. That pressure creates receptiveness to <b>margin-per-transaction</b> arguments — but we should know which line disappointed before walking in.",
  "sources":[{"label":"C.H. Robinson Q2 2026 results","url":"https://finance.yahoo.com/markets/stocks/articles/c-h-robinson-reports-2026-200500665.html"},{"label":"Air freight & logistics peer earnings review","url":"https://markets.financialcontent.com/stocks/article/stockstory-2026-8-3-earnings-to-watch-expeditors-expd-reports-q2-results-tomorrow"}]}
]$$::jsonb,
'2026-07-29', true, 'current'
from public.accounts a where slug = 'chrw';

-- ============================================================
--  EXPEDITORS · WATCH
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'WATCH',
'Steady, asset-light, and famously self-sufficient in technology — Expeditors builds rather than buys. No trigger visible; revisit when a disclosed system or leadership change suggests that posture is shifting.',
$$[
 {"n":"01","text":"<b>Growth is modest and steady.</b> Revenue of $2.78 billion in the prior quarter, up 4.4% year over year, with an EPS beat. Consensus expected roughly 11.4% growth for Q2 2026, improving on 8.7% a year earlier."},
 {"n":"02","text":"<b>The sector backdrop is soft.</b> Air freight and logistics share prices fell about 5% on average over the month around these results, with investor attention rotating across AI disintermediation, geopolitics and rates."},
 {"n":"03","text":"<b>Expeditors is structurally the hardest sell in the forwarding segment</b> — asset-light, historically insourced technology, and a strong internal engineering culture. Displacement requires an event, not an argument."},
 {"n":"04","text":"<b>WATCH, with a defined trigger.</b> Revisit on: a named CIO or CTO change, a disclosed platform replacement, an acquisition requiring integration, or a guidance miss that opens a cost conversation."}
]$$::jsonb,
$$[
 {"no":"A","title":"Position","headline":"Consistent single-digit growth in a soft sector, with expectations stepping up to double digits — no distress, no opening.",
  "chart":{"kind":"bar","y_label":"% revenue growth YoY","labels":["Q2 2025 actual","Most recent quarter","Q2 2026 expected"],
    "series":[{"name":"Revenue growth","tone":"dim","values":[8.7,4.4,11.4]}]},
  "body_html":"<p>Expeditors was scheduled to report Q2 2026 results in early August 2026. The most recent reported quarter showed revenue of <b>$2.78 billion, up 4.4%</b> year over year with a beat on EPS estimates. Analysts covering the company broadly reconfirmed estimates in the preceding 30 days, expecting revenue growth of about 11.4% for the quarter against 8.7% in the comparable prior-year period. Across the air freight and logistics group, share prices were down roughly 5% on average over the prior month.</p>",
  "sowhat":"Nothing here justifies pursuit cost today. Recording that plainly is the point of a WATCH verdict — it keeps the account understood and dated, so the next reporting event is measured against a real baseline rather than a blank page.",
  "sources":[{"label":"Expeditors Q2 2026 earnings preview and peer review","url":"https://markets.financialcontent.com/stocks/article/stockstory-2026-8-3-earnings-to-watch-expeditors-expd-reports-q2-results-tomorrow"}]}
]$$::jsonb,
'2026-08-03', true, 'current'
from public.accounts a where slug = 'expd';
