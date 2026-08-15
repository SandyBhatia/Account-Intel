-- ============================================================
--  BASELINES · BATCH 3 — FedEx Freight, TQL, Bison, Merchants Fleet
--  Private-company baselines rest on press releases, trade press
--  and company disclosures. Thinner than filings, same standard:
--  nothing asserted without a source that was actually read.
--  Run AFTER schema.sql + seed.sql. Safe to re-run.
-- ============================================================

-- FedEx Freight is now an independent NYSE-listed company (FDXF).
update public.accounts
set full_name = 'FedEx Freight Holding Company, Inc. (NYSE: FDXF)',
    is_public = true, cadence = 'quarterly-earnings'
where slug = 'fedex-frt';

update public.baselines set active = false
where account_id in (select id from public.accounts where slug in ('fedex-frt','tql','bison','merchants'));

-- ============================================================
--  FEDEX FREIGHT · PURSUE
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'PURSUE',
'A $9 billion company that became independent on 1 June 2026 and now has to stand up its own technology estate, separate from FedEx Corp. Carve-outs run on transition service agreements with expiry dates — the clock is structural, not seasonal.',
$$[
 {"n":"01","text":"<b>The separation is done.</b> FedEx completed the spin-off on 1 June 2026, establishing FedEx Freight Holding Company (NYSE: FDXF) as an independent public company and the largest North American LTL carrier."},
 {"n":"02","text":"<b>Every carve-out inherits a technology deadline.</b> A newly separated company runs on transition service agreements from the former parent, each with an expiry. Standing up independent systems before those lapse is the defining programme of a carve-out's first two years."},
 {"n":"03","text":"<b>They have said technology is the strategy.</b> Company materials describe an expanded dedicated LTL salesforce, an <b>integrated and digitally enabled technology platform</b>, and optimised operations — with a stated commercial strategy centred on high-growth verticals, technology and infrastructure investment, and ongoing efficiency initiatives."},
 {"n":"04","text":"<b>Scale makes it worth it.</b> Roughly $9 billion in annual revenue, about 30,000 power units, more than 350 service centres, 39,000 team members, and on the order of 85,000–90,000 shipments per day."}
]$$::jsonb,
$$[
 {"no":"A","title":"The separation","headline":"Independent since 1 June 2026, with FedEx retaining 19.9% it intends to dispose of within 24 months.",
  "body_html":"<p>FedEx announced its intent to separate the LTL business on 19 December 2024, filed the Form 10 registration statement on 16 January 2026, received board approval in May, and <b>completed the spin-off on 1 June 2026</b>. The mechanism was a pro rata distribution of <b>80.1%</b> of FedEx Freight common stock — one share for every two FedEx shares held. FedEx retains <b>19.9%</b>, which it intends to dispose of within 24 months through debt repayment or dividend distribution. <b>John Smith</b>, previously FedEx's leader of US and Canadian operations, became president and chief executive of FedEx Freight.</p>",
  "sowhat":"The retained 19.9% stake and its 24-month disposal horizon puts a visible clock on the whole separation. Independence has to be demonstrated — operationally and financially — inside that window, and systems independence is the least glamorous, most urgent part of it.",
  "sources":[{"label":"FedEx completes spin-off of FedEx Freight (1 June 2026)","url":"https://newsroom.fedex.com/newsroom/global-english/fedex-completes-spin-off-of-fedex-freight"},{"label":"FreightWaves — FedEx board approves LTL spinoff","url":"https://www.freightwaves.com/news/fedex-board-approves-spinoff-of-ltl-unit"},{"label":"FedEx Freight Form 10 registration statement (SEC)","url":"https://www.sec.gov/Archives/edgar/data/2082247/000110465926004329/tm2520565d6_ex99-1.htm"}]},
 {"no":"B","title":"Scale and stated agenda","headline":"$9 billion of revenue, 350+ service centres, and a strategy the company itself frames around technology and efficiency.",
  "chart":{"kind":"bar","y_label":"count","labels":["Power units","Service centres","Team members","Shipments per day"],
    "series":[{"name":"FedEx Freight scale","tone":"struct","values":[30000,350,39000,85000]}]},
  "body_html":"<p>FedEx Freight comprises the former FedEx LTL segment including FedEx Custom Critical and LTL Select. In its own separation materials the company commits to <b>executing a focused commercial and operational strategy centred on high-growth verticals, technology and infrastructure investment, and ongoing efficiency initiatives</b>, and to positioning itself with an expanded dedicated salesforce and an integrated, digitally enabled technology platform. Commercially, the separation also decouples parcel and LTL contracts, meaning pricing and discount structures must now be evaluated independently.</p>",
  "sowhat":"Decoupled pricing is its own data problem: FedEx Freight now has to price LTL on its own merits without parcel volume subsidising the relationship. Pricing science, yield management and customer profitability analytics all become first-order capabilities <b>this year</b>.",
  "sources":[{"label":"FedEx Freight spin-off overview (investor relations)","url":"https://investors.fedex.com/fedex-freight-spin-off/default.aspx"},{"label":"FedEx Form 10 announcement (16 Jan 2026)","url":"https://newsroom.fedex.com/newsroom/global-english/fedex-announces-filing-of-form-10-registration-statement-for-planned-spin-off-of-fedex-freight"},{"label":"FleetOwner — FedEx Freight split","url":"https://www.fleetowner.com/operations/article/55292249/fedex-freight-split-30000-trucks-to-focus-on-small-business-e-commerce-and-grocery"}]}
]$$::jsonb,
'2026-06-01', true, 'current'
from public.accounts a where slug = 'fedex-frt';

