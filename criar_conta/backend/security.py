from datetime import datetime, timedelta, timezone
from typing import Literal

from jose import JWTError, jwt
from passlib.context import CryptContext

from app.core.config import settings

# ─── Bcrypt ───────────────────────────────────────────────────────────────────

_pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_senha(senha: str) -> str:
    return _pwd_context.hash(senha)


def verificar_senha(senha: str, hash: str) -> bool:
    return _pwd_context.verify(senha, hash)


# ─── JWT ─────────────────────────────────────────────────────────────────────

def _criar_token(
    user_id: str,
    tipo: Literal["access", "refresh"],
    expira_em: timedelta,
) -> str:
    payload = {
        "sub": user_id,
        "tipo": tipo,
        "exp": datetime.now(timezone.utc) + expira_em,
    }
    return jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")


def criar_access_token(user_id: str) -> str:
    return _criar_token(
        user_id,
        tipo="access",
        expira_em=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES),
    )


def criar_refresh_token(user_id: str) -> str:
    return _criar_token(
        user_id,
        tipo="refresh",
        expira_em=timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS),
    )


def decodificar_token(token: str, tipo_esperado: Literal["access", "refresh"]) -> str:
    """
    Decodifica o token e retorna o user_id (sub).
    Lança JWTError se o token for inválido, expirado ou do tipo errado.
    """
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
    except JWTError:
        raise JWTError("Token inválido ou expirado.")

    if payload.get("tipo") != tipo_esperado:
        raise JWTError(f"Token inválido: esperado '{tipo_esperado}'.")

    user_id: str | None = payload.get("sub")
    if not user_id:
        raise JWTError("Token sem identificação de usuário.")

    return user_id
