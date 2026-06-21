from uuid import uuid4
from datetime import datetime

from sqlalchemy import Column, String, Date, DateTime, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship

from app.db.base import Base


class User(Base):
    __tablename__ = "users"

    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid4,
        index=True
    )

    nome = Column(String(100), nullable=False)

    email = Column(String(255), unique=True, nullable=False, index=True)

    # SEMPRE armazenar hash, nunca senha pura
    senha_hash = Column(String, nullable=False)

    data_nascimento = Column(Date, nullable=False)

    criado_em = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False
    )

    atualizado_em = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now()
    )

    # Relação com children
    children = relationship(
        "Child",
        back_populates="responsavel",
        cascade="all, delete-orphan"
    )