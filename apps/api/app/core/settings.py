"""
Application settings from environment variables.
"""

from __future__ import annotations

import os


def get_allowed_origins() -> list[str]:
    """
    Parse comma-separated CORS origins from ALLOWED_ORIGINS.
    Defaults to localhost dev origins for safer local setup.
    """
    raw = os.getenv(
        "ALLOWED_ORIGINS",
        "http://localhost:3000,http://127.0.0.1:3000,http://localhost:5173",
    )
    origins = [origin.strip() for origin in raw.split(",") if origin.strip()]
    return origins or ["http://localhost:3000"]


GCP_PROJECT_ID = os.getenv("GCP_PROJECT_ID", "")
PUBSUB_TOPIC_ID = os.getenv("PUBSUB_TOPIC_ID", "venue-events")
BIGQUERY_DATASET = os.getenv("BIGQUERY_DATASET", "stadiumiq")
BIGQUERY_TABLE = os.getenv("BIGQUERY_TABLE", "zone_density_snapshots")