-- ============================================================
--  TQL · QUALIFY
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'QUALIFY',
'Enormous brokerage scale on a headcount-heavy model, and a reported $2,000 resignation incentive suggests cost pressure on exactly that model. Private, so the financial picture is partial — resolve before pursuing.',
$$[
 {"n":"01","text":"<b>Scale is not the question.</b> Over 4 million shipments annually across a network of more than 110,000 carriers, 9,000+ employees and 65 offices, headquartered in the Cincinnati area and founded in 1997 by Ken Oaks, who remains CEO, with Kerry Byrne as President."},
 {"n":"02","text":"<b>The model is people-intensive by design</b> — dedicated account teams and 24/7 service are the differentiator. That is precisely the cost structure most exposed to automation, and most expensive to leave unautomated."},
 {"n":"03","text":"<b>There is a cost signal.</b> TQL has reportedly offered a $2,000 resignation incentive to workers, framed as retaining only employees who are fully committed. Voluntary-exit incentives generally indicate headcount pressure."},
 {"n":"04","text":"<b>The revenue history is volatile</b> — publicly reported figures move from $4.1B (2020) to $7.8B (2021), $8.8B (2022) and $6.7B (2023). Private company, so these are secondary-source figures and later years are not established here."}
]$$::jsonb,
$$[
 {"no":"A","title":"Reported revenue history","headline":"A revenue line that nearly doubled and then fell by roughly a quarter — brokerage cyclicality at full amplitude.",
  "chart":{"kind":"bar","y_label":"$ billions","labels":["2020","2021","2022","2023"],
    "series":[{"name":"Reported revenue","tone":"struct","values":[4.1,7.8,8.8,6.7]}]},
  "body_html":"<p>TQL is privately held and does not file financial statements. The figures above are as publicly reported and are the most recent years established here; <b>2024 and 2025 are not verified in this baseline</b>. The company describes itself as the largest full-truckload provider in North America, arranging truckload, LTL, drayage, air, ocean, rail and warehousing across its carrier network. Recent expansion includes new offices in Huntsville and Baton Rouge.</p>",
  "sowhat":"A business whose revenue can swing 25% in a year cannot carry a fixed people cost through the trough. Every downcycle makes the automation argument for us — the question is whether they build it or buy it, and that is what the qualifying conversation should test.",
  "sources":[{"label":"Forbes company overview — TQL","url":"https://www.forbes.com/companies/tql-total-quality-logistics/"},{"label":"Total Quality Logistics — company profile","url":"https://en.wikipedia.org/wiki/Total_Quality_Logistics"},{"label":"TQL press releases","url":"https://www.tql.com/press-releases"}]},
 {"no":"B","title":"Cost signal","headline":"A reported $2,000 resignation incentive — the clearest available indicator of pressure on the headcount model.",
  "body_html":"<p>Trade coverage reports that TQL offered employees a <b>$2,000 resignation incentive</b>, positioned as a way of keeping only those who are, in the company's framing, fully committed. At the same time the company continues to open offices, including a Huntsville location expected to contribute around 100 new jobs.</p><p class='note'>Simultaneous voluntary-exit incentives and regional expansion suggest a <b>mix shift</b> rather than a straightforward contraction — but the underlying driver is not established here and should be confirmed before this account is worked.</p>",
  "sowhat":"Companies rebalancing where and how they employ people are unusually receptive to arguments about which work needs a human at all. That is the entry point — but the read on their intent is inference, not evidence, and needs testing.",
  "sources":[{"label":"TQL company news roundup (incl. FreightWaves report)","url":"https://www.zoominfo.com/c/total-quality-logistics-llc/106086575"}]}
]$$::jsonb,
'2026-06-26', true, 'current'
from public.accounts a where slug = 'tql';

