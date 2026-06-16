from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    pass


# Importa todos os models aqui para que o Alembic os detecte nas migrações
from app.models.user import User      # noqa: F401, E402
from app.models.child import Child    # noqa: F401, E402
