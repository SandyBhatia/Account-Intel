import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

const VERDICTS = ["PURSUE", "QUALIFY", "WATCH", "NO_BASELINE"];

/**
 * Lane 1 entry point. Deep research is done in working sessions to the
 * evidence standard (primary sources, audited arithmetic); the result is
 * pasted here as JSON. Validation is structural honesty, not vibes:
 *   - verdict must be one of the four defined states
 *   - as_of (evidence date) required
 *   - every exhibit must carry at least one source with a URL
 * Old baseline is archived (active=false), never deleted.
 */
export async function POST(req: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "unauthorized" }, { status: 401 });

  const body = await req.json();
  const { slug, verdict, verdict_line, thesis, exhibits, as_of, mode } = body ?? {};

  const problems: string[] = [];
  if (!slug) problems.push("slug missing");
  if (!VERDICTS.includes(verdict)) problems.push(`verdict must be one of ${VERDICTS.join("/")}`);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(String(as_of ?? ""))) problems.push("as_of must be YYYY-MM-DD (evidence date)");
  if (!Array.isArray(exhibits) || exhibits.length === 0) problems.push("exhibits array required");
  else exhibits.forEach((ex: { title?: string; sources?: { url?: string }[] }, i: number) => {
    if (!ex.title) problems.push(`exhibit ${i + 1}: title missing`);
    const srcs = Array.isArray(ex.sources) ? ex.sources : [];
    if (!srcs.some((s) => s.url && /^https?:\/\//.test(s.url)))
      problems.push(`exhibit ${i + 1} ("${ex.title ?? "?"}"): needs at least one source with a URL`);
  });
  if (problems.length) return NextResponse.json({ error: "validation_failed", problems }, { status: 422 });

  const { data: account } = await supabase.from("accounts").select("id").eq("slug", slug).single();
  if (!account) return NextResponse.json({ error: "unknown_account" }, { status: 404 });

  const { data: prev } = await supabase
    .from("baselines").select("id, version").eq("account_id", account.id).eq("active", true).maybeSingle();

  // mode "reaffirm": the review found the baseline still holds — stamp it, no new version.
  if (mode === "reaffirm" && prev) {
    await supabase.from("baselines")
      .update({ last_reviewed: new Date().toISOString(), review_status: "current" })
      .eq("id", prev.id);
    return NextResponse.json({ reaffirmed: true, version: prev.version });
  }

  if (prev) await supabase.from("baselines").update({ active: false }).eq("id", prev.id);

  const { error } = await supabase.from("baselines").insert({
    account_id: account.id,
    version: (prev?.version ?? 0) + 1,
    verdict, verdict_line: verdict_line ?? null,
    thesis: thesis ?? [], exhibits, as_of,
    active: true, review_status: "current", last_reviewed: new Date().toISOString(),
  });
  if (error) return NextResponse.json({ error: "insert_failed", detail: error.message }, { status: 500 });
  return NextResponse.json({ imported: true, version: (prev?.version ?? 0) + 1 });
}
