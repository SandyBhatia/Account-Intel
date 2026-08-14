// ============================================================
// Exhibit charts — server-rendered SVG, no client JS, no chart lib.
// Ported from the pilot dashboard so baselines can carry visuals.
// Schema in a baseline exhibit:
//   "chart": { "kind":"line"|"bar"|"grouped",
//              "labels":["Q3'23", ...],
//              "series":[{ "name":"OR %", "values":[62.0, ...], "tone":"struct"|"go"|"stop"|"dim" }],
//              "y_label":"%", "y_min":58, "y_max":66, "annotate_last":true }
// ============================================================

export interface ChartSpec {
  kind: "line" | "bar" | "grouped";
  labels: string[];
  series: { name: string; values: (number | null)[]; tone?: "struct" | "go" | "stop" | "dim" }[];
  y_label?: string;
  y_min?: number;
  y_max?: number;
  annotate_last?: boolean;
  unit?: string;
}

const TONE: Record<string, string> = {
  struct: "var(--struct)", go: "var(--go)", stop: "var(--stop)", dim: "var(--dim)",
};

export default function ExhibitChart({ spec }: { spec: ChartSpec }) {
  const W = 760, H = 260;
  const padL = 52, padR = 18, padT = 18, padB = 40;
  const plotW = W - padL - padR, plotH = H - padT - padB;

  const all = spec.series.flatMap((s) => s.values).filter((v): v is number => v !== null && Number.isFinite(v));
  if (all.length === 0 || spec.labels.length === 0) return null;

  const rawMin = spec.y_min ?? Math.min(...all);
  const rawMax = spec.y_max ?? Math.max(...all);
  const span = rawMax - rawMin || 1;
  // Bars must be read against zero or they lie about proportion; lines may be zoomed.
  const yMin = spec.kind === "line" ? rawMin - span * 0.15 : (spec.y_min ?? Math.min(0, rawMin));
  const yMax = rawMax + span * 0.15;

  const x = (i: number) => padL + (spec.labels.length === 1 ? plotW / 2 : (i * plotW) / (spec.labels.length - 1));
  const y = (v: number) => padT + plotH - ((v - yMin) / (yMax - yMin)) * plotH;

  const ticks = 4;
  const gridVals = Array.from({ length: ticks + 1 }, (_, i) => yMin + ((yMax - yMin) * i) / ticks);
  const fmt = (v: number) => (Math.abs(v) >= 1000 ? v.toLocaleString(undefined, { maximumFractionDigits: 0 }) : v.toFixed(Math.abs(v) < 10 ? 1 : 0));

  return (
    <div style={{ margin: "6px 0 2px", overflowX: "auto" }}>
      <svg viewBox={`0 0 ${W} ${H}`} width="100%" role="img"
        aria-label={`${spec.series.map((s) => s.name).join(", ")} across ${spec.labels.join(", ")}`}
        style={{ display: "block", minWidth: 420 }}>
        {/* gridlines + y axis */}
        {gridVals.map((v, i) => (
          <g key={i}>
            <line x1={padL} x2={W - padR} y1={y(v)} y2={y(v)} stroke="var(--rule)" strokeWidth="1" opacity={i === 0 ? 0.9 : 0.45} />
            <text x={padL - 9} y={y(v) + 4} textAnchor="end" fill="var(--dim)"
              style={{ fontFamily: "var(--mono)", fontSize: 10.5 }}>{fmt(v)}</text>
          </g>
        ))}

        {/* x labels — thinned when crowded so they never collide */}
        {spec.labels.map((l, i) => {
          const step = Math.ceil(spec.labels.length / 13);
          if (i % step !== 0 && i !== spec.labels.length - 1) return null;
          return (
            <text key={i} x={x(i)} y={H - 14} textAnchor="middle" fill="var(--dim)"
              style={{ fontFamily: "var(--mono)", fontSize: 10.5, letterSpacing: ".03em" }}>{l}</text>
          );
        })}

        {spec.kind === "line" && spec.series.map((s, si) => {
          const stroke = TONE[s.tone ?? "struct"];
          const pts = s.values.map((v, i) => (v === null ? null : `${x(i)},${y(v)}`)).filter(Boolean).join(" ");
          return (
            <g key={si}>
              <polyline points={pts} fill="none" stroke={stroke} strokeWidth="2.4" strokeLinejoin="round" strokeLinecap="round" />
              {s.values.map((v, i) => v === null ? null : (
                <circle key={i} cx={x(i)} cy={y(v)} r={i === s.values.length - 1 ? 4.6 : 3} fill={stroke}
                  stroke="var(--panel)" strokeWidth={i === s.values.length - 1 ? 2 : 0} />
              ))}
              {spec.annotate_last && (() => {
                const li = s.values.length - 1; const lv = s.values[li];
                if (lv === null) return null;
                return <text x={x(li)} y={y(lv) - 13} textAnchor="end" fill="var(--key)"
                  style={{ fontFamily: "var(--mono)", fontSize: 12, fontWeight: 700 }}>{fmt(lv)}{spec.unit ?? ""}</text>;
              })()}
            </g>
          );
        })}

        {(spec.kind === "bar" || spec.kind === "grouped") && (() => {
          const n = spec.labels.length, k = spec.series.length;
          const slot = plotW / n;
          const bw = Math.min(38, (slot * 0.66) / k);
          const zero = y(Math.max(yMin, 0));
          return spec.series.map((s, si) => (
            <g key={si}>
              {s.values.map((v, i) => {
                if (v === null) return null;
                const cx = padL + slot * i + slot / 2;
                const bx = cx - (k * bw) / 2 + si * bw;
                const top = Math.min(y(v), zero), h = Math.max(2, Math.abs(zero - y(v)));
                return (
                  <rect key={i} x={bx} y={top} width={bw - 3} height={h} rx="2.5"
                    fill={TONE[s.tone ?? "struct"]} opacity={0.88} />
                );
              })}
            </g>
          ));
        })()}

        {spec.y_label && (
          <text x={padL - 9} y={padT - 5} textAnchor="end" fill="var(--dim)"
            style={{ fontFamily: "var(--mono)", fontSize: 9.5, letterSpacing: ".1em" }}>{spec.y_label}</text>
        )}
      </svg>

      {spec.series.length > 1 && (
        <div style={{ display: "flex", gap: 16, flexWrap: "wrap", padding: "4px 0 0 52px" }}>
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