-- ============================================================
--  BISON TRANSPORT · PURSUE
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'PURSUE',
'An existing customer that signed a cross-border intermodal agreement with CPKC — another account on this roster. One programme, two relationships, and the Intermodal-as-Horizontal thesis made concrete rather than theoretical.',
$$[
 {"n":"01","text":"<b>Bison and CPKC are partners.</b> Bison signed an agreement with Canadian Pacific Kansas City for continuous cross-border intermodal service through Canada, the US and Mexico — connecting two accounts already on this roster."},
 {"n":"02","text":"<b>This is the intermodal horizontal in practice.</b> The strategic thesis says intermodal cuts across railroad, 3PL and forwarder relationships. Here it does so literally, between a customer and a customer — a single capability sold into both sides of one lane."},
 {"n":"03","text":"<b>Safety is their identity, and they are winning at it</b> — grand prize in the TCA Fleet Safety Awards announced March 2026, and a stated claims ratio below 0.1%. Any technology conversation must be framed as protecting that record, never as a fix for a problem."},
 {"n":"04","text":"<b>Backed by a patient owner.</b> Acquired in January 2021 by James Richardson & Sons, a Canadian family-held conglomerate. Private, long-horizon capital is friendly to multi-year platform investment and hostile to short-payback pitches."}
]$$::jsonb,
$$[
 {"no":"A","title":"The CPKC connection","headline":"A cross-border intermodal agreement with CPKC links two roster accounts through a single lane.",
  "body_html":"<p>Bison Transport announced an agreement with <b>Canadian Pacific Kansas City</b> to provide continuous cross-border intermodal service through Canada, the United States and Mexico. Bison is a privately held, asset-based carrier established in 1969, headquartered in Winnipeg, with terminals, warehouses and yards across Canada, the US and Mexico, employing over 4,000 drivers and staff. The company has also expanded through acquisition, including US-based Hartt Transportation.</p><p>Bison markets specifically to technology and semiconductor shippers, citing GPS tracking, geofencing, carrier vetting, controlled yard processes and real-time visibility for high-value, time-sensitive freight, alongside dedicated fleet solutions for just-in-time semiconductor supply chains and data centre deployment projects.</p>",
  "sowhat":"Cross-border intermodal is a data problem before it is a rail or truck problem — customs, three regulatory regimes, equipment interchange, and handoff visibility. Bison and CPKC each own one half of that lane, and <b>neither owns the data that joins it.</b> That gap is the offer.",
  "sources":[{"label":"Bison Transport news — CPKC intermodal agreement","url":"https://www.bisontransport.com/category/news"},{"label":"Bison Transport — technology shipper capabilities","url":"https://www.bisontransport.com/shippers/technology"},{"label":"Bison Transport — company overview","url":"https://www.bisontransport.com/"}]},
 {"no":"B","title":"Ownership and posture","headline":"Family-conglomerate ownership since 2021 and a safety record that is the brand — invest-to-protect, not fix-what-is-broken.",
  "body_html":"<p>Bison was acquired by <b>James Richardson & Sons</b> on 5 January 2021. In March 2026 Bison and Mill Creek Motor Freight were announced as grand prize winners of the TCA Fleet Safety Awards, an award Bison has taken before; the company also appears on the TCA/CarriersEdge Best Fleets to Drive For list. Bison has previously participated in autonomous-driving ecosystem partnerships alongside other North American carriers, and added barcode technology for real-time freight updates. Leadership changed in May 2024 when the chief executive retired and an internal successor was promoted on an interim basis.</p><p class='note'>Current CEO identity and fleet size are <b>not established</b> in this baseline and should be confirmed before any senior approach.</p>",
  "sowhat":"With an award-winning safety record and patient ownership, the credible pitch is <b>compounding an advantage</b> — predictive analytics that keep the claims ratio below 0.1% as the fleet and lanes grow. Framing it as remediation would misread them entirely.",
  "sources":[{"label":"Bison Transport company profile and news timeline","url":"https://tracxn.com/d/companies/bisontransport/__ajHhMtwDm_gsWfw_rCp9IgaM7V8K190g_VfpuovioJs"},{"label":"Truck News — Bison Transport coverage","url":"https://www.trucknews.com/company/bison-transport/"},{"label":"Bison Transport — company reference","url":"https://en.wikipedia.org/wiki/Bison_Transport"}]}
]$$::jsonb,
'2026-03-05', true, 'current'
from public.accounts a where slug = 'bison';

