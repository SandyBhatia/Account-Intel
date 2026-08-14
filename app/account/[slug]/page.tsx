import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import TopBar from "@/components/TopBar";
import RefreshButton from "@/components/RefreshButton";
import ExhibitChart, { type ChartSpec } from "@/components/ExhibitChart";

export const dynamic = "force-dynamic";

interface Exhibit {
  no: string; title: string; headline: string;
  body_html?: string;
  table?: { head: string[]; rows: (string | number)[][] };
  chart?: ChartSpec;
  sowhat?: string;
  sources?: { label: string; url?: string }[];
}

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
      <main className="wrap">
        <Link href="/" className="note" style={{ display: "inline-block", marginBottom: 14 }}>‹ Back to portfolio</Link>

        <div className="gloss" style={{ padding: "26px 28px", marginBottom: 16 }}>
          <div className="ex-no">Account intelligence · {account.sector} · {account.relationship}</div>
          <h1 className="page">{account.full_name || account.name}</h1>
          <p className="sub">
            {account.is_public ? "Public filer" : "Private — verified public sources only"}
            {account.next_report ? ` · next disclosure ${account.next_report}` : ""}
            {baseline ? ` · baseline v${baseline.version}, evidence dated ${baseline.as_of}` : ""}
          </p>

          <div style={{ display: "flex", alignItems: "center", gap: 15, margin: "20px 0 16px", flexWrap: "wrap" }}>
            <span className={`pill ${verdict}`} style={{ fontSize: ".95rem", padding: "7px 15px" }}>{verdict.replace("_", " ")}</span>
            <span style={{ fontSize: "var(--t-body)", flex: 1, minWidth: 220 }}>
              {baseline?.verdict_line ?? <span className="dim">No baseline built. This page will carry the full evidence pack once the research session is done and imported.</span>}
            </span>
            <RefreshButton slug={account.slug} />
          </div>

          {thesis.length > 0 && (
            <ol style={{ listStyle: "none", display: "flex", flexDirection: "column", gap: 11, maxWidth: "80ch" }}>
              {thesis.map((tItem) => (
                <li key={tItem.n} style={{ fontSize: "var(--t-body)", lineHeight: 1.58 }}>
                  <span className="mono st" style={{ fontSize: "var(--t-micro)", fontWeight: 700, marginRight: 9 }}>{tItem.n}</span>
                  <span dangerouslySetInnerHTML={{ __html: tItem.text }} />
                </li>
              ))}
            </ol>
          )}
        </div>

        {actions && actions.length > 0 && (
          <div className="gloss" style={{ marginBottom: 16 }}>
            <div className="ex-hd"><div className="ex-no">Engine · proposed actions</div>
              <h2>What the rules say to do next</h2></div>
            {actions.map((a) => (
              <div className="act" key={a.id} style={{ borderTop: "1px solid var(--rule)" }}>
                <span className={`pr ${a.priority === 1 ? "p1" : ""}`}>{a.priority}</span>
                <div>
                  <h3>{a.title}</h3>
                  {a.narrative && <p className="nar">{a.narrative}</p>}
                  <p className="ev">{a.rule_id}{a.due_by ? ` · due ${a.due_by}` : ""}</p>
                </div>
              </div>
            ))}
          </div>
        )}

        {exhibits.map((ex) => (
          <div className="ex gloss" key={ex.no}>
            <div className="ex-hd">
              <div className="ex-no">Exhibit {ex.no} · {ex.title}</div>
              <h2>{ex.headline}</h2>
            </div>
            <div className="ex-bd">
              {ex.body_html && <div dangerouslySetInnerHTML={{ __html: ex.body_html }} />}
              {ex.chart && <ExhibitChart spec={ex.chart} />}
              {ex.table && (
                <div className="tblwrap" style={{ marginTop: ex.body_html || ex.chart ? 16 : 0 }}>
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

        <div className="gloss" style={{ padding: "17px 21px" }}>
          <div className="ex-no" style={{ marginBottom: 6 }}>Signal feed · verified events since baseline</div>
          {(signals ?? []).length === 0 && <p className="note" style={{ padding: "10px 0" }}>No signals gathered yet. Use Refresh — every signal requires a working source URL or it is rejected at the API layer.</p>}
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
      </main>
    </>
  );
}
