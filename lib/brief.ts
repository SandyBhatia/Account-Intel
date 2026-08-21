// ============================================================
//  The account brief — shared types and rules.
//
//  Learned the hard way while building the CN reference page.
//  Read the rules before adding a field; several of them exist
//  because the alternative was already shipped and was wrong.
//
//  1. GTM impact is MANDATORY on every signal. A signal with no
//     stated impact on our go-to-market is a news clipping.
//
//  2. A Tria play is OPTIONAL and must be EARNED. Assert one only
//     where the account has evidenced the problem itself — in its
//     own words, numbers or disclosure. Where it has not, say so
//     explicitly ("none") rather than leaving the field empty.
//     Most signals on most accounts will have no play. That is
//     the honest ratio and it is more persuasive than a page
//     where everything conveniently maps to something we sell.
//
//  3. Never assert a NEED the customer has not evidenced.
//     Fabricating a requirement is the same failure as
//     fabricating a fact — it just takes longer to get caught.
//
//  4. Named people: executive team only, and only from the
//     company's own leadership page, a dated company
//     announcement, or a named on-the-record interview. A
//     fabricated first name has already happened on this
//     project. Roles with no verifiable name render as an
//     explicit blank, never as an omission.
//
//  5. Anything we computed is `derived` and must be labelled as
//     such. Arithmetic on published figures is not a disclosure.
//
//  6. Freshness: agenda items must be dated within four quarters
//     unless re-verified against a current source. A prior build
//     carried a 2021 slogan labelled "still operative"; the
//     company had stopped using it and the executive who coined
//     it had left.
// ============================================================

/** Where a signal came from. Curated = researched and verified by hand.
 *  Auto = gathered by the refresh lane. Rendered differently on purpose. */
export type SignalOrigin = "curated" | "auto";

/** How strongly a Tria play is claimed.
 *  direct     — the account stated the problem itself. Assert it.
 *  hypothesis — plausible, unproven. Ask in the room; do not present as fact.
 *  none       — no play here, and saying so is the point. */
export type PlayState = "direct" | "hypothesis" | "none";

/** Tria stack layers. L1 Insight (Ontosphere) · L2 Foresight (Continuum)
 *  · L3 Execute (NeoIP). */
export type TriaLayer = "L1" | "L2" | "L3";

export interface Source {
  label: string;
  url?: string;
  date?: string;
}

export interface SignalPlay {
  state: PlayState;
  /** Which layers attach. Empty for state "none". */
  layers?: TriaLayer[];
  /** For "direct"/"hypothesis": the play. For "none": why there isn't one. */
  text: string;
  /** Honest qualifier to carry into the room. */
  caveat?: string;
}

export interface Signal {
  /** ISO date, or omit for a standing condition (e.g. leadership tenure). */
  date?: string;
  category: string;
  origin: SignalOrigin;
  headline: string;
  detail: string;
  /** MANDATORY. What this changes about our go-to-market. */
  gtm_impact: string;
  play: SignalPlay;
  sources?: Source[];
}

export interface Foresight {
  text: string;
  layers?: TriaLayer[];
  /** true when this is explicitly a coverage/timing observation with no
   *  solution claim attached — keeps us honest about the difference. */
  no_play?: boolean;
}

export interface LinkedAccount {
  slug: string;
  name: string;
  role: string;
  relationship: "customer" | "prospect";
}

export interface PortfolioLink {
  text: string;
  accounts: LinkedAccount[];
  note?: string;
}

export interface Stakeholder {
  /** null when the role matters but no name is verifiable. */
  name: string | null;
  title: string;
  since?: string;
  /** Short tag: mandate owner, pain owner, budget, second door, blocker. */
  role?: string;
  relevance: string;
  /** Provenance is required when a name is present. */
  verified_from?: "company_leadership_page" | "dated_announcement" | "on_record_interview";
}

export interface AgendaItem {
  date: string;
  text: string;
}

export interface PressurePoint {
  text: string;
}

