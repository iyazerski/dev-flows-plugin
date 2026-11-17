from collections.abc import Iterator
from datetime import UTC, datetime
from decimal import Decimal

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session
from sqlalchemy.pool import StaticPool

from app.db import get_session
from app.main import app
from app.models import Base, Order, OrderStatus, User


@pytest.fixture
def session() -> Iterator[Session]:
    engine = create_engine(
        "sqlite://", connect_args={"check_same_thread": False}, poolclass=StaticPool
    )
    Base.metadata.create_all(engine)
    with Session(engine, expire_on_commit=False) as session:
        session.add_all(
            [
                User(id=1, email="ann@example.com", api_token="ann-token"),
                User(id=2, email="bob@example.com", api_token="bob-token"),
                Order(
                    id=1,
                    user_id=1,
                    status=OrderStatus.PENDING,
                    total=Decimal("10.00"),
                    created_at=datetime(2026, 1, 1, tzinfo=UTC),
                ),
                Order(
                    id=2,
                    user_id=1,
                    status=OrderStatus.PAID,
                    total=Decimal("25.50"),
                    created_at=datetime(2026, 1, 2, tzinfo=UTC),
                ),
                Order(
                    id=3,
                    user_id=2,
                    status=OrderStatus.PENDING,
                    total=Decimal("7.00"),
                    created_at=datetime(2026, 1, 3, tzinfo=UTC),
                ),
            ]
        )
        session.commit()
        yield session


@pytest.fixture
def client(session: Session) -> Iterator[TestClient]:
    app.dependency_overrides[get_session] = lambda: session
    with TestClient(app) as client:
        yield client
    app.dependency_overrides.clear()