-- ============================================================
--  MERCHANTS FLEET · QUALIFY
-- ============================================================
insert into public.baselines (account_id, version, verdict, verdict_line, thesis, exhibits, as_of, active, review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id = a.id), 0) + 1, 'QUALIFY',
'Billion-dollar fleet-management business, a leadership transition still settling after a fifteen-year CEO departed, and an EV and telematics agenda that is inherently a data business. Ownership structure unverified — resolve first.',
$$[
 {"n":"01","text":"<b>Scale is established.</b> Gross sales passed $1 billion in 2023. Founded 1962, privately held, headquartered at 14 Central Park Drive, Hooksett, New Hampshire."},
 {"n":"02","text":"<b>The leadership chair turned over.</b> Brendan Keegan retired in May 2024 after fifteen years as chief executive; Brad Burgess and Kirk Hoffman were named interim co-CEOs. Company records subsequently list <b>Matt Dyer</b> as chief executive."},
 {"n":"03","text":"<b>The business is already a data business.</b> Stated specialties span fleet leasing, EV infrastructure and charging, and fleet technology — EV transition planning is fundamentally a modelling problem across duty cycles, charging siting and total cost."},
 {"n":"04","text":"<b>Ownership is the open question.</b> An earlier working assumption about the capital structure could not be substantiated and has been withdrawn. Who owns Merchants Fleet, and on what horizon, determines both the investment appetite and the decision path."}
]$$::jsonb,
$$[
 {"no":"A","title":"Position and transition","headline":"A billion-dollar fleet-management business that changed chief executive after fifteen years of continuity.",
  "body_html":"<p>Merchants Fleet is a privately held fleet-management company founded in <b>1962</b> and headquartered in Hooksett, New Hampshire. Its stated specialties include fleet leasing, EV infrastructure and charging, and fleet technology. <b>Gross sales exceeded $1 billion in 2023.</b> Long-serving chief executive <b>Brendan Keegan retired in May 2024</b> after fifteen years, with <b>Brad Burgess</b> and <b>Kirk Hoffman</b> appointed interim co-chief executives; business records subsequently list <b>Matt Dyer</b> as chief executive.</p><p class='note'>Two items are <b>explicitly unverified</b> and must be confirmed before an approach: the current ownership and capital structure, and whether the chief executive appointment is permanent. An earlier assumption about institutional ownership was withdrawn as unsupported.</p>",
  "sowhat":"A leadership transition following fifteen years of continuity is one of the most reliable openings that exists — incoming executives review vendors, systems and strategy. But approaching without knowing who owns the company or who actually holds the chair would waste the opening.",
  "sources":[{"label":"Merchants Fleet company profile and leadership history","url":"https://www.zoominfo.com/c/total-quality-logistics-llc/106086575"},{"label":"Merchants Fleet — business record","url":"https://www.bbb.org/us/nh/hooksett/profile/fleet-management/merchants-fleet-0051-2000031"}]}
]$$::jsonb,
'2026-08-14', true, 'current'
from public.accounts a where slug = 'merchants';
