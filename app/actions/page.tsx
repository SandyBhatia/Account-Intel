import { createClient } from "@/lib/supabase/server";
import TopBar from "@/components/TopBar";
import RunEngine from "@/components/RunEngine";
import ActionButtons from "@/components/ActionButtons";
import Link from "next/link";
import { RULE_DESCRIPTIONS } from "@/lib/rules";

export const dynamic = "force-dynamic";

export default async function ActionsPage() {
  const supabase = await createClient();
  const { data: actions } = await supabase
    .from("actions")
    .select("*, accounts(name, slug)")
    .eq("status", "proposed")
    .order("priority")
    .order("due_by", { ascending: true, nullsFirst: false });
  const { data: resolved } = await supabase
    .from("actions")
    .select("*, accounts(name, slug)")
    .neq("status", "proposed")
    .order("resolved_at", { ascending: false })
    .limit(15);

  return (
    <>
      <TopBar active="actions" />
      <main className="wrap">
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-end", gap: 16, flexWrap: "wrap" }}>
          <div>
            <h1 className="page">Next best actions</h1>
            <p className="sub">Rules fire from data; the model only phrases them. Every card shows which rule and which evidence.</p>
          </div>
          <RunEngine />
        </div>

        <div className="grouplab">Proposed · {(actions ?? []).length}</div>
        {(actions ?? []).length === 0 && (
          <p className="note">Nothing proposed. Run the engine — or nothing currently needs you, which is a valid answer.</p>
        )}
        {(actions ?? []).map((a) => (
          <div className="gloss act" key={a.id} style={{ marginBottom: 10 }}>
            <span className={`pr ${a.priority === 1 ? "p1" : ""}`}>{a.priority}</span>
            <div style={{ flex: 1 }}>
              <h3>
                <Link href={`/account/${(a.accounts as { slug: string })?.slug}`}>{(a.accounts as { name: string })?.name}</Link>
                {" — "}{a.title}
              </h3>
              {a.narrative && <p className="nar">{a.narrative}</p>}
              <p className="ev">
                {a.rule_id} — {RULE_DESCRIPTIONS[a.rule_id] ?? ""}{a.due_by ? ` · due ${a.due_by}` : ""}
                {Array.isArray(a.evidence) && a.evidence.length > 0 && (
                  <> · evidence: {(a.evidence as { note: string }[]).map((e) => e.note).join(" ; ")}</>
                )}
              </p>
            </div>
            <ActionButtons id={a.id} />
          </div>
        ))}

        {(resolved ?? []).length > 0 && (
          <>
            <div className="grouplab">Recently resolved</div>
            {(resolved ?? []).map((a) => (
              <div key={a.id} className="sigrow" style={{ gridTemplateColumns: "110px 1fr auto" }}>
                <span className="sigdate mono">{a.status.toUpperCase()}</span>
                <span><b className="k">{(a.accounts as { name: string })?.name}</b> — {a.title}</span>
                <span className="note">{a.resolved_at?.slice(0, 10)}</span>
              </div>
            ))}
          </>
        )}
      </main>
    </>
  );
}
