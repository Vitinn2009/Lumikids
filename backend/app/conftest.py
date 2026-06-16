"""
Configuração base dos testes.
Cria um banco em memória (SQLite async) para cada sessão de testes,
sem precisar do PostgreSQL rodando.
"""

import pytest
import pytest_asyncio
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker

from app.db.base import Base
from app.api.dependencies import get_db
from app import app

# Banco SQLite em memória — só para testes
TEST_DATABASE_URL = "sqlite+aiosqlite:///:memory:"


@pytest_asyncio.fixture(scope="session")
async def engine():
    _engine = create_async_engine(TEST_DATABASE_URL, echo=False)
    async with _engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield _engine
    await _engine.dispose()


@pytest_asyncio.fixture
async def db(engine):
    TestSession = async_sessionmaker(engine, expire_on_commit=False)
    async with TestSession() as session:
        yield session
        await session.rollback()  # desfaz tudo após cada teste


@pytest_asyncio.fixture
async def client(db):
    app.dependency_overrides[get_db] = lambda: db

    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
    ) as ac:
        yield ac

    app.dependency_overrides.clear()


# ─── Fixtures de tokens ───────────────────────────────────────────────────────

@pytest_asyncio.fixture
async def token_responsavel(client: AsyncClient) -> str:
    resp = await client.post("/api/v1/auth/register", json={
        "nome": "Responsável Teste",
        "email": "responsavel@teste.com",
        "senha": "senha123",
        "confirmar_senha": "senha123",
        "data_nascimento": "1985-03-15",
    })
    return resp.json()["access_token"]


@pytest_asyncio.fixture
async def token_outro_responsavel(client: AsyncClient) -> str:
    resp = await client.post("/api/v1/auth/register", json={
        "nome": "Outro Responsável",
        "email": "outro@teste.com",
        "senha": "senha123",
        "confirmar_senha": "senha123",
        "data_nascimento": "1990-07-20",
    })
    return resp.json()["access_token"]
