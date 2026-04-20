/**
 * StadiumIQ — Zone Density Simulator
 * Generates synthetic crowd density data mimicking BLE + Wi-Fi probe fusion.
 * Powers the admin dashboard without real hardware.
 */

export type ZoneStatus = "low" | "moderate" | "high" | "critical";

export interface Zone {
  id: string;
  name: string;
  section: string;
  type: "concourse" | "gate" | "restroom" | "concession" | "seating" | "exit";
  capacity: number;
  density: number; // 0.0 - 1.0
  trend: "rising" | "stable" | "falling";
  queueMinutes: number;
  lastUpdated: number;
  x: number; // SVG layout position %
  y: number;
  width: number;
  height: number;
  source: "ble" | "wifi" | "cctv" | "pos";
}

export interface Incident {
  id: string;
  zoneId: string;
  zoneName: string;
  type: "crowd_crush" | "medical" | "fight" | "fire" | "evacuation";
  severity: 1 | 2 | 3 | 4;
  detectedAt: number;
  status: "active" | "responding" | "resolved";
  geminiAnalysis: string;
  staffAssigned: number;
}

export interface SystemMetrics {
  totalAttendees: number;
  activeAlerts: number;
  avgWaitTime: number;
  afsScore: number; // Attendee Friction Score 0-100 (lower = better)
  reroutes: number;
  ordersInFlight: number;
}

// Venue layout — D.Y. Patil Stadium inspired
const INITIAL_ZONES: Zone[] = [
  { id: "G1", name: "Gate A North", section: "North", type: "gate", capacity: 3000, density: 0.15, trend: "stable", queueMinutes: 1, lastUpdated: Date.now(), x: 42, y: 2, width: 16, height: 6, source: "wifi" },
  { id: "G2", name: "Gate B East", section: "East", type: "gate", capacity: 3000, density: 0.72, trend: "rising", queueMinutes: 14, lastUpdated: Date.now(), x: 88, y: 42, width: 6, height: 16, source: "wifi" },
  { id: "G3", name: "Gate C South", section: "South", type: "gate", capacity: 3000, density: 0.31, trend: "stable", queueMinutes: 4, lastUpdated: Date.now(), x: 42, y: 92, width: 16, height: 6, source: "wifi" },
  { id: "G4", name: "Gate D West", section: "West", type: "gate", capacity: 3000, density: 0.88, trend: "rising", queueMinutes: 22, lastUpdated: Date.now(), x: 2, y: 42, width: 6, height: 16, source: "wifi" },

  { id: "C1", name: "Concession Stand 7", section: "North", type: "concession", capacity: 500, density: 0.45, trend: "stable", queueMinutes: 8, lastUpdated: Date.now(), x: 20, y: 20, width: 12, height: 8, source: "ble" },
  { id: "C2", name: "Concession Stand 12", section: "East", type: "concession", capacity: 500, density: 0.08, trend: "falling", queueMinutes: 0, lastUpdated: Date.now(), x: 68, y: 20, width: 12, height: 8, source: "pos" },
  { id: "C3", name: "Food Court South", section: "South", type: "concession", capacity: 800, density: 0.91, trend: "rising", queueMinutes: 19, lastUpdated: Date.now(), x: 35, y: 68, width: 16, height: 10, source: "pos" },
  { id: "C4", name: "Premium Bar West", section: "West", type: "concession", capacity: 300, density: 0.55, trend: "stable", queueMinutes: 7, lastUpdated: Date.now(), x: 12, y: 35, width: 10, height: 8, source: "ble" },

  { id: "R1", name: "Restroom Block A", section: "North", type: "restroom", capacity: 200, density: 0.62, trend: "rising", queueMinutes: 5, lastUpdated: Date.now(), x: 60, y: 20, width: 8, height: 6, source: "ble" },
  { id: "R2", name: "Restroom Block B", section: "East", type: "restroom", capacity: 200, density: 0.38, trend: "stable", queueMinutes: 2, lastUpdated: Date.now(), x: 72, y: 55, width: 8, height: 6, source: "ble" },
  { id: "R3", name: "Restroom Block C", section: "South", type: "restroom", capacity: 200, density: 0.79, trend: "rising", queueMinutes: 8, lastUpdated: Date.now(), x: 20, y: 68, width: 8, height: 6, source: "ble" },

  { id: "K1", name: "North Concourse", section: "North", type: "concourse", capacity: 8000, density: 0.28, trend: "stable", queueMinutes: 0, lastUpdated: Date.now(), x: 25, y: 14, width: 50, height: 12, source: "cctv" },
  { id: "K2", name: "East Concourse", section: "East", type: "concourse", capacity: 8000, density: 0.67, trend: "rising", queueMinutes: 0, lastUpdated: Date.now(), x: 68, y: 30, width: 14, height: 40, source: "cctv" },
  { id: "K3", name: "South Concourse", section: "South", type: "concourse", capacity: 8000, density: 0.44, trend: "stable", queueMinutes: 0, lastUpdated: Date.now(), x: 22, y: 74, width: 56, height: 12, source: "wifi" },
  { id: "K4", name: "West Concourse", section: "West", type: "concourse", capacity: 8000, density: 0.22, trend: "falling", queueMinutes: 0, lastUpdated: Date.now(), x: 14, y: 28, width: 14, height: 44, source: "cctv" },

  { id: "S1", name: "Main Field / Pitch", section: "Centre", type: "seating", capacity: 20000, density: 0.95, trend: "stable", queueMinutes: 0, lastUpdated: Date.now(), x: 28, y: 28, width: 44, height: 44, source: "cctv" },
];

