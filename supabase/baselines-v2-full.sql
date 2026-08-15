-- ============================================================
--  ACCOUNT INTELLIGENCE — FULL BASELINE REBUILD v2
--  Executive-grade pass. Every figure traced to a primary or
--  named credible source. Unverifiable prior claims REMOVED,
--  not softened. Verdicts recalibrated on new evidence.
--
--  Adds Norfolk Southern as the 18th account (UP merger counterparty).
--
--  Run in Supabase SQL Editor AFTER schema.sql and seed.sql.
--  Supersedes baselines-batch1..4 and correction-cn.
--  Safe to re-run.
-- ============================================================

-- ---- add Norfolk Southern, correct FedEx Freight status ----
insert into public.accounts (slug, name, full_name, relationship, sector, is_public, cadence, next_report)
values ('nsc','Norfolk Southern','Norfolk Southern Corporation (NYSE: NSC)','prospect','Rail',true,'quarterly-earnings','2026-10-22')
on conflict (slug) do nothing;

update public.accounts
set full_name='FedEx Freight Holding Company, Inc. (NYSE: FDXF)', is_public=true,
    cadence='transition-period', next_report='2027-02-15'
where slug='fedex-frt';

update public.accounts set next_report='2026-11-18' where slug='expd';

-- ---- archive everything, this pass replaces all standing baselines ----
update public.baselines set active=false;

-- ============================================================
--  UNION PACIFIC · PURSUE
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'The largest systems-integration event in modern North American rail is live: an $85B acquisition of Norfolk Southern, ~$2.75B of targeted synergies, and an STB decision expected in 2027. Integration planning is fundable now, years before close.',
$$[
 {"n":"01","text":"<b>The merger is confirmed and quantified.</b> Terms are 1.0 UP share plus $88.82 cash per NS share — an <b>$85 billion enterprise value</b> for Norfolk Southern and a combined enterprise of over <b>$250 billion</b>, with ~225M UP shares issued (NS holders taking ~27%), a $2.5B reverse termination fee and <b>~$2.75B of expected annualised synergies</b>."},
 {"n":"02","text":"<b>The regulatory clock is running and visible.</b> Joint application filed 19 Dec 2025, found incomplete 16 Jan 2026, revised application filed 30 Apr 2026, STB accepted it 28 May 2026 but held proceedings in abeyance pending supplemental information, delivered 7 July 2026. Completion expected 2027."},
 {"n":"03","text":"<b>UP is already spending on it.</b> Q2 2026 included <b>$35 million of Norfolk Southern acquisition-related costs</b> — integration work is funded and under way well ahead of any approval."},
 {"n":"04","text":"<b>The base business is the best operator in the peer set,</b> so efficiency is not the pitch. Q2 2026 OR 59.7% reported and 59.2% adjusted, with fuel alone costing 120bps. Freight-car velocity +5%, terminal dwell −7%, workforce productivity +5%."}
]$$::jsonb,
$$[
 {"no":"A","title":"Q2 2026 performance","headline":"Revenue $6.864B, up 12%, with the best operating ratio on the roster — 59.7% reported, 59.2% adjusted.",
  "chart":{"kind":"bar","y_label":"OR % (Q2 2026, reported)","y_min":55,
    "labels":["Union Pacific","CPKC (core adj)","CN","CPKC","Norfolk Southern"],
    "series":[{"name":"Operating ratio","tone":"struct","values":[59.7,61.6,62.5,64.6,67.6]}]},
  "body_html":"<p>Operating revenue <b>$6.864 billion</b> (+12%), net income <b>$1.993 billion</b> (+6%) and adjusted net income $2.028 billion (+12%), diluted EPS $3.36 (+7%), adjusted $3.41 (+13%), revenue carloads 2.163 million (+2%). Reported OR 59.7% (+70bps) and adjusted OR 59.2% (+110bps), with fuel expense up 63% costing <b>120 basis points</b>. Debt $30.327 billion at 2.5x adjusted debt/adjusted EBITDA, H1 free cash flow $1.812 billion, capital plan $3.3 billion, $1.640 billion of dividends paid in H1.</p>",
  "sowhat":"UP is the benchmark others are measured against. Any efficiency pitch dies on contact. The opening is <b>scale and integration complexity</b> — problems that get harder as the network grows, not cheaper.",
  "sources":[{"label":"Union Pacific Q2 2026 8-K earnings release (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0000100885/000010088526000249/a2026-07x238xkex991earning.htm"}]},
 {"no":"B","title":"The merger","headline":"$85 billion for Norfolk Southern, ~$2.75 billion of targeted synergies, and an STB decision expected in 2027.",
  "chart":{"kind":"bar","y_label":"$ billions","labels":["NS enterprise value","Combined enterprise","Cash consideration","Targeted synergies","Reverse break fee"],
    "series":[{"name":"Transaction terms","tone":"go","values":[85,250,20,2.75,2.5]}]},
  "body_html":"<p>Announced 29 July 2025. Consideration is <b>1.0 UP share plus $88.82 in cash per NS share</b>. UP's own 10-Q frames it as approximately 225 million UP shares plus roughly $20 billion of cash. Norfolk Southern shareholders would hold about 27% of the combined company. The Surface Transportation Board accepted the revised application on <b>28 May 2026</b> but held proceedings — including environmental review — in abeyance, ordering supplemental information by 27 July 2026, applicants filed their first round of responses on 7 July 2026 addressing TTX, Kansas City Terminal and Terminal Railroad Association. On 22 July 2026 the STB ordered employee-impact data made public.</p><p>A specific competitive condition matters to another roster account: UP and NS combined would exceed 50% of TTX, so they have committed to divest shares to bring combined ownership to <b>49% or below</b>.</p>",
  "sowhat":"Two Class I networks, two PSR platforms, two data estates, two application portfolios. Post-merger integration at this scale runs for years and is contracted early. Clean-room and integration-planning work is legitimate <b>now</b>, the programme itself lands on approval.",
  "sources":[{"label":"STB decision — Federal Register, 29 May 2026","url":"https://www.federalregister.gov/documents/2026/05/29/2026-10751/union-pacific-corporation-and-union-pacific-railroad-company-control-norfolk-southern-corporation"},{"label":"Union Pacific Q2 2026 8-K (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0000100885/000010088526000249/a2026-07x238xkex991earning.htm"}]}
]$$::jsonb,'2026-07-23',true,'current'
from public.accounts a where slug='unp';

-- ============================================================
--  NORFOLK SOUTHERN · PURSUE  (new account)
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id,1,'PURSUE',
'Record revenue and the worst operating ratio in the peer set — 67.6% reported, deteriorating 210bps adjusted. Merger expenses alone cost 150bps. The acquiree in an $85B deal has both a margin problem and an integration mandate.',
$$[
 {"n":"01","text":"<b>Record revenue, deteriorating margin.</b> Q2 2026 railway operating revenues of <b>$3.465 billion</b> — an all-time quarterly record, up 11% on 4% volume growth — but income from railway operations <i>fell</i> 4% to $1.1 billion."},
 {"n":"02","text":"<b>The operating ratio is the weakest on the roster.</b> 67.6% reported against 62.2% a year earlier, adjusted 65.5% against 63.4%, a <b>210 basis point deterioration</b>. Operating expenses grew 15% against 11% revenue growth."},
 {"n":"03","text":"<b>Merger costs are already material.</b> Merger-related expenses of <b>$51 million</b> in operating expenses alone reduced the operating ratio by <b>150 basis points</b> in a single quarter."},
 {"n":"04","text":"<b>They are the acquiree, which is the more urgent side of a merger.</b> The acquired network's systems, data and processes are the ones that must be mapped, reconciled and migrated. That work is specified before close, not after."}
]$$::jsonb,
$$[
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
]$$::jsonb,'2026-07-23',true,'current'
from public.accounts a where slug='nsc';

