// ============================================================
// Decision engine — deterministic rules layer.
// Rules fire from data; Claude only narrates what fired.
// Every proposed action is therefore auditable: rule_id + evidence.
// ============================================================

export type Verdict = "PURSUE" | "QUALIFY" | "WATCH" | "NO_BASELINE";

export interface AccountRow {
  id: string; slug: string; name: string;
  relationship: "customer" | "prospect";
  is_public: boolean; cadence: string | null; next_report: string | null;
}
export interface BaselineRow {
  id: string; account_id: string; verdict: Verdict; verdict_line: string | null;
  as_of: string; built_at: string; active: boolean;
  review_status: "current" | "review_due" | "stale"; last_reviewed: string;
}
export interface SignalRow {
  id: string; account_id: string; headline: string; category: string | null;
  published_on: string | null; gathered_at: string; contradicts_baseline: boolean;
  source_name: string; source_url: string;
}

export interface FiredRule {
  rule_id: string;
  title: string;          // deterministic action title (Claude may refine narrative, never the rule)
  due_by: string | null;  // ISO date
  priority: number;       // 1 = highest
  evidence: { kind: "signal" | "baseline" | "calendar"; ref: string; note: string }[];
}

const DAY = 86_400_000;
const daysBetween = (a: Date, b: Date) => Math.round((b.getTime() - a.getTime()) / DAY);
const iso = (d: Date) => d.toISOString().slice(0, 10);

/**
 * Evaluate all rules for one account. Pure function: no I/O, no model calls,
 * fully unit-testable. Order in RULES below is documentation, not precedence —
 * priority field decides ordering in the UI.
 */
export function evaluateRules(
  account: AccountRow,
  baseline: BaselineRow | null,
  signals: SignalRow[],
  today = new Date()
): FiredRule[] {
  const fired: FiredRule[] = [];
  const t = today;

  // ---- R1 · EARNINGS_PREP — reporting event within 21 days on a PURSUE account
  if (account.next_report && baseline?.verdict === "PURSUE") {
    const d = daysBetween(t, new Date(account.next_report));
    if (d >= 0 && d <= 21) {
      fired.push({
        rule_id: "R1_EARNINGS_PREP",
        title: `Prepare ${account.name} pre-earnings briefing`,
        due_by: account.next_report, priority: 1,
        evidence: [
          { kind: "calendar", ref: account.next_report, note: `Reports in ${d} day(s)` },
          { kind: "baseline", ref: baseline.id, note: `Verdict PURSUE — ${baseline.verdict_line ?? ""}` },
        ],
      });
    }
  }

  // ---- R2 · REBASELINE_FILING — a filing/earnings signal newer than the active baseline
  if (baseline) {
    const filing = signals.find(
      (s) => ["filing", "earnings"].includes(s.category ?? "") &&
             s.published_on && s.published_on > baseline.as_of
    );
    if (filing) {
      fired.push({
        rule_id: "R2_REBASELINE_FILING",
        title: `Re-baseline ${account.name} — new disclosure since ${baseline.as_of}`,
        due_by: iso(new Date(t.getTime() + 14 * DAY)), priority: 2,
        evidence: [
          { kind: "signal", ref: filing.id, note: filing.headline },
          { kind: "baseline", ref: baseline.id, note: `Active baseline evidence date ${baseline.as_of}` },
        ],
      });
    }
  }

  // ---- R3 · REBASELINE_PRIVATE_90D — private account, baseline older than 90 days
  if (baseline && !account.is_public) {
    const age = daysBetween(new Date(baseline.last_reviewed), t);
    if (age > 90) {
      fired.push({
        rule_id: "R3_REBASELINE_PRIVATE_90D",
        title: `Quarterly refresh due — ${account.name} (private, last reviewed ${age} days ago)`,
        due_by: iso(new Date(t.getTime() + 14 * DAY)), priority: 3,
        evidence: [{ kind: "baseline", ref: baseline.id, note: `last_reviewed ${baseline.last_reviewed}` }],
      });
    }
  }

  // ---- R4 · CONTRADICTION_REVIEW — any signal flagged as contradicting the baseline
  const contra = signals.find((s) => s.contradicts_baseline);
  if (baseline && contra) {
    fired.push({
      rule_id: "R4_CONTRADICTION_REVIEW",
      title: `Review ${account.name} baseline — signal contradicts a standing claim`,
      due_by: iso(new Date(t.getTime() + 7 * DAY)), priority: 1,
      evidence: [
        { kind: "signal", ref: contra.id, note: contra.headline },
        { kind: "baseline", ref: baseline.id, note: "Verdict and thesis at risk until reviewed" },
      ],
    });
  }

  // ---- R5 · LEADERSHIP_WINDOW — new C-suite signal within the last 90 days
  const lead = signals.find(
    (s) => s.category === "leadership" && s.published_on &&
           daysBetween(new Date(s.published_on), t) <= 90
  );
  if (lead) {
    fired.push({
      rule_id: "R5_LEADERSHIP_WINDOW",
      title: `Leadership window open at ${account.name} — plan outreach before it closes`,
      due_by: lead.published_on ? iso(new Date(new Date(lead.published_on).getTime() + 90 * DAY)) : null,
      priority: 2,
      evidence: [{ kind: "signal", ref: lead.id, note: lead.headline }],
    });
  }

  // ---- R6 · QUALIFY_STALLED — QUALIFY verdict unresolved for 60+ days
  if (baseline?.verdict === "QUALIFY") {
    const age = daysBetween(new Date(baseline.last_reviewed), t);
    if (age > 60) {
      fired.push({
        rule_id: "R6_QUALIFY_STALLED",
        title: `Resolve or downgrade ${account.name} — QUALIFY question open ${age} days`,
        due_by: iso(new Date(t.getTime() + 14 * DAY)), priority: 2,
        evidence: [{ kind: "baseline", ref: baseline.id, note: baseline.verdict_line ?? "Open qualifying question" }],
      });
    }
  }

  // ---- R7 · NO_BASELINE_QUEUE — roster account never researched
  if (!baseline) {
    fired.push({
      rule_id: "R7_NO_BASELINE_QUEUE",
      title: `Build baseline — ${account.name} has no research behind it`,
      due_by: null, priority: account.relationship === "customer" ? 3 : 4,
      evidence: [{ kind: "calendar", ref: account.slug, note: "No active baseline on record" }],
    });
  }

  return fired;
}

export const RULE_DESCRIPTIONS: Record<string, string> = {
  R1_EARNINGS_PREP: "Reporting event within 21 days on a PURSUE account → prepare briefing before the call.",
  R2_REBASELINE_FILING: "A filing or earnings signal is newer than the active baseline → re-baseline (reaffirm or rebuild).",
  R3_REBASELINE_PRIVATE_90D: "Private company, 90 days since last review → quarterly refresh.",
  R4_CONTRADICTION_REVIEW: "A gathered signal contradicts a standing baseline claim → review within a week.",
  R5_LEADERSHIP_WINDOW: "New executive within 90 days → outreach window is open and closing.",
  R6_QUALIFY_STALLED: "QUALIFY question unresolved 60+ days → resolve it or downgrade to WATCH.",
  R7_NO_BASELINE_QUEUE: "Account on the roster with no research → queue a baseline build.",
};
