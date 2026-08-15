insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id,1,'PURSUE',
'Record revenue and the worst operating ratio in the peer set — 67.6% reported, deteriorating 210bps adjusted. Merger expenses alone cost 150bps. The acquiree in an $85B deal has both a margin problem and an integration mandate.',
'[
 {"n":"01","text":"<b>Record revenue, deteriorating margin.</b> Q2 2026 railway operating revenues of <b>$3.465 billion</b> — an all-time quarterly record, up 11% on 4% volume growth — but income from railway operations <i>fell</i> 4% to $1.1 billion."},
 {"n":"02","text":"<b>The operating ratio is the weakest on the roster.</b> 67.6% reported against 62.2% a year earlier, adjusted 65.5% against 63.4%, a <b>210 basis point deterioration</b>. Operating expenses grew 15% against 11% revenue growth."},
 {"n":"03","text":"<b>Merger costs are already material.</b> Merger-related expenses of <b>$51 million</b> in operating expenses alone reduced the operating ratio by <b>150 basis points</b> in a single quarter."},
 {"n":"04","text":"<b>They are the acquiree, which is the more urgent side of a merger.</b> The acquired network''s systems, data and processes are the ones that must be mapped, reconciled and migrated. That work is specified before close, not after."}
]'::jsonb,
'[
 {"no":"A","title":"Record revenue, margin under pressure","headline":"An all-time revenue record and a 540 basis point reported operating-ratio deterioration in the same quarter.",
  "chart":{"kind":"grouped","y_label":"OR %","y_min":55,
    "labels":["Reported OR","Adjusted OR"],
    "series":[{"name":"Q2 2025","tone":"dim","values":[62.2,63.4]},{"name":"Q2 2026","tone":"stop","values":[67.6,65.5]}]},
  "body_html":"<p>Revenue <b>$3.465 billion</b> (+11%, +$355 million) on 4% volume growth, with higher fuel surcharges contributing six points of that growth, excluding fuel, revenue was still a record $3,050 million (+5%). Income from railway operations $1.1 billion (−4%), adjusted $1,196 million (+5%). Diluted EPS $3.26 (−4%), adjusted diluted EPS $3.52 (+7%), beating consensus of roughly $3.23–3.33. Fuel costs surged $186 million, or 85%, with price accounting for $169 million. H1 2026 operating cash flow $1,398 million, debt-to-total-capitalisation 50.6% at 30 June 2026, Eastern Ohio incident accruals $186 million.</p>",
  "sowhat":"A railroad that grows revenue 11% and loses 540 basis points of reported operating ratio has a cost-structure problem that pricing cannot outrun. Fuel explains part of it, merger cost explains 150bps, the remainder is the conversation.",
  "sources":[{"label":"Norfolk Southern Q2 2026 results (company newsroom)","url":"https://www.norfolksouthern.com/en/newsroom/news-releases/norfolk-southern-reports-second-quarter-2026-results"},{"label":"Norfolk Southern Q2 2026 10-Q summary","url":"https://www.stocktitan.net/sec-filings/NSC/10-q-norfolk-southern-corp-quarterly-earnings-report-c608a3120bed.html"}]},
 {"no":"B","title":"Position in the merger","headline":"The acquired party in an $85 billion transaction — and the side whose systems have to move.",
  "body_html":"<p>Norfolk Southern is being acquired by Union Pacific for <b>1.0 UP share plus $88.82 cash per NS share</b>, an enterprise value of approximately <b>$85 billion</b>, with NS shareholders taking roughly 27% of a combined enterprise valued at over $250 billion. The Surface Transportation Board accepted the revised application on 28 May 2026 and held proceedings in abeyance pending supplemental information. Completion is expected in 2027. President and CEO <b>Mark George</b> described the quarter as exceeding expectations on improving demand.</p>",
  "sowhat":"In every large merger the acquiree carries the heavier integration burden — its applications, data models and operating processes are the ones migrated or retired. Engaging NS now, ahead of approval, positions for the integration programme regardless of which side eventually contracts it.",
  "sources":[{"label":"Norfolk Southern Q2 2026 results","url":"https://www.norfolksouthern.com/en/newsroom/news-releases/norfolk-southern-reports-second-quarter-2026-results"},{"label":"STB decision — Federal Register, 29 May 2026","url":"https://www.federalregister.gov/documents/2026/05/29/2026-10751/union-pacific-corporation-and-union-pacific-railroad-company-control-norfolk-southern-corporation"}]}
]'::jsonb,'2026-07-23',true,'current'
from public.accounts a where slug='nsc';

insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'Guidance raised on the back of productivity offsetting a 60% fuel increase — and a CITO fifteen months into the job with a digital transformation mandate. An existing customer with a named buyer and a stated agenda.',
'[
 {"n":"01","text":"<b>Productivity is the whole story.</b> Fuel expense rose 60% (+C$249M), adding roughly 210bps of operating-ratio pressure, and CN still delivered an OR of 62.5% by hitting a record Q2 fuel efficiency of 0.836 US gal per 1,000 GTM."},
 {"n":"02","text":"<b>Guidance was raised, not defended.</b> CN now assumes low-single-digit RTM growth (up from flattish) and mid-to-high single-digit adjusted diluted EPS growth for 2026."},
 {"n":"03","text":"<b>There is a named technology buyer in his first eighteen months.</b> Bhushan Ivaturi, EVP and Chief Information and Technology Officer since April 2025, previously SVP and CIO at Enbridge where he led its digital transformation."},
 {"n":"04","text":"<b>Consolidation is on CN''s agenda too.</b> The quarter carried advisory costs related to rail consolidation matters, alongside strategic commercial agreements with Union Pacific that could extend CN''s reach into Mexico and Kansas City."}
]'::jsonb,
'[
 {"no":"A","title":"Q2 2026 performance","headline":"Revenue C$4,753M up 11%, EPS up 10%, and an operating ratio held at 62.5% against a 60% fuel increase.",
  "chart":{"kind":"grouped","y_label":"C$ millions","labels":["Revenue","Operating income","Net income"],
    "series":[{"name":"Q2 2026","tone":"struct","values":[4753,1781,1249]}]},
  "body_html":"<p>Revenue <b>C$4,753 million</b> (+11%), operating income C$1,781 million (+9%), adjusted C$1,798 million (+10%), net income C$1,249 million (+7%), diluted EPS C$2.06 (+10%), adjusted C$2.08 (+11%), revenue ton-miles 62.3 billion (+5%). Operating ratio <b>62.5%</b> (+80bps), adjusted 62.2% (+50bps). First-half free cash flow C$1,842 million (+19%). Leverage 2.61x adjusted net debt to adjusted EBITDA, inside the 2.7x target. Q2 buyback of ~2.9 million shares for C$454 million. 2026 capital programme approximately C$2.8 billion. Q3 dividend C$0.9150 per share payable 29 September 2026.</p>",
  "sowhat":"CN''s own narrative is that productivity offsets fuel. That is an optimisation argument made by the customer, not by us — the fastest route in is to extend it with <b>AI-native operations</b> rather than to introduce a new thesis.",
  "sources":[{"label":"CN Q2 2026 results","url":"https://www.cn.ca/en/investors/financial-results/"},{"label":"CN investor relations","url":"https://www.cn.ca/en/investors/"}]},
 {"no":"B","title":"The buying centre","headline":"Bhushan Ivaturi, EVP and Chief Information and Technology Officer since April 2025 — an incoming CIO with a transformation track record.",
  "body_html":"<p>CN''s senior-most technology executive is <b>Bhushan Ivaturi</b>, Executive Vice-President and Chief Information and Technology Officer, appointed <b>April 2025</b>. Per CN''s own materials he was previously Senior Vice President and Chief Information Officer at Enbridge, where he led its digital transformation. He holds a Master of Science in Information Systems and Operations Management and a bachelor''s degree in mechanical engineering, with executive education at Harvard Business School, MIT Sloan and the Stanford Executive Program. President and CEO: Tracy Robinson.</p>",
  "sowhat":"An executive roughly eighteen months into a CIO role is still shaping his platform strategy and vendor roster, and is measured on visible transformation. This window narrows through 2027.",
  "sources":[{"label":"CN leadership","url":"https://www.cn.ca/en/about-cn/leadership/"}]}
]'::jsonb,'2026-07-24',true,'current'
from public.accounts a where slug='cn';

insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'Operating margin fell from 16.7% to 7.0% in the year it was spun out, and the CEO has publicly called untangling its parcel-centric technology "a massive effort." A transition services agreement expires around June 2028. The clearest carve-out mandate on the roster.',
'[
 {"n":"01","text":"<b>Margin collapsed through separation.</b> FY2026 operating income fell <b>58.6% to $616 million</b> on revenue of $8.8 billion (−1.1%) — an operating margin of <b>7.0%</b> against 16.7% the prior year. Adjusted operating income $1.1 billion (−25.6%), adjusted margin 12.6%."},
 {"n":"02","text":"<b>The technology separation is stated in the CEO''s own words.</b> John Smith has described how FedEx meshed back-office technology across units in 2009, that the majority of it was parcel-centric, and that unbundling it is, in his phrase, a massive effort."},
 {"n":"03","text":"<b>The clock is contractual.</b> A Transition Services Agreement with FedEx runs up to two years from the spin-off — to approximately <b>June 2028</b> — covering order creation and network technology operations. Systems independence must be achieved before it lapses."},
 {"n":"04","text":"<b>Pricing must now stand alone.</b> Separation decouples parcel and LTL contracts, so LTL must be priced on its own merits without parcel volume subsidising the relationship — making yield management and customer profitability analytics first-order capabilities."}
]'::jsonb,
'[
 {"no":"A","title":"The cost of independence","headline":"Operating margin fell from 16.7% to 7.0% and operating income dropped 58.6% in the separation year.",
  "chart":{"kind":"grouped","y_label":"%","labels":["Operating margin","Adjusted operating margin"],
    "series":[{"name":"FY2025","tone":"dim","values":[16.7,16.7]},{"name":"FY2026","tone":"stop","values":[7.0,12.6]}]},
  "body_html":"<p>For FY2026 (year ended 31 May 2026): revenue <b>$8.8 billion</b> (−1.1%), operating income <b>$616 million</b> (−58.6%), adjusted operating income $1.1 billion (−25.6%). Q4 FY2026: revenue $2.4 billion (+4.8%), operating income $158 million (−66.9%), adjusted $363 million, average daily shipments 86,700 (−5.9%) with revenue per shipment $415.22 (+11.5%). Pre-spin the company took on <b>$4.3 billion of debt</b> ($3.7B senior notes plus a $0.6B term loan) with a $1.2 billion revolver. Shares outstanding 149,518,133 as at 3 August 2026.</p><p class=''note''>Basis note: these are FedEx Freight <b>segment</b> results as reported within FedEx Corporation and are explicitly not presented on a carve-out basis, the 10-K''s audited carve-out financials differ, and standalone full-year net income was not disclosed.</p>",
  "sowhat":"Revenue per shipment rose 11.5% while shipments fell 5.9% — they are already trading volume for yield. Doing that well without parcel cross-subsidy requires pricing science they have never had to own before.",
  "sources":[{"label":"FedEx Freight FY2026 Form 10-K (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0002082247/000162828026053359/fdxf-20260531.htm"},{"label":"FedEx Freight investor relations","url":"https://investors.fedex.com/fedex-freight-spin-off/default.aspx"}]},
 {"no":"B","title":"The separation clock","headline":"Independent since 1 June 2026, with a transition services agreement expiring around June 2028 and a seven-month transition period closing 31 December 2026.",
  "body_html":"<p>FedEx completed the spin-off on <b>1 June 2026</b>, distributing <b>80.1%</b> of FedEx Freight stock pro rata — one share for every two FedEx shares — and retaining <b>19.9%</b>, which per the 10-K it must generally dispose of within 24 months. The company changed its fiscal year-end from 31 May to 31 December, so its first standalone reporting period is a <b>seven-month transition period from 1 June to 31 December 2026</b>. Guidance for that period: revenue growth of 4–6% against $5.1 billion, operating income $475–515 million, diluted EPS $1.75–1.95. President and CEO <b>John A. Smith</b>, CFO <b>Marshall Witt</b>, Chairman R. Brad Martin. Approximately 40,000 employees and 355+ terminals.</p>",
  "sowhat":"Three dated pressure points converge: first standalone results in early 2027, FedEx''s 19.9% disposal within 24 months, and TSA expiry around June 2028. Everything about the technology estate has to be resolved inside that window.",
  "sources":[{"label":"FedEx Freight FY2026 Form 10-K (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0002082247/000162828026053359/fdxf-20260531.htm"},{"label":"FedEx completes spin-off of FedEx Freight","url":"https://newsroom.fedex.com/newsroom/global-english/fedex-completes-spin-off-of-fedex-freight"},{"label":"FedEx Freight leadership announcement","url":"https://newsroom.fedex.com/newsroom/global-english/fedex-announces-leadership-for-independent-fedex-freight-company-upon-separation"}]}
]'::jsonb,'2026-05-31',true,'current'
from public.accounts a where slug='fedex-frt';

insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'Efficiency Reimagined has banked $1.2B of a $3B full-year target, the Amazon glide-down is complete, and the CEO has named RFID and AI as the next lever. A funded programme with a public number attached to it.',
'[
 {"n":"01","text":"<b>The structural reset is complete.</b> The Amazon glide-down eliminated roughly <b>2 million pieces per day</b> of lower-quality volume and removed about <b>$4.5 billion</b> of related expense, 45 buildings closed in H1 and around 80% of Driver Choice participants departed in Q2."},
 {"n":"02","text":"<b>Efficiency Reimagined is funded, named and measured</b> — approximately <b>$1.2 billion</b> of programme benefits in H1 2026 against a full-year target of roughly <b>$3 billion</b>. The remaining $1.8 billion is someone''s scorecard right now."},
 {"n":"03","text":"<b>Guidance was raised.</b> FY2026 revenue approximately $91.2 billion, operating profit approximately $8.65 billion, adjusted EPS approximately $7.22, with H2 domestic operating margin projected around 8.8%."},
 {"n":"04","text":"<b>The CEO named the technology.</b> Investment in RFID and artificial intelligence for package visibility, described as the most significant advancement in a decade."}
]'::jsonb,
'[
 {"no":"A","title":"Q2 2026 and the cost of transformation","headline":"Revenue $22.8B with GAAP operating profit of $930M against $2.1B adjusted — the gap is the reset being paid for.",
  "chart":{"kind":"bar","y_label":"$ billions","labels":["Revenue","Adjusted operating profit","GAAP operating profit","Transformation charge"],
    "series":[{"name":"Q2 2026","tone":"struct","values":[22.8,2.1,0.93,0.891]}]},
  "body_html":"<p>Consolidated revenue <b>$22.8 billion</b> (+7.6%), GAAP operating profit $930 million, adjusted operating profit <b>$2.1 billion</b> (+12%), GAAP diluted EPS $0.71, adjusted diluted EPS $1.76. The GAAP figures carry after-tax transformation charges of <b>$891 million</b> ($1.05 per share), primarily employee separation costs from the completed Driver Choice Program.</p>",
  "sowhat":"An organisation absorbing this much restructuring has already accepted disruption. The hard decision is made. What follows a physical network reconfiguration is always a systems and decisioning reconfiguration — and that phase is beginning now.",
  "sources":[{"label":"UPS 2Q 2026 earnings release","url":"https://about.ups.com/us/en/newsroom/press-releases/financials/ups-releases-2q-2026-earnings.html"},{"label":"UPS 2Q 2026 release (PDF)","url":"https://investors.ups.com/_assets/_c53d8bf327c039b6881e8488f7b20256/ups/news/2026-07-28_UPS_Releases_2Q_2026_2164.pdf"}]},
 {"no":"B","title":"Revenue quality shift","headline":"Revenue per piece is rising faster than revenue in both segments — the company is now run on mix and pricing decisions.",
  "chart":{"kind":"grouped","y_label":"% change YoY","labels":["US Domestic","International"],
    "series":[{"name":"Revenue","tone":"struct","values":[6.0,12.5]},{"name":"Revenue per piece","tone":"go","values":[9.3,18.9]}]},
  "body_html":"<p>US Domestic revenue rose 6.0% on a 9.3% increase in revenue per piece, with operating margin of 0.1% GAAP and <b>8.0% adjusted</b>. International revenue rose 12.5% on an 18.9% increase in revenue per piece, with margin of 12.4% on both bases. Asia-to-Asia export volume grew 13.6%. Management describes the business as more selective and focused on revenue quality rather than volume.</p>",
  "sowhat":"Yield outpacing revenue in both segments means the enterprise is being steered by pricing and mix decisions at enormous transaction volume. That is a data problem at a scale few companies have, and it is now the stated strategy.",
  "sources":[{"label":"UPS 2Q 2026 earnings release","url":"https://about.ups.com/us/en/newsroom/press-releases/financials/ups-releases-2q-2026-earnings.html"},{"label":"UPS — takeaways from Q2 2026","url":"https://about.ups.com/us/en/our-stories/innovation-driven/top-5-takeaways-from-ups-s-q2-2026-earnings-announcement.html"}]}
]'::jsonb,'2026-07-28',true,'current'
from public.accounts a where slug='ups';

insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'First double-digit intermodal growth quarter in over a decade and a record 578,072 loads — with the operating ratio flat at 88.9%. Record volume is not becoming margin, and the bid season opens in October.',
'[
 {"n":"01","text":"<b>A genuine inflection.</b> Intermodal loads reached a record <b>578,072</b>, up 10% — per Intermodal president Darren Field on the 22 July call, the first double-digit volume growth quarter in over a decade."},
 {"n":"02","text":"<b>Volume did not become margin.</b> Intermodal operating income rose 58% to $150.9 million, yet the intermodal operating ratio stayed roughly <b>flat at 88.9%</b>. Under twelve cents of every intermodal dollar survives as operating profit."},
 {"n":"03","text":"<b>Mix is masking yield.</b> Eastern loads +16% against transcontinental +5%, shorter eastern hauls cut length of haul, and excluding fuel, yields rose only marginally. Managing profitability through a mix shift is a pricing-science problem."},
 {"n":"04","text":"<b>The bid season opens in October</b> — annual intermodal contracts are priced then, which makes decision-support a this-quarter conversation."}
]'::jsonb,
'[
 {"no":"A","title":"Growth without margin","headline":"Every growth metric double-digit, the intermodal operating ratio did not move.",
  "chart":{"kind":"bar","y_label":"% change YoY","labels":["Diluted EPS","Net earnings","Operating income","Intermodal revenue","Revenue","Intermodal loads","Intermodal OR"],
    "series":[{"name":"Q2 2026 vs Q2 2025","tone":"struct","values":[45,40.7,32,22,19.4,10,0]}]},
  "body_html":"<p>Revenue <b>$3.50 billion</b> (+19.4%), operating income $259.5 million (+32%), net earnings $181.0 million (+40.7%), diluted EPS $1.91 (+45%). Intermodal revenue $1.75 billion (+22%) with segment operating income $150.9 million (+58%) on record loads of 578,072 (+10%). Brokerage (ICS) revenue $388 million (+49%) swung to a $1.7 million operating profit from a $3.6 million loss. Truckload posted a $1.3 million operating loss. Total debt approximately $1.15 billion, H1 operating cash flow $723.3 million, net capital expenditure fell to $144.9 million from $399.1 million.</p>",
  "sowhat":"At an 88.9% operating ratio, marginal decisions decide the year — which loads to accept, where to reposition boxes, how to price. Precisely where applied AI pays for itself, and the capital freed by an 64% capex reduction is available to fund it.",
  "sources":[{"label":"J.B. Hunt Q2 2026 results","url":"https://www.ajot.com/news/jb-hunt-reports-second-quarter-2026-results"},{"label":"Transport Topics — J.B. Hunt Q2 2026","url":"https://www.ttnews.com/articles/jb-hunt-earnings-q2-2026"},{"label":"FreightWaves — intermodal shift analysis","url":"https://www.freightwaves.com/news/massive-opportunities-for-j-b-hunt-in-intermodal-shift"}]}
]'::jsonb,'2026-07-15',true,'current'
from public.accounts a where slug='jbht';
