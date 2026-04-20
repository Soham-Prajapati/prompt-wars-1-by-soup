#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   PROJECT_ID=prompt-wars-1-by-soup REGION=asia-south1 ./deploy-gcp.sh

PROJECT_ID="${PROJECT_ID:-prompt-wars-1-by-soup}"
REGION="${REGION:-asia-south1}"
REPO="${REPO:-stadiumiq}"

echo "Using PROJECT_ID=$PROJECT_ID REGION=$REGION REPO=$REPO"

gcloud config set project "$PROJECT_ID"
gcloud services enable run.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

if ! gcloud artifacts repositories describe "$REPO" --location="$REGION" >/dev/null 2>&1; then
  gcloud artifacts repositories create "$REPO" \
    --repository-format=docker \
    --location="$REGION" \
    --description="StadiumIQ images"
fi

API_IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/$REPO/stadiumiq-api:latest"
ADMIN_IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/$REPO/stadiumiq-admin:latest"
TELEGRAM_IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/$REPO/stadiumiq-telegram:latest"

gcloud auth configure-docker "$REGION-docker.pkg.dev" --quiet

echo "Building images..."
docker build -t "$API_IMAGE" apps/api
docker build -t "$ADMIN_IMAGE" apps/admin
docker build -t "$TELEGRAM_IMAGE" apps/telegram

echo "Pushing images..."
docker push "$API_IMAGE"
docker push "$ADMIN_IMAGE"
docker push "$TELEGRAM_IMAGE"

echo "Deploying API..."
gcloud run deploy stadiumiq-api \
  --image "$API_IMAGE" \
  --platform managed \
  --region "$REGION" \
  --allow-unauthenticated \
  --set-env-vars "GCP_PROJECT_ID=$PROJECT_ID,ALLOWED_ORIGINS=*"

echo "Deploying Admin..."
gcloud run deploy stadiumiq-admin \
  --image "$ADMIN_IMAGE" \
  --platform managed \
  --region "$REGION" \
  --allow-unauthenticated

echo "Deploying Telegram..."
gcloud run deploy stadiumiq-telegram \
  --image "$TELEGRAM_IMAGE" \
  --platform managed \
  --region "$REGION" \
  --allow-unauthenticated

API_URL="$(gcloud run services describe stadiumiq-api --region "$REGION" --format='value(status.url)')"
ADMIN_URL="$(gcloud run services describe stadiumiq-admin --region "$REGION" --format='value(status.url)')"
TELEGRAM_URL="$(gcloud run services describe stadiumiq-telegram --region "$REGION" --format='value(status.url)')"

echo ""
echo "Deployment complete:"
echo "API:      $API_URL"
echo "Admin:    $ADMIN_URL"
echo "Telegram: $TELEGRAM_URL"
echo ""
echo "Next step: set Telegram webhook:"
echo "https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/setWebhook?url=$TELEGRAM_URL/telegram/<TELEGRAM_BOT_TOKEN>"
