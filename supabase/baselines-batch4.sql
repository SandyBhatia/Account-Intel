-- ============================================================
--  BASELINES · BATCH 4 — TTX Company, Dart Container
--  Completes the one-time baselining pass: 17 of 17.
--  Run AFTER schema.sql + seed.sql. Safe to re-run.
-- ============================================================

update public.baselines set active = false
where account_id in (select id from public.accounts where slug in ('ttx','dart'));

-- ============================================================
--  TTX COMPANY · PURSUE
--  Structurally the most leveraged account on the roster:
--  jointly owned by the Class I railroads we are already anchored to.
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'PURSUE',
'Owned jointly by the Class I railroads — including CN, CPKC, Union Pacific and CSX. A $17 billion asset pool whose entire purpose is utilisation optimisation, now building telematics through RailPulse. One engagement touches every railroad relationship on this roster.',
$$[
 {"n":"01","text":"<b>TTX is the intersection of the entire railroad anchor strategy.</b> It is privately owned by North America's leading railroads and operates as the industry's railcar cooperative under pooling authority granted by the Surface Transportation Board. BNSF alone discloses a <b>17.4% ownership stake</b> in its SEC filings."},
 {"n":"02","text":"<b>Its business model is literally asset utilisation.</b> Pooled multi-purpose railcars reduce empty miles and switching; cars can be reloaded and routed by any railroad without returning to an owner. TTX states this saves the industry <b>$345 million in operational costs each year</b>."},
 {"n":"03","text":"<b>The scale is extraordinary — $17 billion in assets</b> and over <b>$900 million a year on railcar maintenance alone</b>, across a fleet reported at roughly 177,000 cars. Small percentage gains in utilisation or maintenance efficiency are large absolute numbers."},
 {"n":"04","text":"<b>They joined RailPulse, the industry telematics joint venture,</b> in October 2025 — a public commitment to instrumenting the fleet. Telematics generates the data; deciding what to do with it is the next problem, and it is ours to help with."}
]$$::jsonb,
$$[
 {"no":"A","title":"Ownership and structure","headline":"A cooperative owned by the Class I railroads — the one account where a single engagement touches every railroad relationship we hold.",
  "body_html":"<p>TTX describes itself plainly: not a railroad, not a leasing company, but a <b>railcar pooling company</b>, privately owned by North America's leading railroads and operating under pooling authority granted by the Surface Transportation Board, successor to the ICC. It was founded in <b>1955 as Trailer Train</b> by the Pennsylvania Railroad to invest in flatcars carrying highway trailers; other carriers bought stock, and in 1974 they established distribution principles under an ICC-approved pooling agreement.</p><p>Ownership is confirmed in primary filings: BNSF's Form 10-Q states that North American railroads pay TTX car hire to use its freight equipment, and that <b>BNSF owns 17.4% of TTX while other North American railroads own the remaining interest</b>. Because most owners are public companies, TTX's financial reporting must meet Sarbanes-Oxley requirements.</p><p class='note'>Not established here: the current ownership percentages held by CN, CPKC, Union Pacific and CSX individually. Worth confirming from each railroad's own filings before positioning.</p>",
  "sowhat":"Every railroad on this roster is a part-owner and a customer of TTX simultaneously. Credibility earned here travels — and because TTX exists to serve its owners at cost rather than to extract margin, an efficiency argument aligns with its charter instead of fighting it.",
  "sources":[{"label":"BNSF Form 10-Q, Q2 2026 — related party transactions (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0000934612/000093461226000013/bni-20260630.htm"},{"label":"TTX — Who We Are","url":"https://www.ttx.com/about/who-we-are/"},{"label":"FreightWaves — TTX pool railcars and intermodal efficiency","url":"https://www.freightwaves.com/news/commentary-ttx-pool-railcars-increase-intermodal-efficiency"}]},
 {"no":"B","title":"Scale of the optimisation problem","headline":"$17 billion of assets and $900 million of annual maintenance — a fleet whose only job is to be in the right place.",
  "chart":{"kind":"bar","y_label":"$ millions","labels":["Assets under management","Annual maintenance spend","Annual industry saving"],
    "series":[{"name":"TTX disclosed figures","tone":"struct","values":[17000,900,345]}]},
  "body_html":"<p>TTX states it owns and maintains railcars so the railroads do not have to — <b>$17 billion in assets and $900 million a year in maintenance</b> — and that pooled cars handle more loads with fewer railcars, saving the industry <b>$345 million in operational costs annually</b>. Its fleet spans flatcars, auto carriers, boxcars, gondolas, centrebeam flatcars for lumber and chain tie-down flatcars for heavy equipment. Fleet size is reported at approximately <b>177,000 railcars</b>, though published figures vary between sources and dates, so this should be confirmed at the next pass.</p><p>Participation in the pool is voluntary: each railroad remains free to pursue its own fleet acquisition strategy. TTX therefore has to earn its utilisation advantage continuously.</p>",
  "sowhat":"Maintenance is $900M a year and predictive maintenance is the single most proven AI application in heavy asset industries. A one percent improvement is $9 million — a number that funds a programme without needing a strategic argument.",
  "sources":[{"label":"TTX — Why TTX","url":"https://www.ttx.com/about/why-ttx/"},{"label":"Trains — TTX joins RailPulse telematics joint venture","url":"https://www.trains.com/pro/mechanical/freight-cars/ttx-joins-railpulse-telematics-joint-venture/"}]},
 {"no":"C","title":"The technology signal","headline":"Joining RailPulse in October 2025 is a public commitment to instrumenting a 177,000-car fleet.",
  "body_html":"<p>TTX joined the <b>RailPulse telematics joint venture</b> in October 2025, adding what the partners described as the scale, operational expertise and fleet management capability of North America's leading shared railcar provider. Executive Vice President <b>Marty Thomas</b> framed the move as a commitment to driving innovation and the long-term strength of the freight rail industry. Separately, TTX has invested in industry technology solutions intended to improve the quality and timeliness of financial and operating information both for itself and for the owner railroads it reports to.</p>",
  "sowhat":"Telematics answers <i>where is the car and how is it behaving</i>. It does not answer <i>what should we do next</i> — repositioning, maintenance sequencing, pool allocation. That second question is the offer, and joining RailPulse is the signal that they have started asking it.",
  "sources":[{"label":"Trains — TTX joins RailPulse","url":"https://www.trains.com/pro/mechanical/freight-cars/ttx-joins-railpulse-telematics-joint-venture/"},{"label":"TTX — Who We Are","url":"https://www.ttx.com/about/who-we-are/"}]}
]$$::jsonb,
'2026-06-30', true, 'current'
from public.accounts a where slug = 'ttx';

