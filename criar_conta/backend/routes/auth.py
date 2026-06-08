from flask import Blueprint, request, jsonify
from datetime import datetime

auth_bp = Blueprint("auth", __name__)

# Lista em memória (substitua por banco de dados quando quiser evoluir)
usuarios = []


@auth_bp.route("/cadastro", methods=["POST"])
def cadastro():
    dados = request.get_json(silent=True)

    if not dados:
        return jsonify({"success": False, "message": "Corpo da requisição inválido"}), 400

    nome           = dados.get("nome", "").strip()
    email          = dados.get("email", "").strip().lower()
    senha          = dados.get("senha", "")
    confirmar_senha = dados.get("confirmarSenha", "")
    tipo           = dados.get("tipo", "")
    data_nascimento = dados.get("dataNascimento", "")  # recebe "DD/MM/AAAA"

    # ── Validações ──────────────────────────────────────────────

    if not nome:
        return jsonify({"success": False, "message": "Nome é obrigatório"}), 400

    if not email:
        return jsonify({"success": False, "message": "E-mail é obrigatório"}), 400

    if not senha:
        return jsonify({"success": False, "message": "Senha é obrigatória"}), 400

    if len(senha) < 6:
        return jsonify({"success": False, "message": "A senha deve ter ao menos 6 caracteres"}), 400

    if not confirmar_senha:
        return jsonify({"success": False, "message": "Confirme sua senha"}), 400

    if senha != confirmar_senha:
        return jsonify({"success": False, "message": "As senhas não coincidem"}), 400

    if tipo not in ("responsavel", "crianca"):
        return jsonify({"success": False, "message": "Tipo de usuário inválido"}), 400

    # ── Parsing e validação da data ──────────────────────────────
    # Flutter envia "DD/MM/AAAA" — convertemos para um objeto date.
    if not data_nascimento:
        return jsonify({"success": False, "message": "Informe sua data de nascimento"}), 400

    try:
        data_nasc = datetime.strptime(data_nascimento, "%d/%m/%Y").date()
    except ValueError:
        return jsonify({"success": False, "message": "Data de nascimento inválida"}), 400

    # Responsável precisa ter 18+
    if tipo == "responsavel":
        hoje = datetime.today().date()
        idade = hoje.year - data_nasc.year
        if (hoje.month, hoje.day) < (data_nasc.month, data_nasc.day):
            idade -= 1
        if idade < 18:
            return jsonify({
                "success": False,
                "message": "Você precisa ter 18 anos ou mais para ser responsável"
            }), 400

    # ── E-mail duplicado ─────────────────────────────────────────
    if any(u["email"] == email for u in usuarios):
        return jsonify({"success": False, "message": "E-mail já cadastrado"}), 409

    # ── Persistência ─────────────────────────────────────────────
    usuarios.append({
        "nome": nome,
        "email": email,
        "senha": senha,          # TODO: substituir por bcrypt quando conectar banco real
        "tipo": tipo,
        "dataNascimento": data_nasc.isoformat(),  # armazena como "AAAA-MM-DD"
    })

    return jsonify({
        "success": True,
        "message": "Usuário cadastrado com sucesso",
        "email": email,
    }), 201


@auth_bp.route("/login", methods=["POST"])
def login():
    dados = request.get_json(silent=True)

    if not dados:
        return jsonify({"success": False, "message": "Corpo da requisição inválido"}), 400

    email = dados.get("email", "").strip().lower()
    senha = dados.get("senha", "")

    if not email:
        return jsonify({"success": False, "message": "Informe o e-mail"}), 400

    if not senha:
        return jsonify({"success": False, "message": "Informe a senha"}), 400

    usuario = next((u for u in usuarios if u["email"] == email), None)

    if not usuario:
        return jsonify({"success": False, "message": "E-mail não cadastrado"}), 401

    if usuario["senha"] != senha:
        return jsonify({"success": False, "message": "Senha incorreta"}), 401

    return jsonify({
        "success": True,
        "message": "Login realizado com sucesso",
        "usuario": {
            "nome": usuario["nome"],
            "email": usuario["email"],
            "tipo": usuario["tipo"],
        },
    }), 200


@auth_bp.route("/esqueci-senha", methods=["POST"])
def esqueci_senha():
    """
    Por ora apenas verifica se o e-mail existe.
    Quando o OTP for implementado, aqui entra a geração e envio do código.
    """
    dados = request.get_json(silent=True)

    if not dados:
        return jsonify({"success": False, "message": "Corpo da requisição inválido"}), 400

    email = dados.get("email", "").strip().lower()

    if not email:
        return jsonify({"success": False, "message": "Informe o e-mail"}), 400

    # Resposta genérica intencional — não revela se o e-mail existe
    return jsonify({
        "success": True,
        "message": "Se este e-mail estiver cadastrado, você receberá as instruções.",
    }), 200