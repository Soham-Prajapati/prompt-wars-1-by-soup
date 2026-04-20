from fastapi import FastAPI, WebSocket, WebSocketDisconnect, HTTPException, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from app.models.zone import ZoneDensitySnapshot
from app.models.incident import Incident, IncidentCreate, BroadcastRequest
from app.models.order import Order, OrderCreate, QueueSnapshot
from app.core.auth import create_access_token, get_current_user, require_admin
from app.core.rate_limit import check_rate_limit
from app.services.gemini_service import (
    generate_dispatch_instruction,
    analyze_cctv_frame,
    telegram_nl_response,
    ops_advisor_response,
    generate_post_event_report,
)
from datetime import datetime, timezone
import uuid, random

app = FastAPI(
    title="StadiumIQ API",
    version="1.0.0",
    description="Real-time venue intelligence platform API",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── In-memory stores (replace with Supabase in prod) ──────────────────────────
_incidents: list[dict] = []
_orders: list[dict] = []
_connections: list[WebSocket] = []


# ── Health ─────────────────────────────────────────────────────────────────────
@app.get("/", tags=["health"])
def root():
    return {"status": "ok", "service": "StadiumIQ API", "version": "1.0.0"}


# ── Zones ──────────────────────────────────────────────────────────────────────
@app.get("/venues/{venue_id}/zones/density", tags=["crowd"])
def get_zone_density(venue_id: str):
    """Real-time density for all zones. Simulated for demo."""
    zones = [
        {"zone_id": f"Z{i}", "density": round(random.uniform(0.1, 0.95), 2),
         "person_count": random.randint(50, 900),
         "predicted_8min": round(random.uniform(0.1, 0.99), 2),
         "alert_level": "high" if random.random() > 0.7 else "moderate",
         "source": random.choice(["wifi", "ble", "cctv", "pos"])}
        for i in range(1, 16)
    ]
    return {"venue_id": venue_id, "zones": zones, "updated_at": datetime.now(timezone.utc).isoformat()}


# ── Queues ─────────────────────────────────────────────────────────────────────
@app.get("/venues/{venue_id}/queues", tags=["queues"])
def get_queues(venue_id: str):
    """All vendor/facility queue estimates."""
    stalls = [
        {"stall_id": f"S{i}", "name": f"Stall {i}", "wait_mins": round(random.uniform(0, 20), 1),
         "queue_length": random.randint(0, 40),
         "forecast_15min": round(random.uniform(0, 25), 1),
         "source": "pos", "alternative_stall_ids": []}
        for i in range(1, 10)
    ]
    stalls.sort(key=lambda x: x["wait_mins"])
    return {"venue_id": venue_id, "stalls": stalls}


# ── Navigation ─────────────────────────────────────────────────────────────────
@app.post("/venues/{venue_id}/navigate", tags=["navigation"])
def navigate(venue_id: str, body: dict):
    """Compute indoor route from src to dst, avoiding dense zones."""
    return {
        "venue_id": venue_id,
        "from": body.get("from"),
        "to": body.get("to"),
        "polyline": "mock_encoded_polyline",
        "steps": [
            {"instruction": "Head north toward Gate A", "distance_m": 45},
            {"instruction": "Turn right at Concourse C", "distance_m": 30},
            {"instruction": "Your destination is on the left", "distance_m": 10},
        ],
        "eta_secs": 90,
        "density_penalty_zones": [],
    }


# ── Orders ─────────────────────────────────────────────────────────────────────
@app.post("/orders", tags=["orders"])
def create_order(order: OrderCreate):
    """Create a new in-seat food/beverage order."""
    total = sum(float(i.get("price", 0)) for i in order.items)
    new_order = Order(**order.model_dump(), total_amount=total)
    _orders.append(new_order.model_dump())
    return {
        "order_id": new_order.id,
        "status": "confirmed",
        "payment_url": f"https://razorpay.mock/pay/{new_order.id}",
        "eta_mins": random.randint(8, 20),
        "tracking_ws_url": f"/ws/orders/{new_order.id}",
    }


@app.get("/orders/{order_id}", tags=["orders"])
def get_order(order_id: str):
    """Get order status and delivery staff location."""
    order = next((o for o in _orders if o["id"] == order_id), None)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return {**order, "staff_location": {"lat": 19.044, "lng": 73.016}, "eta_secs": 240}


# ── Incidents ──────────────────────────────────────────────────────────────────
@app.get("/incidents", tags=["incidents"])
def list_incidents(venue_id: str | None = None):
    if venue_id:
        return [i for i in _incidents if i.get("venue_id") == venue_id]
    return _incidents


@app.post("/incidents", tags=["incidents"])
def create_incident(incident: IncidentCreate):
    """Report a fan incident — triggers Gemini analysis in prod."""
    new = Incident(**incident.model_dump())
    _incidents.append(new.model_dump())
    return {
        "incident_id": new.id,
        "ops_notified": True,
        "estimated_response_mins": new.severity * 2,
    }


@app.patch("/incidents/{incident_id}/status", tags=["incidents"])
def update_incident_status(incident_id: str, body: dict):
    for inc in _incidents:
        if inc["id"] == incident_id:
            inc["status"] = body.get("status", inc["status"])
            if body.get("status") == "resolved":
                inc["resolved_at"] = datetime.now(timezone.utc).isoformat()
            return inc
    raise HTTPException(status_code=404, detail="Incident not found")


# ── Widget Data ────────────────────────────────────────────────────────────────
@app.get("/venues/{venue_id}/widget-data", tags=["widgets"])
def get_widget_data(venue_id: str):
    """Compact payload (< 2KB) for home screen widget refresh."""
    return {
        "venue_id": venue_id,
        "zone_summary": {"high_density_zones": 2, "avg_density": 0.54},
        "top_queues": [{"stall": "Stand 7", "wait_mins": 3}, {"stall": "Bar West", "wait_mins": 5}],
        "active_order_eta": None,
        "updated_at": datetime.now(timezone.utc).isoformat(),
    }


# ── Admin ──────────────────────────────────────────────────────────────────────
@app.get("/admin/venues/{venue_id}/dashboard", tags=["admin"])
def get_dashboard(venue_id: str):
    """Full ops data: staff positions, incidents, metrics."""
    return {
        "venue_id": venue_id,
        "capacity_pct": 72,
        "active_incidents": len([i for i in _incidents if i.get("status") == "active"]),
        "staff": [],
        "incidents": _incidents[-5:],
    }


@app.post("/admin/broadcast", tags=["admin"])
def broadcast(req: BroadcastRequest):
    """Send tiered emergency broadcast to all fans in venue."""
    return {
        "broadcast_id": str(uuid.uuid4()),
        "tier": req.tier,
        "message": req.message,
        "delivered_count": 45230,
        "failed_count": 12,
        "channels_used": ["fcm", "telegram", "sms"] if req.tier >= 3 else ["fcm"],
    }


# ── WebSocket ──────────────────────────────────────────────────────────────────
@app.websocket("/ws/venue/{venue_id}/realtime")
async def venue_realtime(websocket: WebSocket, venue_id: str):
    await websocket.accept()
    _connections.append(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await websocket.send_json({
                "type": "ack",
                "venue_id": venue_id,
                "timestamp": datetime.now(timezone.utc).isoformat(),
            })
    except WebSocketDisconnect:
        _connections.remove(websocket)


@app.websocket("/ws/orders/{order_id}")
async def order_tracking(websocket: WebSocket, order_id: str):
    await websocket.accept()
    try:
        while True:
            await websocket.send_json({
                "type": "order_update",
                "order_id": order_id,
                "status": "preparing",
                "eta_secs": 180,
                "timestamp": datetime.now(timezone.utc).isoformat(),
            })
            import asyncio
            await asyncio.sleep(5)
    except WebSocketDisconnect:
        pass


# ── FAQ ────────────────────────────────────────────────────────────────────────
@app.get("/venues/{venue_id}/faq", tags=["faq"])
def faq_search(venue_id: str, q: str = ""):
    """Semantic FAQ search (mocked — wires to Vertex AI Matching Engine in prod)."""
    return {
        "query": q,
        "answer": f"Here is the answer to: '{q}'. Please contact venue staff for more info.",
        "confidence": 0.87,
        "source_chunks": [],
    }


# ── POS Webhook ────────────────────────────────────────────────────────────────
@app.post("/webhooks/pos", tags=["webhooks"])
def pos_webhook(payload: dict):
    """Receive POS transaction events to update queue snapshots."""
    return {"status": "received", "processed": True}


@app.post("/telegram/webhook", tags=["telegram"])
async def telegram_webhook(payload: dict):
    """Telegram Bot API webhook receiver."""
    return {"ok": True}


# ── AI Ops ─────────────────────────────────────────────────────────────────────
@app.post("/admin/ai/dispatch", tags=["ai"])
async def ai_dispatch(incident_id: str, admin: dict = Depends(require_admin)):
    """Generate dispatch instruction via Gemini Flash."""
    incident = next((i for i in _incidents if i["id"] == incident_id), None)
    if not incident:
        raise HTTPException(status_code=404, detail="Incident not found")
    staff = [{"id": "S1", "role": "security", "zone": "ZONE_03"}]
    instruction = await generate_dispatch_instruction(incident, staff)
    return {"instruction": instruction}


@app.post("/admin/ai/cctv", tags=["ai"])
async def ai_cctv_analyze(description: str, admin: dict = Depends(require_admin)):
    """Analyze CCTV frame description for incidents."""
    result = await analyze_cctv_frame(description)
    return result


@app.post("/admin/ai/advisor", tags=["ai"])
async def ai_ops_advisor(query: str, admin: dict = Depends(require_admin)):
    """Ops AI Advisor."""
    context = {"active_incidents": len(_incidents), "capacity_pct": 72}
    advice = await ops_advisor_response(query, context)
    return {"advice": advice}


@app.post("/admin/ai/report", tags=["ai"])
async def ai_post_event_report(admin: dict = Depends(require_admin)):
    """Generate post-event report."""
    metrics = {"attendance": 45000, "avg_queue_time": 8.5}
    report = await generate_post_event_report(metrics)
    return {"report": report}
