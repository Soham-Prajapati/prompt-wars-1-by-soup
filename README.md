# STADIUMIQ: Intelligent Venue Experience
**Product Requirements Document · v1.0**

---

## 01 / EXECUTIVE SUMMARY & PROBLEM SPACE

### 1.1 Core Problem Statement
Large-scale venues (50,000–100,000 attendees) operate with almost zero real-time intelligence available to the fan. This creates a cascade of pain points: gate choke points, concession blind spots, and post-event egress nightmares.

| Pain Point | Current State | Impact (Fan) | Severity |
| :--- | :--- | :--- | :--- |
| **Gate Congestion** | Manual scanners, no flow data | 22 min avg wait | **CRITICAL** |
| **Concession Blind Spots**| No demand forecasting | 18 min avg wait | **HIGH** |
| **Restroom Bottlenecks** | No occupancy data | Missed game moments | **HIGH** |
| **Emergency Egress** | Paper maps + PA announcements | Safety risk | **CRITICAL** |
| **Post-event Exit** | Static signage only | 40–60 min delay | **HIGH** |

### 1.2 Why Now
* **Google Immersive View:** AR APIs now available in India for indoor venues.
* **Flutter 3.x + Impeller:** 120fps UI with true platform widget embedding.
* **Gemini 2.5 Pro:** Multimodal reasoning for CCTV analysis at <300ms latency.
* **Supabase Realtime v2:** Supports 1M+ concurrent WebSocket connections.
* **Unified Payments:** UPI + Razorpay enables viable in-seat ordering.

---

## 02 / PRODUCT VISION & NORTH STAR

> "Every fan at every stadium deserves the same intelligence that a venue operations director has — available in their pocket, proactive, predictive, and personalized."

The North Star metric is the **Attendee Friction Score (AFS)**. StadiumIQ aims to reduce AFS by **70%** within one full event season.

| Pillar | Description | Primary Tech |
| :--- | :--- | :--- |
| **Predict** | Anticipate crowd density & queue length | Vertex AI + IoT BLE |
| **Navigate** | AR turn-by-turn indoor routing | Google Maps Indoor + ARCore |
| **Serve** | In-seat ordering & optimized routing | Flutter + Razorpay + Supabase |
| **Alert** | Proactive push/haptic safety events | FCM + Telegram + Wear OS |
| **Operate** | Live ops dashboard with AI dispatch | Next.js + Gemini |

---

## 03 / TARGET USERS & PERSONAS

* **P1: The Passionate Fan:** Needs live score overlays and the fastest beer/restroom routes.
* **P2: The Family Organizer:** Needs accessible routing, lost-child alerts, and group coordination.
* **P3: Venue Ops Manager:** Needs a "God-view" of hotspots and automated staff dispatch.
* **P4: Casual First-Timer:** Needs zero-learning-curve AR wayfinding from metro to seat.
* **P5: Accessibility User:** Requires elevator-only routing and audio cues (non-negotiable).

---

## 04 / SYSTEM ARCHITECTURE OVERVIEW

### 4.1 High-Level Architecture (Layer Model)
* **Layer 0 (Physical):** BLE mesh, Wi-Fi probes, CCTV, IoT occupancy sensors.
* **Layer 1 (Edge):** Google Distributed Cloud Edge, MediaPipe on-device detection.
* **Layer 2 (Cloud):** Pub/Sub ingestion (500K msg/sec), Dataflow (Apache Beam), BigQuery.
* **Layer 3 (AI):** Vertex AI (Forecasting), Gemini 2.5 Pro (Vision/Dispatch).
* **Layer 4 (Backend):** FastAPI + Supabase (Postgres/Realtime/Auth), Redis cache.
* **Layer 5 (Client):** Flutter (Mobile/Wear/TV), Next.js (Admin), Telegram Bot.

### 4.2 Real-Time Data Flow Pipeline

| Stage | Description | Output SLA |
| :--- | :--- | :--- |
| **Ingest** | Sensor/CCTV/POS events → Pub/Sub | — |
| **Process** | Dataflow: enrich and aggregate per-zone | < 50ms |
| **Store** | BigQuery (Analytics) + Redis (Live State) | < 100ms |
| **Infer** | Vertex AI 8-min density prediction | < 30s cycle |
| **Push** | Supabase Realtime broadcast to Flutter | < 200ms |
| **Notify** | FCM + Telegram + Wear OS haptic | < 800ms |

---

## 05 / TECHNOLOGY STACK

### 5.1 Mobile (Flutter)
* **State:** `flutter_riverpod` (AsyncNotifier)
* **Navigation:** `go_router`
* **Maps/AR:** `Maps_flutter`, `ar_flutter_plugin`
* **Local Storage:** `sqflite` (Tickets), `hive` (Settings)

### 5.2 Backend & Infrastructure
* **API:** FastAPI (Python 3.12)
* **Database:** Supabase (PostgreSQL 16 + `pgvector`)
* **Compute:** GKE Autopilot (K8s)
* **DevOps:** Terraform, GitHub Actions, Fastlane

---

## 06 / CORE FEATURES

