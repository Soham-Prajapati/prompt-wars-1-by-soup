-- StadiumIQ Supabase Schema
-- Run this in your Supabase SQL editor

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";

-- ── venues ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS venues (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name           TEXT NOT NULL,
  city           TEXT NOT NULL,
  capacity       INT NOT NULL,
  floor_plan_url TEXT,
  beacon_config  JSONB DEFAULT '{}',
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

-- ── zones ─────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS zones (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  venue_id     UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
  name         TEXT NOT NULL,
  type         TEXT NOT NULL CHECK (type IN ('gate','concourse','restroom','vendor','seating','exit')),
  max_capacity INT NOT NULL,
  geometry     JSONB DEFAULT '{}',
  beacon_ids   TEXT[] DEFAULT '{}'
);

-- ── zone_density_snapshots ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS zone_density_snapshots (
  id             BIGSERIAL PRIMARY KEY,
  zone_id        UUID NOT NULL REFERENCES zones(id) ON DELETE CASCADE,
  density        NUMERIC(4,3) NOT NULL CHECK (density >= 0 AND density <= 1),
  person_count   INT NOT NULL,
  predicted_8min NUMERIC(4,3) CHECK (predicted_8min >= 0 AND predicted_8min <= 1),
  source         TEXT NOT NULL CHECK (source IN ('ble','wifi','cctv','pos')),
  recorded_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast time-series queries
CREATE INDEX IF NOT EXISTS idx_density_zone_time ON zone_density_snapshots (zone_id, recorded_at DESC);

-- ── vendor_stalls ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS vendor_stalls (
  id                 UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  venue_id           UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
  zone_id            UUID REFERENCES zones(id),
  name               TEXT NOT NULL,
  menu_items         JSONB DEFAULT '[]',
  is_open            BOOL DEFAULT TRUE,
  pos_integration_id TEXT
);

-- ── queue_snapshots ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS queue_snapshots (
  id           BIGSERIAL PRIMARY KEY,
  stall_id     UUID NOT NULL REFERENCES vendor_stalls(id) ON DELETE CASCADE,
  wait_mins    NUMERIC(4,1) NOT NULL,
  queue_length INT NOT NULL,
  source       TEXT NOT NULL CHECK (source IN ('sensor','crowd','pos')),
  recorded_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ── orders ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id      UUID NOT NULL REFERENCES auth.users(id),
  stall_id     UUID NOT NULL REFERENCES vendor_stalls(id),
  items        JSONB NOT NULL,
  total_amount NUMERIC(10,2) NOT NULL,
  seat_zone    TEXT NOT NULL,
  seat_number  TEXT NOT NULL,
  status       TEXT NOT NULL DEFAULT 'pending'
               CHECK (status IN ('pending','confirmed','preparing','delivering','delivered','cancelled')),
  payment_id   TEXT,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  delivered_at TIMESTAMPTZ
);

-- ── incidents ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS incidents (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  venue_id          UUID NOT NULL REFERENCES venues(id),
  zone_id           UUID REFERENCES zones(id),
  type              TEXT NOT NULL
                    CHECK (type IN ('medical','fight','fire','lost_person','crowd_crush','other')),
  severity          INT NOT NULL CHECK (severity BETWEEN 1 AND 4),
  status            TEXT NOT NULL DEFAULT 'active'
                    CHECK (status IN ('active','responding','resolved')),
  reported_by       UUID REFERENCES auth.users(id),
  cctv_frame_url    TEXT,
  gemini_analysis   JSONB,
  assigned_staff_ids UUID[] DEFAULT '{}',
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  resolved_at       TIMESTAMPTZ
);

-- ── staff_locations ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS staff_locations (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  staff_id     UUID NOT NULL REFERENCES auth.users(id),
  venue_id     UUID NOT NULL REFERENCES venues(id),
  zone_id      UUID REFERENCES zones(id),
  lat          NUMERIC(10,8),
  lng          NUMERIC(11,8),
  role         TEXT,
  current_task TEXT,
  updated_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ── telegram_sessions ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS telegram_sessions (
  telegram_user_id BIGINT PRIMARY KEY,
  user_id          UUID REFERENCES auth.users(id),
  venue_id         UUID REFERENCES venues(id),
  seat_zone        TEXT,
  event_id         UUID,
  alert_subscribed BOOL DEFAULT TRUE,
  session_data     JSONB DEFAULT '{}',
  expires_at       TIMESTAMPTZ
);

-- ── Row Level Security ────────────────────────────────────────────────────────
ALTER TABLE venues              ENABLE ROW LEVEL SECURITY;
ALTER TABLE zones               ENABLE ROW LEVEL SECURITY;
ALTER TABLE zone_density_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendor_stalls       ENABLE ROW LEVEL SECURITY;
ALTER TABLE queue_snapshots     ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders              ENABLE ROW LEVEL SECURITY;
ALTER TABLE incidents           ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff_locations     ENABLE ROW LEVEL SECURITY;
ALTER TABLE telegram_sessions   ENABLE ROW LEVEL SECURITY;

-- Public read for venue/zone data
CREATE POLICY "Public venues read" ON venues FOR SELECT USING (true);
CREATE POLICY "Public zones read"  ON zones  FOR SELECT USING (true);
CREATE POLICY "Public density read" ON zone_density_snapshots FOR SELECT USING (true);
CREATE POLICY "Public stalls read" ON vendor_stalls FOR SELECT USING (true);
CREATE POLICY "Public queues read" ON queue_snapshots FOR SELECT USING (true);

-- Users can only see their own orders
CREATE POLICY "Own orders read" ON orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Own orders insert" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Incidents: public read, authenticated insert
CREATE POLICY "Public incidents read" ON incidents FOR SELECT USING (true);
CREATE POLICY "Auth incidents insert" ON incidents FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Staff locations: authenticated only
CREATE POLICY "Auth staff read" ON staff_locations FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Own staff update" ON staff_locations FOR UPDATE USING (auth.uid() = staff_id);

-- Telegram sessions: own only
CREATE POLICY "Own telegram session" ON telegram_sessions
  FOR ALL USING (auth.uid() = user_id);

-- ── Realtime Publications ─────────────────────────────────────────────────────
-- Run these to enable Supabase Realtime on key tables
-- ALTER PUBLICATION supabase_realtime ADD TABLE zone_density_snapshots;
-- ALTER PUBLICATION supabase_realtime ADD TABLE incidents;
-- ALTER PUBLICATION supabase_realtime ADD TABLE orders;
-- ALTER PUBLICATION supabase_realtime ADD TABLE queue_snapshots;
