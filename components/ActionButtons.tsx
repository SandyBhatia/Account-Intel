"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function ActionButtons({ id }: { id: string }) {
  const [busy, setBusy] = useState(false);
  const router = useRouter();
  async function set(status: "accepted" | "done" | "dismissed") {
    setBusy(true);
    const supabase = createClient();
    await supabase.from("actions").update({ status, resolved_at: new Date().toISOString() }).eq("id", id);
    router.refresh(); setBusy(false);
  }
  return (
    <span className="btns">
      <button className="bt primary" disabled={busy} onClick={() => set("accepted")}>Accept</button>
      <button className="bt" disabled={busy} onClick={() => set("done")}>Done</button>
      <button className="bt" disabled={busy} onClick={() => set("dismissed")}>Dismiss</button>
    </span>
  );
}
