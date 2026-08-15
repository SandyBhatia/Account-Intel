insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'$6.82B of gross revenue on a 20.1% net margin, run by 9,000 people — the most people-intensive economics on the roster, in the one model AI reshapes fastest. C.H. Robinson has already proved what is possible.',
'[
 {"n":"01","text":"<b>The economics are now visible.</b> Gross revenue of <b>$6.82 billion in 2024</b> at a net revenue margin of <b>20.1%</b>, giving net revenue of approximately <b>$1.37 billion</b> — the third-largest freight broker by revenue."},
 {"n":"02","text":"<b>It is carried by headcount.</b> Approximately <b>9,000 employees</b> across 56 offices and a network of over 130,000 carriers. Dedicated account teams and 24/7 service are the differentiator — and the cost structure most exposed to automation."},
 {"n":"03","text":"<b>Revenue is highly cyclical:</b> $4.1 billion (2020), $7.8 billion (2021), $8.8 billion (2022), $6.7 billion (2023), $6.82 billion (2024). A business that can swing 25% in a year cannot carry fixed people cost through a trough."},
 {"n":"04","text":"<b>The peer benchmark is brutal and public.</b> C.H. Robinson has cut headcount 28.7% since mid-2023 while growing volume, on 60%+ productivity gains. That is the number a TQL executive has to answer."}
]'::jsonb,
'[
 {"no":"A","title":"Revenue trajectory and margin","headline":"$6.82 billion gross and $1.37 billion net in 2024 — after a 24% peak-to-trough swing.",
  "chart":{"kind":"bar","y_label":"$ billions gross revenue","labels":["2020","2021","2022","2023","2024"],
    "series":[{"name":"Gross revenue","tone":"struct","values":[4.1,7.8,8.8,6.7,6.82]}]},
  "body_html":"<p>TQL is privately held and does not file financial statements. Per the Transport Topics 2025 freight-brokerage rankings, 2024 gross revenue was <b>$6.82 billion</b> with a net revenue margin of <b>20.1%</b>, equating to roughly <b>$1.37 billion</b> of net revenue, across approximately 9,000 employees, 56 offices and 130,000+ carriers. Founded 1997 by <b>Ken Oaks</b>, who remains CEO, President <b>Kerry Byrne</b>. Cincinnati''s largest private company. Because it is private, profitability is not disclosed.</p><p>TQL''s <b>TRAX</b> platform has undergone an AI-driven overhaul, with the company emphasising machine learning for capacity prediction and spot pricing, and asset-light capital expenditure of roughly 1.2% of revenue redirected toward technology and sales.</p>",
  "sowhat":"At 20.1% net margin across $6.82 billion of gross revenue, one point of productivity is worth real money — and they are already building AI internally. The opening is to accelerate what TRAX has started rather than to introduce the idea.",
  "sources":[{"label":"Transport Topics 2025 freight brokerage rankings (via industry analysis)","url":"https://keynnectlogistics.com/top-5-most-profitable-freight-brokerage-2025/"},{"label":"Forbes — TQL company overview","url":"https://www.forbes.com/companies/tql-total-quality-logistics/"},{"label":"Total Quality Logistics — company profile","url":"https://en.wikipedia.org/wiki/Total_Quality_Logistics"}]}
]'::jsonb,'2026-01-02',true,'current'
from public.accounts a where slug='tql';

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