### 6.1 AI Crowd Flow Intelligence
A multi-sensor fusion system producing a live per-zone density score every 5 seconds.
* **Sources:** BLE RSSI triangulation, Wi-Fi probe density, turnstile streams, and MediaPipe CCTV detection.
* **UI:** Live heatmap overlay on Google Maps Indoor SVG layer.

### 6.2 Predictive Queue Engine
* **Tech:** BigQuery ML ARIMA+ trained on POS velocity.
* **Feature:** Smart suggestions (e.g., "Stand 12 has 0 queue — 80m walk").

### 6.3 AR Indoor Navigation
* **Visual Positioning System (VPS):** CM-level accuracy near landmarks.
* **Dynamic Rerouting:** If zone density > 0.8, the route recalculates via quieter corridors.

### 6.4 Smart Vendor & In-Seat Delivery
* **QR Integration:** Seat QR auto-populates section/row/seat.
* **Logistics:** Delivery staff use Google Route Optimization API for multi-order paths.

### 6.5 Telegram Bot Companion
Accessible zero-friction entry via `/start`. Supports `/queue`, `/nav`, and `/order` via inline keyboards.

---

## 07 / NON-FUNCTIONAL REQUIREMENTS

* **Availability:** 99.9% during event hours.
* **Latency:** Sensor-to-fan app ≤ 800ms.
* **Scale:** 80,000 concurrent WebSocket connections.
* **Security:** PII encrypted (AES-256), TLS 1.3 in transit, Supabase RLS policies.

---

## 08 / AI & ML DEEP DIVE

| Integration | Model | Use Case |
| :--- | :--- | :--- |
| **Incident Detection** | Gemini 2.5 Pro Vision | Detects fights, medical events, or fire in CCTV frames. |
| **Staff Dispatch** | Gemini 2.5 Flash | Generates radio-style NL instructions from incident data. |
| **Fan Assistant** | Gemini 2.5 Flash | NL fallback for Telegram bot queries. |
| **FAQ Search** | Vertex AI Matching Engine | Semantic search across venue policies. |

---

## 09 / API DESIGN

**Base URL:** `https://api.stadiumiq.app/v1/`

* `GET /venues/{id}/zones/density`: Real-time density state.
* `POST /venues/{id}/navigate`: Compute route avoiding dense zones.
* `POST /admin/broadcast`: Tiered emergency alert system.

---

## 10 / DATABASE SCHEMA (KEY TABLES)

* `venues`: Metadata, capacity, floor plans.
* `zones`: Geometry, max capacity, beacon mappings.
* `zone_density_snapshots`: Historical and predicted density scores.
* `incidents`: Severity (1-4), Gemini analysis, assigned staff.

---

## 11 / ANTIGRAVITY RULES (DEVELOPMENT PROTOCOL)

* **AG-01 (Stack Lock):** Flutter-only, FastAPI backend.
* **AG-02 (State):** Riverpod 2.x AsyncNotifier mandatory.
* **AG-04 (Realtime):** Supabase Realtime subscriptions, no polling.
* **AG-07 (Offline):** Every feature must implement `sqflite`/`hive` fallback.

---

## 12 / TASK BREAKDOWN (ATOMIC TO-DO)

### P0 (Critical Path)
* [ ] Set up Clean Architecture & Supabase RLS.
* [ ] Implement BLE beacon simulator for development.
* [ ] Build `zone_density_snapshots` Dataflow writer.
* [ ] Create Order Flow: QR scan → Razorpay → WebSocket status.

### P1 (Enhancements)
* [ ] Implement AR Live View arrows at 60fps.
* [ ] Build Wear OS haptic alert handler.
* [ ] Configure Gemini 2.5 Pro Vision for CCTV frame analysis.

---

## 13 / SUCCESS METRICS

* **Wait Time Reduction:** Target ≥ 60% vs baseline.
* **Emergency Response:** Target < 90 seconds from incident to dispatch.
* **App Reliability:** 99.5% crash-free rate.

---

## 14 / RISK REGISTER

* **BLE Drift:** Mitigated by Kalman filter smoothing and Wi-Fi probe fallback.
* **High Concurrency:** Mitigated by Redis Pub/Sub fallback and Supabase Enterprise scaling.
* **Maps Availability:** Fallback to custom SVG venue layouts if Indoor Maps is unavailable.

---

## 15 / APPENDIX: PROMPT TEMPLATES

### CCTV Incident Detection (System Prompt)
> "You are an AI safety analyst monitoring a live sporting venue... Detect: crowd_crush, fight, medical, fire... Return ONLY JSON."

---

## 16 / EXTENDED INTELLIGENCE LAYER (SYSTEM UPGRADE)

### 16.1 CrowdOS Concept
StadiumIQ evolves into a **Venue Operating System** where the crowd is the dynamic input and the AI agents serve as the OS kernel.

### 16.2 AI Orchestration Agents
* **Flow Optimizer:** Redistributes crowd.
* **Safety Sentinel:** Monitors anomalies.
* **Ops Co-Pilot:** Assists admins via NL chat.

