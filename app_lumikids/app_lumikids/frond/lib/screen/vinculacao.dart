import 'package:flutter/material.dart';
import '../design_system/colors.dart';
import '../widgets/buttons.dart';
import '../widgets/custom_text_field.dart';

class VinculacaoPage extends StatefulWidget {
  const VinculacaoPage({super.key});

  @override
  State<VinculacaoPage> createState() => _VinculacaoPageState();
}

class _VinculacaoPageState extends State<VinculacaoPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  String? _validarId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o ID de conexão';
    }

    if (value.trim().length < 4) {
      return 'ID inválido';
    }

    return null;
  }

  void _vincular() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID vinculado com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 42,
              ),
              decoration: BoxDecoration(
                color:  AppColors.veryLightBlue,
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
                    const SizedBox(height: 90),
                    const Text(
                      'Digite o ID de\nconexão do seu filho',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: _idController,
                      hint: '',
                      icon: Icons.numbers,
                      keyboardType: TextInputType.number,
                      validator: _validarId,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _vincular,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                          shadowColor: Colors.black26,
                        ),
                        child: const Text(
                          'VINCULAR',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}