"""
FastAPI tests — run with: pytest tests/ -v
"""

import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health():
    r = client.get("/")
    assert r.status_code == 200
    assert r.json()["status"] == "ok"
    assert "google_cloud" in r.json()


def test_get_zone_density():
    r = client.get("/venues/VENUE_DEMO/zones/density")
    assert r.status_code == 200
    data = r.json()
    assert "zones" in data
    assert len(data["zones"]) == 15
    for zone in data["zones"]:
        assert 0.0 <= zone["density"] <= 1.0
        assert zone["source"] in ("ble", "wifi", "cctv", "pos")


def test_get_queues():
    r = client.get("/venues/VENUE_DEMO/queues")
    assert r.status_code == 200
    stalls = r.json()["stalls"]
    assert len(stalls) > 0
    # Should be sorted by wait_mins ascending
    waits = [s["wait_mins"] for s in stalls]
    assert waits == sorted(waits)


def test_navigate():
    r = client.post("/venues/VENUE_DEMO/navigate", json={"from": "Gate A", "to": "Section C7"})
    assert r.status_code == 200
    data = r.json()
    assert "steps" in data
    assert "eta_secs" in data
    assert len(data["steps"]) > 0


def test_create_and_get_order():
    payload = {
        "user_id": "user_123",
        "stall_id": "stall_456",
        "items": [{"name": "Burger", "price": 120}],
        "seat_zone": "A",
        "seat_number": "15",
    }
    r = client.post("/orders", json=payload)
    assert r.status_code == 200
    data = r.json()
    assert "order_id" in data
    assert "payment_url" in data

    order_id = data["order_id"]
    r2 = client.get(f"/orders/{order_id}")
    assert r2.status_code == 200
    assert r2.json()["id"] == order_id


def test_get_order_not_found():
    r = client.get("/orders/nonexistent-id")
    assert r.status_code == 404


def test_create_incident():
    payload = {
        "venue_id": "VENUE_DEMO",
        "zone_id": "ZONE_03",
        "type": "medical",
        "severity": 3,
    }
    r = client.post("/incidents", json=payload)
    assert r.status_code == 200
    data = r.json()
    assert data["ops_notified"] is True
    assert "incident_id" in data


def test_incident_severity_in_response_time():
    """Higher severity → faster estimated response."""
    for severity in [1, 2, 3, 4]:
        r = client.post("/incidents", json={
            "venue_id": "VENUE_DEMO", "zone_id": "ZONE_01",
            "type": "other", "severity": severity,
        })
        assert r.status_code == 200
        assert r.json()["estimated_response_mins"] == severity * 2


def test_widget_data_under_2kb():
    r = client.get("/venues/VENUE_DEMO/widget-data")
    assert r.status_code == 200
    assert len(r.content) < 2048  # Must be < 2KB per PRD


def test_broadcast():
    r = client.post("/admin/broadcast", json={
        "venue_id": "VENUE_DEMO",
        "tier": 3,
        "message": "Emergency evacuation in progress",
        "zones": [],
    })
    assert r.status_code == 200
    data = r.json()
    assert "fcm" in data["channels_used"]
    assert "telegram" in data["channels_used"]


def test_faq_search():
    r = client.get("/venues/VENUE_DEMO/faq", params={"q": "Where is parking?"})
    assert r.status_code == 200
    assert "answer" in r.json()
    assert r.json()["confidence"] > 0


def test_google_health():
    r = client.get("/google/health")
    assert r.status_code == 200
    data = r.json()
    assert "gcp_enabled" in data
    assert "pubsub_topic" in data


def test_google_publish_event():
    r = client.post("/google/publish-event", json={"event_type": "zone_density_update", "zone_id": "Z1"})
    assert r.status_code == 200
    data = r.json()
    assert data["ok"] is True
    assert data["published"] is True
    assert data["mode"] in ("mock", "gcp")


def test_google_venue_analytics():
    r = client.get("/google/venues/VENUE_DEMO/analytics")
    assert r.status_code == 200
    data = r.json()
    assert data["venue_id"] == "VENUE_DEMO"
    assert isinstance(data["rows"], list)