export function getDensityStatus(density: number): ZoneStatus {
  if (density < 0.4) return "low";
  if (density < 0.65) return "moderate";
  if (density < 0.85) return "high";
  return "critical";
}

export function getDensityColor(density: number): string {
  const s = getDensityStatus(density);
  return {
    low: "#22c55e",
    moderate: "#f59e0b",
    high: "#f97316",
    critical: "#ef4444",
  }[s];
}

export function getQueueMinutes(density: number, type: Zone["type"]): number {
  if (type === "seating" || type === "concourse") return 0;
  const base = density * 25;
  return Math.max(0, Math.round(base + (Math.random() - 0.5) * 3));
}

// Simulate realistic crowd wave behavior
function evolveZone(zone: Zone, tick: number): Zone {
  const eventPhase = getEventPhase(tick);
  let delta = (Math.random() - 0.48) * 0.04;

  // Phase-driven behavior
  if (eventPhase === "ingress" && (zone.type === "gate" || zone.type === "concourse")) {
    delta += 0.03;
  }
  if (eventPhase === "halftime") {
    if (zone.type === "concession" || zone.type === "restroom") delta += 0.05;
    if (zone.type === "gate") delta -= 0.02;
  }
  if (eventPhase === "egress" && zone.type === "exit") {
    delta += 0.06;
  }

  const newDensity = Math.max(0.02, Math.min(0.99, zone.density + delta));
  const trend: Zone["trend"] =
    Math.abs(delta) < 0.01 ? "stable" : delta > 0 ? "rising" : "falling";
  const queueMinutes = getQueueMinutes(newDensity, zone.type);

  return { ...zone, density: newDensity, trend, queueMinutes, lastUpdated: Date.now() };
}

type EventPhase = "pre" | "ingress" | "live" | "halftime" | "egress" | "post";

function getEventPhase(tick: number): EventPhase {
  // Each tick = 3s. Simulate a full match cycle over ~120 ticks (6 min demo loop)
  const phase = tick % 120;
  if (phase < 10) return "pre";
  if (phase < 25) return "ingress";
  if (phase < 55) return "live";
  if (phase < 70) return "halftime";
  if (phase < 90) return "live";
  if (phase < 110) return "egress";
  return "post";
}

// Simulator class — drives the entire fake data layer
export class StadiumSimulator {
  private zones: Zone[] = JSON.parse(JSON.stringify(INITIAL_ZONES));
  private incidents: Incident[] = [];
  private tick = 0;
  private callbacks: Set<(zones: Zone[], incidents: Incident[], metrics: SystemMetrics) => void> = new Set();