### 16.3 Emergency Intelligence Mode
In a crisis, the system overrides all navigation to guide fans to the safest exits while coordinating staff positions in real-time.

---
**Prepared by:** Soham Bhavesh Prajapati
**Institution:** SPIT Mumbai
*"The stadium of tomorrow doesn't have queues. It has intelligence."*


## 17 / CLOSED-LOOP CONTROL SYSTEM

CrowdOS operates as a real-time feedback control loop — every routing output becomes the next cycle's crowd input.

```
Input    →  Crowd movement
Process  →  AI prediction + route computation  
Output   →  User nudges (re-routes, alerts, incentives)
Feedback →  Updated crowd distribution
```

**Objective:** Minimise global congestion `C(t) = Σ(zone_density²)`

---

## 18 / DEGRADED OPERATION MODES

| Mode | Name | Behaviour |
| :--- | :--- | :--- |
| **1** | Full System | All cloud AI active |
| **2** | AI Degraded | Vertex AI offline → rule-based routing |
| **3** | Network Degraded | Offline cached maps + last-known density |
| **4** | Emergency Mode | Edge-only evacuation, no cloud dependency |

**Failover chain:** Vertex AI → Rule Engine → Static Heuristics

---

## 19 / OBSERVABILITY & TELEMETRY

**Metrics:** Route success rate · Prediction MAE · Alert precision/recall · Reroute compliance %

**Tracing:** End-to-end latency span (sensor → Pub/Sub → Dataflow → Supabase → Flutter client)

**Logging:** Per-zone anomaly logs via Cloud Logging (structured JSON, severity-tagged)

**Dashboard:** Real-time SLO compliance in Cloud Monitoring; post-event Looker Studio reports

---

## 20 / EVENT SCHEMA

All system messages follow a unified envelope:

```json
{
  "event_type": "zone_density_update",
  "zone_id": "C7",
  "timestamp": "2025-11-15T20:32:00Z",
  "payload": {
    "density": 0.82,
    "person_count": 410,
    "predicted_8min": 0.91,
    "alert_level": "warning"
  },
  "source": "wifi"
}
```

**Valid `source` values:** `ble` | `wifi` | `cctv` | `pos`

---

## 21 / ABUSE & EDGE CASE HANDLING

- **Fake crowd injection:** ≥2 independent sensor sources required before alert escalation
- **Bot traffic:** Redis rate limiter + device fingerprinting on report endpoints
- **Rate limiting:** 1,000 req/min per user enforced at API gateway
- **Queue fraud:** Trust score weighting — new users have low influence on crowd-sourced reports
- **False alerts:** Gemini Vision + BLE cross-check required before TIER 3/4 escalation

---

## 22 / AI EXPLAINABILITY

Every AI-driven action surfaces a plain-language reason.

**Fan-facing example:**
> *"We suggested Gate B because Gate D is at 88% capacity right now — saves you ~9 minutes."*

**Admin view:**
- Feature importance scores per density prediction
- Confidence intervals on 8-minute forecasts
- Incident detection confidence % with source frame reference

---

## 23 / GROUP DYNAMICS ENGINE

- **Shared routing:** All group members receive the same live route, updated in sync
- **Split detection:** Alert fired if members diverge beyond 50m; re-convergence nudge sent
- **Leader model:** Designated leader's BLE position drives group route computation
- **Group ordering:** Single cart, split-payment via Razorpay for up to 8 members

---

## 24 / INTEROPERABILITY LAYER

- **Open REST API:** OpenAPI 3.1 documented; third-party apps can subscribe to density feeds
- **Venue SDK:** Flutter package for operators to embed StadiumIQ widgets in their own apps
- **Data export:** BigQuery dataset option for city transport & safety agencies
- **Webhook support:** POST to venue's own endpoint on TIER 3+ incidents

---

## 25 / PERFORMANCE BUDGETS

| Metric | Budget |
| :--- | :--- |
| Flutter frame render | ≤ 16ms (60fps guaranteed) |
| API P99 latency | < 300ms |
| Sensor-to-fan update | < 800ms end-to-end |
| Battery drain (active mode) | < 8% / hour |
| App download size | ≤ 45MB |
| Widget refresh on FCM trigger | < 5 seconds |

---

## 26 / FORMAL PROBLEM STATEMENT

**Objective:** Minimise total Attendee Friction Score (AFS):

```
AFS = w1·(avg_wait_time) + w2·(navigation_errors) + w3·(congestion_events) + w4·(response_time)
```

Weights `w1–w4` calibrated per venue from historical baseline data.

**Hard constraints:**
- Zone density ≤ `max_capacity` (safety — non-negotiable)
- Routing response ≤ 800ms (real-time UX)
- Battery budget ≤ 8%/hr (passive background operation)

---

*Built on Google Cloud · Flutter · Vertex AI · Gemini · Maps Platform*

**Prepared by:** Soham Bhavesh Prajapati — B.Tech Computer Engineering, SPIT Mumbai, IEEE SPIT Deputy Tech Head

> *"The stadium of tomorrow doesn't have queues. It has intelligence."*
