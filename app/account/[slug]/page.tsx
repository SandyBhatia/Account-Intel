import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import TopBar from "@/components/TopBar";
import RefreshButton from "@/components/RefreshButton";
import ExhibitChart, { type ChartSpec } from "@/components/ExhibitChart";
import FinancialsPanel, { type Financials } from "@/components/FinancialsPanel";
import { SignalCard, ForesightPanel, PortfolioLinkPanel, OpeningPanel } from "@/components/SignalColumn";
import {
  StakeholderPanel, AgendaPanel, PressurePanel, PlayPanel, DiscussionPanel, LosePanel,
} from "@/components/AnalysisColumn";
import type { Brief, Signal } from "@/lib/brief";

export const dynamic = "force-dynamic";

interface Exhibit {
  no: string; title: string; headline: string;
  body_html?: string;
  table?: { head: string[]; rows: (string | number)[][] };
  chart?: ChartSpec;
  sowhat?: string;
  sources?: { label: string; url?: string }[];
}

/**
 * Two columns.
 *   LEFT  — signals and foresight: what moved and what follows for our GTM.
 *   RIGHT — the analysis stack, identical order on every account:
 *           financials · stakeholders · agenda · pressure · play ·
 *           discussion points · how we lose.
 *
 * Curated signals ship inside the published baseline. Signals gathered by
 * the refresh lane live in the `signals` table and are merged in here,
 * tagged by origin so the reader always knows which is which.
 */
