from pydantic import BaseModel, Field
from typing import Optional, Literal
from datetime import datetime, timezone
import uuid


class Zone(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    venue_id: str
    name: str
    type: Literal["gate", "concourse", "restroom", "vendor", "seating", "exit"]
    max_capacity: int
    beacon_ids: list[str] = []
    geometry: dict = {}


class ZoneDensitySnapshot(BaseModel):
    id: Optional[int] = None
    zone_id: str
    density: float = Field(ge=0.0, le=1.0)
    person_count: int
    predicted_8min: float = Field(ge=0.0, le=1.0)
    source: Literal["ble", "wifi", "cctv", "pos"]
    alert_level: Literal["low", "moderate", "high", "critical"]
    recorded_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))

    @property
    def alert_level_computed(self) -> str:
        if self.density < 0.4:
            return "low"
        elif self.density < 0.65:
            return "moderate"
        elif self.density < 0.85:
            return "high"
        return "critical"
