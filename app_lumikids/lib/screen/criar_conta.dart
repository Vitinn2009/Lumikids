import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/buttons.dart';

import 'login.dart';
import 'criar_perfil_crianca.dart';

class CriarContaPage extends StatefulWidget {
  const CriarContaPage({super.key});

  @override
  State<CriarContaPage> createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {
  final _formKey = GlobalKey<FormState>();

  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _data = TextEditingController();
  final _senha = TextEditingController();
  final _confirmar = TextEditingController();

  bool senhaVisivel = false;
  bool confirmarVisivel = false;

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _data.dispose();
    _senha.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  bool _temMaisDe18Anos(DateTime dataNascimento) {
    final hoje = DateTime.now();

    int idade = hoje.year - dataNascimento.year;

    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }

    return idade >= 18;
  }

  String? _validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu nome';
    }

    if (value.trim().length < 3) {
      return 'Nome muito curto';
    }

    if (RegExp(r'\d').hasMatch(value)) {
      return 'Nome não pode conter números';
    }

    return null;
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu e-mail';
    }

    final email = value.trim();
    final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!regex.hasMatch(email)) {
      return 'E-mail inválido';
    }

    return null;
  }

  String? _validarData(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe sua data de nascimento';
    }

    try {
      final partes = value.split('/');
      if (partes.length != 3) {
        return 'Data inválida';
      }

      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);

      final data = DateTime(ano, mes, dia);

      if (data.day != dia || data.month != mes || data.year != ano) {
        return 'Data inválida';
      }

      if (data.isAfter(DateTime.now())) {
        return 'Data não pode ser no futuro';
      }

      if (!_temMaisDe18Anos(data)) {
        return 'Você precisa ter 18 anos ou mais';
      }

      return null;
    } catch (_) {
      return 'Data inválida';
    }
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe sua senha';
    }

    if (value.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres';
    }

    return null;
  }

  String? _validarConfirmarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme sua senha';
    }

    if (value != _senha.text) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: DateTime(hoje.year - 18, hoje.month, hoje.day),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      setState(() {
        _data.text =
            '${data.day.toString().padLeft(2, '0')}/'
            '${data.month.toString().padLeft(2, '0')}/'
            '${data.year}';
      });
    }
  }

  void _criarConta() {
    final form = _formKey.currentState;
    if (form == null) return;

    if (!form.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos corretamente'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CriarPerfilCriancaPage(),
      ),
    );
  }

  void _irParaLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
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
                        controller: _nome,
                        hint: 'Nome',
                        icon: Icons.person,
                        validator: _validarNome,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-ZÀ-ÿ\s]"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _email,
                        hint: 'Email',
                        icon: Icons.email,
                        validator: _validarEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _data,
                        hint: 'Data nascimento',
                        icon: Icons.calendar_month,
                        readOnly: true,
                        onTap: _selecionarData,
                        validator: _validarData,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _senha,
                        hint: 'Senha',
                        icon: Icons.lock,
                        obscureText: !senhaVisivel,
                        validator: _validarSenha,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => senhaVisivel = !senhaVisivel);
                          },
                          icon: Icon(
                            senhaVisivel
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _confirmar,
                        hint: 'Confirmar senha',
                        icon: Icons.lock_outline,
                        obscureText: !confirmarVisivel,
                        validator: _validarConfirmarSenha,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              confirmarVisivel = !confirmarVisivel;
                            });
                          },
                          icon: Icon(
                            confirmarVisivel
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      PrimaryButton(
                        text: 'Criar conta',
                        onTap: _criarConta,
                      ),
                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Já tem conta? '),
                          GestureDetector(
                            onTap: _irParaLogin,
                            child: const Text(
                              'Fazer login',
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