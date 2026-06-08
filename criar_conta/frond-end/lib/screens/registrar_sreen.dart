import 'package:flutter/material.dart';
import '../theme/cores.dart';
import '../widgets/campo_texto.dart';
import '../widgets/card_tipo.dart';
import '../widgets/bottom.dart';
import '../services/user.server.dart';
import 'login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'criar_perfil_crianca_screen.dart';
import 'vincular_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  String? _tipoSelecionado;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  // Erros de validação
  String? _erroTipo;
  String? _erroNome;
  String? _erroEmail;
  String? _erroData;
  String? _erroSenha;
  String? _erroConfirmarSenha;

  final UserService _userService = UserService();

  // ------------------------------------------------------------
  // LÓGICA DE VALIDAÇÃO (usa o service)
  // ------------------------------------------------------------
  bool _validar() {
    bool valido = true;
    setState(() {
      // Tipo
      if (_tipoSelecionado == null) {
        _erroTipo = 'Selecione quem você é';
        valido = false;
      } else {
        _erroTipo = null;
      }

      // Nome
      // Validação do nome usando o service
      final nameError = _userService.validateName(_nomeController.text);
      if (nameError != null) {
        _erroNome = nameError;
        valido = false;
      } else {
        _erroNome = null;
      }

      // E-mail
      final emailError = _userService.validateEmail(_emailController.text);
      if (emailError != null) {
        _erroEmail = emailError;
        valido = false;
      } else {
        _erroEmail = null;
      }

      // Data de nascimento e idade
      final dataStr = _dataNascimentoController.text;
      if (dataStr.isEmpty) {
        _erroData = 'Informe sua data de nascimento';
        valido = false;
      } else {
        try {
          final partes = dataStr.split('/');
          final dia = int.parse(partes[0]);
          final mes = int.parse(partes[1]);
          final ano = int.parse(partes[2]);
          final dataNasc = DateTime(ano, mes, dia);
          if (_tipoSelecionado == 'responsavel') {
            final ageError = _userService.validateAgeForResponsible(dataNasc);
            if (ageError != null) {
              _erroData = ageError;
              valido = false;
            } else {
              _erroData = null;
            }
          } else {
            _erroData = null;
          }
        } catch (e) {
          _erroData = 'Data inválida';
          valido = false;
        }
      }

      // Senha
      final senhaError = _userService.validatePassword(_senhaController.text);
      if (senhaError != null) {
        _erroSenha = senhaError;
        valido = false;
      } else {
        _erroSenha = null;
      }

      // Confirmar senha
      if (_confirmarSenhaController.text.isEmpty) {
        _erroConfirmarSenha = 'Confirme sua senha';
        valido = false;
      } else if (!_userService.passwordsMatch(
        _senhaController.text,
        _confirmarSenhaController.text,
      )) {
        _erroConfirmarSenha = 'As senhas não coincidem';
        valido = false;
      } else {
        _erroConfirmarSenha = null;
      }
    });
    return valido;
  }

  Future<void> _criarConta() async {
  if (!_validar()) return;

  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/cadastro'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'senha': _senhaController.text,
        'confirmarSenha': _confirmarSenhaController.text,
        'tipo': _tipoSelecionado,
        'dataNascimento': _dataNascimentoController.text,
      }),
    );

    final dados = jsonDecode(response.body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Cadastro realizado!'),
            ],
          ),
          backgroundColor: Cores.sucesso,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CriarPerfilCriancaScreen(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            dados['message'] ?? 'Erro ao cadastrar',
          ),
          backgroundColor: Cores.erro,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Erro de conexão: $e',
        ),
        backgroundColor: Cores.erro,
      ),
    );
  }
}

  // ------------------------------------------------------------
  // BUILD E MÉTODOS DE UI (apenas visual)
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildTipoUsuario(),
                    const SizedBox(height: 28),
                    CampoTexto(
                      controller: _nomeController,
                      label: 'Nome completo',
                      icone: Icons.person_outline_rounded,
                      errorText: _erroNome,
                    ),
                    const SizedBox(height: 14),
                    CampoTexto(
                      controller: _emailController,
                      label: 'E-mail',
                      icone: Icons.email_outlined,
                      tipoTeclado: TextInputType.emailAddress,
                      errorText: _erroEmail,
                    ),
                    const SizedBox(height: 14),
                    _buildCampoData(),
                    const SizedBox(height: 14),
                    _buildCampoSenha(
                      controller: _senhaController,
                      label: 'Senha',
                      visivel: _senhaVisivel,
                      erro: _erroSenha,
                      onToggle: () =>
                          setState(() => _senhaVisivel = !_senhaVisivel),
                    ),
                    const SizedBox(height: 14),
                    _buildCampoSenha(
                      controller: _confirmarSenhaController,
                      label: 'Confirmar senha',
                      visivel: _confirmarSenhaVisivel,
                      erro: _erroConfirmarSenha,
                      onToggle: () => setState(
                        () => _confirmarSenhaVisivel = !_confirmarSenhaVisivel,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildBotao(),
                    const SizedBox(height: 20),
                    _buildLinkLogin(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const BottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Column(
    children: [
      const SizedBox(height: 14),
      const Text(
        'LumiKids',
        style: TextStyle(
          fontSize: 13,
          color: Cores.azulMedio,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Bem-vindo',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: Cores.texto,
          letterSpacing: -0.5,
        ),
      ),
      const SizedBox(height: 16),
      Container(
        height: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Cores.azul.withOpacity(0),
              Cores.azul.withOpacity(0.4),
              Cores.azul.withOpacity(0),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildTipoUsuario() => Column(
    children: [
      const Text(
        'Você é:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Cores.texto,
        ),
      ),
      if (_erroTipo != null) ...[
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Cores.erro, size: 14),
            const SizedBox(width: 4),
            Text(
              _erroTipo!,
              style: const TextStyle(color: Cores.erro, fontSize: 12),
            ),
          ],
        ),
      ],
      const SizedBox(height: 18),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CardTipo(
            tipo: 'responsavel',
            label: 'Responsável',
            icone: Icons.supervisor_account_rounded,
            selecionado: _tipoSelecionado == 'responsavel',
            onTap: () => setState(() => _tipoSelecionado = 'responsavel'),
          ),
          const SizedBox(width: 24),
          CardTipo(
            tipo: 'crianca',
            label: 'Criança',
            icone: Icons.child_care_rounded,
            selecionado: _tipoSelecionado == 'crianca',
            onTap: () async {
              final vinculou = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const VincularScreen()),
              );
              if (vinculou == true)
                setState(() => _tipoSelecionado = 'crianca');
            },
          ),
        ],
      ),
    ],
  );

  Widget _buildCampoData() => CampoTexto(
    controller: _dataNascimentoController,
    label: 'Data de nascimento',
    icone: Icons.cake_outlined,
    readOnly: true,
    errorText: _erroData,
    onTap: () async {
      final data = await showDatePicker(
        context: context,
        initialDate: DateTime(2010),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Cores.azul),
          ),
          child: child!,
        ),
      );
      if (data != null)
        setState(() {
          _dataNascimentoController.text =
              '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
        });
    },
  );

  Widget _buildCampoSenha({
    required TextEditingController controller,
    required String label,
    required bool visivel,
    required String? erro,
    required VoidCallback onToggle,
  }) {
    return CampoTexto(
      controller: controller,
      label: label,
      icone: Icons.lock_outline_rounded,
      obscureText: !visivel,
      errorText: erro,
      suffixIcon: IconButton(
        icon: Icon(
          visivel ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Cores.azulMedio,
          size: 20,
        ),
        onPressed: onToggle,
      ),
    );
  }

  Widget _buildBotao() => Container(
    height: 56,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: const LinearGradient(
        colors: [Color(0xFF2F70FF), Color(0xFF72A8FF)],
      ),
      boxShadow: [
        BoxShadow(
          color: Cores.azul.withOpacity(0.4),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: _criarConta,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: const Text(
        'CRIAR CONTA',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _buildLinkLogin() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Já possui conta? ',
        style: TextStyle(color: Cores.textoSuave, fontSize: 14),
      ),
      GestureDetector(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        ),
        child: const Text(
          'Entrar',
          style: TextStyle(
            color: Cores.azul,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ],
  );
}
