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

insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'WATCH',
'A $3B manufacturer with flat revenue for five years and a 280-truck support fleet. Too small a logistics footprint to fund a programme — but they are recruiting a Transformation Program Management Director, and that is the trigger to watch.',
'[
 {"n":"01","text":"<b>Revenue is flat and the business is mature.</b> Approximately <b>$3 billion</b> in 2025, having moved between $3.0 billion and $3.2 billion since 2021, with around 13,000 employees."},
 {"n":"02","text":"<b>The fleet is a support function, not a business.</b> FMCSA records for the primary authority show <b>280 power units and 248 drivers</b> running 14,039,000 miles in 2024 — meaningful for a manufacturer, too small to fund a standalone logistics transformation."},
 {"n":"03","text":"<b>Safety compliance is already strong</b> — a Satisfactory FMCSA rating with driver and vehicle out-of-service rates below the national average, closing the safety-remediation wedge."},
 {"n":"04","text":"<b>The trigger to watch is a hire.</b> Dart has been recruiting a <b>Transformation Program Management Director</b> and a Manufacturing Reliability Director at Mason, with operations roles at their highest level in twelve months and SAP referenced among the technologies."}
]'::jsonb,
'[
 {"no":"A","title":"Business and fleet scale","headline":"$3 billion of flat revenue and a 280-truck private fleet — a manufacturer, not a logistics buyer.",
  "chart":{"kind":"bar","y_label":"$ billions revenue","labels":["2021","2022","2023","2024","2025"],
    "series":[{"name":"Revenue","tone":"dim","values":[3.0,3.2,3.2,3.0,3.0]}]},
  "body_html":"<p>Dart Container is a privately held manufacturer of single-use foodservice packaging, founded 1960 by William A. Dart, headquartered at Mason, Michigan, where the campus houses corporate headquarters, two production plants, a distribution warehouse and RandD across nearly two million square feet employing about 1,400 people. Revenue of approximately <b>$3 billion in 2025</b> per Forbes America''s Largest Private Companies (FactSet data), roughly flat since 2021. Around 13,000 employees overall. It acquired Solo Cup in 2012 and operates under the Dart, Solo, ProPlanet and Fusion brands.</p><p>The primary trucking authority, <b>Dart Container Corporation of California</b> (USDOT #217295), runs 280 power units and 248 drivers over 14,039,000 annual miles, holding a Satisfactory safety rating. No additional Dart Container carrier authorities were identified that would materially change fleet size.</p><p class=''note''>Leadership shows a source conflict: Forbes lists CEO Keith Clark, older references list Robert C. Dart. Confirm before any named approach. Note also that <i>Dart Transit Company</i> of Eagan, Minnesota is an unrelated carrier and must not be attributed to Dart Container.</p>",
  "sowhat":"At this scale the freight is a supporting function of a manufacturing business, so any conversation starts from <b>plant-to-customer supply chain and SAP</b>, not from the trucks. Set the review for the next 90-day cycle and check whether the transformation director role has been filled.",
  "sources":[{"label":"FMCSA carrier record — Dart Container Corporation of California (DOT# 217295)","url":"https://loadwrap.com/company/217295-dart-container-corporation-of-california"},{"label":"Dart Container — Mason, MI campus","url":"https://corporate.dartcontainer.com/location/mason-mi/"},{"label":"Dart Container — company profile and hiring activity","url":"https://www.zoominfo.com/c/dart-container-corp/33263647"},{"label":"Dart Container — company reference","url":"https://en.wikipedia.org/wiki/Dart_Container"}]}
]'::jsonb,'2026-08-10',true,'current'
from public.accounts a where slug='dart';
