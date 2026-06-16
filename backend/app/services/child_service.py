from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.child import Child
from app.schemas.child import ChildCreate, ChildUpdate
from app.core.exceptions import NotFoundError, ForbiddenError


async def criar_crianca(
    db: AsyncSession,
    responsavel_id: UUID,
    dados: ChildCreate,
) -> Child:
    """Cria um novo perfil de criança vinculado ao responsável logado."""
    crianca = Child(
        responsavel_id=responsavel_id,
        nome=dados.nome,
        data_nascimento=dados.data_nascimento,
    )
    db.add(crianca)
    await db.commit()
    await db.refresh(crianca)
    return crianca


async def listar_criancas(
    db: AsyncSession,
    responsavel_id: UUID,
) -> list[Child]:
    """Retorna todas as crianças do responsável logado."""
    resultado = await db.execute(
        select(Child)
        .where(Child.responsavel_id == responsavel_id)
        .order_by(Child.criado_em.desc())
    )
    return list(resultado.scalars().all())


async def buscar_crianca(
    db: AsyncSession,
    crianca_id: UUID,
    responsavel_id: UUID,
) -> Child:
    """Busca uma criança pelo ID, garantindo que pertence ao responsável logado."""
    resultado = await db.execute(
        select(Child).where(Child.id == crianca_id)
    )
    crianca = resultado.scalar_one_or_none()

    if crianca is None:
        raise NotFoundError("Criança não encontrada.")
    if crianca.responsavel_id != responsavel_id:
        raise ForbiddenError("Você não tem permissão para acessar este perfil.")

    return crianca


async def atualizar_crianca(
    db: AsyncSession,
    crianca_id: UUID,
    responsavel_id: UUID,
    dados: ChildUpdate,
) -> Child:
    """Atualiza nome e/ou data de nascimento. Ignora campos não enviados."""
    crianca = await buscar_crianca(db, crianca_id, responsavel_id)

    for campo, valor in dados.model_dump(exclude_unset=True).items():
        setattr(crianca, campo, valor)

    await db.commit()
    await db.refresh(crianca)
    return crianca


async def deletar_crianca(
    db: AsyncSession,
    crianca_id: UUID,
    responsavel_id: UUID,
) -> None:
    """Remove a criança e todos os dados associados (cascade)."""
    crianca = await buscar_crianca(db, crianca_id, responsavel_id)
    await db.delete(crianca)
    await db.commit()