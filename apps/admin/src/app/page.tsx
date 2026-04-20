"use client";

import { useEffect, useRef, useState } from "react";
import { Zone, Incident, SystemMetrics, StadiumSimulator } from "@/lib/simulator";

// ─── Sub-components ───────────────────────────────────────────────────────────

function TopBar({ metrics, eventPhase }: { metrics: SystemMetrics; eventPhase: string }) {
  return (
    <header className="flex items-center justify-between px-6 border-b border-[#1e2d3d] bg-[#080c12]/90 backdrop-blur-xl" style={{ gridColumn: "1/-1", height: 56 }}>
      <div className="flex items-center gap-3">
        <div className="flex items-center gap-1.5">
          <div className="w-2 h-2 rounded-full bg-[#22c55e] animate-pulse" />
          <span className="text-xs font-bold tracking-widest text-[#22c55e] uppercase">Live</span>
        </div>
        <div className="w-px h-4 bg-[#1e2d3d]" />
        <span className="font-bold text-[#e8f0fe] text-base tracking-tight">StadiumIQ</span>
        <span className="text-[#4a6278] text-sm">/ D.Y. Patil Stadium · Mumbai</span>
      </div>
      <div className="flex items-center gap-6">
        <Metric label="Attendees" value={metrics.totalAttendees.toLocaleString()} color="#06b6d4" />
        <Metric label="Avg Wait" value={`${metrics.avgWaitTime}m`} color={metrics.avgWaitTime > 10 ? "#f97316" : "#22c55e"} />
        <Metric label="AFS Score" value={metrics.afsScore} color={metrics.afsScore > 60 ? "#ef4444" : metrics.afsScore > 35 ? "#f59e0b" : "#22c55e"} />
        <Metric label="Orders" value={metrics.ordersInFlight} color="#a855f7" />
        <div className="flex items-center gap-2 px-3 py-1 rounded-full border border-[#2a4060] bg-[#111b2a]">
          <div className="w-1.5 h-1.5 rounded-full bg-[#3b82f6]" />
          <span className="text-xs text-[#7c9bb5] uppercase tracking-wider">{eventPhase}</span>
        </div>
        {metrics.activeAlerts > 0 && (
          <div className="flex items-center gap-2 px-3 py-1 rounded-full border border-[#ef4444]/40 bg-[#ef4444]/10 animate-pulse">
            <span className="text-xs font-bold text-[#ef4444]">⚠ {metrics.activeAlerts} ALERT{metrics.activeAlerts > 1 ? "S" : ""}</span>
          </div>
        )}
      </div>
    </header>
  );
}

function Metric({ label, value, color }: { label: string; value: string | number; color: string }) {
  return (
    <div className="text-center">
      <div className="text-xs text-[#4a6278] uppercase tracking-wider">{label}</div>
      <div className="text-sm font-bold" style={{ color }}>{value}</div>
    </div>
  );
}

// ─── Sidebar ──────────────────────────────────────────────────────────────────

function Sidebar({ zones, onSelect, selectedId }: { zones: Zone[]; onSelect: (id: string) => void; selectedId: string | null }) {
  const sortedZones = [...zones]
    .filter((z) => z.type !== "seating")
    .sort((a, b) => b.density - a.density);

  return (
    <aside className="flex flex-col border-r border-[#1e2d3d] bg-[#080c12] overflow-hidden">
      <div className="px-4 py-3 border-b border-[#1e2d3d]">
        <span className="text-xs font-bold text-[#4a6278] uppercase tracking-widest">Zone Monitor</span>
      </div>
      <div className="flex-1 overflow-y-auto">
        {sortedZones.map((zone) => (
          <ZoneRow key={zone.id} zone={zone} selected={selectedId === zone.id} onClick={() => onSelect(zone.id)} />
        ))}
      </div>
    </aside>
  );
}

