import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../design_system/colors.dart';
import '../widgets/buttons.dart';
import '../widgets/custom_text_field.dart';
import 'criar_conta.dart';
import 'esqueci_senha.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool senhaVisivel = false;

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu e-mail';
    }
    final email = value.trim();
    final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) return 'E-mail inválido';
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua senha';
    return null;
  }

  void _fazerLogin() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso')),
      );
    }
  }

  void _irParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CriarContaPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alturaInferior = MediaQuery.of(context).size.height / 3;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 40,
                  bottom: alturaInferior + 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Lumikids',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Bem-vindo',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'Sentimos saudades',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 300,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 24),

                      CustomTextField(
                        controller: _email,
                        hint: 'Email',
                        icon: Icons.email,
                        validator: _validarEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _senha,
                        hint: 'Senha',
                        icon: Icons.lock,
                        obscureText: !senhaVisivel,
                        validator: _validarSenha,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => senhaVisivel = !senhaVisivel),
                          icon: Icon(
                            senhaVisivel ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Botão LOGIN
                      PrimaryButton(
                        text: 'Entrar',
                        onTap: _fazerLogin,
                      ),
                      const SizedBox(height: 10),

                      // Esqueci minha senha abaixo do botão
                      GestureDetector(
                        
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => const EsqueciSenhaPage(),
                                ),
                            );
                            },
                        
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Linha de criar conta
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Não tem conta? '),
                          GestureDetector(
                            onTap: _irParaCadastro,
                            child: const Text(
                              'Criar conta',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: alturaInferior / 3,
                decoration: const BoxDecoration(
                  color: AppColors.veryLightBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}