import aiosmtplib
from email.message import EmailMessage

from app.core.config import settings


async def enviar_email_recuperacao(destinatario: str, token: str) -> None:
    """
    Envia um e-mail com o código/token de recuperação de senha.
    Se o SMTP não estiver configurado (.env vazio), apenas ignora o envio
    silenciosamente — útil durante o desenvolvimento.
    """
    if not settings.SMTP_USER or not settings.SMTP_PASS:
        print(f"[DEV] SMTP não configurado. Token de reset para {destinatario}: {token}")
        return

    mensagem = EmailMessage()
    mensagem["From"] = settings.EMAIL_FROM
    mensagem["To"] = destinatario
    mensagem["Subject"] = "Lumikids — Recuperação de senha"

    mensagem.set_content(
        f"""
Olá,

Você solicitou a recuperação de senha da sua conta Lumikids.

Use o código abaixo no aplicativo para redefinir sua senha:

{token}

Esse código expira em 30 minutos.

Se você não solicitou isso, ignore este e-mail.

— Equipe Lumikids
""".strip()
    )

    await aiosmtplib.send(
        mensagem,
        hostname=settings.SMTP_HOST,
        port=settings.SMTP_PORT,
        username=settings.SMTP_USER,
        password=settings.SMTP_PASS,
        start_tls=True,
    )