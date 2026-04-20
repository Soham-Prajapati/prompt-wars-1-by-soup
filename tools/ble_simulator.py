"""
BLE Beacon Simulator
Generates synthetic RSSI events for dev/demo without physical hardware.
Publishes to Google Cloud Pub/Sub topic: venue.raw.events

Usage:
  python3 ble_simulator.py --venue-id <id> --zones 15 --interval 5

Requires:
  pip install google-cloud-pubsub faker
"""

import argparse
import json
import math
import random
import time
import uuid
from datetime import datetime, timezone


def _density_at_tick(zone_idx: int, tick: int, total_zones: int) -> float:
    """Simulate realistic crowd patterns with match phase simulation."""
    phase = tick % 120           # 120 ticks = 1 "match cycle"
    base = 0.3 + 0.1 * math.sin(phase * math.pi / 60)

    # Simulate halftime surge on odd-indexed zones
    if 55 <= phase <= 65 and zone_idx % 2 == 1:
        base += 0.35

    # Random hotspots
    if random.random() < 0.05:
        base += random.uniform(0.1, 0.3)

    return round(min(max(base + random.gauss(0, 0.05), 0.0), 1.0), 3)


def generate_event(venue_id: str, zone_id: str, tick: int, zone_idx: int) -> dict:
    density = _density_at_tick(zone_idx, tick, 15)
    source = random.choice(["ble", "wifi", "cctv", "pos"])

    # Source-based accuracy offsets
    noise = {"ble": 0.02, "wifi": 0.05, "cctv": 0.01, "pos": 0.08}[source]
    density = round(min(max(density + random.gauss(0, noise), 0.0), 1.0), 3)

    alert_level = (
        "critical" if density >= 0.95 else
        "high"     if density >= 0.85 else
        "moderate" if density >= 0.70 else
        "low"
    )

    return {
        "event_type": "zone_density_update",
        "event_id": str(uuid.uuid4()),
        "venue_id": venue_id,
        "zone_id": zone_id,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "payload": {
            "density": density,
            "person_count": int(density * random.randint(800, 1200)),
            "predicted_8min": round(min(density * 1.1 + random.gauss(0, 0.03), 1.0), 3),
            "alert_level": alert_level,
            "rssi_readings": [
                {"beacon_id": f"B{zone_idx}{i}", "rssi": random.randint(-90, -40)}
                for i in range(3)
            ],
        },
        "source": source,
    }


def run_simulator(
    venue_id: str,
    num_zones: int,
    interval_secs: float,
    use_pubsub: bool,
    project_id: str | None,
    topic_id: str,
):
    zone_ids = [f"ZONE_{i:02d}" for i in range(1, num_zones + 1)]
    tick = 0

    publisher = None
    topic_path = None
    if use_pubsub:
        from google.cloud import pubsub_v1
        publisher = pubsub_v1.PublisherClient()
        topic_path = publisher.topic_path(project_id, topic_id)
        print(f"📡 Publishing to Pub/Sub: {topic_path}")
    else:
        print(f"🖥️  Console mode (no Pub/Sub) — {num_zones} zones, {interval_secs}s interval")

    print(f"🏟️  Venue: {venue_id} | Zones: {num_zones} | Ctrl+C to stop\n")

    try:
        while True:
            for idx, zone_id in enumerate(zone_ids):
                event = generate_event(venue_id, zone_id, tick, idx)
                payload_bytes = json.dumps(event).encode("utf-8")

                if use_pubsub and publisher:
                    future = publisher.publish(topic_path, payload_bytes)
                    future.result()
                else:
                    density = event["payload"]["density"]
                    alert = event["payload"]["alert_level"]
                    bar = "█" * int(density * 20)
                    print(f"  {zone_id} [{event['source']:4}] {bar:<20} {density:.3f} [{alert}]")

            tick += 1
            if not use_pubsub:
                print(f"─── tick {tick} ───\n")
            time.sleep(interval_secs)

    except KeyboardInterrupt:
        print("\n⏹️  Simulator stopped.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="StadiumIQ BLE/Wi-Fi Beacon Simulator")
    parser.add_argument("--venue-id",   default="VENUE_DEMO", help="Venue ID")
    parser.add_argument("--zones",      type=int, default=15,  help="Number of zones")
    parser.add_argument("--interval",   type=float, default=5.0, help="Seconds between ticks")
    parser.add_argument("--pubsub",     action="store_true",   help="Publish to Cloud Pub/Sub")
    parser.add_argument("--project-id", default=None,          help="GCP project ID")
    parser.add_argument("--topic",      default="venue.raw.events", help="Pub/Sub topic")
    args = parser.parse_args()

    run_simulator(
        venue_id=args.venue_id,
        num_zones=args.zones,
        interval_secs=args.interval,
        use_pubsub=args.pubsub,
        project_id=args.project_id,
        topic_id=args.topic,
    )
