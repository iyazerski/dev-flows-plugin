from datetime import datetime
from decimal import Decimal
from enum import StrEnum

from sqlalchemy import ForeignKey, Numeric, String
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    pass


class OrderStatus(StrEnum):
    PENDING = "pending"
    PAID = "paid"
    SHIPPED = "shipped"
    CANCELLED = "cancelled"


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String(255), unique=True)
    api_token: Mapped[str] = mapped_column(String(64), unique=True)


class Order(Base):
    __tablename__ = "orders"

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), index=True)
    status: Mapped[OrderStatus] = mapped_column(String(16))
    total: Mapped[Decimal] = mapped_column(Numeric(12, 2))
    created_at: Mapped[datetime]
