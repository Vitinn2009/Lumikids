import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../design_system/colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/buttons.dart';
import '../services/services_api.dart';
import 'tela_principal.dart';

class CriarPerfilCriancaPage extends StatefulWidget {
  const CriarPerfilCriancaPage({super.key});

  @override
  State<CriarPerfilCriancaPage> createState() =>
      _CriarPerfilCriancaPageState();
}

class _CriarPerfilCriancaPageState extends State<CriarPerfilCriancaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _data = TextEditingController();

  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _nome.dispose();
    _data.dispose();
    super.dispose();
  }

  String? _validarNome(String? value) {
    if (value == null || value.trim().isEmpty) return 'Informe o nome';
    if (value.trim().length < 2) return 'Nome muito curto';
    return null;
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  Future<void> _criarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    if (_data.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data de nascimento')),
      );
      return;
    }

    final partes = _data.text.split('/');
    final nascimento = DateTime(
      int.parse(partes[2]),
      int.parse(partes[1]),
      int.parse(partes[0]),
    );

    final hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }

    if (idade >= 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não é permitido criar perfil para maiores de 18 anos',
          ),
        ),
      );
      return;
    }

    final dataApi =
        '${partes[2]}-${partes[1].padLeft(2, '0')}-${partes[0].padLeft(2, '0')}';

    try {
      await _apiService.criarPerfilCrianca(
        nome: _nome.text.trim(),
        dataNascimento: dataApi,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil criado com sucesso')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TelaPrincipal()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Proteja cada passo\ncom carinho.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          controller: _nome,
                          hint: 'Nome da criança',
                          icon: Icons.person,
                          validator: _validarNome,
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _data,
                          hint: 'Data de nascimento',
                          icon: Icons.calendar_month,
                          readOnly: true,
                          onTap: _selecionarData,
                        ),

                        const SizedBox(height: 24),

                        PrimaryButton(
                          text: 'CRIAR',
                          onTap: _criarPerfil,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}