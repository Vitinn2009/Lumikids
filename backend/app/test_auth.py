"""
Testes para o módulo de autenticação.
Execute com: pytest tests/test_auth.py -v
"""

import pytest
from httpx import AsyncClient


# ─── dados de teste ───────────────────────────────────────────────────────────

RESPONSAVEL_VALIDO = {
    "nome": "João Silva",
    "email": "joao@teste.com",
    "senha": "senha123",
    "confirmar_senha": "senha123",
    "data_nascimento": "1990-05-10",
}


# ─── register ────────────────────────────────────────────────────────────────

@pytest.mark.asyncio
async def test_register_sucesso(client: AsyncClient):
    resp = await client.post("/api/v1/auth/register", json=RESPONSAVEL_VALIDO)
    assert resp.status_code == 201
    data = resp.json()
    assert "access_token" in data
    assert "refresh_token" in data
    assert data["token_type"] == "bearer"


@pytest.mark.asyncio
async def test_register_email_duplicado(client: AsyncClient):
    await client.post("/api/v1/auth/register", json=RESPONSAVEL_VALIDO)
    resp = await client.post("/api/v1/auth/register", json=RESPONSAVEL_VALIDO)
    assert resp.status_code == 409


@pytest.mark.asyncio
async def test_register_senha_curta(client: AsyncClient):
    dados = {**RESPONSAVEL_VALIDO, "email": "outro@teste.com", "senha": "123", "confirmar_senha": "123"}
    resp = await client.post("/api/v1/auth/register", json=dados)
    assert resp.status_code == 422
    assert "6 caracteres" in str(resp.json())


@pytest.mark.asyncio
async def test_register_senhas_diferentes(client: AsyncClient):
    dados = {**RESPONSAVEL_VALIDO, "email": "outro2@teste.com", "confirmar_senha": "outrasenha"}
    resp = await client.post("/api/v1/auth/register", json=dados)
    assert resp.status_code == 422
    assert "conferem" in str(resp.json())


@pytest.mark.asyncio
async def test_register_responsavel_menor_de_18(client: AsyncClient):
    # "O responsável precisa ter 18 anos ou mais"
    dados = {**RESPONSAVEL_VALIDO, "email": "jovem@teste.com", "data_nascimento": "2015-01-01"}
    resp = await client.post("/api/v1/auth/register", json=dados)
    assert resp.status_code == 422
    assert "18" in str(resp.json())


# ─── login ────────────────────────────────────────────────────────────────────

@pytest.mark.asyncio
async def test_login_sucesso(client: AsyncClient):
    await client.post("/api/v1/auth/register", json=RESPONSAVEL_VALIDO)
    resp = await client.post("/api/v1/auth/login", json={
        "email": RESPONSAVEL_VALIDO["email"],
        "senha": RESPONSAVEL_VALIDO["senha"],
    })
    assert resp.status_code == 200
    assert "access_token" in resp.json()


@pytest.mark.asyncio
async def test_login_senha_errada(client: AsyncClient):
    await client.post("/api/v1/auth/register", json=RESPONSAVEL_VALIDO)
    resp = await client.post("/api/v1/auth/login", json={
        "email": RESPONSAVEL_VALIDO["email"],
        "senha": "senhaerrada",
    })
    assert resp.status_code == 401
    # "Senha incorreta" — texto igual ao APK
    assert "incorreta" in resp.json()["detail"].lower()


@pytest.mark.asyncio
async def test_login_email_inexistente(client: AsyncClient):
    resp = await client.post("/api/v1/auth/login", json={
        "email": "naoexiste@teste.com",
        "senha": "qualquer",
    })
    assert resp.status_code == 401


# ─── refresh ──────────────────────────────────────────────────────────────────

@pytest.mark.asyncio
async def test_refresh_token_valido(client: AsyncClient):
    reg = await client.post("/api/v1/auth/register", json=RESPONSAVEL_VALIDO)
    refresh = reg.json()["refresh_token"]

    resp = await client.post("/api/v1/auth/refresh", json={"refresh_token": refresh})
    assert resp.status_code == 200
    assert "access_token" in resp.json()


@pytest.mark.asyncio
async def test_refresh_token_invalido(client: AsyncClient):
    resp = await client.post("/api/v1/auth/refresh", json={"refresh_token": "token.invalido.aqui"})
    assert resp.status_code == 401


# ─── me ───────────────────────────────────────────────────────────────────────

@pytest.mark.asyncio
async def test_me_autenticado(client: AsyncClient):
    reg = await client.post("/api/v1/auth/register", json=RESPONSAVEL_VALIDO)
    token = reg.json()["access_token"]

    resp = await client.get("/api/v1/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert resp.status_code == 200
    assert resp.json()["email"] == RESPONSAVEL_VALIDO["email"]
    assert resp.json()["nome"] == RESPONSAVEL_VALIDO["nome"]


@pytest.mark.asyncio
async def test_me_sem_token(client: AsyncClient):
    resp = await client.get("/api/v1/auth/me")
    assert resp.status_code == 403  # HTTPBearer retorna 403 sem header


# ─── forgot / reset password ─────────────────────────────────────────────────

@pytest.mark.asyncio
async def test_forgot_password_sempre_202(client: AsyncClient):
    # Mesmo e-mail não cadastrado retorna 202 (não revela se existe)
    resp = await client.post("/api/v1/auth/forgot-password", json={"email": "naoexiste@teste.com"})
    assert resp.status_code == 202


@pytest.mark.asyncio
async def test_reset_password_token_invalido(client: AsyncClient):
    resp = await client.post("/api/v1/auth/reset-password", json={
        "token": "tokeninvalido",
        "nova_senha": "novasenha123",
        "confirmar_senha": "novasenha123",
    })
    assert resp.status_code == 401
