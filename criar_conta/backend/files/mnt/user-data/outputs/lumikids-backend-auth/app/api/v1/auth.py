from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.dependencies import get_db, get_current_user
from app.models.user import User
from app.schemas.auth import (
    RegisterRequest,
    LoginRequest,
    TokenResponse,
    RefreshRequest,
    ForgotPasswordRequest,
    ResetPasswordRequest,
    UserOut,
)
from app.services import auth_service

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post(
    "/register",
    response_model=TokenResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Cadastro do responsável",
    description="Cria uma conta para o responsável e retorna os tokens de acesso.",
)
async def register(
    dados: RegisterRequest,
    db: AsyncSession = Depends(get_db),
):
    return await auth_service.registrar(db, dados)


@router.post(
    "/login",
    response_model=TokenResponse,
    summary="Login",
    description="Autentica o responsável e retorna os tokens de acesso.",
)
async def login(
    dados: LoginRequest,
    db: AsyncSession = Depends(get_db),
):
    return await auth_service.login(db, dados)


@router.post(
    "/refresh",
    response_model=TokenResponse,
    summary="Renovar token",
    description="Gera um novo access token a partir do refresh token.",
)
async def refresh(
    dados: RefreshRequest,
    db: AsyncSession = Depends(get_db),
):
    return await auth_service.renovar_token(db, dados.refresh_token)


@router.post(
    "/forgot-password",
    status_code=status.HTTP_202_ACCEPTED,
    summary="Solicitar recuperação de senha",
    description="Envia um e-mail com link para redefinição de senha.",
)
async def forgot_password(
    dados: ForgotPasswordRequest,
    db: AsyncSession = Depends(get_db),
):
    # Gera o token internamente — em produção, envie por e-mail aqui
    await auth_service.solicitar_reset(db, dados.email)

    # Sempre retorna 202, mesmo se o e-mail não existir (segurança)
    return {"mensagem": "Se o e-mail estiver cadastrado, você receberá as instruções em breve."}


@router.post(
    "/reset-password",
    status_code=status.HTTP_200_OK,
    summary="Redefinir senha",
    description="Redefine a senha usando o token recebido por e-mail.",
)
async def reset_password(
    dados: ResetPasswordRequest,
    db: AsyncSession = Depends(get_db),
):
    await auth_service.redefinir_senha(db, dados.token, dados.nova_senha)
    return {"mensagem": "Senha redefinida com sucesso."}


@router.get(
    "/me",
    response_model=UserOut,
    summary="Dados do usuário logado",
    description="Retorna as informações do responsável autenticado.",
)
async def me(usuario_atual: User = Depends(get_current_user)):
    return usuario_atual
