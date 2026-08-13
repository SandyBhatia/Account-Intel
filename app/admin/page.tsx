"use client";
import { useState } from "react";
import TopBar from "@/components/TopBar";

const TEMPLATE = `{
  "slug": "cpkc",
  "verdict": "QUALIFY",
  "verdict_line": "One-line why, in plain language.",
  "as_of": "2026-08-12",
  "thesis": [
    { "n": "01", "text": "First thesis point. <b>Bold</b> allowed." }
  ],
  "exhibits": [
    {
      "no": "A",
      "title": "Short label",
      "headline": "The finding, stated as a sentence.",
      "body_html": "<p>Narrative with <b>verified numbers</b>.</p>",
      "table": { "head": ["", "FY24", "FY25"], "rows": [["Revenue", "1,000", "1,100"]] },
      "sowhat": "Why this matters for the pursuit.",
      "sources": [ { "label": "FY25 Annual Report, p.30", "url": "https://..." } ]
    }
  ]
}`;

export default function AdminPage() {
  const [json, setJson] = useState("");
  const [mode, setMode] = useState<"import" | "reaffirm">("import");
  const [result, setResult] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  async function submit() {
    setBusy(true); setResult(null);
    let payload: Record<string, unknown>;
    try { payload = JSON.parse(json); }
    catch (e) { setResult(`Not valid JSON: ${(e as Error).message}`); setBusy(false); return; }
    if (mode === "reaffirm") payload.mode = "reaffirm";
    const r = await fetch("/api/import-baseline", {
      method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(payload),
    });
    const j = await r.json();
    if (!r.ok) setResult(`Rejected — ${j.error}${j.problems ? ":\n• " + j.problems.join("\n• ") : ""}`);
    else if (j.reaffirmed) setResult(`Baseline reaffirmed (still v${j.version}). Review clock reset.`);
    else setResult(`Imported as v${j.version}. Previous version archived, not deleted.`);
    setBusy(false);
  }

  return (
    <>
      <TopBar active="admin" />
      <main className="wrap" style={{ maxWidth: 880 }}>
        <h1 className="page">Import a baseline</h1>
        <p className="sub">Lane 1 · deep research is done in a working session, then pasted here as JSON</p>

        <div className="gloss" style={{ padding: "20px 22px", marginTop: 18 }}>
          <p style={{ fontSize: "var(--t-small)", lineHeight: 1.6 }}>
            Validation enforces the evidence standard mechanically: verdict must be one of the four states,
            <b className="k"> as_of</b> must carry the evidence date, and <b className="k">every exhibit needs at least one source URL</b>.
            A baseline that fails these checks does not enter the system.
          </p>

          <label>Mode</label>
          <div style={{ display: "flex", gap: 8 }}>
            <button className={`bt ${mode === "import" ? "primary" : ""}`} onClick={() => setMode("import")}>New version (rebuild)</button>
            <button className={`bt ${mode === "reaffirm" ? "primary" : ""}`} onClick={() => setMode("reaffirm")}>Reaffirm existing (10-min review, baseline holds)</button>
          </div>
          {mode === "reaffirm" && <p className="note" style={{ marginTop: 8 }}>Reaffirm only needs {"{"}&quot;slug&quot;: &quot;...&quot;{"}"} plus valid verdict/as_of/exhibits from the standing baseline — it stamps last_reviewed without creating a version.</p>}

          <label>Baseline JSON</label>
          <textarea className="mono" rows={16} value={json} onChange={(e) => setJson(e.target.value)} placeholder={TEMPLATE} />

          <div style={{ display: "flex", gap: 12, alignItems: "center", marginTop: 14 }}>
            <button className="bt primary" onClick={submit} disabled={busy || !json.trim()}>{busy ? "Validating…" : "Validate & import"}</button>
            <button className="bt" onClick={() => setJson(TEMPLATE)}>Load template</button>
          </div>
          {result && <pre className="note" style={{ marginTop: 14, whiteSpace: "pre-wrap" }}>{result}</pre>}
        </div>
      </main>
    </>
  );
}