function ZoneRow({ zone, selected, onClick }: { zone: Zone; selected: boolean; onClick: () => void }) {
  const statusColors: Record<string, string> = { low: "#22c55e", moderate: "#f59e0b", high: "#f97316", critical: "#ef4444" };
  const status = zone.density < 0.4 ? "low" : zone.density < 0.65 ? "moderate" : zone.density < 0.85 ? "high" : "critical";
  const color = statusColors[status];

  return (
    <button
      onClick={onClick}
      className="w-full flex items-center gap-3 px-4 py-2.5 border-b border-[#0d1420] hover:bg-[#0d1420] transition-all text-left"
      style={{ background: selected ? "#111b2a" : undefined, borderLeft: selected ? `2px solid ${color}` : "2px solid transparent" }}
    >
      <div className="relative flex-shrink-0">
        <div className="w-2 h-2 rounded-full" style={{ background: color }} />
        {status === "critical" && (
          <div className="absolute inset-0 w-2 h-2 rounded-full animate-ping" style={{ background: color, opacity: 0.5 }} />
        )}
      </div>
      <div className="flex-1 min-w-0">
        <div className="text-xs font-medium text-[#e8f0fe] truncate">{zone.name}</div>
        <div className="text-[10px] text-[#4a6278] capitalize">{zone.type} · {zone.section}</div>
      </div>
      <div className="flex-shrink-0 text-right">
        <div className="text-xs font-bold" style={{ color }}>{Math.round(zone.density * 100)}%</div>
        {zone.queueMinutes > 0 && <div className="text-[10px] text-[#4a6278]">{zone.queueMinutes}m wait</div>}
      </div>
    </button>
  );
}

// ─── Venue Heatmap ────────────────────────────────────────────────────────────

function VenueHeatmap({ zones, selectedId, onSelect }: { zones: Zone[]; selectedId: string | null; onSelect: (id: string) => void }) {
  const [tooltip, setTooltip] = useState<{ zone: Zone; x: number; y: number } | null>(null);

  const getDensityFill = (density: number) => {
    if (density < 0.4) return "rgba(34,197,94,0.25)";
    if (density < 0.65) return "rgba(245,158,11,0.3)";
    if (density < 0.85) return "rgba(249,115,22,0.35)";
    return "rgba(239,68,68,0.4)";
  };

  const getDensityStroke = (density: number) => {
    if (density < 0.4) return "rgba(34,197,94,0.6)";
    if (density < 0.65) return "rgba(245,158,11,0.7)";
    if (density < 0.85) return "rgba(249,115,22,0.8)";
    return "rgba(239,68,68,0.9)";
  };

  return (
    <div className="flex-1 flex flex-col p-4 overflow-hidden">
      <div className="flex items-center justify-between mb-3">
        <span className="text-xs font-bold text-[#4a6278] uppercase tracking-widest">Live Venue Heatmap</span>
        <div className="flex items-center gap-4">
          {[["Low", "#22c55e"], ["Moderate", "#f59e0b"], ["High", "#f97316"], ["Critical", "#ef4444"]].map(([label, color]) => (
            <div key={label} className="flex items-center gap-1.5">
              <div className="w-2.5 h-2.5 rounded-sm" style={{ background: color, opacity: 0.7 }} />
              <span className="text-[11px] text-[#4a6278]">{label}</span>
            </div>
          ))}
        </div>
      </div>

      <div className="flex-1 rounded-xl border border-[#1e2d3d] bg-[#0a1018] relative overflow-hidden">
        {/* Stadium ring background */}
        <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
          <div className="w-[80%] h-[80%] rounded-full border-2 border-[#1e2d3d]/40" />
          <div className="absolute w-[55%] h-[55%] rounded-full border border-[#1e2d3d]/30" />
        </div>

        <svg className="absolute inset-0 w-full h-full" viewBox="0 0 100 100" preserveAspectRatio="none">
          {/* Grid lines */}
          {[20, 40, 60, 80].map((v) => (
            <g key={v}>
              <line x1={v} y1={0} x2={v} y2={100} stroke="#1e2d3d" strokeWidth="0.2" />
              <line x1={0} y1={v} x2={100} y2={v} stroke="#1e2d3d" strokeWidth="0.2" />
            </g>
          ))}

          {/* Zones */}
          {zones.map((zone) => {
            const isSelected = zone.id === selectedId;
            const isCritical = zone.density >= 0.85;
            return (
              <g key={zone.id}>
                {isCritical && (
                  <rect
                    x={zone.x - 1} y={zone.y - 1}
                    width={zone.width + 2} height={zone.height + 2}
                    fill="none"
                    stroke={getDensityStroke(zone.density)}
                    strokeWidth="0.5"
                    rx="1"
                    opacity="0.5"
                  >
                    <animate attributeName="opacity" values="0.5;0.9;0.5" dur="1.2s" repeatCount="indefinite" />
                  </rect>
                )}
                <rect
                  x={zone.x} y={zone.y}
                  width={zone.width} height={zone.height}
                  fill={getDensityFill(zone.density)}
                  stroke={isSelected ? "#3b82f6" : getDensityStroke(zone.density)}
                  strokeWidth={isSelected ? "0.8" : "0.3"}
                  rx="0.8"
                  style={{ cursor: "pointer", transition: "fill 0.8s ease" }}
                  onClick={() => onSelect(zone.id)}
                />
                {zone.type !== "seating" && zone.type !== "concourse" && (
                  <text
                    x={zone.x + zone.width / 2}
                    y={zone.y + zone.height / 2 + 0.8}
                    textAnchor="middle"
                    fontSize="2.2"
                    fill="white"
                    opacity="0.8"
                    style={{ pointerEvents: "none", fontFamily: "monospace" }}
                  >
                    {Math.round(zone.density * 100)}%
                  </text>
                )}
              </g>
            );
          })}
        </svg>

        {/* Centre pitch label */}
        <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
          <div className="text-center">
            <div className="text-[10px] font-bold text-[#2a4060] tracking-widest uppercase">Main Pitch</div>
          </div>
        </div>

        {/* Compass */}
        <div className="absolute top-3 right-3 text-[10px] text-[#2a4060] font-bold">
          <div className="text-center">N</div>
          <div className="flex gap-3"><span>W</span><span>E</span></div>
          <div className="text-center">S</div>
        </div>
      </div>
    </div>
  );
}

