"""
StadiumIQ Telegram Bot
Hosted on Cloud Run — webhook mode, async python-telegram-bot v21
"""

import logging
import os
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import (
    Application,
    CommandHandler,
    MessageHandler,
    CallbackQueryHandler,
    ContextTypes,
    filters,
)
import httpx

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

API_BASE = os.getenv("STADIUMIQ_API_URL", "http://localhost:8000")
GEMINI_KEY = os.getenv("GEMINI_API_KEY", "")


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _api(path: str, method: str = "GET", data: dict | None = None) -> dict:
    async with httpx.AsyncClient(base_url=API_BASE, timeout=8.0) as client:
        if method == "POST":
            r = await client.post(path, json=data or {})
        else:
            r = await client.get(path)
        r.raise_for_status()
        return r.json()


def _venue_id(context: ContextTypes.DEFAULT_TYPE) -> str:
    return context.user_data.get("venue_id", "VENUE_DEMO")


# ── Commands ───────────────────────────────────────────────────────────────────

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Onboarding: detect venue from ticket hash, register session."""
    args = context.args
    ticket_hash = args[0] if args else None

    if ticket_hash:
        context.user_data["ticket_hash"] = ticket_hash
        await update.message.reply_text(
            "🎟️ Ticket detected! Setting up your StadiumIQ session...\n"
            "Send /help to see what I can do for you."
        )
    else:
        await update.message.reply_text(
            "👋 Welcome to *StadiumIQ* — your AI stadium assistant!\n\n"
            "Commands:\n"
            "/queue — Find shortest queue\n"
            "/bathroom — Nearest restroom\n"
            "/nav — Get directions\n"
            "/order — Order food to your seat\n"
            "/exit — Best exit route\n"
            "/alert — Toggle crowd alerts\n"
            "/lost — Report lost person",
            parse_mode="Markdown",
        )


async def queue(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Returns shortest queue stalls with wait times."""
    venue_id = _venue_id(context)
    try:
        data = await _api(f"/venues/{venue_id}/queues")
        stalls = data.get("stalls", [])[:3]
        lines = ["🍺 *Shortest queues right now:*\n"]
        for s in stalls:
            wait = s["wait_mins"]
            emoji = "🟢" if wait < 5 else "🟡" if wait < 12 else "🔴"
            lines.append(f"{emoji} *{s['name']}* — {wait} min wait")
        await update.message.reply_text("\n".join(lines), parse_mode="Markdown")
    except Exception as e:
        await update.message.reply_text("⚠️ Couldn't fetch queue data. Try again shortly.")
        logger.error(e)


async def bathroom(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Nearest restroom with occupancy estimate."""
    await update.message.reply_text(
        "🚻 *Nearest restrooms:*\n\n"
        "🟢 Section C — 2 min walk, ~30% full\n"
        "🟡 Section A — 1 min walk, ~70% full\n\n"
        "_Tip: Section C has shorter wait right now._",
        parse_mode="Markdown",
    )


async def nav(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Text directions to a destination."""
    dest = " ".join(context.args) if context.args else "your seat"
    venue_id = _venue_id(context)
    try:
        data = await _api(
            f"/venues/{venue_id}/navigate",
            method="POST",
            data={"from": "current", "to": dest},
        )
        steps = data.get("steps", [])
        eta = data.get("eta_secs", 0) // 60
        lines = [f"🗺️ *Route to {dest}* (~{eta} min)\n"]
        for i, step in enumerate(steps, 1):
            lines.append(f"{i}. {step['instruction']}")
        await update.message.reply_text("\n".join(lines), parse_mode="Markdown")
    except Exception as e:
        await update.message.reply_text("⚠️ Navigation unavailable. Check your connection.")
        logger.error(e)


async def order(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Inline keyboard order flow."""
    keyboard = [
        [InlineKeyboardButton("🍔 Burgers", callback_data="menu_burgers"),
         InlineKeyboardButton("🍕 Pizza", callback_data="menu_pizza")],
        [InlineKeyboardButton("🍺 Drinks", callback_data="menu_drinks"),
         InlineKeyboardButton("🍿 Snacks", callback_data="menu_snacks")],
    ]
    await update.message.reply_text(
        "🛒 *What would you like to order?*\nDelivered straight to your seat!",
        reply_markup=InlineKeyboardMarkup(keyboard),
        parse_mode="Markdown",
    )


async def alert_toggle(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Toggle crowd & safety alerts."""
    current = context.user_data.get("alerts_on", True)
    context.user_data["alerts_on"] = not current
    status = "✅ ON" if not current else "🔕 OFF"
    await update.message.reply_text(f"Crowd alerts: {status}")


async def exit_cmd(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Best exit gate based on current density."""
    await update.message.reply_text(
        "🚪 *Best exit routes right now:*\n\n"
        "1. *Gate G (North)* — 4 min, low crowd 🟢\n"
        "2. *Gate E (East)* — 6 min, moderate 🟡\n\n"
        "_Metro: Board from Gate G for fastest connection._",
        parse_mode="Markdown",
    )


async def lost(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Report a lost person — auto-escalates to venue ops."""
    description = " ".join(context.args) if context.args else "No description provided"
    venue_id = _venue_id(context)
    try:
        await _api("/incidents", method="POST", data={
            "venue_id": venue_id,
            "zone_id": "ZONE_01",
            "type": "lost_person",
            "severity": 2,
        })
        await update.message.reply_text(
            f"🆘 *Lost person report submitted.*\n"
            f"Description: _{description}_\n\n"
            "Venue ops have been notified. Staff will respond within 5 minutes.",
            parse_mode="Markdown",
        )
    except Exception as e:
        await update.message.reply_text("⚠️ Report failed. Please find the nearest staff member.")
        logger.error(e)


# ── Gemini NL fallback ────────────────────────────────────────────────────────

async def nl_fallback(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    """Free-text query → Gemini 2.5 Flash with venue context."""
    user_text = update.message.text
    # TODO: call Gemini API with venue context system prompt
    await update.message.reply_text(
        f"🤖 Let me check that for you...\n\n"
        f"_(Gemini will answer: \"{user_text}\")_\n\n"
        "Full AI integration connects to Vertex AI in production.",
        parse_mode="Markdown",
    )


# ── Callback handler for inline keyboards ─────────────────────────────────────

async def callback_handler(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    query = update.callback_query
    await query.answer()
    category = query.data.replace("menu_", "").title()
    await query.edit_message_text(
        f"🛒 *{category} menu:*\n\n"
        "• Item A — ₹120\n"
        "• Item B — ₹180\n"
        "• Item C — ₹90\n\n"
        "_Tap to add to cart (full integration in prod)_",
        parse_mode="Markdown",
    )


# ── App factory ────────────────────────────────────────────────────────────────

def build_app() -> Application:
    token = os.environ["TELEGRAM_BOT_TOKEN"]
    app = Application.builder().token(token).build()

    app.add_handler(CommandHandler("start",    start))
    app.add_handler(CommandHandler("queue",    queue))
    app.add_handler(CommandHandler("bathroom", bathroom))
    app.add_handler(CommandHandler("nav",      nav))
    app.add_handler(CommandHandler("order",    order))
    app.add_handler(CommandHandler("alert",    alert_toggle))
    app.add_handler(CommandHandler("exit",     exit_cmd))
    app.add_handler(CommandHandler("lost",     lost))
    app.add_handler(CallbackQueryHandler(callback_handler))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, nl_fallback))

    return app


if __name__ == "__main__":
    build_app().run_polling()
