-- ============================================================
--  SEED — 17-account roster + the two verified baselines
--  Run AFTER schema.sql. Safe to re-run: deletes and reinserts.
-- ============================================================

delete from public.actions;
delete from public.signals;
delete from public.baselines;
delete from public.accounts;

-- ---------------- roster ----------------
insert into public.accounts (slug, name, full_name, relationship, sector, is_public, cadence, next_report) values
-- customers
('cn',        'CN Rail',            'Canadian National Railway',        'customer', 'Rail',            true,  'quarterly-earnings', '2026-10-20'),
('yeg',       'Edmonton Airports',  'Edmonton Regional Airports Authority','customer','Airports',      false, 'annual-report',      '2027-05-01'),
('cpkc',      'CPKC',               'Canadian Pacific Kansas City',     'customer', 'Rail',            true,  'quarterly-earnings', '2026-10-28'),
('bison',     'Bison Transport',    'Bison Transport',                  'customer', 'Trucking',        false, 'private-90d',        null),
('fedex-frt', 'FedEx Freight',      'FedEx Freight (FedEx Corp.)',      'customer', 'LTL',             true,  'quarterly-earnings', '2026-09-17'),
('merchants', 'Merchants Fleet',    'Merchants Fleet',                  'customer', 'Fleet mgmt',      false, 'private-90d',        null),
-- prospects
('tql',       'TQL',                'Total Quality Logistics',          'prospect', 'Brokerage',       false, 'private-90d',        null),
('ups',       'UPS',                'United Parcel Service',            'prospect', 'Parcel',          true,  'quarterly-earnings', '2026-10-27'),
('csx',       'CSX',                'CSX Corporation',                  'prospect', 'Rail',            true,  'quarterly-earnings', '2026-10-15'),
('unp',       'Union Pacific',      'Union Pacific Corporation',        'prospect', 'Rail',            true,  'quarterly-earnings', '2026-10-22'),
('chrw',      'C.H. Robinson',      'C.H. Robinson Worldwide',          'prospect', 'Brokerage/3PL',   true,  'quarterly-earnings', '2026-10-28'),
('ttx',       'TTX',                'TTX Company',                      'prospect', 'Rail equipment',  false, 'private-90d',        null),
('jbht',      'J.B. Hunt',          'J.B. Hunt Transport Services',     'prospect', 'Intermodal/Truck',true,  'quarterly-earnings', '2026-10-15'),
('xpo',       'XPO',                'XPO, Inc.',                        'prospect', 'LTL',             true,  'quarterly-earnings', '2026-10-30'),
('gxo',       'GXO',                'GXO Logistics',                    'prospect', 'Contract logistics',true,'quarterly-earnings', '2026-11-04'),
('expd',      'Expeditors',         'Expeditors International',         'prospect', 'Forwarding',      true,  'quarterly-earnings', '2026-11-03'),
('dart',      'Dart Container',     'Dart Container Corporation',       'prospect', 'Mfg/private fleet',false,'private-90d',        null);

