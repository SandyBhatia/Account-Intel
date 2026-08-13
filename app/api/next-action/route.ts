import { NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";
import { evaluateRules, type AccountRow, type BaselineRow, type SignalRow } from "@/lib/rules";

export const runtime = "nodejs";
export const maxDuration = 60;

/**
 * Decision engine. Two stages, strictly separated:
 *   1) lib/rules.ts fires deterministic rules from the data (auditable).
 *   2) Claude writes a short narrative for each fired rule, citing only
 *      the evidence attached to it. The model cannot invent actions,
 *      change priorities, or fire rules — it only phrases them.
 * Existing proposed actions for the same rule+account are replaced, so
 * running the engine is idempotent. Accepted/done/dismissed are kept.
 */
export async function POST() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const { data: accounts } = await supabase.from("accounts").select("*");
  const { data: baselines } = await supabase.from("baselines").select("*").eq("active", true);
  const { data: signals } = await supabase.from("signals").select("*").order("gathered_at", { ascending: false }).limit(400);
  if (!accounts) return NextResponse.json({ error: "no_accounts" }, { status: 500 });

  const byAccount = (aid: string) => (signals ?? []).filter((s) => s.account_id === aid) as SignalRow[];
  const blFor = (aid: string) => ((baselines ?? []).find((b) => b.account_id === aid) ?? null) as BaselineRow | null;

  type Prepared = { account: AccountRow; fired: ReturnType<typeof evaluateRules> };
  const prepared: Prepared[] = (accounts as AccountRow[]).map((account) => ({
    account,
    fired: evaluateRules(account, blFor(account.id), byAccount(account.id)),
  })).filter((p) => p.fired.length > 0);

  // Narration (optional — engine still works without a key, with rule titles only)
  let narratives: Record<string, string> = {};
  if (process.env.ANTHROPIC_API_KEY && prepared.length) {
    const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
    const model = process.env.ANTHROPIC_MODEL || "claude-sonnet-4-5";
    const items = prepared.flatMap((p) =>
      p.fired.map((f) => ({
        key: `${p.account.slug}::${f.rule_id}`,
        account: p.account.name,
        rule: f.rule_id,
        title: f.title,
        evidence: f.evidence.map((e) => e.note),
      }))
    );
    const resp = await anthropic.messages.create({
      model, max_tokens: 1800,
      system: `You phrase next-best-actions for a sales leader. For each item, write ONE tight sentence (max 30 words) explaining why now, citing ONLY the evidence given. No invented facts, no hype. Respond ONLY with JSON: {"<key>":"sentence", ...}`,
      messages: [{ role: "user", content: JSON.stringify(items) }],
    });
    const text = resp.content.filter((b) => b.type === "text").map((b) => (b as { text: string }).text).join("");
    try { narratives = JSON.parse(text.replace(/```json|```/g, "").trim()); } catch { narratives = {}; }
  }

  // Idempotent write: clear previous proposals, keep resolved history
  await supabase.from("actions").delete().eq("status", "proposed");

  const rows = prepared.flatMap((p) =>
    p.fired.map((f) => ({
      account_id: p.account.id,
      rule_id: f.rule_id,
      title: f.title,
      narrative: narratives[`${p.account.slug}::${f.rule_id}`] ?? null,
      due_by: f.due_by,
      priority: f.priority,
      status: "proposed",
      evidence: f.evidence,
    }))
  );
  if (rows.length) {
    const { error } = await supabase.from("actions").insert(rows);
    if (error) return NextResponse.json({ error: "insert_failed", detail: error.message }, { status: 500 });
  }
  return NextResponse.json({ proposed: rows.length });
}
