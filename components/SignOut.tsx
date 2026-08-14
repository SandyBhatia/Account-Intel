"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function SignOut() {
  const [busy, setBusy] = useState(false);
  const router = useRouter();
  async function out() {
    setBusy(true);
    await createClient().auth.signOut();
    router.push("/login");
    router.refresh();
  }
  return <button className="bt" onClick={out} disabled={busy}>{busy ? "…" : "Sign out"}</button>;
}