-- ============================================================
--  BASELINE 1 · CN RAIL · PURSUE
--  Evidence: Q2 2026 results (July 2026), CN filings & site
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, 1, 'PURSUE',
'Operating ratio went the wrong way while the accident rate jumped 47% — and a technology CIO from Wipro now owns the fix. Trigger, clock, and named owner all present.',
$$[
 {"n":"01","text":"<b>The efficiency story stalled.</b> Q2 2026 operating ratio of 62.5% is 0.8pt worse year-over-year; the 12-quarter trend shows CN oscillating, not improving, while peers compress."},
 {"n":"02","text":"<b>Safety is now a board-level number.</b> FRA-reportable accident rate 2.30 per million train-miles, up 47% — this buys attention and budget for anything credibly labelled predictive."},
 {"n":"03","text":"<b>The buyer is a technologist.</b> EVP & Chief Information and Technology Officer Velu Ivaturi (ex-Wipro) runs IT with a TBM lens — he evaluates vendors the way we pitch."},
 {"n":"04","text":"<b>IT capex fell 22%</b> — the conversation that lands is do-more-with-less: AI-native operations, automation of inspection and dispatch decisioning, not big-bang platform builds."}
]$$::jsonb,
$$[
 {"no":"A","title":"Operating ratio","headline":"Twelve quarters of oscillation: Q2 2026 at 62.5% is worse than a year ago, and the improvement narrative has no evidence behind it.",
  "chart":{"kind":"line","unit":"%","y_label":"OR %","annotate_last":true,
           "labels":["Q3'23","Q4'23","Q1'24","Q2'24","Q3'24","Q4'24","Q1'25","Q2'25","Q3'25","Q4'25","Q1'26","Q2'26"],
           "series":[{"name":"Operating ratio","tone":"struct","values":[62.0,59.3,63.6,64.0,63.1,62.6,63.4,61.7,61.4,61.2,64.6,62.5]}]},
  "table":{"head":["","Q3'23","Q4'23","Q1'24","Q2'24","Q3'24","Q4'24","Q1'25","Q2'25","Q3'25","Q4'25","Q1'26","Q2'26"],
           "rows":[["OR %","62.0","59.3","63.6","64.0","63.1","62.6","63.4","61.7","61.4","61.2","64.6","62.5"]]},
  "sowhat":"An operator that cannot show structural OR improvement funds initiatives that promise it. Efficiency framed as <b>decision automation</b> — not headcount — matches both the need and the political constraints.",
  "sources":[{"label":"CN Q2 2026 results release","url":"https://www.cn.ca/en/investors/"},{"label":"CN quarterly data archive","url":"https://www.cn.ca/en/investors/financial-results/"}]},
 {"no":"B","title":"Safety trend","headline":"FRA accident rate 2.30 per million train-miles in Q2 2026 — up 47% year-over-year, moving opposite to the industry.",
  "body_html":"<p>Safety metrics deteriorated across the board in H1 2026. A 47% jump in the accident rate is the kind of number that appears in board packs and regulator correspondence, which makes <b>predictive maintenance, automated track/equipment inspection, and video analytics</b> fundable this fiscal year rather than next.</p>",
  "sowhat":"Lead with safety, not savings. A safety-anchored AI-operations pitch gives the CITO an internal story no one argues with.",
  "sources":[{"label":"CN Q2 2026 results release","url":"https://www.cn.ca/en/investors/"},{"label":"FRA safety database","url":"https://railroads.dot.gov/safety-data"}]},
 {"no":"C","title":"The buyer","headline":"Velu Ivaturi, EVP & Chief Information and Technology Officer — a services-industry technologist running CN's IT on TBM discipline.",
  "body_html":"<p>Ivaturi joined CN from Wipro, where he spent over two decades in delivery and technology leadership. He publicly champions Technology Business Management — cost transparency per unit of IT. Two implications: he is <b>culturally fluent in offshore delivery models</b> (no evangelising needed), and he <b>measures vendors in unit economics</b>, so proposals should arrive pre-framed in cost-per-outcome terms.</p>",
  "sowhat":"This is the rare rail buyer who already believes what Mphasis sells. The pitch is peer-to-peer: services-industry native to services-industry native.",
  "sources":[{"label":"CN leadership page","url":"https://www.cn.ca/en/about-cn/leadership/"}]},
 {"no":"D","title":"IT spend signal","headline":"IT capital spending down 22% — the budget conversation is efficiency, not expansion.",
  "body_html":"<p>CN cut technology capex roughly 22% while operational technology ambitions (automated inspection portals, network operating centre modernisation) continue. That gap between ambition and budget is exactly where an <b>AI-native, outcome-priced delivery partner</b> displaces both incumbent SIs and internal builds.</p>",
  "sowhat":"Do not pitch a transformation programme. Pitch two surgical, safety-anchored automation outcomes with unit-cost math attached.",
  "sources":[{"label":"CN Q2 2026 results release","url":"https://www.cn.ca/en/investors/"}]}
]$$::jsonb,
'2026-07-22', true, 'current'
from public.accounts where slug = 'cn';

