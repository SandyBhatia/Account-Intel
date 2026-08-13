"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";

export default function RefreshButton({ slug }: { slug: string }) {
  const [busy, setBusy] = useState(false);
  const [msg, setMsg] = useState<string | null>(null);
  const router = useRouter();

  async function run() {
    setBusy(true); setMsg(null);
    try {
      const r = await fetch("/api/refresh", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ slug }) });
      const j = await r.json();
      if (!r.ok) setMsg(j.error ?? "failed");
      else { setMsg(`${j.inserted} signal(s) added${j.rejected?.length ? `, ${j.rejected.length} rejected (unverifiable)` : ""}`); router.refresh(); }
    } catch { setMsg("network error"); }
    setBusy(false);
  }

  return (
    <span style={{ display: "inline-flex", gap: 10, alignItems: "center" }}>
      <button className="bt primary" onClick={run} disabled={busy}>{busy ? "Gathering…" : "↻ Refresh signals"}</button>
      {msg && <span className="note">{msg}</span>}
    </span>
  );
}