// ─── Right Panel ──────────────────────────────────────────────────────────────

function RightPanel({
  zones,
  incidents,
  selectedId,
  onDispatch,
}: {
  zones: Zone[];
  incidents: Incident[];
  selectedId: string | null;
  onDispatch: (id: string) => void;
}) {
  const selected = zones.find((z) => z.id === selectedId);

  return (
    <aside className="flex flex-col border-l border-[#1e2d3d] bg-[#080c12] overflow-hidden">
      {/* Zone detail */}
      <div className="border-b border-[#1e2d3d] p-4">
        <div className="text-xs font-bold text-[#4a6278] uppercase tracking-widest mb-3">Zone Detail</div>
        {selected ? (
          <ZoneDetail zone={selected} />
        ) : (
          <div className="text-[#4a6278] text-xs text-center py-4">Select a zone on the map or sidebar</div>
        )}
      </div>

      {/* Incident feed */}
      <div className="flex-1 overflow-hidden flex flex-col">
        <div className="px-4 py-3 border-b border-[#1e2d3d] flex items-center justify-between">
          <span className="text-xs font-bold text-[#4a6278] uppercase tracking-widest">Gemini Incidents</span>
          {incidents.filter((i) => i.status === "active").length > 0 && (
            <div className="w-2 h-2 rounded-full bg-[#ef4444] animate-pulse" />
          )}
        </div>
        <div className="flex-1 overflow-y-auto">
          {incidents.length === 0 ? (
            <div className="p-4 text-[#4a6278] text-xs text-center">No incidents detected. All systems nominal.</div>
          ) : (
            incidents.map((inc) => (
              <IncidentCard key={inc.id} incident={inc} onDispatch={onDispatch} />
            ))
          )}
        </div>
      </div>
    </aside>
  );
}

