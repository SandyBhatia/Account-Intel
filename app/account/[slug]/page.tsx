import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import TopBar from "@/components/TopBar";
import RefreshButton from "@/components/RefreshButton";
import ExhibitChart, { type ChartSpec } from "@/components/ExhibitChart";
import FinancialsPanel, { type Financials } from "@/components/FinancialsPanel";

export const dynamic = "force-dynamic";

interface Exhibit {
  no: string; title: string; headline: string;
  body_html?: string;
  table?: { head: string[]; rows: (string | number)[][] };
  chart?: ChartSpec;
  sowhat?: string;
  sources?: { label: string; url?: string }[];
}

/** An exhibit needs the full width when it carries a chart or a wide table;
 *  narrative exhibits pair up two-across on large screens. */
const isWide = (ex: Exhibit) => Boolean(ex.chart) || (ex.table?.head.length ?? 0) > 5;

export default async function AccountPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const supabase = await createClient();
  const { data: account } = await supabase.from("accounts").select("*").eq("slug", slug).single();
  if (!account) return <main className="wrap"><p>Unknown account.</p></main>;

  const { data: baseline } = await supabase.from("baselines").select("*").eq("account_id", account.id).eq("active", true).maybeSingle();
  const { data: signals } = await supabase.from("signals").select("*").eq("account_id", account.id).order("published_on", { ascending: false }).limit(40);
  const { data: actions } = await supabase.from("actions").select("*").eq("account_id", account.id).eq("status", "proposed").order("priority");

  const verdict = baseline?.verdict ?? "NO_BASELINE";
  const exhibits: Exhibit[] = (baseline?.exhibits as Exhibit[]) ?? [];
  const thesis: { n: string; text: string }[] = (baseline?.thesis as { n: string; text: string }[]) ?? [];

  return (
    <>
      <TopBar active="portfolio" />
      <main className="wrap wide">
        <Link href="/" className="note" style={{ display: "inline-block", marginBottom: 14 }}>‹ Back to portfolio</Link>

        <div className="acct">
          {/* ---------------- sticky rail: who they are, our call, what to do ---------------- */}
          <aside className="rail">
            <div className="gloss" style={{ padding: "20px 21px" }}>
              <div className="ex-no">{account.sector} · {account.relationship}</div>
              <h1 style={{ fontSize: "1.55rem", fontWeight: 800, letterSpacing: "-.03em", color: "var(--key)", lineHeight: 1.15, margin: "4px 0 8px" }}>
                {account.full_name || account.name}
              </h1>
              <p className="note" style={{ marginBottom: 15 }}>
                {account.is_public ? "Public filer" : "Private — verified public sources only"}
                {account.next_report ? ` · next disclosure ${account.next_report}` : ""}
                {baseline ? ` · baseline v${baseline.version}, evidence ${baseline.as_of}` : ""}
              </p>

              <span className={`pill ${verdict}`} style={{ fontSize: ".85rem", padding: "6px 13px" }}>{verdict.replace("_", " ")}</span>
              <p style={{ fontSize: "var(--t-small)", lineHeight: 1.55, margin: "12px 0 0" }}>
                {baseline?.verdict_line ?? <span className="dim">No baseline built yet. This page fills in once the research session is imported.</span>}
              </p>

              {thesis.length > 0 && (
                <ol style={{ listStyle: "none", display: "flex", flexDirection: "column", gap: 10, marginTop: 17, paddingTop: 15, borderTop: "1px solid var(--rule)" }}>
                  {thesis.map((tItem) => (
                    <li key={tItem.n} style={{ fontSize: "var(--t-small)", lineHeight: 1.55 }}>
                      <span className="mono st" style={{ fontSize: ".65rem", fontWeight: 700, marginRight: 8 }}>{tItem.n}</span>
                      <span dangerouslySetInnerHTML={{ __html: tItem.text }} />
                    </li>
                  ))}
                </ol>
              )}

              <div style={{ marginTop: 17, paddingTop: 14, borderTop: "1px solid var(--rule)" }}>
                <RefreshButton slug={account.slug} />
              </div>
            </div>

            {actions && actions.length > 0 && (
              <div className="gloss" style={{ marginTop: 16 }}>
                <div style={{ padding: "14px 18px 4px" }}><div className="ex-no">Proposed actions</div></div>
                {actions.map((a) => (
                  <div className="act" key={a.id} style={{ paddingTop: 10, paddingBottom: 12 }}>
                    <span className={`pr ${a.priority === 1 ? "p1" : ""}`}>{a.priority}</span>
                    <div>
                      <h3 style={{ fontSize: "var(--t-small)" }}>{a.title}</h3>
                      {a.narrative && <p className="nar" style={{ fontSize: ".8rem" }}>{a.narrative}</p>}
                      <p className="ev">{a.rule_id}{a.due_by ? ` · due ${a.due_by}` : ""}</p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </aside>

          {/* ---------------- evidence ---------------- */}
          <div>
            {baseline?.financials ? (
              <div className="exgrid" style={{ marginBottom: 16 }}>
                <FinancialsPanel fin={baseline.financials as Financials} />
              </div>
            ) : baseline ? (
              <div className="gloss" style={{ padding: "15px 19px", marginBottom: 16 }}>
                <p className="note">Financial series not yet loaded for this account.</p>
              </div>
            ) : null}

            <div className="exgrid">
              {exhibits.map((ex) => (
                <div className={`ex gloss ${isWide(ex) ? "wide" : ""}`} key={ex.no}>
                  <div className="ex-hd">
                    <div className="ex-no">Exhibit {ex.no} · {ex.title}</div>
                    <h2>{ex.headline}</h2>
                  </div>
                  <div className="ex-bd">
                    {ex.body_html && <div dangerouslySetInnerHTML={{ __html: ex.body_html }} />}
                    {ex.chart && <ExhibitChart spec={ex.chart} />}
                    {/* A table is shown only when there is no chart carrying the same series. */}
                    {ex.table && !ex.chart && (
                      <div className="tblwrap" style={{ marginTop: ex.body_html ? 16 : 0 }}>
                        <table className={`tbl ${ex.table.head.length > 7 ? "dense" : ""}`}>
                          <thead><tr>{ex.table.head.map((h, i) => <th key={i}>{h}</th>)}</tr></thead>
                          <tbody>{ex.table.rows.map((r, i) => (
                            <tr key={i}>{r.map((c, j) => <td key={j} dangerouslySetInnerHTML={{ __html: String(c) }} />)}</tr>
                          ))}</tbody>
                        </table>
                      </div>
                    )}
                    {ex.sowhat && (
                      <div className="sowhat"><span className="l">So what</span>
                        <span dangerouslySetInnerHTML={{ __html: ex.sowhat }} />
                      </div>
                    )}
                  </div>
                  {ex.sources && ex.sources.length > 0 && (
                    <div className="src">
                      {ex.sources.map((s, i) => (
                        <span key={i}>{i > 0 && " · "}{s.url ? <a href={s.url} target="_blank" rel="noopener">{s.label} ↗</a> : s.label}</span>
                      ))}
                    </div>
                  )}
                </div>
              ))}
            </div>

            <div className="gloss" style={{ padding: "17px 21px", marginTop: 16 }}>
              <div className="ex-no" style={{ marginBottom: 6 }}>Signal feed · verified events since baseline</div>
              {(signals ?? []).length === 0 && <p className="note" style={{ padding: "10px 0" }}>No signals gathered yet. Use Refresh — a signal without a working source URL is rejected before it reaches the database.</p>}
              {(signals ?? []).map((s) => (
                <div className="sigrow" key={s.id}>
                  <span className="sigdate">{s.published_on ?? "undated"}</span>
                  <span>
                    <span className="sigcat">{s.category}</span>{s.contradicts_baseline && <span className="stop mono" style={{ fontSize: ".65rem", marginLeft: 8 }}>CONTRADICTS BASELINE</span>}
                    <br /><b className="k">{s.headline}</b>
                    {s.detail && <><br /><span style={{ fontSize: "var(--t-small)" }}>{s.detail}</span></>}
                  </span>
                  <a href={s.source_url} target="_blank" rel="noopener" className="mono" style={{ fontSize: "var(--t-micro)" }}>{s.source_name} ↗</a>
                </div>
              ))}
            </div>
          </div>
        </div>
      </main>
    </>
  );
}
