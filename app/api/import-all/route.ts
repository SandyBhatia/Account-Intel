import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { readdir, readFile } from "fs/promises";
import path from "path";
import { validateBrief } from "@/lib/brief";

export const runtime = "nodejs";
export const maxDuration = 60;

const VERDICTS = ["PURSUE", "QUALIFY", "WATCH", "NO_BASELINE"];

function isAdmin(email?: string | null) {
  const list = (process.env.ADMIN_EMAILS ?? "").split(",").map((s) => s.trim().toLowerCase()).filter(Boolean);
  return !!email && list.includes(email.toLowerCase());
}

interface Payload {
  slug: string; verdict: string; verdict_line?: string;
  as_of: string; thesis?: unknown; exhibits?: { title?: string; sources?: { url?: string }[] }[];
  financials?: unknown; brief?: unknown; card?: unknown;
}

/**
 * Bulk loader. Reads the baseline files bundled in /data/baselines and
 * publishes every one in a single request — no SQL editor, no paste limits.
 * Each file goes through the same validation as a manual import, and each
 * insert creates a new version with the previous one archived.
 */
export async function POST() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  if (!isAdmin(user.email)) return NextResponse.json({ error: "forbidden" }, { status: 403 });

  const dir = path.join(process.cwd(), "data", "baselines");
  let files: string[];
  try {
    files = (await readdir(dir)).filter((f) => f.endsWith(".json")).sort();
  } catch {
    return NextResponse.json({ error: "no_baseline_files", detail: `Expected files in ${dir}` }, { status: 500 });
  }

  const { data: accounts } = await supabase.from("accounts").select("id, slug, name");
  const bySlug = new Map((accounts ?? []).map((a) => [a.slug, a]));

  const results: { file: string; account: string; status: string; detail?: string }[] = [];

  for (const file of files) {
    let p: Payload;
    try {
      p = JSON.parse(await readFile(path.join(dir, file), "utf8"));
    } catch (e) {
      results.push({ file, account: "-", status: "failed", detail: `unreadable: ${(e as Error).message}` });
      continue;
    }

    const problems: string[] = [];
    if (!VERDICTS.includes(p.verdict)) problems.push("bad verdict");
    if (!/^\d{4}-\d{2}-\d{2}$/.test(String(p.as_of ?? ""))) problems.push("bad as_of");
    if (!Array.isArray(p.exhibits) || p.exhibits.length === 0) problems.push("no exhibits");
    else p.exhibits.forEach((ex, i) => {
      if (!(ex.sources ?? []).some((s) => s.url && /^https?:\/\//.test(s.url)))
        problems.push(`exhibit ${i + 1} has no source URL`);
    });

    if (p.brief) problems.push(...validateBrief(p.brief, String(p.as_of ?? "")));

    const account = bySlug.get(p.slug);
    if (!account) problems.push(`unknown account "${p.slug}"`);

    if (problems.length) {
      results.push({ file, account: p.slug ?? "-", status: "rejected", detail: problems.join("; ") });
      continue;
    }

    const { data: prev } = await supabase
      .from("baselines").select("id, version")
      .eq("account_id", account!.id).eq("active", true).maybeSingle();
    if (prev) await supabase.from("baselines").update({ active: false }).eq("id", prev.id);

    const { error } = await supabase.from("baselines").insert({
      account_id: account!.id,
      version: (prev?.version ?? 0) + 1,
      verdict: p.verdict,
      verdict_line: p.verdict_line ?? null,
      thesis: p.thesis ?? [],
      exhibits: p.exhibits,
      financials: p.financials ?? null,
      brief: p.brief ?? null,
      card: p.card ?? null,
      as_of: p.as_of,
      active: true, review_status: "current", last_reviewed: new Date().toISOString(),
    });

    results.push(
      error
        ? { file, account: account!.name, status: "failed", detail: error.message }
        : { file, account: account!.name, status: `published v${(prev?.version ?? 0) + 1}` }
    );
  }

  const published = results.filter((r) => r.status.startsWith("published")).length;
  return NextResponse.json({ published, total: files.length, results });
}
