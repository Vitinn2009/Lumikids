import 'package:flutter/material.dart';
import '../theme/cores.dart';
import '../widgets/campo_texto.dart';
import '../widgets/bottom.dart';
import '../services/user.server.dart';
import 'home_screen.dart';
import 'registrar_sreen.dart'; 
import 'esqueci_senha_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaVisivel = false;
  String? _erroLogin;

  final UserService _userService = UserService();

  void _fazerLogin() async {
    final erro = _userService.validateLogin(
      _emailController.text,
      _senhaController.text,
    );
    if (erro != null) {
      setState(() => _erroLogin = erro);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado!'),
          backgroundColor: Cores.sucesso,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

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
                    const SizedBox(height: 40),
                    if (_erroLogin != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          // CORRIGIDO: withOpacity deprecated → withValues
                          color: Cores.erro.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Cores.erro,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _erroLogin!,
                                style: const TextStyle(
                                  color: Cores.erro,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    CampoTexto(
                      controller: _emailController,
                      label: 'E-mail',
                      icone: Icons.email_outlined,
                      tipoTeclado: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    CampoTexto(
                      controller: _senhaController,
                      label: 'Senha',
                      icone: Icons.lock_outline_rounded,
                      obscureText: !_senhaVisivel,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _senhaVisivel
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Cores.azulMedio,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _senhaVisivel = !_senhaVisivel),
                      ),
                    ),
                    // ADICIONADO: link "Esqueci minha senha"
                    const SizedBox(height: 10),
                    _buildLinkEsqueciSenha(),
                    const SizedBox(height: 22),
                    _buildBotaoLogin(),
                    const SizedBox(height: 20),
                    _buildLinkCadastro(),
                    const SizedBox(height: 30),
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
        'Bem-vindo de volta',
        style: TextStyle(
          fontSize: 28,
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
              // CORRIGIDO: withOpacity deprecated → withValues
              Cores.azul.withValues(alpha: 0),
              Cores.azul.withValues(alpha: 0.4),
              Cores.azul.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildBotaoLogin() => Container(
    height: 56,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: const LinearGradient(
        colors: [Color(0xFF2F70FF), Color(0xFF72A8FF)],
      ),
      boxShadow: [
        BoxShadow(
          // CORRIGIDO: withOpacity deprecated → withValues
          color: Cores.azul.withValues(alpha: 0.4),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: _fazerLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: const Text(
        'ENTRAR',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
          color: Colors.white,
        ),
      ),
    ),
  );

  // ADICIONADO: widget do link "Esqueci minha senha"
  Widget _buildLinkEsqueciSenha() => Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EsqueciSenhaScreen()),
      ),
      child: const Text(
        'Esqueci minha senha',
        style: TextStyle(
          color: Cores.azulMedio,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  Widget _buildLinkCadastro() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Não tem uma conta? ',
        style: TextStyle(color: Cores.textoSuave, fontSize: 14),
      ),
      GestureDetector(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CadastroScreen()),
        ),
        child: const Text(
          'Criar conta',
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