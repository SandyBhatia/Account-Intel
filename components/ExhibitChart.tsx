// ============================================================
// Exhibit charts — server-rendered SVG, no client JS, no chart lib.
//
// Design rules that are non-negotiable here:
//  1. Numbers are never rounded away. If the source says 62.5, the
//     label says 62.5. A chart that disagrees with its own exhibit
//     destroys the tool's premise.
//  2. Every point carries its value. Reading a trend should not
//     require squinting at gridlines.
//  3. Bars are measured from zero; lines may be zoomed to the data.
// ============================================================

export interface ChartSpec {
  kind: "line" | "bar" | "grouped";
  labels: string[];
  series: { name: string; values: (number | null)[]; tone?: "struct" | "go" | "stop" | "dim" }[];
  y_label?: string;
  y_min?: number;
  y_max?: number;
  unit?: string;
  /** Plot height in px. Default 280; the financial stack uses less so the
   *  analysis column does not open with a wall of charts. */
  height?: number;
  /** Value labels. true = every point (default), false = none,
   *  "ends" = first and last verified point of each series — the readable
   *  compromise for multi-series charts, where labelling all 24 points is
   *  noise but labelling none makes the reader squint at gridlines. */
  data_labels?: boolean | "ends";
}

const TONE: Record<string, string> = {
  struct: "var(--struct)", go: "var(--go)", stop: "var(--stop)", dim: "var(--dim)",
};

/** Decimal places needed so no value is misrepresented, capped at 2. */
function precisionFor(values: number[]): number {
  let p = 0;
  for (const v of values) {
    const s = String(v);
    const dot = s.indexOf(".");
    if (dot >= 0) p = Math.max(p, Math.min(2, s.length - dot - 1));
  }
  return p;
}

/** Axis ticks on human-friendly intervals (1, 2, 2.5, 5, 10 x 10^n). */
function niceTicks(min: number, max: number, target = 4): number[] {
  const span = max - min || 1;
  const rough = span / target;
  const mag = Math.pow(10, Math.floor(Math.log10(rough)));
  const norm = rough / mag;
  const step = (norm <= 1 ? 1 : norm <= 2 ? 2 : norm <= 2.5 ? 2.5 : norm <= 5 ? 5 : 10) * mag;
  const start = Math.floor(min / step) * step;
  const out: number[] = [];
  for (let v = start; v <= max + step * 0.001; v += step) out.push(Number(v.toFixed(10)));
  return out;
}

