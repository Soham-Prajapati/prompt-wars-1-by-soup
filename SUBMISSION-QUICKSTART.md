# StadiumIQ Submission Quickstart

This repository is a demo scaffold. Most endpoints return simulated data so the project runs without full cloud infra.

## What is implemented right now

- `apps/api`: FastAPI demo API with mocked venue, queue, order, incident, and AI endpoints.
- `apps/admin`: Next.js dashboard shell.
- `apps/telegram`: Telegram bot commands wired to the API.
- `apps/mobile`: default Flutter starter app (not integrated yet).

## Environment variables

The repo did not include env templates. They are now provided:

- `apps/api/.env.example`
- `apps/telegram/.env.example`

Copy them before running:

```bash
cp apps/api/.env.example apps/api/.env
cp apps/telegram/.env.example apps/telegram/.env
```

Notes:

- `GEMINI_API_KEY` is optional for demo mode. If empty, API returns mock AI responses.
- `TELEGRAM_BOT_TOKEN` is required only if you run the Telegram bot.
- `GCP_PROJECT_ID` enables Google Cloud mode for Pub/Sub and BigQuery endpoints.

## Fastest local run (API + Admin)

From repo root:

```bash
npm install
npm run dev
```

Then open:

- Admin: http://localhost:3000
- API health: http://localhost:8000/

If Turbo does not run Python services automatically, run API manually:

```bash
cd apps/api
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

## Optional: Run Telegram bot locally

```bash
cd apps/telegram
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
set -a && source .env && set +a
python main.py
```

## Deploy to Google Cloud Run (recommended for judging)

Project id prefilled for your case: `prompt-wars-1-by-soup`

```bash
PROJECT_ID=prompt-wars-1-by-soup REGION=asia-south1 ./deploy-gcp.sh
```

This deploys:

- `stadiumiq-api`
- `stadiumiq-admin`
- `stadiumiq-telegram`

Then set Telegram webhook using the URL printed by the script.

## Architecture reality check for submission

The PRD describes a full production architecture (Supabase, Vertex AI, Pub/Sub, Dataflow, BLE, etc.), but this repo is a hackathon/demo baseline with mocked logic and in-memory stores.

For your demo explanation:

- "Backend endpoints are functional and return real-time simulated data."
- "AI module is wired; with `GEMINI_API_KEY` it calls Gemini, otherwise safe mock fallback."
- "Admin dashboard is a Next.js frontend shell ready to consume backend APIs."
- "Telegram bot flows are implemented for key commands."

## Google Cloud-first endpoints (for judging)

The API now exposes explicit Google integration routes:

- `GET /google/health` → project and integration readiness
- `POST /google/publish-event` → Pub/Sub publish (mock fallback when local)
- `GET /google/venues/{venue_id}/analytics` → BigQuery analytics (mock fallback when local)

These endpoints run in:

- **GCP mode** when `GCP_PROJECT_ID` and Google credentials are configured
- **Mock mode** for local/demo without failing
