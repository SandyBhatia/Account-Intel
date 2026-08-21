import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import SignOut from "@/components/SignOut";
import { BUILD } from "@/lib/version";

/** Admin emails see the Import tool. Set ADMIN_EMAILS="a@x.com,b@y.com" in env.
 *  Empty/unset => nobody sees Import, which is the safe default for a shared trial. */
function isAdmin(email?: string | null) {
  const list = (process.env.ADMIN_EMAILS ?? "").split(",").map((s) => s.trim().toLowerCase()).filter(Boolean);
  return !!email && list.includes(email.toLowerCase());
}

export default async function TopBar({ active }: { active: "portfolio" | "actions" | "admin" }) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  const admin = isAdmin(user?.email);

  return (
    <div className="bar">
      <span className="brand"><b>Mphasis</b> Transportation &amp; Logistics · Account Intelligence</span>
      <nav style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
        <Link className={`nb ${active === "portfolio" ? "on" : ""}`} href="/">◧ Portfolio</Link>
        <Link className={`nb ${active === "actions" ? "on" : ""}`} href="/actions">⚡ Actions</Link>
        {admin && <Link className={`nb ${active === "admin" ? "on" : ""}`} href="/admin">⇪ Import</Link>}
      </nav>
      <span style={{ display: "inline-flex", gap: 12, alignItems: "center" }}>
        <span className="note" title={`build ${BUILD}`}>{BUILD}</span>
        <span className="note" title={user?.email ?? ""}>{user?.email?.split("@")[0] ?? ""}</span>
        <SignOut />
      </span>
    </div>
  );
}