-- ============================================================
--  CN RAIL · PURSUE
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'Guidance raised on the back of productivity offsetting a 60% fuel increase — and a CITO fifteen months into the job with a digital transformation mandate. An existing customer with a named buyer and a stated agenda.',
$$[
 {"n":"01","text":"<b>Productivity is the whole story.</b> Fuel expense rose 60% (+C$249M), adding roughly 210bps of operating-ratio pressure, and CN still delivered an OR of 62.5% by hitting a record Q2 fuel efficiency of 0.836 US gal per 1,000 GTM."},
 {"n":"02","text":"<b>Guidance was raised, not defended.</b> CN now assumes low-single-digit RTM growth (up from flattish) and mid-to-high single-digit adjusted diluted EPS growth for 2026."},
 {"n":"03","text":"<b>There is a named technology buyer in his first eighteen months.</b> Bhushan Ivaturi, EVP and Chief Information and Technology Officer since April 2025, previously SVP and CIO at Enbridge where he led its digital transformation."},
 {"n":"04","text":"<b>Consolidation is on CN's agenda too.</b> The quarter carried advisory costs related to rail consolidation matters, alongside strategic commercial agreements with Union Pacific that could extend CN's reach into Mexico and Kansas City."}
]$$::jsonb,
$$[
 {"no":"A","title":"Q2 2026 performance","headline":"Revenue C$4,753M up 11%, EPS up 10%, and an operating ratio held at 62.5% against a 60% fuel increase.",
  "chart":{"kind":"grouped","y_label":"C$ millions","labels":["Revenue","Operating income","Net income"],
    "series":[{"name":"Q2 2026","tone":"struct","values":[4753,1781,1249]}]},
  "body_html":"<p>Revenue <b>C$4,753 million</b> (+11%), operating income C$1,781 million (+9%), adjusted C$1,798 million (+10%), net income C$1,249 million (+7%), diluted EPS C$2.06 (+10%), adjusted C$2.08 (+11%), revenue ton-miles 62.3 billion (+5%). Operating ratio <b>62.5%</b> (+80bps), adjusted 62.2% (+50bps). First-half free cash flow C$1,842 million (+19%). Leverage 2.61x adjusted net debt to adjusted EBITDA, inside the 2.7x target. Q2 buyback of ~2.9 million shares for C$454 million. 2026 capital programme approximately C$2.8 billion. Q3 dividend C$0.9150 per share payable 29 September 2026.</p>",
  "sowhat":"CN's own narrative is that productivity offsets fuel. That is an optimisation argument made by the customer, not by us — the fastest route in is to extend it with <b>AI-native operations</b> rather than to introduce a new thesis.",
  "sources":[{"label":"CN Q2 2026 results","url":"https://www.cn.ca/en/investors/financial-results/"},{"label":"CN investor relations","url":"https://www.cn.ca/en/investors/"}]},
 {"no":"B","title":"The buying centre","headline":"Bhushan Ivaturi, EVP and Chief Information and Technology Officer since April 2025 — an incoming CIO with a transformation track record.",
  "body_html":"<p>CN's senior-most technology executive is <b>Bhushan Ivaturi</b>, Executive Vice-President and Chief Information and Technology Officer, appointed <b>April 2025</b>. Per CN's own materials he was previously Senior Vice President and Chief Information Officer at Enbridge, where he led its digital transformation. He holds a Master of Science in Information Systems and Operations Management and a bachelor's degree in mechanical engineering, with executive education at Harvard Business School, MIT Sloan and the Stanford Executive Program. President and CEO: Tracy Robinson.</p>",
  "sowhat":"An executive roughly eighteen months into a CIO role is still shaping his platform strategy and vendor roster, and is measured on visible transformation. This window narrows through 2027.",
  "sources":[{"label":"CN leadership","url":"https://www.cn.ca/en/about-cn/leadership/"}]}
]$$::jsonb,'2026-07-24',true,'current'
from public.accounts a where slug='cn';

-- ============================================================
--  FEDEX FREIGHT · PURSUE
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'Operating margin fell from 16.7% to 7.0% in the year it was spun out, and the CEO has publicly called untangling its parcel-centric technology "a massive effort." A transition services agreement expires around June 2028. The clearest carve-out mandate on the roster.',
$$[
 {"n":"01","text":"<b>Margin collapsed through separation.</b> FY2026 operating income fell <b>58.6% to $616 million</b> on revenue of $8.8 billion (−1.1%) — an operating margin of <b>7.0%</b> against 16.7% the prior year. Adjusted operating income $1.1 billion (−25.6%), adjusted margin 12.6%."},
 {"n":"02","text":"<b>The technology separation is stated in the CEO's own words.</b> John Smith has described how FedEx meshed back-office technology across units in 2009, that the majority of it was parcel-centric, and that unbundling it is, in his phrase, a massive effort."},
 {"n":"03","text":"<b>The clock is contractual.</b> A Transition Services Agreement with FedEx runs up to two years from the spin-off — to approximately <b>June 2028</b> — covering order creation and network technology operations. Systems independence must be achieved before it lapses."},
 {"n":"04","text":"<b>Pricing must now stand alone.</b> Separation decouples parcel and LTL contracts, so LTL must be priced on its own merits without parcel volume subsidising the relationship — making yield management and customer profitability analytics first-order capabilities."}
]$$::jsonb,
$$[
 {"no":"A","title":"The cost of independence","headline":"Operating margin fell from 16.7% to 7.0% and operating income dropped 58.6% in the separation year.",
  "chart":{"kind":"grouped","y_label":"%","labels":["Operating margin","Adjusted operating margin"],
    "series":[{"name":"FY2025","tone":"dim","values":[16.7,16.7]},{"name":"FY2026","tone":"stop","values":[7.0,12.6]}]},
  "body_html":"<p>For FY2026 (year ended 31 May 2026): revenue <b>$8.8 billion</b> (−1.1%), operating income <b>$616 million</b> (−58.6%), adjusted operating income $1.1 billion (−25.6%). Q4 FY2026: revenue $2.4 billion (+4.8%), operating income $158 million (−66.9%), adjusted $363 million, average daily shipments 86,700 (−5.9%) with revenue per shipment $415.22 (+11.5%). Pre-spin the company took on <b>$4.3 billion of debt</b> ($3.7B senior notes plus a $0.6B term loan) with a $1.2 billion revolver. Shares outstanding 149,518,133 as at 3 August 2026.</p><p class='note'>Basis note: these are FedEx Freight <b>segment</b> results as reported within FedEx Corporation and are explicitly not presented on a carve-out basis, the 10-K's audited carve-out financials differ, and standalone full-year net income was not disclosed.</p>",
  "sowhat":"Revenue per shipment rose 11.5% while shipments fell 5.9% — they are already trading volume for yield. Doing that well without parcel cross-subsidy requires pricing science they have never had to own before.",
  "sources":[{"label":"FedEx Freight FY2026 Form 10-K (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0002082247/000162828026053359/fdxf-20260531.htm"},{"label":"FedEx Freight investor relations","url":"https://investors.fedex.com/fedex-freight-spin-off/default.aspx"}]},
 {"no":"B","title":"The separation clock","headline":"Independent since 1 June 2026, with a transition services agreement expiring around June 2028 and a seven-month transition period closing 31 December 2026.",
  "body_html":"<p>FedEx completed the spin-off on <b>1 June 2026</b>, distributing <b>80.1%</b> of FedEx Freight stock pro rata — one share for every two FedEx shares — and retaining <b>19.9%</b>, which per the 10-K it must generally dispose of within 24 months. The company changed its fiscal year-end from 31 May to 31 December, so its first standalone reporting period is a <b>seven-month transition period from 1 June to 31 December 2026</b>. Guidance for that period: revenue growth of 4–6% against $5.1 billion, operating income $475–515 million, diluted EPS $1.75–1.95. President and CEO <b>John A. Smith</b>, CFO <b>Marshall Witt</b>, Chairman R. Brad Martin. Approximately 40,000 employees and 355+ terminals.</p>",
  "sowhat":"Three dated pressure points converge: first standalone results in early 2027, FedEx's 19.9% disposal within 24 months, and TSA expiry around June 2028. Everything about the technology estate has to be resolved inside that window.",
  "sources":[{"label":"FedEx Freight FY2026 Form 10-K (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0002082247/000162828026053359/fdxf-20260531.htm"},{"label":"FedEx completes spin-off of FedEx Freight","url":"https://newsroom.fedex.com/newsroom/global-english/fedex-completes-spin-off-of-fedex-freight"},{"label":"FedEx Freight leadership announcement","url":"https://newsroom.fedex.com/newsroom/global-english/fedex-announces-leadership-for-independent-fedex-freight-company-upon-separation"}]}
]$$::jsonb,'2026-05-31',true,'current'
from public.accounts a where slug='fedex-frt';