export default async function AccountPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const supabase = await createClient();
  const { data: account } = await supabase.from("accounts").select("*").eq("slug", slug).single();
  if (!account) return <main className="wrap"><p>Unknown account.</p></main>;

  const { data: baseline } = await supabase
    .from("baselines").select("*").eq("account_id", account.id).eq("active", true).maybeSingle();
  const { data: autoSignals } = await supabase
    .from("signals").select("*").eq("account_id", account.id).order("published_on", { ascending: false }).limit(40);
  const { data: actions } = await supabase
    .from("actions").select("*").eq("account_id", account.id).eq("status", "proposed").order("priority");

  const verdict = baseline?.verdict ?? "NO_BASELINE";
  const brief = (baseline?.brief as Brief | null) ?? null;

  // The brief supersedes the exhibits. Rendering both produced a page that
  // contradicted itself — the legacy buying-centre exhibit and the new
  // stakeholder panel described the same executive with different tenures.
  // Exhibits remain in the stored baseline for history; they render only
  // for accounts not yet migrated to the brief structure.
  const exhibits: Exhibit[] = brief ? [] : ((baseline?.exhibits as Exhibit[]) ?? []);

  // Refresh-lane signals become Signal shape. They carry no GTM impact or play
  // until someone reviews them — shown plainly as unreviewed rather than dressed up.
  const gathered: Signal[] = (autoSignals ?? []).map((s) => ({
    date: s.published_on ?? undefined,
    category: s.category ?? "other",
    origin: "auto" as const,
    headline: s.headline,
    detail: s.detail ?? "",
    gtm_impact: "Not yet reviewed. Gathered automatically since the baseline; needs a human read before it means anything.",
    play: { state: "none" as const, text: "Unreviewed — no play assessed." },
    sources: [{ label: s.source_name, url: s.source_url }],
  }));

  const signals: Signal[] = [...(brief?.signals ?? []), ...gathered];

  return (
    <>
      <TopBar active="portfolio" />
      <main className="wrap wide">
        <Link href="/" className="note" style={{ display: "inline-block", marginBottom: 14 }}>‹ Back to portfolio</Link>

        {/* ---------------- header ---------------- */}
        <div className="gloss acct-hd">
          <div>
            <div className="ex-no">{account.sector} · {account.relationship}</div>
            <h1>{account.full_name || account.name}</h1>
            <p className="note">
              {account.is_public ? "Public filer" : "Private — verified public sources only"}
              {account.next_report ? ` · next disclosure ${account.next_report}` : ""}
              {baseline ? ` · baseline v${baseline.version}, evidence ${baseline.as_of}` : ""}
              {baseline && !brief ? " · legacy exhibit format, not yet migrated to the brief" : ""}
            </p>
          </div>
          <div className="acct-hd-r">
            <span className={`pill ${verdict}`}>{verdict.replace("_", " ")}</span>
            <RefreshButton slug={account.slug} />
          </div>
        </div>
        {baseline?.verdict_line && <p className="verdictline">{baseline.verdict_line}</p>}

        {brief?.opening && <div style={{ marginBottom: 16 }}><OpeningPanel opening={brief.opening} /></div>}

        {!baseline && (
          <div className="gloss" style={{ padding: "18px 21px" }}>
            <p className="note">No baseline built yet. This page fills in once the research session is imported.</p>
          </div>
        )}

        <div className="acct">
          {/* ============ LEFT ============ */}
          <div className="col">
            <div className="colhdr">Signals &amp; foresight · what moves our GTM</div>

            {signals.length === 0 && (
              <div className="gloss" style={{ padding: "15px 19px" }}>
                <p className="note">
                  No signals yet. Use Refresh — a signal without a working source URL is rejected before it reaches
                  the database.
                </p>
              </div>
            )}
            {signals.map((s, i) => <SignalCard key={i} signal={s} />)}

            {brief?.foresight && <ForesightPanel items={brief.foresight} />}
            {brief?.portfolio_link && <PortfolioLinkPanel link={brief.portfolio_link} />}

            {actions && actions.length > 0 && (
              <div className="gloss">
                <div className="sec-h"><div className="ex-no">Proposed actions</div></div>
                <div style={{ padding: "4px 6px 8px" }}>
                  {actions.map((a) => (
                    <div className="act" key={a.id}>
                      <span className={`pr ${a.priority === 1 ? "p1" : ""}`}>{a.priority}</span>
                      <div>
                        <h3 style={{ fontSize: "var(--t-small)" }}>{a.title}</h3>
                        {a.narrative && <p className="nar" style={{ fontSize: ".8rem" }}>{a.narrative}</p>}
                        <p className="ev">{a.rule_id}{a.due_by ? ` · due ${a.due_by}` : ""}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>

          {/* ============ RIGHT ============ */}
          <div className="col">
            <div className="colhdr">Analysis</div>

            {baseline?.financials
              ? <FinancialsPanel fin={baseline.financials as Financials} />
              : baseline
                ? <div className="gloss" style={{ padding: "15px 19px" }}>
                    <p className="note">Financial series not yet loaded for this account.</p>
                  </div>
                : null}

            {brief?.stakeholders && <StakeholderPanel people={brief.stakeholders} note={brief.stakeholder_note} />}
            {brief?.agenda && <AgendaPanel items={brief.agenda} note={brief.agenda_note} />}
            {brief?.pressure && (
              <PressurePanel points={brief.pressure} read={brief.pressure_read} warning={brief.pressure_warning} />
            )}
            {brief?.play && <PlayPanel play={brief.play} />}
            {brief?.discussion_points && <DiscussionPanel points={brief.discussion_points} />}
            {brief?.how_we_lose && <LosePanel risks={brief.how_we_lose} />}

            {/* Legacy exhibits — shown only for accounts without a brief. */}
            {exhibits.map((ex) => (
              <div className="gloss ex" key={ex.no}>
                <div className="ex-hd">
                  <div className="ex-no">Exhibit {ex.no} · {ex.title}</div>
                  <h2>{ex.headline}</h2>
                </div>
                <div className="ex-bd">
                  {ex.body_html && <div dangerouslySetInnerHTML={{ __html: ex.body_html }} />}
                  {ex.chart && <ExhibitChart spec={ex.chart} />}
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
        </div>
      </main>
    </>
  );
}
