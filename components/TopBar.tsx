import Link from "next/link";

export default function TopBar({ active }: { active: "portfolio" | "actions" | "admin" }) {
  return (
    <div className="bar">
      <span className="brand"><b>Mphasis</b> · Account Intelligence</span>
      <nav style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
        <Link className={`nb ${active === "portfolio" ? "on" : ""}`} href="/">◧ Portfolio</Link>
        <Link className={`nb ${active === "actions" ? "on" : ""}`} href="/actions">⚡ Actions</Link>
        <Link className={`nb ${active === "admin" ? "on" : ""}`} href="/admin">⇪ Import</Link>
      </nav>
      <span className="note">Verified sources only</span>
    </div>
  );
}
