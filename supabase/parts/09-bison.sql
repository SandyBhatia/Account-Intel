insert into public.baselines (account_id,version,verdict,verdict_line,thesis,exhibits,as_of,active,review_status)
select id, coalesce((select max(version) from public.baselines b where b.account_id=a.id),0)+1,'PURSUE',
'A C$788M carrier mid-way through a cloud TMS replacement, with a cross-border intermodal agreement with CPKC — another customer. Two roster accounts, one lane, and a new platform to integrate around.',
'[
 {"n":"01","text":"<b>Scale is established.</b> Revenue of <b>C$788.4 million</b> per the Transport Topics for-hire ranking (data through 31 December 2025), operating 2,000+ tractors and around 10,000 trailers and containers with roughly 4,000 employees and contractors."},
 {"n":"02","text":"<b>A TMS replacement is under way.</b> Bison partnered with <b>Mastery Logistics Systems</b> to implement the cloud-based MasterMind TMS, announced April 2025, and added barcode technology for real-time freight updates in March 2025."},
 {"n":"03","text":"<b>The CPKC intermodal agreement links two customers.</b> Bison signed with Canadian Pacific Kansas City for continuous cross-border intermodal service across Canada, the US and Mexico — the intermodal horizontal made literal."},
 {"n":"04","text":"<b>Leadership changed in 2024.</b> Mike Ludwick became President and CEO effective 1 June 2024, succeeding Rob Penner who retired 31 May 2024. Chairman Don Streuber, COO Steve Zokvic, CFO Hans Andersen."}
]'::jsonb,
'[
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
]'::jsonb,'2026-08-14',true,'current'
from public.accounts a where slug='bison';