-- ============================================================
--  UPS · PURSUE
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'Efficiency Reimagined has banked $1.2B of a $3B full-year target, the Amazon glide-down is complete, and the CEO has named RFID and AI as the next lever. A funded programme with a public number attached to it.',
$$[
 {"n":"01","text":"<b>The structural reset is complete.</b> The Amazon glide-down eliminated roughly <b>2 million pieces per day</b> of lower-quality volume and removed about <b>$4.5 billion</b> of related expense, 45 buildings closed in H1 and around 80% of Driver Choice participants departed in Q2."},
 {"n":"02","text":"<b>Efficiency Reimagined is funded, named and measured</b> — approximately <b>$1.2 billion</b> of programme benefits in H1 2026 against a full-year target of roughly <b>$3 billion</b>. The remaining $1.8 billion is someone's scorecard right now."},
 {"n":"03","text":"<b>Guidance was raised.</b> FY2026 revenue approximately $91.2 billion, operating profit approximately $8.65 billion, adjusted EPS approximately $7.22, with H2 domestic operating margin projected around 8.8%."},
 {"n":"04","text":"<b>The CEO named the technology.</b> Investment in RFID and artificial intelligence for package visibility, described as the most significant advancement in a decade."}
]$$::jsonb,
$$[
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
]$$::jsonb,'2026-07-28',true,'current'
from public.accounts a where slug='ups';

-- ============================================================
--  J.B. HUNT · PURSUE
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'First double-digit intermodal growth quarter in over a decade and a record 578,072 loads — with the operating ratio flat at 88.9%. Record volume is not becoming margin, and the bid season opens in October.',
$$[
 {"n":"01","text":"<b>A genuine inflection.</b> Intermodal loads reached a record <b>578,072</b>, up 10% — per Intermodal president Darren Field on the 22 July call, the first double-digit volume growth quarter in over a decade."},
 {"n":"02","text":"<b>Volume did not become margin.</b> Intermodal operating income rose 58% to $150.9 million, yet the intermodal operating ratio stayed roughly <b>flat at 88.9%</b>. Under twelve cents of every intermodal dollar survives as operating profit."},
 {"n":"03","text":"<b>Mix is masking yield.</b> Eastern loads +16% against transcontinental +5%, shorter eastern hauls cut length of haul, and excluding fuel, yields rose only marginally. Managing profitability through a mix shift is a pricing-science problem."},
 {"n":"04","text":"<b>The bid season opens in October</b> — annual intermodal contracts are priced then, which makes decision-support a this-quarter conversation."}
]$$::jsonb,
$$[
 {"no":"A","title":"Growth without margin","headline":"Every growth metric double-digit, the intermodal operating ratio did not move.",
  "chart":{"kind":"bar","y_label":"% change YoY","labels":["Diluted EPS","Net earnings","Operating income","Intermodal revenue","Revenue","Intermodal loads","Intermodal OR"],
    "series":[{"name":"Q2 2026 vs Q2 2025","tone":"struct","values":[45,40.7,32,22,19.4,10,0]}]},
  "body_html":"<p>Revenue <b>$3.50 billion</b> (+19.4%), operating income $259.5 million (+32%), net earnings $181.0 million (+40.7%), diluted EPS $1.91 (+45%). Intermodal revenue $1.75 billion (+22%) with segment operating income $150.9 million (+58%) on record loads of 578,072 (+10%). Brokerage (ICS) revenue $388 million (+49%) swung to a $1.7 million operating profit from a $3.6 million loss. Truckload posted a $1.3 million operating loss. Total debt approximately $1.15 billion, H1 operating cash flow $723.3 million, net capital expenditure fell to $144.9 million from $399.1 million.</p>",
  "sowhat":"At an 88.9% operating ratio, marginal decisions decide the year — which loads to accept, where to reposition boxes, how to price. Precisely where applied AI pays for itself, and the capital freed by an 64% capex reduction is available to fund it.",
  "sources":[{"label":"J.B. Hunt Q2 2026 results","url":"https://www.ajot.com/news/jb-hunt-reports-second-quarter-2026-results"},{"label":"Transport Topics — J.B. Hunt Q2 2026","url":"https://www.ttnews.com/articles/jb-hunt-earnings-q2-2026"},{"label":"FreightWaves — intermodal shift analysis","url":"https://www.freightwaves.com/news/massive-opportunities-for-j-b-hunt-in-intermodal-shift"}]}
]$$::jsonb,'2026-07-15',true,'current'
from public.accounts a where slug='jbht';

