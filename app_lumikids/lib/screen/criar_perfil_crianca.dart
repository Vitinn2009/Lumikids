import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../design_system/colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/buttons.dart';

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

  @override
  void dispose() {
    _nome.dispose();
    _data.dispose();
    super.dispose();
  }

  void _selecionarData() async {
    DateTime? data = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      _data.text = "${data.day}/${data.month}/${data.year}";
    }
  }

  void _criarPerfil() {
    if (!_formKey.currentState!.validate()) return;

    if (_data.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a data de nascimento'),
        ),
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil criado com sucesso'),
      ),
    );
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
                // TÍTULO
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

                // CARD
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
                          hint: 'Nome',
                          icon: Icons.person,
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