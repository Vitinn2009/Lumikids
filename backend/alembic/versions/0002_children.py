"""create children table

Revision ID: 0002_children
Revises: 0001_users
Create Date: 2024-01-01 00:00:00
"""

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID

revision = "0002_children"
down_revision = "0001_users"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "children",
        sa.Column(
            "id",
            UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "responsavel_id",
            UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("nome", sa.String(100), nullable=False),
        sa.Column("data_nascimento", sa.Date, nullable=False),
        sa.Column(
            "criado_em",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column("atualizado_em", sa.DateTime(timezone=True), nullable=True),
    )

    op.create_index("ix_children_id", "children", ["id"])
    op.create_index("ix_children_responsavel_id", "children", ["responsavel_id"])


def downgrade() -> None:
    op.drop_index("ix_children_responsavel_id", table_name="children")
    op.drop_index("ix_children_id", table_name="children")
    op.drop_table("children")