  subscribe(cb: (zones: Zone[], incidents: Incident[], metrics: SystemMetrics) => void) {
    this.callbacks.add(cb);
    return () => this.callbacks.delete(cb);
  }

  private broadcast() {
    const metrics = this.computeMetrics();
    this.callbacks.forEach((cb) => cb([...this.zones], [...this.incidents], metrics));
  }

  private computeMetrics(): SystemMetrics {
    const totalAttendees = Math.round(
      this.zones.reduce((sum, z) => sum + z.density * z.capacity, 0)
    );
    const waitZones = this.zones.filter((z) => z.queueMinutes > 0);
    const avgWait = waitZones.length
      ? Math.round(waitZones.reduce((s, z) => s + z.queueMinutes, 0) / waitZones.length)
      : 0;
    const densitySum = this.zones.reduce((s, z) => s + z.density * z.density, 0);
    const afsScore = Math.round(Math.min(100, (densitySum / this.zones.length) * 100));

    return {
      totalAttendees,
      activeAlerts: this.incidents.filter((i) => i.status === "active").length,
      avgWaitTime: avgWait,
      afsScore,
      reroutes: Math.floor(totalAttendees * 0.003),
      ordersInFlight: Math.floor(Math.random() * 80) + 20,
    };
  }

  private maybeSpawnIncident() {
    if (Math.random() > 0.015) return; // ~1.5% chance per tick
    const criticalZones = this.zones.filter((z) => z.density > 0.82 && z.type !== "seating");
    if (!criticalZones.length) return;
    const zone = criticalZones[Math.floor(Math.random() * criticalZones.length)];
    const types: Incident["type"][] = ["crowd_crush", "medical", "fight", "fire", "evacuation"];
    const type = types[Math.floor(Math.random() * types.length)];
    const analysisMap: Record<Incident["type"], string> = {
      crowd_crush: "Gemini Vision: Detected abnormal density gradient. Crowd compression pattern emerging. Recommend immediate zone evacuation protocol.",
      medical: "Gemini Vision: Individual detected in distress. Surrounding crowd exhibiting response behavior. Medical team dispatch required.",
      fight: "Gemini Vision: Altercation detected between 2-3 individuals. Security intervention recommended. Adjacent crowd moving away.",
      fire: "Gemini Vision: Smoke and heat signature anomaly detected near concession zone. Trigger fire response and clear adjacent paths.",
      evacuation: "Gemini Vision: Multi-zone risk detected. Controlled evacuation route recommendations generated for nearest exits.",
    };
    const analysis = analysisMap[type];

    const incident: Incident = {
      id: `INC-${Date.now()}`,
      zoneId: zone.id,
      zoneName: zone.name,
      type,
      severity: zone.density > 0.9 ? 4 : zone.density > 0.8 ? 3 : 2,
      detectedAt: Date.now(),
      status: "active",
      geminiAnalysis: analysis,
      staffAssigned: 0,
    };
    this.incidents = [incident, ...this.incidents.slice(0, 9)];
  }

  tick3s() {
    this.tick++;
    this.zones = this.zones.map((z) => evolveZone(z, this.tick));
    this.maybeSpawnIncident();
    // Auto-resolve old incidents
    this.incidents = this.incidents.map((inc) => {
      if (inc.status === "active" && Date.now() - inc.detectedAt > 15000) {
        return { ...inc, status: "responding", staffAssigned: inc.severity * 2 };
      }
      if (inc.status === "responding" && Date.now() - inc.detectedAt > 45000) {
        return { ...inc, status: "resolved" };
      }
      return inc;
    });
    this.broadcast();
  }

  start(intervalMs = 3000) {
    this.broadcast(); // immediate first emit
    return setInterval(() => this.tick3s(), intervalMs);
  }

  getZones() { return [...this.zones]; }
  getIncidents() { return [...this.incidents]; }
  dispatchStaff(incidentId: string) {
    this.incidents = this.incidents.map((i) =>
      i.id === incidentId ? { ...i, status: "responding", staffAssigned: i.severity * 2 } : i
    );
    this.broadcast();
  }
}