-- ============================================================
--  GXO · PURSUE
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'New business signings up 34% against revenue growth of 4.3% — the gap between sold and live is implementation capacity, and it widens every quarter. A $2.7B pipeline and a 90%-complete Wincanton integration on top.',
$$[
 {"n":"01","text":"<b>Signings are outrunning delivery.</b> Approximately <b>$410 million</b> of new business signed in the quarter, up 34% — the strongest in three years — against revenue growth of just 4.3%."},
 {"n":"02","text":"<b>The committed book is large and dated.</b> Contracts won through Q2 are expected to generate roughly <b>$1 billion of incremental 2026 revenue</b> (+29%) plus a further <b>$353 million for 2027</b>. Record sales pipeline of approximately $2.7 billion as at 29 July 2026."},
 {"n":"03","text":"<b>Margin is under pressure while this happens.</b> Operating income fell to $77 million from $89 million even as adjusted EBITDA rose to $219 million — the cost of standing up new sites lands before the revenue does."},
 {"n":"04","text":"<b>Two technology programmes are live:</b> GXO IQ has moved from launch to scaled deployment, and the Wincanton integration is around 90% complete, on track for $60 million of run-rate synergies by year end."}
]$$::jsonb,
$$[
 {"no":"A","title":"The implementation gap","headline":"Signings grew 34% while revenue grew 4.3% — the difference is work sold but not yet stood up.",
  "chart":{"kind":"bar","y_label":"$ millions","labels":["New business signed (Q2)","Incremental 2026 revenue","2027 revenue secured","Sales pipeline"],
    "series":[{"name":"GXO disclosed","tone":"go","values":[410,1000,353,2700]}]},
  "body_html":"<p>Revenue <b>$3.441 billion</b> (+4.3%, organic 3.4%), operating income $77 million (from $89 million), net income attributable to GXO $25 million, adjusted EBITDA $219 million (from $212 million), adjusted diluted EPS $0.59 (from $0.57). Around 40% of new wins were in the strategic verticals — aerospace and defence, technology, industrial and life sciences. Net leverage improved to 2.6x from 3.0x. Management noted humanoid-robot deployments are not yet at ROI, roughly two years from production use.</p>",
  "sowhat":"In contract logistics every win is an implementation: WMS configuration, client system integration, automation commissioning, data flows. A 34% signing rate against 4.3% revenue growth is the most direct services opportunity on the roster, and it compounds.",
  "sources":[{"label":"GXO Q2 2026 results","url":"https://investors.gxo.com/news-releases/news-release-details/gxo-reports-second-quarter-2026-results"},{"label":"GXO Q2 2026 release (PDF)","url":"https://investors.gxo.com/static-files/1183723b-dd51-4f53-b876-8d87510632ad"}]}
]$$::jsonb,'2026-08-04',true,'current'
from public.accounts a where slug='gxo';

-- ============================================================
--  TTX · PURSUE
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'Owned by all seven Class I railroads, operating ~177,000 pooled cars and the majority of North American intermodal well cars. The UP-NS merger forces a divestment below 49% and puts TTX under regulatory scrutiny — a governance moment with an integration agenda attached.',
$$[
 {"n":"01","text":"<b>One account, every railroad relationship.</b> TTX ownership per the STB record: <b>Union Pacific 37.03%, Norfolk Southern 19.78%, CSX 19.78%, BNSF 17.4%, CN 3.2%, CPKC 2.2%, Ferromex 0.6%.</b> Five of those seven are on this roster."},
 {"n":"02","text":"<b>It owns the intermodal asset base.</b> Approximately <b>177,000 pooled railcars</b>, including over half of the well cars used for intermodal traffic in North America — the physical substrate of the intermodal horizontal."},
 {"n":"03","text":"<b>The merger creates a forced change.</b> UP and NS combined would exceed 50% of TTX, so they have committed to divest down to <b>49% or below</b>. Ownership restructuring under STB scrutiny is a governance and data-transparency moment."},
 {"n":"04","text":"<b>The financial relationship is material to owners.</b> Union Pacific's TTX investment carrying value was approximately <b>$1.8 billion</b> at end-2023, with car-hire expense of roughly <b>$399 million</b> in 2023 — from one owner alone."}
]$$::jsonb,
$$[
 {"no":"A","title":"Ownership structure","headline":"Seven railroad owners, five of them on this roster — and a merger that forces the two largest to sell down.",
  "chart":{"kind":"bar","y_label":"% ownership","labels":["Union Pacific","Norfolk Southern","CSX","BNSF","CN","CPKC","Ferromex"],
    "series":[{"name":"TTX ownership","tone":"struct","values":[37.03,19.78,19.78,17.4,3.2,2.2,0.6]}]},
  "body_html":"<p>TTX is privately owned by North America's Class I railroads and operates as the industry's railcar cooperative under pooling authority granted by the Surface Transportation Board. Ownership percentages above are drawn from the STB decision published in the Federal Register. In share terms: UP 5,850 shares, NS and CSX 3,125 each, BNSF 2,750, CN 500. Because UP and NS combined would exceed 50%, the merger applicants have committed to divest shares to reach 49% or below and avoid a separate control application.</p><p>Founded in 1955 as Trailer Train by the Pennsylvania Railroad, renamed and restructured under an ICC-approved pooling agreement in 1974.</p>",
  "sowhat":"Credibility earned at TTX travels to every railroad on the roster simultaneously. And because TTX exists to serve its owners at cost rather than extract margin, an efficiency argument aligns with its charter instead of fighting it.",
  "sources":[{"label":"STB decision — Federal Register, 29 May 2026","url":"https://www.federalregister.gov/documents/2026/05/29/2026-10751/union-pacific-corporation-and-union-pacific-railroad-company-control-norfolk-southern-corporation"},{"label":"BNSF Form 10-Q Q2 2026 — related party transactions (SEC)","url":"https://www.sec.gov/Archives/edgar/data/0000934612/000093461226000013/bni-20260630.htm"},{"label":"TTX — Who We Are","url":"https://www.ttx.com/about/who-we-are/"}]},
 {"no":"B","title":"The technology signal","headline":"Joining the RailPulse telematics venture in October 2025 instruments a 177,000-car fleet — and raises the question of what to do with the data.",
  "body_html":"<p>TTX joined the <b>RailPulse</b> telematics joint venture in October 2025, adding the scale and fleet-management capability of the largest shared railcar provider. Executive Vice President <b>Marty Thomas</b> framed the move as a commitment to innovation and the long-term strength of the freight rail industry. TTX separately invests in industry technology intended to improve the quality and timeliness of financial and operating information for itself and for the owner railroads it reports to. Because most owners are public companies, TTX's financial reporting must meet Sarbanes-Oxley requirements.</p>",
  "sowhat":"Telematics answers where a car is and how it is behaving. It does not answer what should happen next — repositioning, maintenance sequencing, pool allocation across seven owners. That second question is the offer.",
  "sources":[{"label":"Trains — TTX joins RailPulse","url":"https://www.trains.com/pro/mechanical/freight-cars/ttx-joins-railpulse-telematics-joint-venture/"},{"label":"TTX — Who We Are","url":"https://www.ttx.com/about/who-we-are/"}]}
]$$::jsonb,'2026-05-29',true,'current'
from public.accounts a where slug='ttx';

