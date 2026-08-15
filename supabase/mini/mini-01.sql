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
