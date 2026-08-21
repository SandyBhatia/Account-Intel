import ExhibitChart from "@/components/ExhibitChart";

/**
 * The standard financial exhibit. Every account renders this the same way so
 * the portfolio is comparable side by side.
 *
 * Design rules learned the hard way:
 *  - Never mix units on one axis. Each series declares its own kind, and
 *    series are grouped into separate charts by kind.
 *  - Never draw a chart from a single data point. Below three periods we
 *    render the table only.
 *  - Percentages and ratios get their own panel, currency gets another.
 *  - Missing data is shown as an explicit gap, never interpolated.
 */

export interface FinancialSeries {
  label: string;
  /** currency = aggregate money (millions/billions), pershare = per-share
   *  currency figures (EPS). Kept distinct from "currency" even though both
   *  are dollar-denominated: EPS (~$2) charted on the same axis as revenue
   *  (~$4,700M) reads as a flat line at zero, so they get separate charts.
   *  percent = margin/growth, ratio = operating ratio, count = units */
  kind: "currency" | "pershare" | "percent" | "ratio" | "count";
  /** null means the figure could not be verified for that period */
  values: (number | null)[];
  /** lower is better (operating ratio) — flips the good/bad colouring */
  inverse?: boolean;
  /** show in the KPI strip at the top */
  headline?: boolean;
  note?: string;
}

export interface Financials {
  currency?: string;      // "US$" | "C$"
  unit?: string;          // "millions" | "billions"
  periods: string[];      // ["Q3'24", ... "Q2'26"] or ["FY2021", ...]
  basis?: string;         // e.g. "Segment results within FedEx Corp, not carve-out"
  series: FinancialSeries[];
  /** The filings/press releases these values were read from. Same evidence
   *  standard as exhibit sources — rendered the same way. Not yet enforced
   *  at the API layer; many baselines still carry only the `basis` note. */
  sources?: { label: string; url?: string }[];
}

const fmt = (v: number | null, kind: string, cur = "") => {
  if (v === null || !Number.isFinite(v)) return "—";
  if (kind === "percent" || kind === "ratio") return `${v.toFixed(1)}%`;
  if (kind === "count") return v.toLocaleString();
  const abs = Math.abs(v);
  const s = abs >= 1000 ? v.toLocaleString(undefined, { maximumFractionDigits: 0 })
          : abs >= 10 ? v.toFixed(0)
          : v.toFixed(2);
  return `${cur}${s}`;
};

const QUARTER_RE = /^Q[1-4]'\d{2}$/;

/**
 * Change vs. the same period a year ago when that comparator is available —
 * every exhibit narrative and thesis point in this tool is framed YoY, and
 * a seasonal transportation business makes QoQ deltas noisy/misleading next
 * to that framing. Falls back to the nearest prior verified point if there's
 * no YoY comparator (short history, or an annual reporter). Always returns a
 * label so the KPI strip never implies a comparison it isn't making.
 */
function delta(s: FinancialSeries, periods: string[]) {
  const pts = s.values.map((v, i) => ({ v, i })).filter((p) => p.v !== null) as { v: number; i: number }[];
  if (pts.length < 2) return null;
  const last = pts[pts.length - 1];
  const quarterly = periods.length >= 5 && periods.every((p) => QUARTER_RE.test(p));

  let prev: { v: number; i: number } | undefined;
  let label = "";
  const yoyIdx = last.i - 4;
  const yoyVal = quarterly && yoyIdx >= 0 ? s.values[yoyIdx] : null;
  if (quarterly && yoyVal !== null && yoyVal !== undefined) {
    prev = { v: yoyVal, i: yoyIdx };
    label = "YoY";
  } else {
    prev = pts[pts.length - 2];
    label = prev.i === last.i - 1 ? (quarterly ? "QoQ" : "vs prior") : `vs ${periods[prev.i]}`;
  }

  const diff = last.v - prev.v;
  if (s.kind === "percent" || s.kind === "ratio") return { text: `${diff >= 0 ? "+" : ""}${diff.toFixed(1)}pt`, label, good: s.inverse ? diff < 0 : diff > 0 };
  if (prev.v === 0) return null;
  const pct = (diff / Math.abs(prev.v)) * 100;
  return { text: `${pct >= 0 ? "+" : ""}${pct.toFixed(1)}%`, label, good: s.inverse ? pct < 0 : pct > 0 };
}