-- ============================================================
--  BISON TRANSPORT · PURSUE
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'A C$788M carrier mid-way through a cloud TMS replacement, with a cross-border intermodal agreement with CPKC — another customer. Two roster accounts, one lane, and a new platform to integrate around.',
$$[
 {"n":"01","text":"<b>Scale is established.</b> Revenue of <b>C$788.4 million</b> per the Transport Topics for-hire ranking (data through 31 December 2025), operating 2,000+ tractors and around 10,000 trailers and containers with roughly 4,000 employees and contractors."},
 {"n":"02","text":"<b>A TMS replacement is under way.</b> Bison partnered with <b>Mastery Logistics Systems</b> to implement the cloud-based MasterMind TMS, announced April 2025, and added barcode technology for real-time freight updates in March 2025."},
 {"n":"03","text":"<b>The CPKC intermodal agreement links two customers.</b> Bison signed with Canadian Pacific Kansas City for continuous cross-border intermodal service across Canada, the US and Mexico — the intermodal horizontal made literal."},
 {"n":"04","text":"<b>Leadership changed in 2024.</b> Mike Ludwick became President and CEO effective 1 June 2024, succeeding Rob Penner who retired 31 May 2024. Chairman Don Streuber, COO Steve Zokvic, CFO Hans Andersen."}
]$$::jsonb,
$$[
 {"no":"A","title":"Scale and the TMS programme","headline":"C$788 million of revenue and a cloud TMS implementation in flight — integration work with a defined anchor.",
  "chart":{"kind":"bar","y_label":"C$ millions","labels":["FY2025 revenue"],
    "series":[{"name":"Bison Transport","tone":"struct","values":[788.4]}]},
  "body_html":"<p>Bison is a privately held, asset-based carrier founded in 1969, headquartered in Winnipeg, acquired by <b>James Richardson and Sons</b> in January 2021. It operates terminals, warehouses and yards across Canada, the United States and Mexico, and owns H.O. Wolding, trading as Bison Transport USA. Revenue of <b>C$788,404 thousand</b> is reported in the Transport Topics for-hire carrier ranking using data through 31 December 2025.</p><p>The company markets specifically to technology and semiconductor shippers, citing GPS tracking, geofencing, carrier vetting, controlled yard processes and real-time visibility for high-value time-sensitive freight, plus dedicated fleet solutions for just-in-time semiconductor supply and data-centre deployment projects.</p>",
  "sowhat":"A new cloud TMS is the single best time to engage: integration, data migration, analytics and AI layers are all specified in the first eighteen months after go-live. Patient family-conglomerate ownership supports multi-year platform investment.",
  "sources":[{"label":"Transport Topics for-hire ranking — Bison","url":"https://www.ttnews.com/for-hire/companies/bison/2026"},{"label":"Bison Transport company profile","url":"https://tracxn.com/d/companies/bisontransport/__ajHhMtwDm_gsWfw_rCp9IgaM7V8K190g_VfpuovioJs"},{"label":"Bison Transport — technology shippers","url":"https://www.bisontransport.com/shippers/technology"}]},
 {"no":"B","title":"The CPKC lane","headline":"A cross-border intermodal agreement with CPKC connects two Mphasis accounts through one lane.",
  "body_html":"<p>Bison announced an agreement with <b>Canadian Pacific Kansas City</b> (February 2024) to provide continuous cross-border intermodal service through Canada, the United States and Mexico. CPKC is also a Mphasis customer, making this the only place on the roster where two accounts share an operating lane.</p>",
  "sowhat":"Cross-border intermodal is a data problem before it is a rail or truck problem — customs, three regulatory regimes, equipment interchange, handoff visibility. Bison and CPKC each own one half of that lane and <b>neither owns the data that joins it</b>. One capability, two relationships.",
  "sources":[{"label":"Bison Transport news","url":"https://www.bisontransport.com/category/news"},{"label":"Bison Transport company profile","url":"https://tracxn.com/d/companies/bisontransport/__ajHhMtwDm_gsWfw_rCp9IgaM7V8K190g_VfpuovioJs"}]}
]$$::jsonb,'2026-08-14',true,'current'
from public.accounts a where slug='bison';

-- ============================================================
--  CPKC · QUALIFY
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'Revenue up 13% with the operating ratio 90 basis points worse on both measures, and reported EPS down 14%. A three-nation network is a data-integration problem — but no technology owner has been identified.',
$$[
 {"n":"01","text":"<b>Growth is not converting to efficiency.</b> Q2 2026 revenue <b>$4.2 billion</b> (+13%) against a reported operating ratio of <b>64.6%</b> (worse by 90bps) and a core adjusted OR of <b>61.6%</b> (also worse by 90bps)."},
 {"n":"02","text":"<b>The GAAP-to-adjusted gap is where integration cost still lives.</b> Reported diluted EPS <b>fell 14% to $1.15</b> while core adjusted diluted EPS rose 13% to $1.27, three years after the CP-KCS merger closed."},
 {"n":"03","text":"<b>The three-nation network is the differentiator and the complexity.</b> Canada-US-Mexico single-line service means customs, currency and three regulatory regimes across one operating plan."},
 {"n":"04","text":"<b>The open question is ownership.</b> No senior technology executive has been identified for CPKC in this pass. Until there is a named buyer, this stays QUALIFY rather than PURSUE."}
]$$::jsonb,
$$[
 {"no":"A","title":"Q2 2026 performance","headline":"Record revenue and a worsening operating ratio on both reported and core adjusted measures.",
  "chart":{"kind":"grouped","y_label":"OR %","y_min":55,"labels":["Reported OR","Core adjusted OR"],
    "series":[{"name":"Q2 2025","tone":"dim","values":[63.7,60.7]},{"name":"Q2 2026","tone":"stop","values":[64.6,61.6]}]},
  "body_html":"<p>Revenue <b>$4.16 billion</b> (+13% from $3.7 billion) with revenue ton-miles up 4%. Net income $1,024 million, from $1,234 million. Reported diluted EPS <b>$1.15</b> (−14%), core adjusted diluted EPS $1.27 (+13%). Fuel expense rose to $618 million from $405 million. The dividend was raised to $0.268 per share from $0.228. Management reaffirmed double-digit earnings growth for 2026 and reported record operating metrics in train speed, dwell and locomotive productivity. President and CEO: Keith Creel.</p>",
  "sowhat":"A railroad running Precision Scheduled Railroading whose operating ratio degrades during a volume upcycle has a cost-structure question it has not answered. That is the wedge — the same one that works at CN, framed as decision automation rather than headcount.",
  "sources":[{"label":"CPKC Q2 2026 earnings release (SEC Exhibit 99.1)","url":"https://www.sec.gov/Archives/edgar/data/16875/000001687526000024/exhibit991-q22026earningsr.htm"},{"label":"CPKC investor relations","url":"https://investor.cpkcr.com/news/press-release-details/2026/CPKC-reports-strong-Q2-results-poised-for-accelerated-growth-in-second-half-of-2026/default.aspx"}]}
]$$::jsonb,'2026-07-29',true,'current'
from public.accounts a where slug='cpkc';

-- ============================================================
--  CSX · QUALIFY
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'Record revenue, operating margin up 240 basis points and intermodal volume up 9% — a railroad executing well, which makes the efficiency pitch harder. Strong intermodal alignment, no named technology owner yet.',
$$[
 {"n":"01","text":"<b>This is a strong quarter, not a distressed one.</b> Record revenue of <b>$3.94 billion</b> (+10%), operating income $1.51 billion (+17%), operating margin <b>38.3%</b> (+240bps), diluted EPS $0.54 (+23%)."},
 {"n":"02","text":"<b>Intermodal is the growth engine</b> — volume up 9% within total volume growth of 6% to 1.68 million units. Direct alignment with the Intermodal-as-Horizontal pillar."},
 {"n":"03","text":"<b>Cash generation transformed.</b> H1 free cash flow before dividends of <b>$1.62 billion</b> against $444 million in the prior year, with FY2026 guidance of over 80% free cash flow growth and capex held below $2.4 billion."},
 {"n":"04","text":"<b>Safety improved sharply</b> — FRA injury rate down 19% and train accident rate down 30% year over year, closing the safety-remediation wedge."}
]$$::jsonb,
$$[
 {"no":"A","title":"Q2 2026 performance","headline":"Record revenue with 240 basis points of margin expansion — CSX is executing, so the entry point is growth, not repair.",
  "chart":{"kind":"bar","y_label":"% change YoY","labels":["Diluted EPS","Net earnings","Operating income","Revenue","Intermodal volume","Total volume"],
    "series":[{"name":"Q2 2026","tone":"go","values":[23,21,17,10,9,6]}]},
  "body_html":"<p>Revenue <b>$3.94 billion</b> (record, +10%), operating income $1.51 billion (+17%), operating margin 38.3% (+240bps), net earnings $1.00 billion (+21%), diluted EPS $0.54 (+23%). Volume 1.68 million units (+6%) with intermodal volume up 9%. First-half free cash flow before dividends $1.62 billion against $444 million. FY2026 guidance: mid-to-high single-digit revenue growth, over 350 basis points of operating-margin expansion, over 80% free cash flow growth, capex below $2.4 billion. CEO: Steve Angel.</p><p class='note'>CSX is also a 19.78% owner of TTX and a stakeholder in the UP-NS merger proceedings — see the TTX and Union Pacific baselines.</p>",
  "sowhat":"With margin expanding and cash generation transformed, CSX has money and no crisis. The credible approach is intermodal growth capacity and pricing science — helping them capture more of a segment already growing 9% — rather than cost repair.",
  "sources":[{"label":"CSX Q2 2026 results coverage","url":"https://ca.finance.yahoo.com/news/csx-q2-earnings-revenues-beat-172900827.html"}]}
]$$::jsonb,'2026-07-22',true,'current'
from public.accounts a where slug='csx';

