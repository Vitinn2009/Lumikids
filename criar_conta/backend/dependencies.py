from uuid import UUID

from fastapi import Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import UnauthorizedError
from app.core.security import decodificar_token
from app.db.session import AsyncSessionLocal

# ─── Banco de dados ───────────────────────────────────────────────────────────

async def get_db() -> AsyncSession:  # type: ignore
    async with AsyncSessionLocal() as session:
        yield session


# ─── Autenticação ─────────────────────────────────────────────────────────────

_bearer = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(_bearer),
    db: AsyncSession = Depends(get_db),
):
    """
    Extrai e valida o Bearer token.
    Retorna o User autenticado ou lança 401.
    """
    # Importação local para evitar circular import
    from app.models.user import User

    try:
        user_id = decodificar_token(credentials.credentials, tipo_esperado="access")
    except JWTError:
        raise UnauthorizedError("Token inválido ou expirado.")

    resultado = await db.execute(
        select(User).where(User.id == UUID(user_id))
    )
    usuario = resultado.scalar_one_or_none()

    if usuario is None:
        raise UnauthorizedError("Usuário não encontrado.")

    return usuario