export default function FinancialsPanel({ fin }: { fin: Financials }) {
  if (!fin?.periods?.length || !fin.series?.length) return null;
  const cur = fin.currency ?? "";
  const headline = fin.series.filter((s) => s.headline).slice(0, 4);
  const verifiedCount = (s: FinancialSeries) => s.values.filter((v) => v !== null).length;

  // Group by kind so units never share an axis. currency and pershare are
  // both dollar-denominated but differ by orders of magnitude (revenue in
  // millions vs. EPS around a few dollars), so they get separate charts too.
  const money = fin.series.filter((s) => s.kind === "currency" && verifiedCount(s) >= 3);
  const perShare = fin.series.filter((s) => s.kind === "pershare" && verifiedCount(s) >= 3);
  const rates = fin.series.filter((s) => (s.kind === "percent" || s.kind === "ratio") && verifiedCount(s) >= 3);

  return (
    <div className="ex gloss wide">
      <div className="ex-hd">
        <div className="ex-no">Financial performance · {fin.periods.length} periods</div>
        <h2>{fin.periods[0]} to {fin.periods[fin.periods.length - 1]}
          {fin.unit ? <span className="dim" style={{ fontWeight: 400 }}> · {cur} {fin.unit}</span> : null}</h2>
      </div>

      <div className="ex-bd">
        {/* ---- latest period at a glance ---- */}
        {headline.length > 0 && (
          <div className="kpis">
            {headline.map((s) => {
              const last = [...s.values].reverse().find((v) => v !== null) ?? null;
              const d = delta(s, fin.periods);
              const isMoney = s.kind === "currency" || s.kind === "pershare";
              return (
                <div className="kpi" key={s.label}>
                  <span className="kpi-l">{s.label}</span>
                  <span className="kpi-v">{fmt(last, s.kind, isMoney ? cur : "")}</span>
                  {d && (
                    <span className={`kpi-d ${d.good ? "go" : "stop"}`}>
                      {d.text} <span className="dim" style={{ fontWeight: 400 }}>{d.label}</span>
                    </span>
                  )}
                </div>
              );
            })}
          </div>
        )}


        {/* The table is the record and leads; the charts are the shape and
            follow. Opening the analysis column with three tall charts pushed
            everything below them off the screen. */}
        <div className="tblwrap">
          <table className="tbl dense">
            <thead>
              <tr><th>{cur}{fin.unit ? ` ${fin.unit}` : ""}</th>
                {fin.periods.map((p) => <th key={p}>{p}</th>)}</tr>
            </thead>
            <tbody>
              {fin.series.map((s) => (
                <tr key={s.label}>
                  <td>{s.label}{s.note && <span className="dim" style={{ fontSize: ".72rem" }}> · {s.note}</span>}</td>
                  {s.values.map((v, i) => (
                    <td key={i} className={v === null ? "dim" : ""}>{fmt(v, s.kind, (s.kind === "currency" || s.kind === "pershare") ? cur : "")}</td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {money.length > 0 && (
          <ExhibitChart spec={{
            kind: "line", labels: fin.periods, height: 250, y_label: `${cur}${fin.unit ? " " + fin.unit : ""}`,
            data_labels: true,
            series: money.map((s, i) => ({ label: s.label, name: s.label, values: s.values,
              tone: (["struct", "go", "dim", "stop"] as const)[i % 4] })),
          }} />
        )}

        {perShare.length > 0 && (
          <div style={{ marginTop: money.length ? 18 : 0 }}>
            <ExhibitChart spec={{
              kind: "line", labels: fin.periods, height: 225, y_label: `${cur} / share`,
              data_labels: true,
              series: perShare.map((s, i) => ({ label: s.label, name: s.label, values: s.values,
                tone: (["go", "struct", "stop", "dim"] as const)[i % 4] })),
            }} />
          </div>
        )}

        {rates.length > 0 && (
          <div style={{ marginTop: money.length || perShare.length ? 18 : 0 }}>
            <ExhibitChart spec={{
              kind: "line", labels: fin.periods, height: 225, unit: "%", y_label: "%",
              data_labels: true,
              series: rates.map((s, i) => ({ name: s.label, values: s.values,
                tone: (["stop", "struct", "go", "dim"] as const)[i % 4] })),
            }} />
          </div>
        )}

        {fin.basis && <p className="note" style={{ marginTop: 12 }}>Basis: {fin.basis}</p>}
        {fin.series.some((s) => s.values.includes(null)) && (
          <p className="note" style={{ marginTop: 8 }}>
            Em dash marks a period that could not be verified from a primary source. Nothing is interpolated.
          </p>
        )}
      </div>

      {fin.sources && fin.sources.length > 0 && (
        <div className="src">
          {fin.sources.map((s, i) => (
            <span key={i}>{i > 0 && " · "}{s.url ? <a href={s.url} target="_blank" rel="noopener">{s.label} ↗</a> : s.label}</span>
          ))}
        </div>
      )}
    </div>
  );
}
