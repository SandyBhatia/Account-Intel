import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import TopBar from "@/components/TopBar";

export const dynamic = "force-dynamic";

const ORDER: Record<string, number> = { PURSUE: 1, QUALIFY: 2, WATCH: 3, NO_BASELINE: 4 };

export default async function Portfolio() {
  const supabase = await createClient();
  const { data: accounts } = await supabase.from("accounts").select("*").order("name");
  const { data: baselines } = await supabase.from("baselines").select("account_id, verdict, verdict_line, as_of, review_status").eq("active", true);
  const { data: proposedActions } = await supabase.from("actions").select("account_id").eq("status", "proposed");

  const bl = (id: string) => baselines?.find((b) => b.account_id === id);
  const actionCount = (id: string) => proposedActions?.filter((a) => a.account_id === id).length ?? 0;

  const rows = (accounts ?? []).map((a) => ({ ...a, baseline: bl(a.id), actions: actionCount(a.id) }));
  const groups: ["customer" | "prospect", string][] = [["customer", "Customers"], ["prospect", "Prospects"]];

  return (
    <>
      <TopBar active="portfolio" />
      <main className="wrap">
        <h1 className="page">Transportation &amp; Logistics Portfolio</h1>
        <p className="sub">
          {rows.length} accounts · {baselines?.length ?? 0} with verified baselines · customers first, verdict-sorted within group
        </p>

        {groups.map(([key, label]) => {
          const set = rows
            .filter((r) => r.relationship === key)
            .sort((x, y) => (ORDER[x.baseline?.verdict ?? "NO_BASELINE"] - ORDER[y.baseline?.verdict ?? "NO_BASELINE"]) || x.name.localeCompare(y.name));
          return (
            <section key={key}>
              <div className="grouplab">{label} · {set.length}</div>
              <div className="cards">
                {set.map((a) => {
                  const v = a.baseline?.verdict ?? "NO_BASELINE";
                  return (
                    <Link key={a.id} href={`/account/${a.slug}`} className={`card gloss ${v === "NO_BASELINE" ? "empty" : ""}`}>
                      <div className="c-top">
                        <div>
                          <div className="c-name">{a.name}</div>
                          <div className="c-meta">{a.sector} · {a.relationship}</div>
                        </div>
                        <span className={`pill ${v}`}>{v.replace("_", " ")}</span>
                      </div>
                      <div className="c-why">
                        {a.baseline?.verdict_line ?? <span className="dim">Not yet researched — no verdict earned. {a.is_public ? "Public filings available for the baseline build." : "Private company; baseline will use verifiable public sources only."}</span>}
                      </div>
                      <div className="c-foot">
                        <span>{a.next_report ? `Next · ${a.next_report}` : "No public cadence"}{a.baseline ? ` · evidence ${a.baseline.as_of}` : ""}</span>
                        <span className="open">{a.actions > 0 ? `${a.actions} action${a.actions > 1 ? "s" : ""} ›` : "Open ›"}</span>
                      </div>
                    </Link>
                  );
                })}
              </div>
            </section>
          );
        })}

        <div className="gloss" style={{ marginTop: 26, padding: "17px 19px" }}>
          <div className="ex-no" style={{ marginBottom: 12 }}>What the verdicts mean</div>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit,minmax(258px,1fr))", gap: 15, fontSize: "var(--t-small)", lineHeight: 1.55 }}>
            <div><span className="pill PURSUE">PURSUE</span><p style={{ marginTop: 8 }}><b className="k">Spend pursuit cost now.</b> A trigger with a clock on it, a named person whose problem it is, and a commercial shape their budget can absorb. Act this quarter.</p></div>
            <div><span className="pill QUALIFY">QUALIFY</span><p style={{ marginTop: 8 }}><b className="k">Test one question first.</b> Credible signal, but a single open question — wallet, timing, incumbent — could flip the answer. Spend a little to resolve it.</p></div>
            <div><span className="pill WATCH">WATCH</span><p style={{ marginTop: 8 }}><b className="k">No active trigger.</b> Researched and understood; revisit at the next reporting event rather than manufacturing a reason to call.</p></div>
            <div><span className="pill NO_BASELINE">NO BASELINE</span><p style={{ marginTop: 8 }}><b className="k">Not yet researched.</b> No verdict, because the work has not been done to earn one. These stay visibly empty.</p></div>
          </div>
          <p className="note" style={{ marginTop: 15, paddingTop: 13, borderTop: "1px solid var(--rule)" }}>
            Verdicts are our call, reviewed quarterly, and rank pursuit priority only — they say nothing about relationship health or account value.
          </p>
        </div>
      </main>
    </>
  );
}
