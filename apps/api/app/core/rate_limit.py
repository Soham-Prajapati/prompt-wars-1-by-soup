"""
Redis-backed rate limiter for FastAPI.
Enforces 1000 req/min per user as per PRD security requirements.
"""

import os
import time
from typing import Optional

from fastapi import Depends, HTTPException, Request, status

RATE_LIMIT_RPM = int(os.getenv("RATE_LIMIT_RPM", "1000"))

# In-memory fallback when Redis is unavailable
_mem_store: dict[str, list[float]] = {}


def _get_redis():
    """Return Redis client or None if unavailable."""
    try:
        import redis
        r = redis.Redis.from_url(
            os.getenv("REDIS_URL", "redis://localhost:6379"),
            decode_responses=True,
            socket_connect_timeout=1,
        )
        r.ping()
        return r
    except Exception:
        return None


def check_rate_limit(request: Request) -> None:
    """FastAPI dependency: enforce per-IP rate limit."""
    client_ip = request.client.host if request.client else "unknown"
    redis = _get_redis()
    now = time.time()
    window = 60  # 1 minute

    if redis:
        key = f"rl:{client_ip}"
        pipe = redis.pipeline()
        pipe.zadd(key, {str(now): now})
        pipe.zremrangebyscore(key, 0, now - window)
        pipe.zcard(key)
        pipe.expire(key, window)
        results = pipe.execute()
        count = results[2]
    else:
        # In-memory fallback
        timestamps = _mem_store.get(client_ip, [])
        timestamps = [t for t in timestamps if now - t < window]
        timestamps.append(now)
        _mem_store[client_ip] = timestamps
        count = len(timestamps)

    if count > RATE_LIMIT_RPM:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail=f"Rate limit exceeded: {RATE_LIMIT_RPM} requests/minute",
            headers={"Retry-After": "60"},
        )
