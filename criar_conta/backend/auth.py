from datetime import date
from uuid import UUID

from pydantic import BaseModel, EmailStr, field_validator, Field


def _calcular_idade(nascimento: date) -> int:
    hoje = date.today()
    return hoje.year - nascimento.year - (
        (hoje.month, hoje.day) < (nascimento.month, nascimento.day)
    )


# ─── Registro ────────────────────────────────────────────────────────────────

class RegisterRequest(BaseModel):
    nome: str = Field(..., min_length=2, max_length=100)
    email: EmailStr
    senha: str = Field(..., min_length=6)
    confirmar_senha: str
    data_nascimento: date

    @field_validator("nome")
    @classmethod
    def nome_nao_vazio(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("Informe seu nome.")
        return v

    @field_validator("senha")
    @classmethod
    def senha_minima(cls, v: str) -> str:
        # "A senha deve ter ao menos 6 caracteres"
        if len(v) < 6:
            raise ValueError("A senha deve ter ao menos 6 caracteres.")
        return v

    @field_validator("confirmar_senha")
    @classmethod
    def senhas_iguais(cls, v: str, info) -> str:
        # "As senhas não conferem"
        senha = info.data.get("senha")
        if senha and v != senha:
            raise ValueError("As senhas não conferem.")
        return v

    @field_validator("data_nascimento")
    @classmethod
    def responsavel_maior_de_18(cls, v: date) -> date:
        # "O responsável precisa ter 18 anos ou mais para ser responsável"
        if v > date.today():
            raise ValueError("Data de nascimento inválida.")
        if _calcular_idade(v) < 18:
            raise ValueError("O responsável precisa ter 18 anos ou mais.")
        return v


# ─── Login ───────────────────────────────────────────────────────────────────

class LoginRequest(BaseModel):
    email: EmailStr
    senha: str


# ─── Tokens ──────────────────────────────────────────────────────────────────

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class RefreshRequest(BaseModel):
    refresh_token: str


# ─── Recuperação de senha ─────────────────────────────────────────────────────

class ForgotPasswordRequest(BaseModel):
    email: EmailStr


class ResetPasswordRequest(BaseModel):
    token: str
    nova_senha: str = Field(..., min_length=6)
    confirmar_senha: str

    @field_validator("confirmar_senha")
    @classmethod
    def senhas_iguais(cls, v: str, info) -> str:
        nova = info.data.get("nova_senha")
        if nova and v != nova:
            raise ValueError("As senhas não conferem.")
        return v


# ─── Resposta do usuário ──────────────────────────────────────────────────────

class UserOut(BaseModel):
    id: UUID
    nome: str
    email: str
    data_nascimento: date

    model_config = {"from_attributes": True}