-- ============================================================
--  C.H. ROBINSON · QUALIFY
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'The best AI operating story in the portfolio — 60%+ productivity gains since 2022 and headcount down 28.7% under the current CEO. They are proof the thesis works, which makes them a hard sell and a superb reference for their peers.',
$$[
 {"n":"01","text":"<b>Lean AI is delivering measurably.</b> Per CEO Dave Bozeman, evergreen productivity improvements of <b>over 60% since the end of 2022</b> in both NAST and Global Forwarding, with 15%+ year-over-year in Q2, while average headcount fell <b>10.8% year over year</b> and roughly 28.7% since he took over in mid-2023."},
 {"n":"02","text":"<b>Margins hit target.</b> NAST adjusted operating margin 40.9% and Global Forwarding 33.4% — both at mid-cycle targets. Adjusted operating margin 34.7% overall, up 360bps."},
 {"n":"03","text":"<b>The revenue beat was low quality, which is why the market disliked it.</b> Transportation adjusted gross profit margin <i>fell</i> 210bps to 15.4% as truckload linehaul costs rose about 29% and passed through into revenue, cash from operations collapsed to <b>$35.9 million from $227.1 million</b> on a $227.3 million adverse working-capital swing."},
 {"n":"04","text":"<b>This resolves the prior open question.</b> Revenue grew 19.3% and the shares fell because gross margin thinned and cash generation deteriorated — the top line was pass-through, not profit."}
]$$::jsonb,
$$[
 {"no":"A","title":"Quality of the beat","headline":"Revenue up 19.3% and adjusted operating margin up 360bps — but gross margin thinned and operating cash fell 84%.",
  "chart":{"kind":"bar","y_label":"$ millions","labels":["Cash from operations Q2 2025","Cash from operations Q2 2026"],
    "series":[{"name":"Operating cash flow","tone":"stop","values":[227.1,35.9]}]},
  "body_html":"<p>Total revenue <b>$4.93 billion</b> (+19.3%), adjusted gross profit $738.0 million (+6.5%), income from operations $255.7 million (+18.4%), adjusted operating margin 34.7% (+360bps), diluted EPS $1.56 (+23.8%), adjusted $1.61 (+24.8%). Transportation adjusted gross profit margin fell 210 basis points to <b>15.4%</b> as truckload linehaul costs rose roughly 29% and were passed through into revenue with adjusted gross profit per shipment roughly flat. Guidance was reaffirmed, not raised: FY2026 adjusted operating income $964 million to $1.04 billion. President and CEO Dave Bozeman, CFO Damon Lee.</p>",
  "sowhat":"C.H. Robinson is the competitive proof point, not primarily a target. Their published numbers — 60% productivity, 28.7% headcount reduction, volumes still growing — are the strongest available evidence when pitching AI-native operations to <b>TQL, J.B. Hunt ICS and XPO brokerage</b>.",
  "sources":[{"label":"C.H. Robinson Q2 2026 results","url":"https://finance.yahoo.com/markets/stocks/articles/c-h-robinson-reports-2026-200500665.html"},{"label":"Air freight & logistics peer earnings review","url":"https://markets.financialcontent.com/stocks/article/stockstory-2026-8-3-earnings-to-watch-expeditors-expd-reports-q2-results-tomorrow"}]}
]$$::jsonb,'2026-07-29',true,'current'
from public.accounts a where slug='chrw';

-- ============================================================
--  EDMONTON AIRPORTS · QUALIFY
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'C$97M of 2026 debt service against C$18M of cash. Real ambition, genuinely constrained wallet — every proposal must be small-start, opex-shaped and revenue-linked.',
$$[
 {"n":"01","text":"<b>Revenue grew 9.5% to C$264.4 million</b> with operating earnings of C$115.0 million and net income of C$15.9 million — a substantial improvement from C$1.9 million the prior year."},
 {"n":"02","text":"<b>The balance sheet is the constraint.</b> Total long-term debt <b>C$973.9 million</b> against <b>C$97.1 million</b> of 2026 debt service (C$57.4M principal plus C$39.7M interest), with cash down 36% to <b>C$18.3 million</b>."},
 {"n":"03","text":"<b>Recovery is complete, the growth must now come from the estate.</b> Passengers reached <b>8.14 million</b> (+2.8%), essentially back to 2019 levels. Further growth has to come from cargo, land development and commercial revenue."},
 {"n":"04","text":"<b>The open question is whether discretionary technology spend survives 2026</b> given the debt schedule. That is what the qualifying conversation must test."}
]$$::jsonb,
$$[
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
]$$::jsonb,'2026-03-19',true,'current'
from public.accounts a where slug='yeg';

-- ============================================================
--  EXPEDITORS · QUALIFY  (upgraded from WATCH — leadership refresh)
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'Three of the top seats changed in two years — CEO in 2025, CFO in 2025, CIO in 2024 — at a company famous for building its own technology. Exceptional Q2 numbers and no debt. The open question is whether the build-not-buy culture moves with the people.',
$$[
 {"n":"01","text":"<b>An outstanding quarter.</b> Revenue <b>$3.50 billion</b> (+32%), operating income $349.6 million (+41%), net earnings $266.2 million (+45%), diluted EPS $2.03 (+51%) — driven by airfreight revenue up 57% and tonnage up 14%."},
 {"n":"02","text":"<b>The balance sheet is pristine</b> — $1.03 billion of cash and no long-term debt beyond leases, with $461 million returned to shareholders in the quarter and $748 million year to date."},
 {"n":"03","text":"<b>Leadership has turned over at the top.</b> Daniel R. Wall elected President and CEO in April 2025, David A. Hackett became CFO on 1 October 2025, Courtney Hawkins joined as SVP and Chief Information Officer in 2024, previously in technology leadership at Nordstrom, Starbucks and Nike."},
 {"n":"04","text":"<b>The verdict moved from WATCH to QUALIFY on that turnover.</b> Expeditors has historically built rather than bought technology, three new executives, one of them from outside the industry, is the only realistic circumstance in which that posture changes."}
]$$::jsonb,
$$[
 {"no":"A","title":"Q2 2026 performance","headline":"Revenue up 32% and EPS up 51%, with over a billion in cash and no long-term debt.",
  "chart":{"kind":"bar","y_label":"% change YoY","labels":["Diluted EPS","Net earnings","Operating income","Revenue","Airfreight tonnage"],
    "series":[{"name":"Q2 2026","tone":"go","values":[51,45,41,32,14]}]},
  "body_html":"<p>Quarter ended 30 June 2026: revenue <b>$3,502,335 thousand</b> (+32%), operating income $349.6 million (+41%), net earnings attributable to shareholders $266.2 million (+45%), diluted EPS $2.03 (+51%). Airfreight revenue rose 57% and customs and other services 27%, airfreight tonnage rose 14% while ocean volume was flat. Cash $1.03 billion with no long-term debt beyond leases, approximately 20,389 full-time equivalents. Investor Day is scheduled for <b>18 November 2026</b>.</p>",
  "sowhat":"A new CEO, a new CFO and a relatively new CIO from outside logistics, arriving into record results and a debt-free balance sheet, have both the mandate and the means to revisit build-versus-buy. The Investor Day on 18 November is where any change of technology posture would surface.",
  "sources":[{"label":"Expeditors Q2 2026 earnings and peer review","url":"https://markets.financialcontent.com/stocks/article/stockstory-2026-8-3-earnings-to-watch-expeditors-expd-reports-q2-results-tomorrow"}]}
]$$::jsonb,'2026-08-05',true,'current'
from public.accounts a where slug='expd';

