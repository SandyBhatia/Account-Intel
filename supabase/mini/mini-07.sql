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
