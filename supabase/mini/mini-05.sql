insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'Revenue up 13% with the operating ratio 90 basis points worse on both measures, and reported EPS down 14%. A three-nation network is a data-integration problem — but no technology owner has been identified.',
'[
 {"n":"01","text":"<b>Growth is not converting to efficiency.</b> Q2 2026 revenue <b>$4.2 billion</b> (+13%) against a reported operating ratio of <b>64.6%</b> (worse by 90bps) and a core adjusted OR of <b>61.6%</b> (also worse by 90bps)."},
 {"n":"02","text":"<b>The GAAP-to-adjusted gap is where integration cost still lives.</b> Reported diluted EPS <b>fell 14% to $1.15</b> while core adjusted diluted EPS rose 13% to $1.27, three years after the CP-KCS merger closed."},
 {"n":"03","text":"<b>The three-nation network is the differentiator and the complexity.</b> Canada-US-Mexico single-line service means customs, currency and three regulatory regimes across one operating plan."},
 {"n":"04","text":"<b>The open question is ownership.</b> No senior technology executive has been identified for CPKC in this pass. Until there is a named buyer, this stays QUALIFY rather than PURSUE."}
]'::jsonb,
'[
 {"no":"A","title":"Q2 2026 performance","headline":"Record revenue and a worsening operating ratio on both reported and core adjusted measures.",
  "chart":{"kind":"grouped","y_label":"OR %","y_min":55,"labels":["Reported OR","Core adjusted OR"],
    "series":[{"name":"Q2 2025","tone":"dim","values":[63.7,60.7]},{"name":"Q2 2026","tone":"stop","values":[64.6,61.6]}]},
  "body_html":"<p>Revenue <b>$4.16 billion</b> (+13% from $3.7 billion) with revenue ton-miles up 4%. Net income $1,024 million, from $1,234 million. Reported diluted EPS <b>$1.15</b> (−14%), core adjusted diluted EPS $1.27 (+13%). Fuel expense rose to $618 million from $405 million. The dividend was raised to $0.268 per share from $0.228. Management reaffirmed double-digit earnings growth for 2026 and reported record operating metrics in train speed, dwell and locomotive productivity. President and CEO: Keith Creel.</p>",
  "sowhat":"A railroad running Precision Scheduled Railroading whose operating ratio degrades during a volume upcycle has a cost-structure question it has not answered. That is the wedge — the same one that works at CN, framed as decision automation rather than headcount.",
  "sources":[{"label":"CPKC Q2 2026 earnings release (SEC Exhibit 99.1)","url":"https://www.sec.gov/Archives/edgar/data/16875/000001687526000024/exhibit991-q22026earningsr.htm"},{"label":"CPKC investor relations","url":"https://investor.cpkcr.com/news/press-release-details/2026/CPKC-reports-strong-Q2-results-poised-for-accelerated-growth-in-second-half-of-2026/default.aspx"}]}
]'::jsonb,'2026-07-29',true,'current'
from public.accounts a where slug='cpkc';

insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'QUALIFY',
'Record revenue, operating margin up 240 basis points and intermodal volume up 9% — a railroad executing well, which makes the efficiency pitch harder. Strong intermodal alignment, no named technology owner yet.',
'[
 {"n":"01","text":"<b>This is a strong quarter, not a distressed one.</b> Record revenue of <b>$3.94 billion</b> (+10%), operating income $1.51 billion (+17%), operating margin <b>38.3%</b> (+240bps), diluted EPS $0.54 (+23%)."},
 {"n":"02","text":"<b>Intermodal is the growth engine</b> — volume up 9% within total volume growth of 6% to 1.68 million units. Direct alignment with the Intermodal-as-Horizontal pillar."},
 {"n":"03","text":"<b>Cash generation transformed.</b> H1 free cash flow before dividends of <b>$1.62 billion</b> against $444 million in the prior year, with FY2026 guidance of over 80% free cash flow growth and capex held below $2.4 billion."},
 {"n":"04","text":"<b>Safety improved sharply</b> — FRA injury rate down 19% and train accident rate down 30% year over year, closing the safety-remediation wedge."}
]'::jsonb,
'[
 {"no":"A","title":"Q2 2026 performance","headline":"Record revenue with 240 basis points of margin expansion — CSX is executing, so the entry point is growth, not repair.",
  "chart":{"kind":"bar","y_label":"% change YoY","labels":["Diluted EPS","Net earnings","Operating income","Revenue","Intermodal volume","Total volume"],
    "series":[{"name":"Q2 2026","tone":"go","values":[23,21,17,10,9,6]}]},
  "body_html":"<p>Revenue <b>$3.94 billion</b> (record, +10%), operating income $1.51 billion (+17%), operating margin 38.3% (+240bps), net earnings $1.00 billion (+21%), diluted EPS $0.54 (+23%). Volume 1.68 million units (+6%) with intermodal volume up 9%. First-half free cash flow before dividends $1.62 billion against $444 million. FY2026 guidance: mid-to-high single-digit revenue growth, over 350 basis points of operating-margin expansion, over 80% free cash flow growth, capex below $2.4 billion. CEO: Steve Angel.</p><p class=''note''>CSX is also a 19.78% owner of TTX and a stakeholder in the UP-NS merger proceedings — see the TTX and Union Pacific baselines.</p>",
  "sowhat":"With margin expanding and cash generation transformed, CSX has money and no crisis. The credible approach is intermodal growth capacity and pricing science — helping them capture more of a segment already growing 9% — rather than cost repair.",
  "sources":[{"label":"CSX Q2 2026 results coverage","url":"https://ca.finance.yahoo.com/news/csx-q2-earnings-revenues-beat-172900827.html"}]}
]'::jsonb,'2026-07-22',true,'current'
from public.accounts a where slug='csx';
