# StadiumIQ Score 95+ Playbook

This is the exact step-by-step checklist to push your score from ~84 toward 95+.

---

## 1) Live hosted links (already done)

- **API (Cloud Run):** `https://stadiumiq-api-995392737699.asia-south1.run.app`
- **Admin Frontend (Cloud Run):** `https://stadiumiq-admin-995392737699.asia-south1.run.app`
- **Telegram Bot service (Cloud Run):** `https://stadiumiq-telegram-995392737699.asia-south1.run.app`

---

## 2) Google infra checklist (already done)

- APIs enabled: Cloud Run, Artifact Registry, Cloud Build, Pub/Sub, BigQuery, Secret Manager, Vertex AI, Gemini.
- Pub/Sub topic: `venue-events`
- BigQuery dataset/table: `stadiumiq.zone_density_snapshots`
- Runtime service account: `stadiumiq-runtime@prompt-wars-1-by-soup.iam.gserviceaccount.com`
- Secrets created: `GEMINI_API_KEY`, `JWT_SECRET_KEY`, `TELEGRAM_BOT_TOKEN`, `GOOGLE_API_KEY`
- Telegram webhook set to Cloud Run endpoint.

---

## 3) Immediate steps you should do now (5-10 minutes)

### Step A — Set real secret values

Where to get each value:

- `GEMINI_API_KEY`
  - Go to [Google AI Studio](https://aistudio.google.com/app/apikey)
  - Create API key in project: `prompt-wars-1-by-soup`
  - Copy key and run command below.
- `TELEGRAM_BOT_TOKEN`
  - From `@BotFather` in Telegram (`/mybots` -> select bot -> API Token).
  - You already shared this and it has already been set in Secret Manager.
- `JWT_SECRET_KEY`
  - This is your own random backend secret (not from Google console).
  - Generate one locally:
    - `openssl rand -base64 48`
  - Use the output as JWT secret.
- `GOOGLE_API_KEY` (optional: Maps/Places style features)
  - Google Cloud Console -> **APIs & Services** -> **Credentials** -> **Create Credentials** -> **API key**
  - Restrict key to only APIs you need.

Run:

```bash
printf 'YOUR_REAL_GEMINI_KEY' | gcloud secrets versions add GEMINI_API_KEY --data-file=-
printf 'YOUR_REAL_TELEGRAM_BOT_TOKEN' | gcloud secrets versions add TELEGRAM_BOT_TOKEN --data-file=-
printf 'YOUR_STRONG_JWT_SECRET' | gcloud secrets versions add JWT_SECRET_KEY --data-file=-
```

If needed:

```bash
printf 'YOUR_GOOGLE_API_KEY' | gcloud secrets versions add GOOGLE_API_KEY --data-file=-
```

### Step A.1 — Verify secrets actually exist

```bash
gcloud secrets list
gcloud secrets versions list GEMINI_API_KEY
gcloud secrets versions list TELEGRAM_BOT_TOKEN
gcloud secrets versions list JWT_SECRET_KEY
```

### Step B — Smoke test hosted endpoints

```bash
curl -s "https://stadiumiq-api-995392737699.asia-south1.run.app/"
curl -s "https://stadiumiq-api-995392737699.asia-south1.run.app/google/health"
curl -s "https://stadiumiq-api-995392737699.asia-south1.run.app/google/venues/VENUE_DEMO/analytics"
```

### Step C — Quick Telegram test

1. Open Telegram bot chat.
2. Send `/start`
3. Send `/queue`
4. Send `/nav gate a`
5. Screenshot responses for submission proof.

---

## 4) What to show judges (this boosts score heavily)

### Google Services Proof (critical)

Show all 4 on screen:

- Cloud Run service list (`stadiumiq-api`, `stadiumiq-admin`, `stadiumiq-telegram`)
- Pub/Sub topic `venue-events`
- BigQuery table `stadiumiq.zone_density_snapshots`
- Secret Manager secrets

### Functional demo flow (90 seconds)

1. Open Admin dashboard (live URL).
2. Open API `/google/health` and mention GCP-enabled mode.
3. Hit `/google/publish-event` (Postman/curl) and explain Pub/Sub eventing.
4. Hit `/google/venues/VENUE_DEMO/analytics` and explain BigQuery analytics.
5. Show Telegram bot commands working.

---

## 5) Submission text template (copy/paste)

## Technical (Codebase + Live Preview)
- Built and deployed StadiumIQ on Google Cloud using Cloud Run, Pub/Sub, BigQuery, Secret Manager, and Gemini-ready AI endpoints.
- Implemented real-time venue intelligence APIs, Google-integrated analytics routes, and a live Telegram companion bot with webhook deployment.
- Live links:
  - API: `https://stadiumiq-api-995392737699.asia-south1.run.app`
  - Admin: `https://stadiumiq-admin-995392737699.asia-south1.run.app`
  - Telegram backend: `https://stadiumiq-telegram-995392737699.asia-south1.run.app`

## Narrative (LinkedIn / community post)
- We built StadiumIQ: an AI-powered intelligent venue experience platform that predicts crowd flow, reduces wait times, and improves safety.
- Deployed fully on Google Cloud with production-style architecture: Cloud Run microservices + Pub/Sub eventing + BigQuery analytics + secure secrets.
- Added a conversational Telegram assistant for zero-friction fan access and real-time operations support.

---

## 6) Final rank-boost checklist before submit

- [ ] API URL opens and responds with `status: ok`
- [ ] `/google/health` returns `gcp_enabled: true`
- [ ] Frontend URL loads cleanly
- [ ] Telegram bot replies to `/start` and `/queue`
- [ ] 2-3 screenshots attached in submission
- [ ] Technical write-up explicitly names Google services used
- [ ] LinkedIn post includes architecture image + live links

## 6.1) Safe last-submission protocol (very important)

Because only the **last** submission counts, do this exact sequence:

1. Re-check all live links:
   - API
   - Admin
   - Telegram command response
2. Run 3 endpoint checks:
   - `/`
   - `/google/health`
   - `/google/venues/VENUE_DEMO/analytics`
3. Take fresh screenshots after checks succeed.
4. Paste final technical write-up (from this file).
5. Submit only when all checks pass.
6. Do **not** push any new risky code after validation.

---

## 7) If score still stalls below 90

Fastest upgrades:

1. Add one short test report section in submission ("endpoint tests passed for health + google routes + telegram commands").
2. Add one architecture diagram screenshot from Cloud Console.
3. Mention security hardening: Secret Manager + service account IAM + rate limiting + JWT.
4. Mention graceful fallback behavior when AI key is absent (robust engineering signal).