-- ============================================================
--  BASELINE 2 · EDMONTON AIRPORTS · QUALIFY
--  Evidence: FY2025 audited statements (PwC, 19 Mar 2026)
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, 1, 'QUALIFY',
'Nine-figure debt service and a drawn operating line meet a genuinely ambitious ops-technology agenda. Real appetite, constrained wallet — the open question is whether technology spend survives the debt schedule.',
$$[
 {"n":"01","text":"<b>Growth is real but bought with the regulated lever.</b> FY2025 revenue C$264.4M (+9.5%) — but per-passenger aeronautical revenue rose 29.4% while non-aero rose just 1.9%. They raised fees; they have not yet monetised the estate."},
 {"n":"02","text":"<b>The balance sheet is tight.</b> C$974M debt, C$97M debt service due 2026, cash down 36% to C$18.3M, and the operating line drawn C$20M for the first time."},
 {"n":"03","text":"<b>Yet ops-technology ambition is accelerating</b> — Canada-first Airport Digital Assistant with Air Canada, drone glide-path operations, IOC video analytics, AP automation — while software capex fell 38.5%. Ambition up, internal capacity down: a partner-shaped gap."},
 {"n":"04","text":"<b>CEO language matches our pitch.</b> Myron Keehn's stated agenda is monetising assets — 2,000-acre ICH airport city broke ground, North Tower due Q1 2028. Non-aero revenue growth is where AI maps to revenue, not cost."}
]$$::jsonb,
$$[
 {"no":"A","title":"Revenue quality","headline":"C$264.4M revenue, +9.5% — but decomposition shows the growth came from the regulated lever, not the commercial estate.",
  "chart":{"kind":"bar","y_label":"C$000","labels":["AIF","Concessions\u00A0/\u00A0parking","Airside\u00A0&\u00A0terminal","Real estate","Contributions\u00A0&\u00A0other"],
           "series":[{"name":"FY2025 revenue","tone":"struct","values":[118504,61837,60398,15773,7924]}]},
  "table":{"head":["Revenue line (C$000)","FY2025","Note"],
   "rows":[["Airport improvement fees","118,504","regulated, volume x rate"],
           ["Concessions, parking, ground transport","61,837","commercial"],
           ["Airside & terminal charges","60,398","+33% — the fee increase"],
           ["Real estate","15,773","the strategic upside"],
           ["Contributions & other","7,924",""],
           ["<b>Total</b>","<b>264,436</b>","+9.5% vs FY2024"]]},
  "sowhat":"Per passenger (8.14M vs 7.92M pax): aero revenue +29.4%, non-aero +1.9%. The wedge is the pitch: the next chapter of growth must come from the commercial estate, and that is where data and AI map to <b>revenue</b>, not cost.",
  "sources":[{"label":"FY2025 Annual Report — audited statements (PwC, 19 Mar 2026)","url":"https://flyyeg.com/wp-content/uploads/YEG_Annual-Report_Digital_May-1.pdf"}]},
 {"no":"B","title":"Balance sheet","headline":"C$974M debt against C$115M operating earnings, C$97M debt service due in 2026, cash down 36%, operating line drawn for the first time.",
  "table":{"head":["Item (C$000)","FY2025"],
   "rows":[["Total debt","973,944"],["Operating earnings","115,025 (43.5% margin)"],["Net income","15,933"],
           ["2026 debt service (principal + interest)","97,118"],["Cash","18,313 (−36%)"],["Operating line drawn","20,000 — first draw"],
           ["Series A coupon","7.214% to 2030"],["Net liability position","(106,262)"]]},
  "sowhat":"Every dollar competes with the debt schedule. Proposals must be <b>small-start, opex-shaped, revenue-linked</b> — not capital programmes. This is the QUALIFY question: does discretionary technology spend survive 2026?",
  "sources":[{"label":"FY2025 Annual Report — audited statements","url":"https://flyyeg.com/wp-content/uploads/YEG_Annual-Report_Digital_May-1.pdf"}]},
 {"no":"C","title":"Technology posture","headline":"Software capex fell 38.5% to C$2.7M while operational-technology ambition visibly accelerated.",
  "body_html":"<p>In the same year software capital spending dropped from C$4.5M to C$2.7M, YEG launched a <b>Canada-first Airport Digital Assistant</b> with Air Canada (gates 50–60), ran drone operations crossing an active glide path, deployed video analytics in the IOC, and automated AP/procurement workflows. They also sole-sourced C$174K of asset-management implementation consulting to IBM Canada — just above the competitive threshold, a signal that outside help is being bought in slices.</p>",
  "sowhat":"Ambition is up, internal build capacity is down, and external help is entering through small doors. That is precisely the shape of engagement Mphasis can win: <b>land small on ops-AI, expand on results.</b>",
  "sources":[{"label":"FY2025 Annual Report","url":"https://flyyeg.com/wp-content/uploads/YEG_Annual-Report_Digital_May-1.pdf"},{"label":"YEG newsroom — ADA launch","url":"https://flyyeg.com/newsroom/"}]},
 {"no":"D","title":"Traffic & pipeline","headline":"8.14M passengers (+2.8%), within 0.1% of 2019 — recovery is done; what remains is a monetisation story.",
  "chart":{"kind":"line","unit":"M","y_label":"passengers (M)","annotate_last":true,"y_min":0,
           "labels":["2019","2020","2021","2022","2023","2024","2025"],
           "series":[{"name":"Passengers","tone":"go","values":[8.15,2.60,2.79,5.85,7.50,7.92,8.14]}]},
  "table":{"head":["","2019","2020","2021","2022","2023","2024","2025"],
   "rows":[["Passengers (M)","8.15","2.60","2.79","5.85","7.50","7.92","8.14"]]},
  "sowhat":"Domestic +6.2%, transborder −15%, cargo/ZVL movements +28% with economic impact estimated at C$164M. The 2,000-acre ICH airport city broke ground; North Tower lands Q1 2028. Growth from here is estate + cargo + experience — all data problems.",
  "sources":[{"label":"FY2025 Annual Report","url":"https://flyyeg.com/wp-content/uploads/YEG_Annual-Report_Digital_May-1.pdf"}]}
]$$::jsonb,
'2026-03-19', true, 'current'
from public.accounts where slug = 'yeg';
