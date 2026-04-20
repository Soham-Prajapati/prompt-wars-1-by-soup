from pydantic import BaseModel, Field
from typing import Optional, Literal
from datetime import datetime, timezone
import uuid


class Order(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    stall_id: str
    items: list[dict]
    total_amount: float
    seat_zone: str
    seat_number: str
    status: Literal[
        "pending", "confirmed", "preparing", "delivering", "delivered", "cancelled"
    ] = "pending"
    payment_id: Optional[str] = None
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    delivered_at: Optional[datetime] = None


class OrderCreate(BaseModel):
    user_id: str
    stall_id: str
    items: list[dict]
    seat_zone: str
    seat_number: str


class QueueSnapshot(BaseModel):
    stall_id: str
    wait_mins: float
    queue_length: int
    forecast_15min: float
    source: Literal["sensor", "crowd", "pos"]
    alternative_stall_ids: list[str] = Field(default_factory=list)
    recorded_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