export default function ExhibitChart({ spec }: { spec: ChartSpec }) {
  const W = 760, H = spec.height ?? 280;
  const padL = 56, padR = 22, padT = 28, padB = 42;
  const plotW = W - padL - padR, plotH = H - padT - padB;

  const all = spec.series.flatMap((s) => s.values).filter((v): v is number => v !== null && Number.isFinite(v));
  if (all.length === 0 || spec.labels.length === 0) return null;

  const prec = precisionFor(all);
  const unit = spec.unit ?? "";
  const label = (v: number) =>
    (Math.abs(v) >= 10000 ? v.toLocaleString(undefined, { maximumFractionDigits: 0 }) : v.toFixed(prec)) + unit;

  const dataMin = Math.min(...all), dataMax = Math.max(...all);
  const pad = (dataMax - dataMin || Math.abs(dataMax) || 1) * 0.18;
  const lo = spec.y_min ?? (spec.kind === "line" ? dataMin - pad : Math.min(0, dataMin));
  const hi = spec.y_max ?? dataMax + pad;

  const ticks = niceTicks(lo, hi);
  const yMin = Math.min(lo, ticks[0]);
  const yMax = Math.max(hi, ticks[ticks.length - 1]);
  const tickPrec = precisionFor(ticks);
  const tickLabel = (v: number) => (Math.abs(v) >= 10000 ? v.toLocaleString(undefined, { maximumFractionDigits: 0 }) : v.toFixed(tickPrec));

  const x = (i: number) => padL + (spec.labels.length === 1 ? plotW / 2 : (i * plotW) / (spec.labels.length - 1));
  const y = (v: number) => padT + plotH - ((v - yMin) / (yMax - yMin || 1)) * plotH;
  const showLabels = spec.data_labels !== false;
  const endsOnly = spec.data_labels === "ends";
  /** Indices of the first and last verified point in a series. */
  const endIdx = (values: (number | null)[]) => {
    const filled = values.map((v, i) => (v === null ? -1 : i)).filter((i) => i >= 0);
    return filled.length ? [filled[0], filled[filled.length - 1]] : [];
  };

  return (
    <div style={{ margin: "4px 0 2px", overflowX: "auto" }}>
      <svg viewBox={`0 0 ${W} ${H}`} width="100%" role="img"
        aria-label={`${spec.series.map((s) => s.name).join(", ")} across ${spec.labels.join(", ")}`}
        style={{ display: "block", minWidth: 480 }}>

        {ticks.map((v, i) => (
          <g key={i}>
            <line x1={padL} x2={W - padR} y1={y(v)} y2={y(v)} stroke="var(--rule)" strokeWidth="1" opacity={v === 0 ? 0.95 : 0.4} />
            <text x={padL - 10} y={y(v) + 4} textAnchor="end" fill="var(--dim)"
              style={{ fontFamily: "var(--mono)", fontSize: 10.5 }}>{tickLabel(v)}</text>
          </g>
        ))}

        {spec.labels.map((l, i) => {
          const slot = plotW / spec.labels.length;
          const cx = spec.kind === "line" ? x(i) : padL + slot * i + slot / 2;
          return (
            <text key={i} x={cx} y={H - 15} textAnchor="middle" fill="var(--dim)"
              style={{ fontFamily: "var(--mono)", fontSize: spec.labels.length > 9 ? 9.5 : 10.5, letterSpacing: ".02em" }}>{l}</text>
          );
        })}

        {spec.kind === "line" && (() => {
          // Pass 1 — lines and points.
          const marks = spec.series.map((s, si) => {
            const stroke = TONE[s.tone ?? "struct"];
            const pts = s.values.map((v, i) => (v === null ? null : `${x(i)},${y(v)}`)).filter(Boolean).join(" ");
            return (
              <g key={si}>
                <polyline points={pts} fill="none" stroke={stroke} strokeWidth="2.4" strokeLinejoin="round" strokeLinecap="round" />
                {s.values.map((v, i) => v === null ? null : (
                  <circle key={i} cx={x(i)} cy={y(v)} r={i === s.values.length - 1 ? 4.6 : 3.2} fill={stroke}
                    stroke="var(--panel)" strokeWidth={i === s.values.length - 1 ? 2 : 0} />
                ))}
              </g>
            );
          });

          // Pass 2 — every point carries its value, so labels must be placed
          // with knowledge of each other. Within an x position: order series
          // by their point height, then alternate above/below so neighbouring
          // series push apart rather than stack, and finally enforce a
          // minimum gap in each direction.
          type Lbl = { i: number; px: number; anchorY: number; py: number; text: string; last: boolean; up: boolean };
          const groups = new Map<number, Lbl[]>();
          spec.series.forEach((s) => {
            const ends = endIdx(s.values);
            s.values.forEach((v, i) => {
              if (v === null) return;
              if (!showLabels || (endsOnly && !ends.includes(i))) return;
              const g = groups.get(i) ?? [];
              g.push({ i, px: x(i), anchorY: y(v), py: y(v), text: label(v),
                       last: i === s.values.length - 1, up: true });
              groups.set(i, g);
            });
          });

          const GAP = 12, OFF = 11;
          const plan: Lbl[] = [];
          groups.forEach((g) => {
            g.sort((a, b) => a.anchorY - b.anchorY);
            // Single label at this x: keep it above the point.
            if (g.length === 1) { g[0].py = g[0].anchorY - OFF; plan.push(g[0]); return; }
            g.forEach((l, k) => { l.up = k % 2 === 0; l.py = l.anchorY + (l.up ? -OFF : OFF + 5); });
            // Alternation alone is not enough: a label placed below an upper
            // point and one placed above a lower point can still cross when
            // the two series run close together. Final sweep guarantees the
            // minimum gap regardless of direction.
            g.sort((a, b) => a.py - b.py);
            for (let k = 1; k < g.length; k++) {
              const limit = g[k - 1].py + GAP;
              if (g[k].py < limit) g[k].py = limit;
            }
            plan.push(...g);
          });

          return (
            <g>
              {marks}
              {plan.map((l, k) => (
                <text key={k} x={l.px} y={l.py} textAnchor="middle"
                  fill={l.last ? "var(--key)" : "var(--text)"}
                  style={{ fontFamily: "var(--mono)", fontSize: l.last ? 10.5 : 9.5, fontWeight: l.last ? 700 : 400 }}>
                  {l.text}
                </text>
              ))}
            </g>
          );
        })()}

        {(spec.kind === "bar" || spec.kind === "grouped") && (() => {
          const n = spec.labels.length, k = spec.series.length;
          const slot = plotW / n;
          const bw = Math.min(46, (slot * 0.7) / k);
          const zero = y(Math.max(yMin, 0));
          return spec.series.map((s, si) => (
            <g key={si}>
              {s.values.map((v, i) => {
                if (v === null) return null;
                const cx = padL + slot * i + slot / 2;
                const bx = cx - (k * bw) / 2 + si * bw;
                const top = Math.min(y(v), zero), h = Math.max(2, Math.abs(zero - y(v)));
                return (
                  <g key={i}>
                    <rect x={bx} y={top} width={bw - 4} height={h} rx="2.5" fill={TONE[s.tone ?? "struct"]} opacity={0.9} />
                    {showLabels && (
                      <text x={bx + (bw - 4) / 2} y={(v >= 0 ? top - 7 : top + h + 14)} textAnchor="middle" fill="var(--key)"
                        style={{ fontFamily: "var(--mono)", fontSize: 10.5, fontWeight: 600 }}>{label(v)}</text>
                    )}
                  </g>
                );
              })}
            </g>
          ));
        })()}

        {spec.y_label && (
          <text x={4} y={12} textAnchor="start" fill="var(--dim)"
            style={{ fontFamily: "var(--mono)", fontSize: 9.5, letterSpacing: ".1em" }}>{spec.y_label}</text>
        )}
      </svg>

      {spec.series.length > 1 && (
        <div style={{ display: "flex", gap: 16, flexWrap: "wrap", padding: `4px 0 0 ${padL}px` }}>
          {spec.series.map((s, i) => (
            <span key={i} className="mono" style={{ fontSize: "var(--t-micro)", color: "var(--dim)" }}>
              <span style={{ display: "inline-block", width: 10, height: 10, borderRadius: 2, background: TONE[s.tone ?? "struct"], marginRight: 6, verticalAlign: "-1px" }} />
              {s.name}
            </span>
          ))}
        </div>
      )}
    </div>
  );
}
