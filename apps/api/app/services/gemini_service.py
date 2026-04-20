"""
StadiumIQ — Gemini AI Service
All Gemini API calls route through this module (AG-05 rule).
"""

import json
import logging
import os
from typing import Any

import httpx

logger = logging.getLogger(__name__)

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")
GEMINI_BASE = "https://generativelanguage.googleapis.com/v1beta/models"
FLASH_MODEL = "gemini-2.5-flash-preview-04-17"
PRO_MODEL   = "gemini-2.5-pro-preview-04-17"


async def _call_gemini(model: str, system: str, user: str) -> str:
    """Low-level Gemini REST call — returns text response."""
    if not GEMINI_API_KEY:
        logger.warning("GEMINI_API_KEY not set — returning mock response")
        return f"[MOCK] Gemini response for: {user[:80]}"

    url = f"{GEMINI_BASE}/{model}:generateContent?key={GEMINI_API_KEY}"
    payload = {
        "system_instruction": {"parts": [{"text": system}]},
        "contents": [{"role": "user", "parts": [{"text": user}]}],
        "generationConfig": {"temperature": 0.2, "maxOutputTokens": 512},
    }
    async with httpx.AsyncClient(timeout=15.0) as client:
        r = await client.post(url, json=payload)
        r.raise_for_status()
        return r.json()["candidates"][0]["content"]["parts"][0]["text"]


# ── 1. Staff Dispatch NLG ─────────────────────────────────────────────────────

DISPATCH_SYSTEM = """You are a venue operations dispatcher.
Generate a single terse radio-style instruction.
Rules: Under 20 words. Imperative mood. Include zone, action, urgency.
Example: "Unit 7 to Gate C-3 immediately — crowd crush forming, assist crowd control." """

async def generate_dispatch_instruction(incident: dict, staff: list[dict]) -> str:
    user_prompt = (
        f"Incident: {json.dumps(incident, default=str)}\n"
        f"Available staff: {json.dumps(staff, default=str)}"
    )
    return await _call_gemini(FLASH_MODEL, DISPATCH_SYSTEM, user_prompt)


# ── 2. CCTV Incident Detection ────────────────────────────────────────────────

CCTV_SYSTEM = """You are an AI safety analyst monitoring a live sporting venue via CCTV.
Analyze the provided description and detect any incident types:
- crowd_crush: density so high movement is impossible, distress visible
- fight: physical altercation between 2+ individuals
- medical: person collapsed, unresponsive, or requiring aid
- fire: visible flames or smoke
- suspicious: unattended bags, perimeter breach

Respond ONLY with a JSON object:
{
  "incident_detected": boolean,
  "incident_type": string | null,
  "confidence": float,
  "zone_description": string,
  "severity": integer 1-4,
  "recommended_action": string
}
If no incident detected, return: {"incident_detected": false}"""

async def analyze_cctv_frame(frame_description: str) -> dict:
    """Analyze a CCTV frame description for incidents."""
    try:
        raw = await _call_gemini(PRO_MODEL, CCTV_SYSTEM, frame_description)
        # Strip markdown code fences if present
        clean = raw.strip().removeprefix("```json").removesuffix("```").strip()
        return json.loads(clean)
    except (json.JSONDecodeError, Exception) as e:
        logger.error(f"CCTV analysis failed: {e}")
        return {"incident_detected": False, "error": str(e)}


# ── 3. Telegram NL Fallback ───────────────────────────────────────────────────

def build_telegram_system(venue_name: str, event_name: str,
                          seat_zone: str, seat_number: str) -> str:
    return f"""You are StadiumIQ, an AI assistant for fans at {venue_name}.
Current event: {event_name} | User seat: {seat_zone}-{seat_number}
You have access to tools: queue_lookup(stall_name), nav_directions(destination), faq_search(query).
Be concise (under 80 words). Use plain text, no markdown.
If the question needs live data, call the appropriate tool first.
If unsure, say "Let me check that for you" and call faq_search."""

async def telegram_nl_response(
    user_message: str,
    venue_name: str = "Demo Stadium",
    event_name: str = "Live Event",
    seat_zone: str = "A",
    seat_number: str = "1",
) -> str:
    system = build_telegram_system(venue_name, event_name, seat_zone, seat_number)
    return await _call_gemini(FLASH_MODEL, system, user_message)


# ── 4. Ops AI Advisor ─────────────────────────────────────────────────────────

OPS_SYSTEM = """You are a venue operations intelligence analyst with access to real-time data.
Provide concise, actionable analysis. Focus on immediate operational decisions.
Keep responses under 150 words. Use bullet points for action items."""

async def ops_advisor_response(query: str, context: dict) -> str:
    user_prompt = f"Query: {query}\n\nLive context: {json.dumps(context, default=str)}"
    return await _call_gemini(PRO_MODEL, OPS_SYSTEM, user_prompt)


# ── 5. Post-Event Report ──────────────────────────────────────────────────────

POST_EVENT_SYSTEM = """You are a sports venue analytics journalist.
Write a concise executive summary (300-400 words) of the event from an operations perspective.
Structure:
1) Top-line attendance & performance vs. targets
2) Key friction points identified
3) AI system performance highlights
4) Three specific recommendations for next event

Tone: professional, data-driven, actionable. No fluff."""

async def generate_post_event_report(metrics: dict) -> str:
    return await _call_gemini(
        PRO_MODEL, POST_EVENT_SYSTEM, json.dumps(metrics, default=str)
    )
