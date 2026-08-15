insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'WATCH',
'A record 79.9% operating ratio that the CEO attributes to AI, with in-house capability beating its own productivity targets. No problem to solve in North America. The only soft spot is Europe, where restructuring pushed the segment to a loss.',
'[
 {"n":"01","text":"<b>They are winning, and they are winning with AI.</b> North American LTL adjusted operating ratio improved 300 basis points to a record <b>79.9%</b>, AI workforce-planning technology contributed roughly <b>2.5 productivity points against a 1.5-point target</b>."},
 {"n":"02","text":"<b>The financials are excellent.</b> Revenue $2.36 billion (+13.2%), adjusted diluted EPS <b>$1.70</b> (+61.9%), adjusted EBITDA $434 million (+25% excluding real estate), free cash flow $207 million, net leverage 2.1x."},
 {"n":"03","text":"<b>Pricing power is real</b> — XPO reports pricing two to three points above competitors on the strength of service and technology investment, and has raised full-year OR-improvement guidance to at least 200 basis points against a low-70s long-term target."},
 {"n":"04","text":"<b>Europe is the exception.</b> The European Transportation segment posted a <b>$6 million operating loss</b> against $11 million of income a year earlier, driven by restructuring, though adjusted EBITDA still rose to $48 million."}
]'::jsonb,
'[
 {"no":"A","title":"Performance","headline":"Record LTL operating ratio and adjusted EPS up 62% — with a European segment in restructuring.",
  "chart":{"kind":"grouped","y_label":"$ per share","labels":["Diluted EPS","Adjusted diluted EPS"],
    "series":[{"name":"Q2 2025","tone":"dim","values":[0.89,1.05]},{"name":"Q2 2026","tone":"go","values":[1.36,1.70]}]},
  "body_html":"<p>Revenue <b>$2,355 million</b> (+13.2%), GAAP diluted EPS $1.36 (from $0.89), adjusted diluted EPS <b>$1.70</b> (+61.9%), adjusted EBITDA $434 million. North American LTL revenue $1.43 billion (+15.2%) with adjusted operating ratio at a record <b>79.9%</b>, improved 300 basis points. European Transportation revenue $927 million (+10%) with a $6 million operating loss. Free cash flow $207 million, cash $298 million, net leverage 2.1x. Q3 LTL operating ratio expected below 81%. CEO: Mario Harik.</p>",
  "sowhat":"Approaching XPO with an efficiency pitch would be embarrassing — they are the ones setting the benchmark. If an opening exists it is <b>European restructuring and systems rationalisation</b>, not North American operations. Revisit at Q3.",
  "sources":[{"label":"XPO Q2 2026 results","url":"https://investors.xpo.com/news-releases/news-release-details/xpo-reports-second-quarter-2026-results"},{"label":"XPO Q2 2026 results (SEC Exhibit 99.1)","url":"https://www.sec.gov/Archives/edgar/data/0001166003/000110465926088438/tm2616097d5_ex99-1.htm"}]}
]'::jsonb,'2026-07-30',true,'current'
from public.accounts a where slug='xpo';
