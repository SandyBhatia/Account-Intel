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
