insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'The best AI operating story in the portfolio — 60%+ productivity gains since 2022 and headcount down 28.7% under the current CEO. They are proof the thesis works, which makes them a hard sell and a superb reference for their peers.',
'[
 {"n":"01","text":"<b>Lean AI is delivering measurably.</b> Per CEO Dave Bozeman, evergreen productivity improvements of <b>over 60% since the end of 2022</b> in both NAST and Global Forwarding, with 15%+ year-over-year in Q2, while average headcount fell <b>10.8% year over year</b> and roughly 28.7% since he took over in mid-2023."},
 {"n":"02","text":"<b>Margins hit target.</b> NAST adjusted operating margin 40.9% and Global Forwarding 33.4% — both at mid-cycle targets. Adjusted operating margin 34.7% overall, up 360bps."},
 {"n":"03","text":"<b>The revenue beat was low quality, which is why the market disliked it.</b> Transportation adjusted gross profit margin <i>fell</i> 210bps to 15.4% as truckload linehaul costs rose about 29% and passed through into revenue, cash from operations collapsed to <b>$35.9 million from $227.1 million</b> on a $227.3 million adverse working-capital swing."},
 {"n":"04","text":"<b>This resolves the prior open question.</b> Revenue grew 19.3% and the shares fell because gross margin thinned and cash generation deteriorated — the top line was pass-through, not profit."}
]'::jsonb,
'[
 {"no":"A","title":"Quality of the beat","headline":"Revenue up 19.3% and adjusted operating margin up 360bps — but gross margin thinned and operating cash fell 84%.",
  "chart":{"kind":"bar","y_label":"$ millions","labels":["Cash from operations Q2 2025","Cash from operations Q2 2026"],
    "series":[{"name":"Operating cash flow","tone":"stop","values":[227.1,35.9]}]},
  "body_html":"<p>Total revenue <b>$4.93 billion</b> (+19.3%), adjusted gross profit $738.0 million (+6.5%), income from operations $255.7 million (+18.4%), adjusted operating margin 34.7% (+360bps), diluted EPS $1.56 (+23.8%), adjusted $1.61 (+24.8%). Transportation adjusted gross profit margin fell 210 basis points to <b>15.4%</b> as truckload linehaul costs rose roughly 29% and were passed through into revenue with adjusted gross profit per shipment roughly flat. Guidance was reaffirmed, not raised: FY2026 adjusted operating income $964 million to $1.04 billion. President and CEO Dave Bozeman, CFO Damon Lee.</p>",
  "sowhat":"C.H. Robinson is the competitive proof point, not primarily a target. Their published numbers — 60% productivity, 28.7% headcount reduction, volumes still growing — are the strongest available evidence when pitching AI-native operations to <b>TQL, J.B. Hunt ICS and XPO brokerage</b>.",
  "sources":[{"label":"C.H. Robinson Q2 2026 results","url":"https://finance.yahoo.com/markets/stocks/articles/c-h-robinson-reports-2026-200500665.html"},{"label":"Air freight & logistics peer earnings review","url":"https://markets.financialcontent.com/stocks/article/stockstory-2026-8-3-earnings-to-watch-expeditors-expd-reports-q2-results-tomorrow"}]}
]'::jsonb,'2026-07-29',true,'current'
from public.accounts a where slug='chrw';

insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'C$97M of 2026 debt service against C$18M of cash. Real ambition, genuinely constrained wallet — every proposal must be small-start, opex-shaped and revenue-linked.',
'[
 {"n":"01","text":"<b>Revenue grew 9.5% to C$264.4 million</b> with operating earnings of C$115.0 million and net income of C$15.9 million — a substantial improvement from C$1.9 million the prior year."},
 {"n":"02","text":"<b>The balance sheet is the constraint.</b> Total long-term debt <b>C$973.9 million</b> against <b>C$97.1 million</b> of 2026 debt service (C$57.4M principal plus C$39.7M interest), with cash down 36% to <b>C$18.3 million</b>."},
 {"n":"03","text":"<b>Recovery is complete, the growth must now come from the estate.</b> Passengers reached <b>8.14 million</b> (+2.8%), essentially back to 2019 levels. Further growth has to come from cargo, land development and commercial revenue."},
 {"n":"04","text":"<b>The open question is whether discretionary technology spend survives 2026</b> given the debt schedule. That is what the qualifying conversation must test."}
]'::jsonb,
'[
 {"no":"A","title":"FY2025 audited results","headline":"C$264.4M revenue and C$115.0M operating earnings — against C$974M of debt and C$18.3M of cash.",
  "chart":{"kind":"bar","y_label":"C$ thousands","labels":["Revenue","Operating earnings","2026 debt service","Net income","Cash"],
    "series":[{"name":"FY2025 audited","tone":"struct","values":[264436,115025,97118,15933,18313]}]},
  "body_html":"<p>Audited by PwC, signed 19 March 2026. Total revenue <b>C$264,436 thousand</b> (from C$241,521, +9.5%), operating earnings before other income and expense <b>C$115,025 thousand</b>, net income <b>C$15,933 thousand</b> (from C$1,891 thousand). Cash and equivalents C$18,313 thousand, down 36% from C$28,525 thousand. Total long-term debt net C$973,944 thousand, total assets C$1,017,648 thousand, net liabilities improved to −C$106,262 thousand from −C$125,537 thousand. As a non-share not-for-profit corporation it is income-tax exempt and reports net liabilities rather than equity. President and CEO: Myron Keehn. Board chair: Carman McNary.</p>",
  "sowhat":"C$97 million of debt service against C$18 million of cash means every dollar competes with the schedule. Proposals must be <b>small-start, opex-shaped and revenue-linked</b> — cost-to-serve optimisation and non-aeronautical revenue, not capital programmes.",
  "sources":[{"label":"Edmonton Airports FY2025 Annual Report — audited statements","url":"https://flyyeg.com/wp-content/uploads/YEG_Annual-Report_Digital_May-1.pdf"}]},
 {"no":"B","title":"Where growth has to come from","headline":"Passenger recovery is complete at 8.14 million — the next chapter is cargo, land and commercial revenue.",
  "chart":{"kind":"line","unit":"M","y_label":"passengers (M)","y_min":0,
    "labels":["2019","2020","2021","2022","2023","2024","2025"],
    "series":[{"name":"Passengers","tone":"go","values":[8.15,2.60,2.79,5.85,7.50,7.92,8.14]}]},
  "body_html":"<p>Traffic reached <b>8.14 million passengers</b> in 2025, up 2.8% and within 0.1% of the 2019 peak. The <b>YEG Ascent</b> programme bundles five transformational capital projects including an International Cargo Hub, cargo and logistics plus land development are the stated strategic growth pillars, alongside a hydrogen hub and CEIV Pharma cargo handling certification.</p>",
  "sowhat":"With passenger recovery finished, growth is now a monetisation problem — cargo operations digitisation, parking and retail yield, loyalty data. All are data and AI problems that lift the C$115 million operating-earnings line without heavy capex.",
  "sources":[{"label":"Edmonton Airports FY2025 Annual Report","url":"https://flyyeg.com/wp-content/uploads/YEG_Annual-Report_Digital_May-1.pdf"}]}
]'::jsonb,'2026-03-19',true,'current'
from public.accounts a where slug='yeg';

insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'Three of the top seats changed in two years — CEO in 2025, CFO in 2025, CIO in 2024 — at a company famous for building its own technology. Exceptional Q2 numbers and no debt. The open question is whether the build-not-buy culture moves with the people.',
'[
 {"n":"01","text":"<b>An outstanding quarter.</b> Revenue <b>$3.50 billion</b> (+32%), operating income $349.6 million (+41%), net earnings $266.2 million (+45%), diluted EPS $2.03 (+51%) — driven by airfreight revenue up 57% and tonnage up 14%."},
 {"n":"02","text":"<b>The balance sheet is pristine</b> — $1.03 billion of cash and no long-term debt beyond leases, with $461 million returned to shareholders in the quarter and $748 million year to date."},
 {"n":"03","text":"<b>Leadership has turned over at the top.</b> Daniel R. Wall elected President and CEO in April 2025, David A. Hackett became CFO on 1 October 2025, Courtney Hawkins joined as SVP and Chief Information Officer in 2024, previously in technology leadership at Nordstrom, Starbucks and Nike."},
 {"n":"04","text":"<b>The verdict moved from WATCH to QUALIFY on that turnover.</b> Expeditors has historically built rather than bought technology, three new executives, one of them from outside the industry, is the only realistic circumstance in which that posture changes."}
]'::jsonb,
'[
 {"no":"A","title":"Q2 2026 performance","headline":"Revenue up 32% and EPS up 51%, with over a billion in cash and no long-term debt.",
  "chart":{"kind":"bar","y_label":"% change YoY","labels":["Diluted EPS","Net earnings","Operating income","Revenue","Airfreight tonnage"],
    "series":[{"name":"Q2 2026","tone":"go","values":[51,45,41,32,14]}]},
  "body_html":"<p>Quarter ended 30 June 2026: revenue <b>$3,502,335 thousand</b> (+32%), operating income $349.6 million (+41%), net earnings attributable to shareholders $266.2 million (+45%), diluted EPS $2.03 (+51%). Airfreight revenue rose 57% and customs and other services 27%, airfreight tonnage rose 14% while ocean volume was flat. Cash $1.03 billion with no long-term debt beyond leases, approximately 20,389 full-time equivalents. Investor Day is scheduled for <b>18 November 2026</b>.</p>",
  "sowhat":"A new CEO, a new CFO and a relatively new CIO from outside logistics, arriving into record results and a debt-free balance sheet, have both the mandate and the means to revisit build-versus-buy. The Investor Day on 18 November is where any change of technology posture would surface.",
  "sources":[{"label":"Expeditors Q2 2026 earnings and peer review","url":"https://markets.financialcontent.com/stocks/article/stockstory-2026-8-3-earnings-to-watch-expeditors-expd-reports-q2-results-tomorrow"}]}
]'::jsonb,'2026-08-05',true,'current'
from public.accounts a where slug='expd';

insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'Cognizant signed a strategic automation partnership here in December 2025. A competitor is already inside, under a CEO appointed in January 2025 and PE owners who expect a digital value-creation story. The question is displacement or coexistence.',
'[
 {"n":"01","text":"<b>A direct competitor is embedded.</b> Cognizant announced a strategic partnership with Merchants Fleet on <b>3 December 2025</b>, described as leveraging automation to modernise fleet management. Any approach must start from that fact."},
 {"n":"02","text":"<b>The leadership question is resolved.</b> Matt Dyer was appointed Chief Executive Officer, announced <b>28 January 2025</b>, ending the interim co-CEO arrangement that followed Brendan Keegan''s retirement in May 2024 after fifteen years."},
 {"n":"03","text":"<b>Scale and ownership are confirmed.</b> Over <b>$2 billion in assets under management</b> and <b>175,000 managed commercial fleet units</b> across North America, the fourth largest fleet management company on the continent. Owned since 2022 by <b>Bain Capital, a wholly owned subsidiary of the Abu Dhabi Investment Authority, and the management team</b>."},
 {"n":"04","text":"<b>There is an SEC-registered financing vehicle.</b> Merchants Fleet Funding LLC files Form ABS-15G annually, signed by CFO Kirk Hoffman — a securitisation programme that generates its own data and reporting obligations."}
]'::jsonb,
'[
 {"no":"A","title":"Scale, ownership and the competitive position","headline":"$2B of assets under management and 175,000 fleet units — with Cognizant already holding an automation partnership.",
  "chart":{"kind":"bar","y_label":"count / $","labels":["Managed fleet units","Assets under management ($M)"],
    "series":[{"name":"Merchants Fleet","tone":"struct","values":[175000,2000]}]},
  "body_html":"<p>Founded in 1962 as Merchants Motors in Manchester, New Hampshire, now headquartered in Hooksett. Over <b>$2 billion in assets under management</b> and <b>175,000 managed commercial fleet units</b> across North America, describing itself as the fourth largest and fastest growing fleet management company on the continent, with a business model focused on fleet technology, innovative fleet services and proactive electric-vehicle adoption.</p><p>Ownership was acquired in 2022 by <b>Bain Capital</b> together with a wholly owned subsidiary of the <b>Abu Dhabi Investment Authority</b> and the Merchants leadership team, the company continues to operate independently. CEO <b>Matt Dyer</b> (announced 28 January 2025), CFO <b>Kirk Hoffman</b>.</p><p>On <b>3 December 2025</b>, Cognizant announced a strategic partnership with Merchants Fleet to modernise fleet management through automation.</p>",
  "sowhat":"Private-equity ownership plus a new CEO plus EV transition planning is exactly the profile that buys AI and data services — but Cognizant got there first. The realistic play is <b>adjacent scope</b>: EV duty-cycle and charging-siting modelling, or the securitisation data estate, rather than a head-on displacement.",
  "sources":[{"label":"Merchants Fleet — ownership group","url":"https://www.merchantsfleet.com/about/ownershipgroup/"},{"label":"Merchants Fleet completes acquisition by Bain Capital and ADIA","url":"https://www.prnewswire.com/news-releases/merchants-fleet-announces-completion-of-acquisition-by-bain-capital-adia-and-the-merchants-leadership-team-301653229.html"},{"label":"Merchants Fleet news — Cognizant partnership and CEO appointment","url":"https://www.zoominfo.com/c/merchants-fleet-management/356854940"},{"label":"Merchants Fleet Funding LLC Form ABS-15G (SEC)","url":"https://www.sec.gov/Archives/edgar/data/1964471/000095014226000364/eh260733558_abs15g.htm"}]}
]'::jsonb,'2026-08-14',true,'current'
from public.accounts a where slug='merchants';

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