export interface PlayLayer {
  layer: TriaLayer;
  product: string;
  /** earned = lead with this · not_earned = do not lead · later = phase 3 */
  state: "earned" | "not_earned" | "later";
  text: string;
  their_trigger?: string;
}

export interface Play {
  layers: PlayLayer[];
  /** How we sit relative to an incumbent. Positioning about us, not an
   *  insight about them — labelled so it is never confused for one. */
  positioning?: string;
  proof?: { internal: boolean; text: string };
  commercial?: { internal: boolean; text: string };
}

export interface DiscussionPoint {
  /** Which section on the page this draws on. A point that cites
   *  nothing is small talk. */
  anchor: string;
  question: string;
  why: string;
}

export interface LossRisk {
  risk: string;
  counter?: string;
}

export interface Opening {
  script: string;
  note?: string;
  sources?: Source[];
}

export interface Brief {
  opening?: Opening;
  signals: Signal[];
  foresight?: Foresight[];
  portfolio_link?: PortfolioLink;
  stakeholders?: Stakeholder[];
  stakeholder_note?: string;
  agenda?: AgendaItem[];
  agenda_note?: string;
  pressure?: PressurePoint[];
  pressure_read?: string;
  pressure_warning?: string;
  play?: Play;
  discussion_points?: DiscussionPoint[];
  how_we_lose?: LossRisk[];
}

/** The portfolio landing card: a standing read plus the latest dated move. */
export interface CardSummary {
  insight: string;
  signal?: { date: string; text: string };
}

// ---------------- validation ----------------

/** Four quarters. Agenda items older than this must be re-verified
 *  against a current source or dropped. */
export const AGENDA_MAX_AGE_DAYS = 400;

export function agendaIsStale(date: string, asOf: string): boolean {
  const d = Date.parse(date), a = Date.parse(asOf);
  if (Number.isNaN(d) || Number.isNaN(a)) return false;
  return (a - d) / 86_400_000 > AGENDA_MAX_AGE_DAYS;
}

/**
 * Structural honesty checks for the brief. Returns human-readable
 * problems; an empty array means it passes. Mirrors the exhibit
 * source-URL check that already guards Lane 1.
 */
export function validateBrief(brief: unknown, asOf: string): string[] {
  const p: string[] = [];
  if (!brief || typeof brief !== "object") return ["brief must be an object"];
  const b = brief as Partial<Brief>;

  if (!Array.isArray(b.signals) || b.signals.length === 0) {
    p.push("brief.signals must contain at least one signal");
  } else {
    b.signals.forEach((s, i) => {
      const n = `signal ${i + 1}${s?.headline ? ` ("${s.headline.slice(0, 40)}…")` : ""}`;
      if (!s?.headline) p.push(`${n}: headline missing`);
      if (!s?.gtm_impact) p.push(`${n}: gtm_impact is mandatory — a signal with no stated GTM impact is a news clipping`);
      if (!s?.play || !["direct", "hypothesis", "none"].includes(s.play.state))
        p.push(`${n}: play.state must be direct, hypothesis or none — "none" is a valid, expected answer`);
      else if (!s.play.text)
        p.push(`${n}: play.text required — for state "none", state why there is no play`);
      if (s?.play?.state === "direct" && !(s.play.layers ?? []).length)
        p.push(`${n}: a direct play must name at least one Tria layer`);
      if (!(s?.sources ?? []).some((x) => x.url && /^https?:\/\//.test(x.url)))
        p.push(`${n}: needs at least one source with a working URL`);
    });
  }

  (b.stakeholders ?? []).forEach((s, i) => {
    if (s.name && !s.verified_from)
      p.push(`stakeholder ${i + 1} ("${s.name}"): verified_from is required whenever a name is present`);
  });

  (b.agenda ?? []).forEach((a, i) => {
    if (!a.date) p.push(`agenda item ${i + 1}: date required`);
    else if (agendaIsStale(a.date, asOf))
      p.push(`agenda item ${i + 1} (${a.date}): older than four quarters — re-verify against a current source or drop it`);
  });

  return p;
}
