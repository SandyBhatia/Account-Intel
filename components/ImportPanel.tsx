"use client";
import { useState } from "react";

export default function ImportPanel({ accounts }: { accounts: { slug: string; name: string }[] }) {
  const [file, setFile] = useState<File | null>(null);
  const [payload, setPayload] = useState<Record<string, unknown> | null>(null);
  const [problems, setProblems] = useState<string[]>([]);
  const [result, setResult] = useState<{ ok: boolean; text: string } | null>(null);
  const [busy, setBusy] = useState(false);
  const [mode, setMode] = useState<"import" | "reaffirm">("import");
  const [bulk, setBulk] = useState<string | null>(null);
  const [bulkBusy, setBulkBusy] = useState(false);

  const nameFor = (slug: string) => accounts.find((a) => a.slug === slug)?.name ?? slug;

  async function pick(f: File | null) {
    setFile(f); setPayload(null); setProblems([]); setResult(null);
    if (!f) return;
    try {
      const parsed = JSON.parse(await f.text());
      const p: string[] = [];
      if (!parsed.slug) p.push("No account identified in the file.");
      else if (!accounts.some((a) => a.slug === parsed.slug)) p.push(`"${parsed.slug}" is not an account on the roster.`);
      if (!["PURSUE", "QUALIFY", "WATCH", "NO_BASELINE"].includes(parsed.verdict)) p.push("Verdict must be PURSUE, QUALIFY, WATCH or NO_BASELINE.");
      if (!/^\d{4}-\d{2}-\d{2}$/.test(String(parsed.as_of ?? ""))) p.push("Missing the evidence date.");
      if (!Array.isArray(parsed.exhibits) || parsed.exhibits.length === 0) p.push("No exhibits in the file.");
      setPayload(parsed); setProblems(p);
    } catch (e) {
      setProblems([`This file is not valid JSON — ${(e as Error).message}`]);
    }
  }

  async function send() {
    if (!payload) return;
    setBusy(true); setResult(null);
    const body = mode === "reaffirm" ? { ...payload, mode: "reaffirm" } : payload;
    const r = await fetch("/api/import-baseline", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) });
    const j = await r.json();
    if (!r.ok) setResult({ ok: false, text: j.problems ? j.problems.join(" · ") : (j.error ?? "Import failed.") });
    else if (j.reaffirmed) setResult({ ok: true, text: `Reviewed — baseline holds at version ${j.version}. Review clock reset.` });
    else setResult({ ok: true, text: `Published as version ${j.version}. The previous version is archived, not deleted.` });
    setBusy(false);
  }

  const exhibitCount = Array.isArray(payload?.exhibits) ? (payload!.exhibits as unknown[]).length : 0;
  const ready = payload && problems.length === 0;

  async function importAll() {
    setBulkBusy(true); setBulk(null);
    const r = await fetch("/api/import-all", { method: "POST" });
    const j = await r.json();
    setBulk(r.ok
      ? `Published ${j.published} of ${j.total} baselines.` +
        (j.results ?? []).filter((x: { status: string }) => !x.status.startsWith("published"))
          .map((x: { account: string; detail?: string }) => ` · ${x.account}: ${x.detail}`).join("")
      : `Failed — ${j.error ?? "unknown"}`);
    setBulkBusy(false);
  }

  return (
    <div className="gloss" style={{ padding: "22px 24px", marginTop: 18 }}>
      <div style={{ paddingBottom: 18, marginBottom: 18, borderBottom: "1px solid var(--rule)" }}>
        <div className="ex-no">Bulk load</div>
        <p style={{ fontSize: "var(--t-small)", lineHeight: 1.6, margin: "8px 0 12px" }}>
          Publish every baseline bundled with this build in one pass. Each file goes through the same
          validation as a single import and creates a new version, archiving the previous one.
        </p>
        <button className="bt primary" onClick={importAll} disabled={bulkBusy}>
          {bulkBusy ? "Publishing all…" : "⇪ Load all bundled baselines"}
        </button>
        {bulk && <p className="note" style={{ marginTop: 10 }}>{bulk}</p>}
      </div>
      <p style={{ fontSize: "var(--t-small)", lineHeight: 1.6, marginBottom: 18 }}>
        Deep research happens in working sessions, then arrives here as a file. Nothing enters the portfolio
        until it passes the evidence checks: a real account, one of the four verdicts, a dated basis, and
        <b className="k"> a source URL on every exhibit</b>.
      </p>

      <label>Baseline file</label>
      <label htmlFor="f" style={{ display: "block", cursor: "pointer", border: "1px dashed var(--rule)", borderRadius: 10,
        padding: "26px 18px", textAlign: "center", background: "var(--panel2)", textTransform: "none", letterSpacing: 0 }}>
        <span style={{ fontSize: "var(--t-body)", color: "var(--key)" }}>{file ? file.name : "Choose a .json file"}</span>
        <br /><span className="note">{file ? "Click to choose a different file" : "or drag one onto this box"}</span>
      </label>
      <input id="f" type="file" accept="application/json,.json" style={{ display: "none" }}
        onChange={(e) => pick(e.target.files?.[0] ?? null)} />

      {problems.length > 0 && (
        <div style={{ marginTop: 16, padding: "13px 15px", border: "1px solid var(--stop)", borderRadius: 9 }}>
          <div className="ex-no" style={{ color: "var(--stop)", WebkitTextFillColor: "var(--stop)" }}>Cannot import</div>
          <ul style={{ marginTop: 8, paddingLeft: 18, fontSize: "var(--t-small)" }}>
            {problems.map((p, i) => <li key={i}>{p}</li>)}
          </ul>
        </div>
      )}

      {ready && (
        <>
          <div style={{ marginTop: 18, padding: "15px 17px", border: "1px solid var(--rule)", borderRadius: 9, background: "var(--panel2)" }}>
            <div className="ex-no">Ready to publish</div>
            <p style={{ fontSize: "var(--t-body)", marginTop: 9 }}>
              <b className="k">{nameFor(String(payload!.slug))}</b>
              {" — "}<span className={`pill ${payload!.verdict}`}>{String(payload!.verdict).replace("_", " ")}</span>
            </p>
            <p style={{ fontSize: "var(--t-small)", marginTop: 9 }}>{String(payload!.verdict_line ?? "")}</p>
            <p className="note" style={{ marginTop: 9 }}>{exhibitCount} exhibit(s) · evidence dated {String(payload!.as_of)}</p>
          </div>

          <label>Publish as</label>
          <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
            <button className={`bt ${mode === "import" ? "primary" : ""}`} onClick={() => setMode("import")}>New version</button>
            <button className={`bt ${mode === "reaffirm" ? "primary" : ""}`} onClick={() => setMode("reaffirm")}>Reviewed, no change</button>
          </div>
          <p className="note" style={{ marginTop: 7 }}>
            {mode === "import"
              ? "Creates a new version and archives the current one. Nothing is deleted."
              : "Records that the account was reviewed and the standing baseline still holds. No new version."}
          </p>

          <button className="bt primary" style={{ marginTop: 17 }} onClick={send} disabled={busy}>
            {busy ? "Publishing…" : "Publish to portfolio"}
          </button>
        </>
      )}

      {result && (
        <p style={{ marginTop: 16, fontSize: "var(--t-body)" }} className={result.ok ? "go" : "stop"}>{result.text}</p>
      )}
    </div>
  );
}
