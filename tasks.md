# StadiumIQ — Tasks

## Sprint 0: Foundation ✅
- [x] Turborepo monorepo setup (apps/admin, apps/api, packages/shared)
- [x] Next.js 16 admin app scaffolded + dependencies installed
- [x] BLE Zone Density Simulator (synthetic crowd engine, 15 zones, event phases)
- [x] Admin dashboard live: TopBar, Sidebar, Heatmap, Right Panel, Bottom Bar
- [x] Incident detection + staff dispatch (mock Gemini Vision)
- [x] Dev server running at http://localhost:3000

## Sprint 1: Backend + Real Data
- [ ] FastAPI backend scaffold (apps/api)
- [ ] Supabase project setup (schema: venues, zones, zone_density_snapshots, incidents)
- [ ] WebSocket streaming endpoint replacing simulator
- [ ] Zone density history chart (Recharts area chart in zone detail panel)
- [ ] Staff dispatch API + response tracking

## Sprint 2: Intelligence Layer
- [ ] Gemini 2.5 Flash integration for NL staff dispatch instructions
- [ ] Predictive queue engine (ARIMA-style trend extrapolation)
- [ ] Rerouting recommendation engine (avoid dense zones)
- [ ] AI explainability panel ("Route changed because Section B density = 0.87")

## Sprint 3: Flutter Mobile
- [ ] Flutter project scaffold (apps/mobile)
- [ ] Riverpod state setup + Supabase Realtime subscription
- [ ] Fan-facing zone density view (simplified heatmap)
- [ ] Proactive push notifications (FCM: "Stand 12 has 0 queue — go now")
- [ ] AR wayfinding stub (ARCore integration)

## Sprint 4: Hardening
- [ ] Degraded operation modes (Mode 2/3/4 from PRD)
- [ ] Redis cache layer for zone state
- [ ] BLE simulator → actual BLE beacon integration hooks
- [ ] Observability: route success rate, prediction MAE, alert accuracy
