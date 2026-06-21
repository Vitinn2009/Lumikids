import ssl

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from app.core.config import settings


def _montar_url_async(url: str) -> str:
    """
    Garante que a URL use o driver assíncrono (asyncpg).
    Aceita tanto 'postgresql://...' quanto 'postgresql+asyncpg://...'.
    """
    if url.startswith("postgresql+asyncpg://"):
        return url
    if url.startswith("postgresql://"):
        return url.replace("postgresql://", "postgresql+asyncpg://", 1)
    if url.startswith("postgres://"):
        return url.replace("postgres://", "postgresql+asyncpg://", 1)
    return url


# Supabase exige conexão via SSL.
# Em algumas máquinas Windows, antivírus/proxy corporativo faz inspeção SSL
# e substitui o certificado real por um auto-assinado, o que quebra a
# verificação padrão (CERTIFICATE_VERIFY_FAILED: self-signed certificate
# in certificate chain). Por isso desabilitamos a verificação aqui.
DATABASE_URL = _montar_url_async(settings.DATABASE_URL)

_ssl_context = ssl.create_default_context()
_ssl_context.check_hostname = False
_ssl_context.verify_mode = ssl.CERT_NONE

engine = create_async_engine(
    DATABASE_URL,
    pool_pre_ping=True,
    connect_args={
        "ssl": _ssl_context,
        # Necessário ao usar o "Transaction pooler" do Supabase (pgbouncer).
        # Ele não suporta prepared statements; sem isso, dá
        # DuplicatePreparedStatementError.
        "statement_cache_size": 0,
    },
)

AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
)
