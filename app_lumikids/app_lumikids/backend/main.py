from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import ValidationError

from app.api.v1.auth import router as auth_router
from app.api.v1.children import router as children_router

app = FastAPI(
    title="Lumikids API",
    description="Backend da Lumikids.",
    version="1.0.0",
)

# ─── CORS ─────────────────────────────────────────────────────────────────────
# Permite que o app Flutter acesse a API durante o desenvolvimento.
# Em produção, substitua "*" pelo domínio real.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ─── Routers ──────────────────────────────────────────────────────────────────
app.include_router(auth_router, prefix="/api/v1")
app.include_router(children_router, prefix="/api/v1")


# ─── Health check ─────────────────────────────────────────────────────────────
@app.get("/", tags=["status"])
async def root():
    return {"status": "ok", "app": "Lumikids API"}
