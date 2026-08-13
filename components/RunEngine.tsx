"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";

export default function RunEngine() {
  const [busy, setBusy] = useState(false);
  const [msg, setMsg] = useState<string | null>(null);
  const router = useRouter();
  async function run() {
    setBusy(true); setMsg(null);
    const r = await fetch("/api/next-action", { method: "POST" });
    const j = await r.json();
    setMsg(r.ok ? `${j.proposed} action(s) proposed` : (j.error ?? "failed"));
    router.refresh(); setBusy(false);
  }
  return (
    <span style={{ display: "inline-flex", gap: 10, alignItems: "center" }}>
      <button className="bt primary" onClick={run} disabled={busy}>{busy ? "Evaluating rules…" : "⚡ Run engine"}</button>
      {msg && <span className="note">{msg}</span>}
    </span>
  );
}
