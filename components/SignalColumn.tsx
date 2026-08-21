import type { Signal, Foresight, PortfolioLink, Opening } from "@/lib/brief";
import Link from "next/link";

/**
 * Left column — signals and foresight. This is the spine of the page:
 * what has moved, and what follows from it for our go-to-market.
 *
 * Every signal shows its GTM impact. The Tria play is shown only when
 * it has been earned, and when it has not, the card says so explicitly
 * rather than going quiet — a visible "no play here" is a stronger
 * signal of rigour than a page where everything maps to something we sell.
 */

function Sources({ sources }: { sources?: { label: string; url?: string }[] }) {
  if (!sources?.length) return null;
  return (
    <div className="src">
      {sources.map((s, i) => (
        <span key={i}>
          {i > 0 && " · "}
          {s.url ? <a href={s.url} target="_blank" rel="noopener">{s.label} ↗</a> : s.label}
        </span>
      ))}
    </div>
  );
}

function LayerChips({ layers }: { layers?: string[] }) {
  if (!layers?.length) return null;
  const label: Record<string, string> = { L1: "L1 insight", L2: "L2 foresight", L3: "L3 execute" };
  return (
    <>
      {layers.map((l) => <span key={l} className={`tria ${l}`}>{label[l] ?? l}</span>)}
    </>
  );
}

function PlayBlock({ play }: { play: Signal["play"] }) {
  if (play.state === "none") {
    return (
      <div className="noplay">
        <span className="l">No Tria play — considered and rejected</span>
        <p>{play.text}</p>
      </div>
    );
  }
  const hyp = play.state === "hypothesis";
  return (
    <div className={`hook ${hyp ? "hyp" : ""}`}>
      <span className="l">
        {hyp ? "Tria play · hypothesis only — unverified" : "Tria play · direct fit — the customer stated the problem"}
      </span>
      <p>{play.text}</p>
      {play.caveat && <p className="caveat"><b>Caveat to carry into the room:</b> {play.caveat}</p>}
    </div>
  );
}

export function SignalCard({ signal }: { signal: Signal }) {
  return (
    <div className="gloss sig-card">
      <div className="sig-hd">
        <span className="sig-date">{signal.date ?? "Standing"}</span>
        <span className="tag">{signal.category}</span>
        <span className={`tag ${signal.origin}`}>{signal.origin === "curated" ? "Curated" : "Auto"}</span>
        <LayerChips layers={signal.play.state === "none" ? [] : signal.play.layers} />
      </div>
      <h3>{signal.headline}</h3>
      <div className="sig-body">{signal.detail}</div>
      <div className="impact">
        <span className="l">GTM impact</span>
        <p>{signal.gtm_impact}</p>
      </div>
      <PlayBlock play={signal.play} />
      <Sources sources={signal.sources} />
    </div>
  );
}

export function ForesightPanel({ items }: { items: Foresight[] }) {
  if (!items?.length) return null;
  return (
    <div className="gloss">
      <div className="sec-h">
        <div className="ex-no">Foresight</div>
        <h2>What follows, read through what we actually sell</h2>
      </div>
      <ul className="fore">
        {items.map((f, i) => (
          <li key={i}>
            <span className="n">{String(i + 1).padStart(2, "0")}</span>
            <span dangerouslySetInnerHTML={{ __html: f.text }} />
            {(f.layers?.length || f.no_play) && (
              <div className="lay">
                {f.no_play ? <span className="tria none">no play asserted</span> : <LayerChips layers={f.layers} />}
              </div>
            )}
          </li>
        ))}
      </ul>
    </div>
  );
}

export function PortfolioLinkPanel({ link }: { link: PortfolioLink }) {
  if (!link) return null;
  return (
    <div className="gloss xacct">
      <div className="sec-h">
        <div className="ex-no">Portfolio linkage</div>
        <h2>This signal is not contained to one account</h2>
      </div>
      <div className="sec-b">
        <p style={{ fontSize: "var(--t-small)", lineHeight: 1.6 }} dangerouslySetInnerHTML={{ __html: link.text }} />
        <div style={{ marginTop: 11 }}>
          {link.accounts.map((a) => (
            <Link key={a.slug} href={`/account/${a.slug}`} className="xchip">
              {a.name} · {a.role} · <b className={a.relationship === "customer" ? "go" : "dim"}>{a.relationship}</b>
            </Link>
          ))}
        </div>
        {link.note && <p className="note" style={{ marginTop: 12 }}>{link.note}</p>}
      </div>
    </div>
  );
}

export function OpeningPanel({ opening }: { opening: Opening }) {
  if (!opening?.script) return null;
  return (
    <div className="gloss open">
      <div className="sec-h">
        <div className="ex-no">The first ninety seconds</div>
        <h2>If you get ninety seconds, this is the opening</h2>
      </div>
      <div className="sec-b">
        <p className="q">{opening.script}</p>
        {opening.note && <p className="note" style={{ marginTop: 13 }}>{opening.note}</p>}
      </div>
      <Sources sources={opening.sources} />
    </div>
  );
}
