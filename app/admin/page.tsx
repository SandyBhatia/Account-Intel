import TopBar from "@/components/TopBar";
import ImportPanel from "@/components/ImportPanel";
import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

function isAdmin(email?: string | null) {
  const list = (process.env.ADMIN_EMAILS ?? "").split(",").map((s) => s.trim().toLowerCase()).filter(Boolean);
  return !!email && list.includes(email.toLowerCase());
}

export default async function AdminPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!isAdmin(user?.email)) redirect("/");

  const { data: accounts } = await supabase.from("accounts").select("slug, name").order("name");

  return (
    <>
      <TopBar active="admin" />
      <main className="wrap" style={{ maxWidth: 820 }}>
        <h1 className="page">Import research</h1>
        <p className="sub">Admin only · drop in a baseline file from a research session</p>
        <ImportPanel accounts={accounts ?? []} />
      </main>
    </>
  );
}