-- ============================================================
--  DART CONTAINER · WATCH
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'WATCH',
'A family-owned manufacturer running its own trucking fleet as a cost centre, with a Transformation Program Management Director role open. Real but modest logistics scope, and a transformation whose shape is not yet visible. Watch the hiring, not the freight.',
$$[
 {"n":"01","text":"<b>The private fleet is real but small.</b> FMCSA records for Dart Container Corporation of California show <b>280 power units and 248 drivers</b>, running about 14.0 million miles in 2024, carrying general freight and intermodal containers. Meaningful for a manufacturer; modest as a standalone logistics opportunity."},
 {"n":"02","text":"<b>Safety compliance is already strong</b> — a Satisfactory FMCSA rating, driver and vehicle out-of-service rates below national average, and a 5% out-of-service rate across 200 recent roadside inspections. The safety-remediation wedge that works at CN is closed here."},
 {"n":"03","text":"<b>There is a transformation signal in the hiring.</b> Dart has been recruiting a <b>Transformation Program Management Director</b> and a Manufacturing Reliability Director at Mason, with operations roles at their highest level in twelve months and SAP among the technologies referenced."},
 {"n":"04","text":"<b>Family ownership sets the tempo.</b> Founded 1960 by William A. Dart, held by the Dart family, led by Robert C. Dart. Private family capital moves slowly and on relationships — this is a multi-quarter cultivation, not a campaign."}
]$$::jsonb,
$$[
 {"no":"A","title":"The private fleet","headline":"280 power units, 248 drivers, 14 million miles — a manufacturer's supporting fleet rather than a logistics business.",
  "chart":{"kind":"bar","y_label":"count","labels":["Power units","Drivers","Inspections on file","Crashes (24-mo window)"],
    "series":[{"name":"FMCSA record","tone":"dim","values":[280,248,339,12]}]},
  "body_html":"<p>Dart Container Corporation of California is an FMCSA-validated carrier based in Mason, Michigan, registered since <b>12 July 1982</b>. The fleet comprises <b>280 power units and 248 drivers</b>, with annual mileage of about <b>14.0 million miles</b> (2024). It carries general freight, intermodal containers, and refuse among other categories, holds Common and Contract operating authorities, and carries $5 million of insurance. Twelve crashes are recorded with no fatalities across 339 inspections, and the carrier holds a <b>Satisfactory</b> safety rating with out-of-service rates below the national average.</p><p class='note'>This is one registered entity. Whether Dart operates additional carrier authorities under other subsidiaries is <b>not established here</b> and would change the size of the opportunity materially.</p>",
  "sowhat":"At this scale, fleet optimisation alone will not fund a programme. The freight is a supporting function of a manufacturing business — so any conversation has to start from <b>plant-to-customer supply chain</b>, not from the trucks.",
  "sources":[{"label":"FMCSA carrier record — Dart Container Corporation of California (DOT# 217295)","url":"https://loadwrap.com/company/217295-dart-container-corporation-of-california"}]},
 {"no":"B","title":"Company and the transformation signal","headline":"World's largest foam cup manufacturer, family-held since 1960 — and currently hiring a transformation director.",
  "body_html":"<p>Dart Container is a privately held American manufacturer of single-use foodservice packaging, <b>founded in 1960 by William A. Dart</b> and headquartered at Mason, Michigan, where the campus houses corporate headquarters, two production plants, a distribution warehouse and R&amp;D across nearly two million square feet employing about 1,400 people. <b>Robert C. Dart</b> is chief executive. The company is described as the world's largest manufacturer of foam cups and containers, operating a network of manufacturing and distribution facilities across the US, Canada and Mexico under the Dart, Solo, ProPlanet and Fusion brands. It acquired Solo Cup in 2012.</p><p>Recent job postings include a <b>Transformation Program Management Director</b> and a Manufacturing Reliability Director, both at Mason, with operations openings reportedly at their highest level in twelve months and SAP referenced among relevant technologies.</p><p class='note'>Published revenue and headcount figures vary widely between secondary sources and none is authoritative. They are deliberately omitted here rather than reported with false precision.</p>",
  "sowhat":"A named transformation role being recruited is the trigger to watch. If that hire lands and the mandate turns out to cover supply chain or ERP, the account converts from WATCH to a live conversation — <b>set the review for the next 90-day cycle</b> and check the posting status.",
  "sources":[{"label":"Dart Container — company reference","url":"https://en.wikipedia.org/wiki/Dart_Container"},{"label":"Dart Container — Mason, MI campus","url":"https://corporate.dartcontainer.com/location/mason-mi/"},{"label":"Dart Container — company profile and hiring activity","url":"https://www.zoominfo.com/c/dart-container-corp/33263647"},{"label":"GlobalData — Dart Container Corp profile","url":"https://www.globaldata.com/company-profile/dart-container-corp/"}]}
]$$::jsonb,
'2026-08-10', true, 'current'
from public.accounts a where slug = 'dart';
