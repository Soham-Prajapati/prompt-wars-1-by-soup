FROM python:3.12-slim

WORKDIR /app

# Security: run as non-root
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    python-telegram-bot[webhooks] httpx

COPY . .

RUN chown -R appuser:appgroup /app
USER appuser

ENV PORT=8080
EXPOSE 8080

# Webhook mode — Cloud Run provides HTTPS automatically
CMD ["python", "-m", "uvicorn", "main:webhook_app", "--host", "0.0.0.0", "--port", "8080"]