-- ============================================================
--  MERCHANTS FLEET · QUALIFY  (competitor embedded)
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'Cognizant signed a strategic automation partnership here in December 2025. A competitor is already inside, under a CEO appointed in January 2025 and PE owners who expect a digital value-creation story. The question is displacement or coexistence.',
$$[
 {"n":"01","text":"<b>A direct competitor is embedded.</b> Cognizant announced a strategic partnership with Merchants Fleet on <b>3 December 2025</b>, described as leveraging automation to modernise fleet management. Any approach must start from that fact."},
 {"n":"02","text":"<b>The leadership question is resolved.</b> Matt Dyer was appointed Chief Executive Officer, announced <b>28 January 2025</b>, ending the interim co-CEO arrangement that followed Brendan Keegan's retirement in May 2024 after fifteen years."},
 {"n":"03","text":"<b>Scale and ownership are confirmed.</b> Over <b>$2 billion in assets under management</b> and <b>175,000 managed commercial fleet units</b> across North America, the fourth largest fleet management company on the continent. Owned since 2022 by <b>Bain Capital, a wholly owned subsidiary of the Abu Dhabi Investment Authority, and the management team</b>."},
 {"n":"04","text":"<b>There is an SEC-registered financing vehicle.</b> Merchants Fleet Funding LLC files Form ABS-15G annually, signed by CFO Kirk Hoffman — a securitisation programme that generates its own data and reporting obligations."}
]$$::jsonb,
$$[
 {"no":"A","title":"Scale, ownership and the competitive position","headline":"$2B of assets under management and 175,000 fleet units — with Cognizant already holding an automation partnership.",
  "chart":{"kind":"bar","y_label":"count / $","labels":["Managed fleet units","Assets under management ($M)"],
    "series":[{"name":"Merchants Fleet","tone":"struct","values":[175000,2000]}]},
  "body_html":"<p>Founded in 1962 as Merchants Motors in Manchester, New Hampshire, now headquartered in Hooksett. Over <b>$2 billion in assets under management</b> and <b>175,000 managed commercial fleet units</b> across North America, describing itself as the fourth largest and fastest growing fleet management company on the continent, with a business model focused on fleet technology, innovative fleet services and proactive electric-vehicle adoption.</p><p>Ownership was acquired in 2022 by <b>Bain Capital</b> together with a wholly owned subsidiary of the <b>Abu Dhabi Investment Authority</b> and the Merchants leadership team, the company continues to operate independently. CEO <b>Matt Dyer</b> (announced 28 January 2025), CFO <b>Kirk Hoffman</b>.</p><p>On <b>3 December 2025</b>, Cognizant announced a strategic partnership with Merchants Fleet to modernise fleet management through automation.</p>",
  "sowhat":"Private-equity ownership plus a new CEO plus EV transition planning is exactly the profile that buys AI and data services — but Cognizant got there first. The realistic play is <b>adjacent scope</b>: EV duty-cycle and charging-siting modelling, or the securitisation data estate, rather than a head-on displacement.",
  "sources":[{"label":"Merchants Fleet — ownership group","url":"https://www.merchantsfleet.com/about/ownershipgroup/"},{"label":"Merchants Fleet completes acquisition by Bain Capital and ADIA","url":"https://www.prnewswire.com/news-releases/merchants-fleet-announces-completion-of-acquisition-by-bain-capital-adia-and-the-merchants-leadership-team-301653229.html"},{"label":"Merchants Fleet news — Cognizant partnership and CEO appointment","url":"https://www.zoominfo.com/c/merchants-fleet-management/356854940"},{"label":"Merchants Fleet Funding LLC Form ABS-15G (SEC)","url":"https://www.sec.gov/Archives/edgar/data/1964471/000095014226000364/eh260733558_abs15g.htm"}]}
]$$::jsonb,'2026-08-14',true,'current'
from public.accounts a where slug='merchants';

-- ============================================================
--  TQL · QUALIFY
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'$6.82B of gross revenue on a 20.1% net margin, run by 9,000 people — the most people-intensive economics on the roster, in the one model AI reshapes fastest. C.H. Robinson has already proved what is possible.',
$$[
 {"n":"01","text":"<b>The economics are now visible.</b> Gross revenue of <b>$6.82 billion in 2024</b> at a net revenue margin of <b>20.1%</b>, giving net revenue of approximately <b>$1.37 billion</b> — the third-largest freight broker by revenue."},
 {"n":"02","text":"<b>It is carried by headcount.</b> Approximately <b>9,000 employees</b> across 56 offices and a network of over 130,000 carriers. Dedicated account teams and 24/7 service are the differentiator — and the cost structure most exposed to automation."},
 {"n":"03","text":"<b>Revenue is highly cyclical:</b> $4.1 billion (2020), $7.8 billion (2021), $8.8 billion (2022), $6.7 billion (2023), $6.82 billion (2024). A business that can swing 25% in a year cannot carry fixed people cost through a trough."},
 {"n":"04","text":"<b>The peer benchmark is brutal and public.</b> C.H. Robinson has cut headcount 28.7% since mid-2023 while growing volume, on 60%+ productivity gains. That is the number a TQL executive has to answer."}
]$$::jsonb,
$$[
 {"no":"A","title":"Revenue trajectory and margin","headline":"$6.82 billion gross and $1.37 billion net in 2024 — after a 24% peak-to-trough swing.",
  "chart":{"kind":"bar","y_label":"$ billions gross revenue","labels":["2020","2021","2022","2023","2024"],
    "series":[{"name":"Gross revenue","tone":"struct","values":[4.1,7.8,8.8,6.7,6.82]}]},
  "body_html":"<p>TQL is privately held and does not file financial statements. Per the Transport Topics 2025 freight-brokerage rankings, 2024 gross revenue was <b>$6.82 billion</b> with a net revenue margin of <b>20.1%</b>, equating to roughly <b>$1.37 billion</b> of net revenue, across approximately 9,000 employees, 56 offices and 130,000+ carriers. Founded 1997 by <b>Ken Oaks</b>, who remains CEO, President <b>Kerry Byrne</b>. Cincinnati's largest private company. Because it is private, profitability is not disclosed.</p><p>TQL's <b>TRAX</b> platform has undergone an AI-driven overhaul, with the company emphasising machine learning for capacity prediction and spot pricing, and asset-light capital expenditure of roughly 1.2% of revenue redirected toward technology and sales.</p>",
  "sowhat":"At 20.1% net margin across $6.82 billion of gross revenue, one point of productivity is worth real money — and they are already building AI internally. The opening is to accelerate what TRAX has started rather than to introduce the idea.",
  "sources":[{"label":"Transport Topics 2025 freight brokerage rankings (via industry analysis)","url":"https://keynnectlogistics.com/top-5-most-profitable-freight-brokerage-2025/"},{"label":"Forbes — TQL company overview","url":"https://www.forbes.com/companies/tql-total-quality-logistics/"},{"label":"Total Quality Logistics — company profile","url":"https://en.wikipedia.org/wiki/Total_Quality_Logistics"}]}
]$$::jsonb,'2026-01-02',true,'current'
from public.accounts a where slug='tql';

