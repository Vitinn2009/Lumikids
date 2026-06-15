from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    # Banco de dados
    DATABASE_URL: str

    # JWT
    SECRET_KEY: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7

    # Email (recuperação de senha)
    SMTP_HOST: str = "smtp.gmail.com"
    SMTP_PORT: int = 587
    SMTP_USER: str = ""
    SMTP_PASS: str = ""
    EMAIL_FROM: str = "noreply@lumikids.app"

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


settings = Settings()
