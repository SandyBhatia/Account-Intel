import { NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";
export const maxDuration = 60;

const CATEGORIES = ["filing","earnings","leadership","guidance","safety","contract","merger","rating","technology","market","other"];

/**
 * Lane 2 — signals only. Gathers dated, sourced events since the active
 * baseline. It NEVER writes baselines: deep research happens in working
 * sessions and enters through /api/import-baseline.
 *
 * The verified-sources rule is enforced here in code:
 *   - no source_url  -> row rejected
 *   - non-http(s) url -> row rejected
 * A signal that cannot be checked does not exist.
 */
export async function POST(req: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const { slug } = await req.json();
  const { data: account } = await supabase.from("accounts").select("*").eq("slug", slug).single();
  if (!account) return NextResponse.json({ error: "unknown_account" }, { status: 404 });

  const { data: baseline } = await supabase
    .from("baselines").select("as_of, verdict, verdict_line")
    .eq("account_id", account.id).eq("active", true).maybeSingle();

  const since = baseline?.as_of ?? "the last 6 months";

  if (!process.env.ANTHROPIC_API_KEY)
    return NextResponse.json({ error: "missing_api_key" }, { status: 500 });

  const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
  const model = process.env.ANTHROPIC_MODEL || "claude-sonnet-4-5";

  const system = `You are a research assistant for a B2B account-intelligence tool. You gather VERIFIED, dated news signals about one company. Rules, non-negotiable:
- Report only facts you found at a specific URL in your search results. Never infer, estimate, or fill gaps.
- Every signal MUST carry the exact source URL you read it at and the publication date.
- Prefer primary sources (SEC/SEDAR filings, company press releases, regulator sites) over news aggregators.
- If nothing verifiable happened, return an empty list. An empty list is a good answer; a padded one is a failure.
- Categories: ${CATEGORIES.join(", ")}.
- If a fact directly contradicts the standing view given to you, set contradicts_baseline true.
Respond ONLY with JSON: {"signals":[{"headline":str,"detail":str,"category":str,"source_name":str,"source_url":str,"published_on":"YYYY-MM-DD","contradicts_baseline":bool}]}`;

  const userMsg = `Company: ${account.full_name || account.name} (${account.sector ?? "logistics"}).
Find verifiable developments SINCE ${since}. Standing view to check against: verdict ${baseline?.verdict ?? "none"} — ${baseline?.verdict_line ?? "no baseline yet"}.
Focus: filings/results, leadership changes, guidance moves, safety data, major contracts, M&A, credit ratings, technology announcements.`;

  const resp = await anthropic.messages.create({
    model, max_tokens: 2000,
    system,
    messages: [{ role: "user", content: userMsg }],
    tools: [{ type: "web_search_20250305", name: "web_search" } as never],
  });

  const text = resp.content.filter((b) => b.type === "text").map((b) => (b as { text: string }).text).join("\n");
  let parsed: { signals?: Record<string, unknown>[] } = {};
  try { parsed = JSON.parse(text.replace(/```json|```/g, "").trim()); }
  catch { return NextResponse.json({ error: "parse_failed", raw: text.slice(0, 400) }, { status: 502 }); }

  const candidates = Array.isArray(parsed.signals) ? parsed.signals : [];
  const accepted: Record<string, unknown>[] = [];
  const rejected: { headline: unknown; reason: string }[] = [];

  for (const s of candidates) {
    const url = typeof s.source_url === "string" ? s.source_url.trim() : "";
    if (!url || !/^https?:\/\/.+\..+/.test(url)) { rejected.push({ headline: s.headline, reason: "no verifiable source_url" }); continue; }
    if (!s.headline || !s.source_name) { rejected.push({ headline: s.headline, reason: "incomplete" }); continue; }
    accepted.push({
      account_id: account.id,
      headline: String(s.headline).slice(0, 300),
      detail: s.detail ? String(s.detail).slice(0, 1000) : null,
      category: CATEGORIES.includes(String(s.category)) ? s.category : "other",
      source_name: String(s.source_name).slice(0, 120),
      source_url: url,
      published_on: /^\d{4}-\d{2}-\d{2}$/.test(String(s.published_on)) ? s.published_on : null,
      contradicts_baseline: Boolean(s.contradicts_baseline),
    });
  }

  if (accepted.length) {
    const { error } = await supabase.from("signals").insert(accepted);
    if (error) return NextResponse.json({ error: "insert_failed", detail: error.message }, { status: 500 });
  }

  return NextResponse.json({ inserted: accepted.length, rejected });
}