function ZoneDetail({ zone }: { zone: Zone }) {
  const status = zone.density < 0.4 ? "low" : zone.density < 0.65 ? "moderate" : zone.density < 0.85 ? "high" : "critical";
  const statusColors: Record<string, string> = { low: "#22c55e", moderate: "#f59e0b", high: "#f97316", critical: "#ef4444" };
  const color = statusColors[status];
  const pct = Math.round(zone.density * 100);

  return (
    <div className="space-y-3 animate-fade-up">
      <div>
        <div className="font-semibold text-[#e8f0fe] text-sm">{zone.name}</div>
        <div className="text-[11px] text-[#4a6278] capitalize">{zone.type} · {zone.section}</div>
      </div>

      {/* Density bar */}
      <div>
        <div className="flex justify-between mb-1">
          <span className="text-[11px] text-[#7c9bb5]">Density</span>
          <span className="text-[11px] font-bold" style={{ color }}>{pct}%</span>
        </div>
        <div className="h-2 rounded-full bg-[#1e2d3d] overflow-hidden">
          <div
            className="h-full rounded-full transition-all duration-700"
            style={{ width: `${pct}%`, background: `linear-gradient(90deg, ${color}80, ${color})` }}
          />
        </div>
      </div>

      <div className="grid grid-cols-2 gap-2">
        <StatBox label="Capacity" value={zone.capacity.toLocaleString()} />
        <StatBox label="Occupied" value={Math.round(zone.density * zone.capacity).toLocaleString()} />
        <StatBox label="Wait" value={zone.queueMinutes > 0 ? `${zone.queueMinutes} min` : "No queue"} />
        <StatBox label="Trend" value={zone.trend === "rising" ? "↑ Rising" : zone.trend === "falling" ? "↓ Falling" : "→ Stable"} color={zone.trend === "rising" ? "#f97316" : zone.trend === "falling" ? "#22c55e" : "#7c9bb5"} />
      </div>

      <div className={`text-xs px-2 py-1.5 rounded-lg capitalize font-medium badge-${status} text-center`}>
        {status === "critical" ? "⚠ CRITICAL — Intervention Recommended" :
         status === "high" ? "High Density — Monitor Closely" :
         status === "moderate" ? "Moderate — Normal Operations" :
         "Low — All Clear"}
      </div>
    </div>
  );
}

function StatBox({ label, value, color }: { label: string; value: string; color?: string }) {
  return (
    <div className="bg-[#0d1420] border border-[#1e2d3d] rounded-lg px-3 py-2">
      <div className="text-[10px] text-[#4a6278] uppercase tracking-wider">{label}</div>
      <div className="text-xs font-bold mt-0.5" style={{ color: color || "#e8f0fe" }}>{value}</div>
    </div>
  );
}

function IncidentCard({ incident, onDispatch }: { incident: Incident; onDispatch: (id: string) => void }) {
  const severityColor = { 1: "#22c55e", 2: "#f59e0b", 3: "#f97316", 4: "#ef4444" }[incident.severity];
  const typeLabel = { crowd_crush: "Crowd Crush", medical: "Medical", fight: "Fight", fire: "Fire", evacuation: "Evacuation" }[incident.type];

  return (
    <div className="px-4 py-3 border-b border-[#0d1420] animate-slide-in hover:bg-[#0d1420]/50 transition-colors">
      <div className="flex items-start justify-between gap-2 mb-1.5">
        <div className="flex items-center gap-2">
          <div className="w-1.5 h-1.5 rounded-full flex-shrink-0" style={{ background: severityColor }} />
          <span className="text-xs font-bold" style={{ color: severityColor }}>{typeLabel}</span>
          <span className="text-[10px] text-[#4a6278]">SEV-{incident.severity}</span>
        </div>
        <span className={`text-[10px] px-1.5 py-0.5 rounded font-medium ${
          incident.status === "active" ? "bg-red-500/10 text-red-400" :
          incident.status === "responding" ? "bg-amber-500/10 text-amber-400" :
          "bg-green-500/10 text-green-400"
        }`}>
          {incident.status.toUpperCase()}
        </span>
      </div>
      <div className="text-[11px] text-[#7c9bb5] mb-1">{incident.zoneName}</div>
      <div className="text-[10px] text-[#4a6278] leading-relaxed mb-2">{incident.geminiAnalysis}</div>
      {incident.status === "active" && (
        <button
          onClick={() => onDispatch(incident.id)}
          className="w-full text-[11px] py-1.5 rounded-lg font-bold text-white transition-all hover:opacity-90 active:scale-95"
          style={{ background: `linear-gradient(135deg, ${severityColor}90, ${severityColor})` }}
        >
          Dispatch Staff →
        </button>
      )}
      {incident.staffAssigned > 0 && (
        <div className="text-[10px] text-[#22c55e]">{incident.staffAssigned} staff assigned</div>
      )}
    </div>
  );
}

// ─── Bottom Stats Bar ─────────────────────────────────────────────────────────

