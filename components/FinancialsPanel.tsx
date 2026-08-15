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
  /** currency = money, percent = margin/growth, ratio = operating ratio, count = units */
  kind: "currency" | "percent" | "ratio" | "count";
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

/** Change between the last two verified points in a series. */
function delta(s: FinancialSeries) {
  const pts = s.values.map((v, i) => ({ v, i })).filter((p) => p.v !== null) as { v: number; i: number }[];
  if (pts.length < 2) return null;
  const last = pts[pts.length - 1], prev = pts[pts.length - 2];
  const diff = last.v - prev.v;
  if (s.kind === "percent" || s.kind === "ratio") return { text: `${diff >= 0 ? "+" : ""}${diff.toFixed(1)}pt`, good: s.inverse ? diff < 0 : diff > 0 };
  if (prev.v === 0) return null;
  const pct = (diff / Math.abs(prev.v)) * 100;
  return { text: `${pct >= 0 ? "+" : ""}${pct.toFixed(1)}%`, good: s.inverse ? pct < 0 : pct > 0 };
}

export default function FinancialsPanel({ fin }: { fin: Financials }) {
  if (!fin?.periods?.length || !fin.series?.length) return null;
  const cur = fin.currency ?? "";
  const headline = fin.series.filter((s) => s.headline).slice(0, 4);
  const verifiedCount = (s: FinancialSeries) => s.values.filter((v) => v !== null).length;

  // Group by kind so units never share an axis.
  const money = fin.series.filter((s) => s.kind === "currency" && verifiedCount(s) >= 3);
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
              const d = delta(s);
              return (
                <div className="kpi" key={s.label}>
                  <span className="kpi-l">{s.label}</span>
                  <span className="kpi-v">{fmt(last, s.kind, s.kind === "currency" ? cur : "")}</span>
                  {d && <span className={`kpi-d ${d.good ? "go" : "stop"}`}>{d.text}</span>}
                </div>
              );
            })}
          </div>
        )}

        {money.length > 0 && (
          <ExhibitChart spec={{
            kind: "line", labels: fin.periods, y_label: `${cur}${fin.unit ? " " + fin.unit : ""}`,
            data_labels: money.length === 1,
            series: money.map((s, i) => ({ label: s.label, name: s.label, values: s.values,
              tone: (["struct", "go", "dim", "stop"] as const)[i % 4] })),
          }} />
        )}

        {rates.length > 0 && (
          <div style={{ marginTop: money.length ? 18 : 0 }}>
            <ExhibitChart spec={{
              kind: "line", labels: fin.periods, unit: "%", y_label: "%",
              data_labels: rates.length === 1,
              series: rates.map((s, i) => ({ name: s.label, values: s.values,
                tone: (["stop", "struct", "go", "dim"] as const)[i % 4] })),
            }} />
          </div>
        )}

        {/* ---- full series, always shown: the chart is the shape, the table is the record ---- */}
        <div className="tblwrap" style={{ marginTop: 18 }}>
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
                    <td key={i} className={v === null ? "dim" : ""}>{fmt(v, s.kind, s.kind === "currency" ? cur : "")}</td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {fin.basis && <p className="note" style={{ marginTop: 12 }}>Basis: {fin.basis}</p>}
        {fin.series.some((s) => s.values.includes(null)) && (
          <p className="note" style={{ marginTop: 8 }}>
            Em dash marks a period that could not be verified from a primary source. Nothing is interpolated.
          </p>
        )}
      </div>
    </div>
  );
}