-- ============================================================
--  XPO · WATCH
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'WATCH',
'A record 79.9% operating ratio that the CEO attributes to AI, with in-house capability beating its own productivity targets. No problem to solve in North America. The only soft spot is Europe, where restructuring pushed the segment to a loss.',
$$[
 {"n":"01","text":"<b>They are winning, and they are winning with AI.</b> North American LTL adjusted operating ratio improved 300 basis points to a record <b>79.9%</b>, AI workforce-planning technology contributed roughly <b>2.5 productivity points against a 1.5-point target</b>."},
 {"n":"02","text":"<b>The financials are excellent.</b> Revenue $2.36 billion (+13.2%), adjusted diluted EPS <b>$1.70</b> (+61.9%), adjusted EBITDA $434 million (+25% excluding real estate), free cash flow $207 million, net leverage 2.1x."},
 {"n":"03","text":"<b>Pricing power is real</b> — XPO reports pricing two to three points above competitors on the strength of service and technology investment, and has raised full-year OR-improvement guidance to at least 200 basis points against a low-70s long-term target."},
 {"n":"04","text":"<b>Europe is the exception.</b> The European Transportation segment posted a <b>$6 million operating loss</b> against $11 million of income a year earlier, driven by restructuring, though adjusted EBITDA still rose to $48 million."}
]$$::jsonb,
$$[
 {"no":"A","title":"Performance","headline":"Record LTL operating ratio and adjusted EPS up 62% — with a European segment in restructuring.",
  "chart":{"kind":"grouped","y_label":"$ per share","labels":["Diluted EPS","Adjusted diluted EPS"],
    "series":[{"name":"Q2 2025","tone":"dim","values":[0.89,1.05]},{"name":"Q2 2026","tone":"go","values":[1.36,1.70]}]},
  "body_html":"<p>Revenue <b>$2,355 million</b> (+13.2%), GAAP diluted EPS $1.36 (from $0.89), adjusted diluted EPS <b>$1.70</b> (+61.9%), adjusted EBITDA $434 million. North American LTL revenue $1.43 billion (+15.2%) with adjusted operating ratio at a record <b>79.9%</b>, improved 300 basis points. European Transportation revenue $927 million (+10%) with a $6 million operating loss. Free cash flow $207 million, cash $298 million, net leverage 2.1x. Q3 LTL operating ratio expected below 81%. CEO: Mario Harik.</p>",
  "sowhat":"Approaching XPO with an efficiency pitch would be embarrassing — they are the ones setting the benchmark. If an opening exists it is <b>European restructuring and systems rationalisation</b>, not North American operations. Revisit at Q3.",
  "sources":[{"label":"XPO Q2 2026 results","url":"https://investors.xpo.com/news-releases/news-release-details/xpo-reports-second-quarter-2026-results"},{"label":"XPO Q2 2026 results (SEC Exhibit 99.1)","url":"https://www.sec.gov/Archives/edgar/data/0001166003/000110465926088438/tm2616097d5_ex99-1.htm"}]}
]$$::jsonb,'2026-07-30',true,'current'
from public.accounts a where slug='xpo';

-- ============================================================
--  DART CONTAINER · WATCH
-- ============================================================
insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'WATCH',
'A $3B manufacturer with flat revenue for five years and a 280-truck support fleet. Too small a logistics footprint to fund a programme — but they are recruiting a Transformation Program Management Director, and that is the trigger to watch.',
$$[
 {"n":"01","text":"<b>Revenue is flat and the business is mature.</b> Approximately <b>$3 billion</b> in 2025, having moved between $3.0 billion and $3.2 billion since 2021, with around 13,000 employees."},
 {"n":"02","text":"<b>The fleet is a support function, not a business.</b> FMCSA records for the primary authority show <b>280 power units and 248 drivers</b> running 14,039,000 miles in 2024 — meaningful for a manufacturer, too small to fund a standalone logistics transformation."},
 {"n":"03","text":"<b>Safety compliance is already strong</b> — a Satisfactory FMCSA rating with driver and vehicle out-of-service rates below the national average, closing the safety-remediation wedge."},
 {"n":"04","text":"<b>The trigger to watch is a hire.</b> Dart has been recruiting a <b>Transformation Program Management Director</b> and a Manufacturing Reliability Director at Mason, with operations roles at their highest level in twelve months and SAP referenced among the technologies."}
]$$::jsonb,
$$[
 {"no":"A","title":"Business and fleet scale","headline":"$3 billion of flat revenue and a 280-truck private fleet — a manufacturer, not a logistics buyer.",
  "chart":{"kind":"bar","y_label":"$ billions revenue","labels":["2021","2022","2023","2024","2025"],
    "series":[{"name":"Revenue","tone":"dim","values":[3.0,3.2,3.2,3.0,3.0]}]},
  "body_html":"<p>Dart Container is a privately held manufacturer of single-use foodservice packaging, founded 1960 by William A. Dart, headquartered at Mason, Michigan, where the campus houses corporate headquarters, two production plants, a distribution warehouse and RandD across nearly two million square feet employing about 1,400 people. Revenue of approximately <b>$3 billion in 2025</b> per Forbes America's Largest Private Companies (FactSet data), roughly flat since 2021. Around 13,000 employees overall. It acquired Solo Cup in 2012 and operates under the Dart, Solo, ProPlanet and Fusion brands.</p><p>The primary trucking authority, <b>Dart Container Corporation of California</b> (USDOT #217295), runs 280 power units and 248 drivers over 14,039,000 annual miles, holding a Satisfactory safety rating. No additional Dart Container carrier authorities were identified that would materially change fleet size.</p><p class='note'>Leadership shows a source conflict: Forbes lists CEO Keith Clark, older references list Robert C. Dart. Confirm before any named approach. Note also that <i>Dart Transit Company</i> of Eagan, Minnesota is an unrelated carrier and must not be attributed to Dart Container.</p>",
  "sowhat":"At this scale the freight is a supporting function of a manufacturing business, so any conversation starts from <b>plant-to-customer supply chain and SAP</b>, not from the trucks. Set the review for the next 90-day cycle and check whether the transformation director role has been filled.",
  "sources":[{"label":"FMCSA carrier record — Dart Container Corporation of California (DOT# 217295)","url":"https://loadwrap.com/company/217295-dart-container-corporation-of-california"},{"label":"Dart Container — Mason, MI campus","url":"https://corporate.dartcontainer.com/location/mason-mi/"},{"label":"Dart Container — company profile and hiring activity","url":"https://www.zoominfo.com/c/dart-container-corp/33263647"},{"label":"Dart Container — company reference","url":"https://en.wikipedia.org/wiki/Dart_Container"}]}
]$$::jsonb,'2026-08-10',true,'current'
from public.accounts a where slug='dart';