function BottomBar({ zones }: { zones: Zone[] }) {
  const types = ["gate", "concession", "restroom", "concourse"] as const;
  return (
    <div className="flex border-t border-[#1e2d3d] bg-[#080c12]" style={{ gridColumn: "2/3", height: 72 }}>
      {types.map((type) => {
        const typeZones = zones.filter((z) => z.type === type);
        const avgDensity = typeZones.length ? typeZones.reduce((s, z) => s + z.density, 0) / typeZones.length : 0;
        const pct = Math.round(avgDensity * 100);
        const color = avgDensity < 0.4 ? "#22c55e" : avgDensity < 0.65 ? "#f59e0b" : avgDensity < 0.85 ? "#f97316" : "#ef4444";
        const icons: Record<string, string> = { gate: "🚪", concession: "🍺", restroom: "🚻", concourse: "🏟" };
        return (
          <div key={type} className="flex-1 flex items-center gap-3 px-5 border-r border-[#1e2d3d] last:border-r-0">
            <span className="text-xl">{icons[type]}</span>
            <div className="flex-1">
              <div className="flex justify-between mb-1">
                <span className="text-[11px] text-[#7c9bb5] capitalize">{type}s avg</span>
                <span className="text-[11px] font-bold" style={{ color }}>{pct}%</span>
              </div>
              <div className="h-1.5 rounded-full bg-[#1e2d3d] overflow-hidden">
                <div className="h-full rounded-full transition-all duration-700" style={{ width: `${pct}%`, background: color }} />
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}

// ─── Main Dashboard ───────────────────────────────────────────────────────────

export default function Dashboard() {
  const [zones, setZones] = useState<Zone[]>([]);
  const [incidents, setIncidents] = useState<Incident[]>([]);
  const [metrics, setMetrics] = useState<SystemMetrics>({ totalAttendees: 0, activeAlerts: 0, avgWaitTime: 0, afsScore: 0, reroutes: 0, ordersInFlight: 0 });
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [eventPhase, setEventPhase] = useState("LIVE");
  const tickRef = useRef(0);

  const simulatorRef = useRef<StadiumSimulator | null>(null);

  useEffect(() => {
    if (!simulatorRef.current) {
      simulatorRef.current = new StadiumSimulator();
    }
    const unsub = simulatorRef.current.subscribe((z, inc, m) => {
      setZones(z);
      setIncidents(inc);
      setMetrics(m);
      tickRef.current++;
      const phase = tickRef.current % 120;
      setEventPhase(phase < 10 ? "PRE-MATCH" : phase < 25 ? "INGRESS" : phase < 55 ? "1ST HALF" : phase < 70 ? "HALFTIME" : phase < 90 ? "2ND HALF" : phase < 110 ? "EGRESS" : "POST-MATCH");
    });
    const interval = simulatorRef.current.start(3000);
    return () => { clearInterval(interval); unsub(); };
  }, []);

  const handleDispatch = (id: string) => {
    if (simulatorRef.current) {
        simulatorRef.current.dispatchStaff(id);
    }
  };

  return (
    <div style={{
      display: "grid",
      gridTemplateColumns: "260px 1fr 320px",
      gridTemplateRows: "56px 1fr 72px",
      height: "100vh",
      background: "#080c12",
      overflow: "hidden",
    }}>
      {/* Row 1: Top bar */}
      <div style={{ gridColumn: "1/-1", gridRow: 1 }}>
        <TopBar metrics={metrics} eventPhase={eventPhase} />
      </div>

      {/* Row 2: Sidebar | Map | Right Panel */}
      <div style={{ gridColumn: 1, gridRow: 2, overflow: "hidden", display: "flex", flexDirection: "column" }}>
        <Sidebar zones={zones} onSelect={setSelectedId} selectedId={selectedId} />
      </div>

      <div style={{ gridColumn: 2, gridRow: 2, overflow: "hidden", display: "flex", flexDirection: "column" }}>
        <VenueHeatmap zones={zones} selectedId={selectedId} onSelect={setSelectedId} />
      </div>

      <div style={{ gridColumn: 3, gridRow: 2, overflow: "hidden", display: "flex", flexDirection: "column" }}>
        <RightPanel zones={zones} incidents={incidents} selectedId={selectedId} onDispatch={handleDispatch} />
      </div>

      {/* Row 3: Bottom bar */}
      <div style={{ gridColumn: "1/-1", gridRow: 3 }}>
        <BottomBar zones={zones} />
      </div>
    </div>
  );
}
