"use client";
import { useState, useEffect, Suspense } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

function LoginInner() {
  const router = useRouter();
  const params = useSearchParams();
  const [mode, setMode] = useState<"password" | "magic">("password");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [sent, setSent] = useState(false);
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState("");
  const [note, setNote] = useState("");

  useEffect(() => { const e = params.get("err"); if (e) setErr(e); }, [params]);

  async function signIn() {
    if (!email.trim() || !password) return;
    setBusy(true); setErr(""); setNote("");
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithPassword({ email: email.trim(), password });
    setBusy(false);
    if (error) { setErr(error.message); return; }
    router.push("/"); router.refresh();
  }

  async function signUp() {
    if (!email.trim() || !password) return;
    if (password.length < 6) { setErr("Password must be at least 6 characters."); return; }
    setBusy(true); setErr(""); setNote("");
    const supabase = createClient();
    const { data, error } = await supabase.auth.signUp({ email: email.trim(), password });
    setBusy(false);
    if (error) { setErr(error.message); return; }
    if (data.session) { router.push("/"); router.refresh(); return; }
    setNote("Account created. If email confirmation is on, confirm in Supabase (Authentication → Users), then sign in.");
  }

  async function sendLink() {
    if (!email.trim()) return;
    setBusy(true); setErr(""); setNote("");
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithOtp({
      email: email.trim(),
      options: { emailRedirectTo: `${process.env.NEXT_PUBLIC_SITE_URL || window.location.origin}/auth/callback` },
    });
    setBusy(false);
    if (error) setErr(error.message); else setSent(true);
  }

  return (
    <main className="wrap" style={{ maxWidth: 440, paddingTop: 70 }}>
      <div className="ex-no">Mphasis · Account Intelligence</div>
      <h1 className="page" style={{ marginBottom: 18 }}>Sign in</h1>

      <div style={{ display: "flex", gap: 8, marginBottom: 14 }}>
        <button className={`bt ${mode === "password" ? "primary" : ""}`} onClick={() => { setMode("password"); setErr(""); setSent(false); }}>Password</button>
        <button className={`bt ${mode === "magic" ? "primary" : ""}`} onClick={() => { setMode("magic"); setErr(""); }}>Email link</button>
      </div>

      <div className="gloss" style={{ padding: "20px 22px" }}>
        {sent && mode === "magic" ? (
          <p className="note">Check your email — a sign-in link is on its way to <b className="k">{email}</b>. Open it on this device.</p>
        ) : (
          <>
            <label htmlFor="email">Email</label>
            <input id="email" type="email" placeholder="you@company.com" suppressHydrationWarning
              value={email} onChange={(e) => setEmail(e.target.value)} />
            {mode === "password" && (
              <>
                <label htmlFor="pw">Password</label>
                <input id="pw" type="password" value={password} onChange={(e) => setPassword(e.target.value)}
                  onKeyDown={(e) => e.key === "Enter" && signIn()} />
              </>
            )}
            <div style={{ display: "flex", gap: 10, marginTop: 16 }}>
              {mode === "password" ? (
                <>
                  <button className="bt primary" onClick={signIn} disabled={busy}>{busy ? "…" : "Sign in"}</button>
                  <button className="bt" onClick={signUp} disabled={busy}>Create account</button>
                </>
              ) : (
                <button className="bt primary" onClick={sendLink} disabled={busy}>{busy ? "…" : "Send link"}</button>
              )}
            </div>
          </>
        )}
        {err && <p className="note stop" style={{ marginTop: 12 }}>{err}</p>}
        {note && <p className="note" style={{ marginTop: 12 }}>{note}</p>}
      </div>
    </main>
  );
}

export default function LoginPage() {
  return <Suspense><LoginInner /></Suspense>;
}
