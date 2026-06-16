from uuid import UUID
from datetime import date, datetime

from pydantic import BaseModel, field_validator, Field


def _calcular_idade(nascimento: date) -> int:
    hoje = date.today()
    return hoje.year - nascimento.year - (
        (hoje.month, hoje.day) < (nascimento.month, nascimento.day)
    )


class ChildCreate(BaseModel):
    nome: str = Field(..., min_length=2, max_length=100)
    data_nascimento: date

    @field_validator("nome")
    @classmethod
    def nome_nao_vazio(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("O nome não pode estar vazio.")
        return v

    @field_validator("data_nascimento")
    @classmethod
    def crianca_deve_ser_menor_de_18(cls, v: date) -> date:
        if v > date.today():
            raise ValueError("Data de nascimento inválida.")
        if _calcular_idade(v) >= 18:
            raise ValueError("A criança deve ter menos de 18 anos.")
        return v


class ChildUpdate(BaseModel):
    nome: str | None = Field(default=None, min_length=2, max_length=100)
    data_nascimento: date | None = None

    @field_validator("nome")
    @classmethod
    def nome_nao_vazio(cls, v: str | None) -> str | None:
        if v is not None:
            v = v.strip()
            if not v:
                raise ValueError("O nome não pode estar vazio.")
        return v

    @field_validator("data_nascimento")
    @classmethod
    def crianca_deve_ser_menor_de_18(cls, v: date | None) -> date | None:
        if v is not None:
            if v > date.today():
                raise ValueError("Data de nascimento inválida.")
            if _calcular_idade(v) >= 18:
                raise ValueError("A criança deve ter menos de 18 anos.")
        return v


class ChildOut(BaseModel):
    id: UUID
    responsavel_id: UUID
    nome: str
    data_nascimento: date
    criado_em: datetime
    atualizado_em: datetime | None = None

    model_config = {"from_attributes": True}