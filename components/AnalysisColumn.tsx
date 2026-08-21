import type {
  Stakeholder, AgendaItem, PressurePoint, Play, DiscussionPoint, LossRisk,
} from "@/lib/brief";

/**
 * Right column — the analysis stack. Order is deliberate and identical on
 * every account so the portfolio stays comparable:
 *   financials (FinancialsPanel, rendered by the page) → stakeholders →
 *   agenda → pressure → play → discussion points → how we lose.
 */

export function StakeholderPanel({ people, note }: { people: Stakeholder[]; note?: string }) {
  if (!people?.length) return null;
  return (
    <div className="gloss">
      <div className="sec-h">
        <div className="ex-no">02 · Key stakeholders</div>
        <h2>Who decides, who feels it, who pays</h2>
      </div>
      <div className="sec-b">
        <table className="stk"><tbody>
          {people.map((p, i) => (
            <tr key={i}><td>
              {p.name
                ? <span className="nm">{p.name}</span>
                : <span className="nm dim">{p.title}</span>}
              {p.name
                ? <span className="ti">{p.title}{p.since ? ` · since ${p.since}` : ""}</span>
                : <span className="blank">Name not established from a primary source</span>}
              <span className="rl">
                {p.role && <b className="st">{p.role}. </b>}
                <span dangerouslySetInnerHTML={{ __html: p.relevance }} />
              </span>
            </td></tr>
          ))}
        </tbody></table>
        {note && <p className="note" style={{ marginTop: 11 }}>{note}</p>}
      </div>
    </div>
  );
}

export function AgendaPanel({ items, note }: { items: AgendaItem[]; note?: string }) {
  if (!items?.length) return null;
  return (
    <div className="gloss">
      <div className="sec-h">
        <div className="ex-no">03 · Their agenda &amp; purpose</div>
        <h2>What they have committed to, in their own words</h2>
      </div>
      <div className="sec-b">
        <table className="agenda"><tbody>
          {items.map((a, i) => (
            <tr key={i}>
              <td className="dt">{a.date}</td>
              <td dangerouslySetInnerHTML={{ __html: a.text }} />
            </tr>
          ))}
        </tbody></table>
        {note && <p className="note" style={{ marginTop: 11 }}>{note}</p>}
      </div>
    </div>
  );
}

export function PressurePanel(
  { points, read, warning }: { points: PressurePoint[]; read?: string; warning?: string }
) {
  if (!points?.length) return null;
  return (
    <div className="gloss">
      <div className="sec-h">
        <div className="ex-no">04 · Where the pressure is</div>
        <h2>What is actually hard for them</h2>
      </div>
      <div className="sec-b">
        <ul className="press">
          {points.map((p, i) => <li key={i} dangerouslySetInnerHTML={{ __html: p.text }} />)}
        </ul>
        {read && <div className="read"><span className="l">Read</span><span dangerouslySetInnerHTML={{ __html: read }} /></div>}
        {warning && <div className="warn" dangerouslySetInnerHTML={{ __html: warning }} />}
      </div>
    </div>
  );
}

const LAYER_LABEL: Record<string, string> = { L1: "L1 insight", L2: "L2 foresight", L3: "L3 execute" };
const STATE_LABEL: Record<string, string> = {
  earned: "the only earned entry", not_earned: "not yet earned", later: "phase three",
};

export function PlayPanel({ play }: { play: Play }) {
  if (!play?.layers?.length) return null;
  return (
    <div className="gloss">
      <div className="sec-h">
        <div className="ex-no">05 · The play</div>
        <h2>Mapped to the Tria stack, layer by layer</h2>
      </div>
      <div className="sec-b">
        {play.layers.map((l, i) => (
          <div className="layer" key={i}>
            <div className="layer-hd">
              <span className={`tria ${l.layer}`}>{LAYER_LABEL[l.layer]}</span>
              <span className="prod">{l.product}</span>
              <span className={`tria state-${l.state}`}>{STATE_LABEL[l.state]}</span>
            </div>
            <p dangerouslySetInnerHTML={{ __html: l.text }} />
            {l.their_trigger && <p className="their">Their trigger: {l.their_trigger}</p>}
          </div>
        ))}

        {play.positioning && (
          <div className="layer">
            <span className="play-l ex-no">Positioning against the incumbent</span>
            <p style={{ marginTop: 7 }} dangerouslySetInnerHTML={{ __html: play.positioning }} />
          </div>
        )}

        {play.commercial && (
          <div className="layer">
            <span className="play-l ex-no">Commercial shape</span>
            {play.commercial.internal && <span className="internal">Internal — to supply</span>}
            <p dangerouslySetInnerHTML={{ __html: play.commercial.text }} />
          </div>
        )}

        {play.proof && (
          <div className="layer">
            <span className="play-l ex-no">Proof</span>
            {play.proof.internal && <span className="internal">Internal — named references to supply</span>}
            <p dangerouslySetInnerHTML={{ __html: play.proof.text }} />
          </div>
        )}
      </div>
    </div>
  );
}

export function DiscussionPanel({ points }: { points: DiscussionPoint[] }) {
  if (!points?.length) return null;
  return (
    <div className="gloss">
      <div className="sec-h">
        <div className="ex-no">06 · Discussion points</div>
        <h2>What to actually say in the room</h2>
      </div>
      <div className="sec-b">
        <ul className="dp">
          {points.map((d, i) => (
            <li key={i}>
              <span className="anch">{d.anchor}</span>
              <p className="q">{d.question}</p>
              <p className="why">{d.why}</p>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

export function LosePanel({ risks }: { risks: LossRisk[] }) {
  if (!risks?.length) return null;
  return (
    <div className="gloss">
      <div className="sec-h">
        <div className="ex-no">07 · How we lose</div>
        <h2>Steelmanned — the case against us</h2>
      </div>
      <div className="sec-b">
        <ul className="lose">
          {risks.map((r, i) => (
            <li key={i}>
              <span className="h" dangerouslySetInnerHTML={{ __html: r.risk }} />
              {r.counter && <> <b className="k">Counter:</b> <span dangerouslySetInnerHTML={{ __html: r.counter }} /></>}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
