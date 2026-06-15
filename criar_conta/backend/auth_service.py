import secrets
from datetime import datetime, timedelta, timezone
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ConflictError, UnauthorizedError, NotFoundError
from app.core.security import (
    hash_senha,
    verificar_senha,
    criar_access_token,
    criar_refresh_token,
    decodificar_token,
)
from app.models.user import User
from app.schemas.auth import RegisterRequest, LoginRequest, TokenResponse

# Armazena tokens de reset em memória.
# Em produção, substitua por uma tabela no banco ou chave no Redis.
_reset_tokens: dict[str, tuple[str, datetime]] = {}
_RESET_EXPIRA_EM = timedelta(minutes=30)


# ─── Registro ────────────────────────────────────────────────────────────────

async def registrar(db: AsyncSession, dados: RegisterRequest) -> TokenResponse:
    # Verifica se email já existe
    resultado = await db.execute(select(User).where(User.email == dados.email))
    if resultado.scalar_one_or_none():
        raise ConflictError("Este e-mail já está cadastrado.")

    usuario = User(
        nome=dados.nome,
        email=dados.email,
        senha_hash=hash_senha(dados.senha),
        data_nascimento=dados.data_nascimento,
    )
    db.add(usuario)
    await db.commit()
    await db.refresh(usuario)

    return _gerar_tokens(usuario)


# ─── Login ───────────────────────────────────────────────────────────────────

async def login(db: AsyncSession, dados: LoginRequest) -> TokenResponse:
    resultado = await db.execute(select(User).where(User.email == dados.email))
    usuario = resultado.scalar_one_or_none()

    # Mesmo erro para email errado e senha errada (segurança)
    if not usuario or not verificar_senha(dados.senha, usuario.senha_hash):
        raise UnauthorizedError("Senha incorreta.")  # texto igual ao APK

    return _gerar_tokens(usuario)


# ─── Refresh token ───────────────────────────────────────────────────────────

async def renovar_token(db: AsyncSession, refresh_token: str) -> TokenResponse:
    from jose import JWTError

    try:
        user_id = decodificar_token(refresh_token, tipo_esperado="refresh")
    except JWTError:
        raise UnauthorizedError("Refresh token inválido ou expirado.")

    resultado = await db.execute(select(User).where(User.id == UUID(user_id)))
    usuario = resultado.scalar_one_or_none()

    if not usuario:
        raise UnauthorizedError("Usuário não encontrado.")

    return _gerar_tokens(usuario)


# ─── Recuperação de senha ─────────────────────────────────────────────────────

async def solicitar_reset(db: AsyncSession, email: str) -> str:
    """
    Gera um token de reset e o armazena.
    Retorna o token para que o router possa enviá-lo por e-mail.
    Em produção, o envio de e-mail deve acontecer aqui (ou via worker).
    """
    resultado = await db.execute(select(User).where(User.email == email))
    usuario = resultado.scalar_one_or_none()

    # Não revela se o e-mail existe ou não (segurança)
    if not usuario:
        return ""

    token = secrets.token_urlsafe(32)
    _reset_tokens[token] = (str(usuario.id), datetime.now(timezone.utc))
    return token


async def redefinir_senha(db: AsyncSession, token: str, nova_senha: str) -> None:
    entrada = _reset_tokens.get(token)

    if not entrada:
        raise UnauthorizedError("Token de recuperação inválido.")

    user_id, criado_em = entrada
    if datetime.now(timezone.utc) - criado_em > _RESET_EXPIRA_EM:
        del _reset_tokens[token]
        raise UnauthorizedError("Token de recuperação expirado.")

    resultado = await db.execute(select(User).where(User.id == UUID(user_id)))
    usuario = resultado.scalar_one_or_none()

    if not usuario:
        raise NotFoundError("Usuário não encontrado.")

    usuario.senha_hash = hash_senha(nova_senha)
    del _reset_tokens[token]

    await db.commit()


# ─── Helpers ─────────────────────────────────────────────────────────────────

def _gerar_tokens(usuario: User) -> TokenResponse:
    user_id = str(usuario.id)
    return TokenResponse(
        access_token=criar_access_token(user_id),
        refresh_token=criar_refresh_token(user_id),
    )
