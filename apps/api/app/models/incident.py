from pydantic import BaseModel, Field
from typing import Optional, Literal
from datetime import datetime, timezone
import uuid


class Incident(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    venue_id: str
    zone_id: str
    type: Literal["medical", "fight", "fire", "lost_person", "crowd_crush", "other"]
    severity: int = Field(ge=1, le=4)
    status: Literal["active", "responding", "resolved"] = "active"
    reported_by: Optional[str] = None
    cctv_frame_url: Optional[str] = None
    gemini_analysis: Optional[dict] = None
    assigned_staff_ids: list[str] = Field(default_factory=list)
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    resolved_at: Optional[datetime] = None


class IncidentCreate(BaseModel):
    venue_id: str
    zone_id: str
    type: Literal["medical", "fight", "fire", "lost_person", "crowd_crush", "other"]
    severity: int = Field(ge=1, le=4)
    reported_by: Optional[str] = None


class BroadcastRequest(BaseModel):
    venue_id: str
    tier: int = Field(ge=1, le=4)
    message: str
    zones: list[str] = Field(default_factory=list)  # empty = all zones
