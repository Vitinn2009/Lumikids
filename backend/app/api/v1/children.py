from uuid import UUID

from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.dependencies import get_current_user, get_db
from app.models.user import User
from app.schemas.child import ChildCreate, ChildUpdate, ChildOut
from app.services import child_service

router = APIRouter(prefix="/children", tags=["children"])


@router.post(
    "/",
    response_model=ChildOut,
    status_code=status.HTTP_201_CREATED,
    summary="Criar perfil de criança",
)
async def criar_crianca(
    dados: ChildCreate,
    db: AsyncSession = Depends(get_db),
    usuario_atual: User = Depends(get_current_user),
):
    return await child_service.criar_crianca(
        db=db,
        responsavel_id=usuario_atual.id,
        dados=dados,
    )


@router.get(
    "/",
    response_model=list[ChildOut],
    summary="Listar crianças do responsável",
)
async def listar_criancas(
    db: AsyncSession = Depends(get_db),
    usuario_atual: User = Depends(get_current_user),
):
    return await child_service.listar_criancas(
        db=db,
        responsavel_id=usuario_atual.id,
    )


@router.get(
    "/{crianca_id}",
    response_model=ChildOut,
    summary="Detalhe de uma criança",
)
async def buscar_crianca(
    crianca_id: UUID,
    db: AsyncSession = Depends(get_db),
    usuario_atual: User = Depends(get_current_user),
):
    return await child_service.buscar_crianca(
        db=db,
        crianca_id=crianca_id,
        responsavel_id=usuario_atual.id,
    )


@router.put(
    "/{crianca_id}",
    response_model=ChildOut,
    summary="Atualizar perfil de criança",
)
async def atualizar_crianca(
    crianca_id: UUID,
    dados: ChildUpdate,
    db: AsyncSession = Depends(get_db),
    usuario_atual: User = Depends(get_current_user),
):
    return await child_service.atualizar_crianca(
        db=db,
        crianca_id=crianca_id,
        responsavel_id=usuario_atual.id,
        dados=dados,
    )


@router.delete(
    "/{crianca_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Remover criança",
)
async def deletar_crianca(
    crianca_id: UUID,
    db: AsyncSession = Depends(get_db),
    usuario_atual: User = Depends(get_current_user),
):
    await child_service.deletar_crianca(
        db=db,
        crianca_id=crianca_id,
        responsavel_id=usuario_atual.id,
    )