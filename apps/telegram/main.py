"""
Webhook entrypoint for Cloud Run.
Wraps the Telegram bot in a FastAPI ASGI app for Cloud Run's HTTP interface.
"""

import logging
import os

from fastapi import FastAPI, Request, Response
from telegram import Update
from bot import build_app as build_telegram_app

logging.basicConfig(level=logging.INFO)

BOT_TOKEN = os.environ["TELEGRAM_BOT_TOKEN"]
WEBHOOK_SECRET = os.getenv("TELEGRAM_WEBHOOK_SECRET", "stadiumiq-secret")
PORT = int(os.getenv("PORT", "8080"))

telegram_app = build_telegram_app()
webhook_app = FastAPI()


@webhook_app.on_event("startup")
async def startup():
    await telegram_app.initialize()
    await telegram_app.start()
    logging.info("Telegram bot started in webhook mode")


@webhook_app.on_event("shutdown")
async def shutdown():
    await telegram_app.stop()
    await telegram_app.shutdown()


@webhook_app.post(f"/telegram/{BOT_TOKEN}")
async def telegram_webhook(request: Request):
    """Receive updates from Telegram."""
    data = await request.json()
    update = Update.de_json(data, telegram_app.bot)
    await telegram_app.process_update(update)
    return Response(status_code=200)


@webhook_app.get("/health")
def health():
    return {"status": "ok", "service": "stadiumiq-telegram-bot"}
