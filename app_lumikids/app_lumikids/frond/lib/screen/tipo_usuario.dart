import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../widgets/option_card.dart';
import '../widgets/buttons.dart';
import 'criar_conta.dart';
import 'vinculacao.dart';

class EscolhaUsuarioPage extends StatefulWidget {
  const EscolhaUsuarioPage({super.key});

  @override
  State<EscolhaUsuarioPage> createState() => _EscolhaUsuarioPageState();
}

class _EscolhaUsuarioPageState extends State<EscolhaUsuarioPage> {
  int selected = 1;

  void selectCard(int index) {
    setState(() => selected = index);
  }

  void _continuar() {
    if (selected == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CriarContaPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const VinculacaoPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Quem vai usar esse\ndispositivo?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 70),
              OptionCard(
                title: 'Responsável',
                subtitle: 'Este é meu telefone',
                isSelected: selected == 1,
                collapsedColor: AppColors.white,
                expandedColor: AppColors.primary,
                borderColor: AppColors.veryLightBlue,
                dotColor: AppColors.white,
                imagePath: 'assets/teste.png',
                onTap: () => selectCard(1),
              ),
              const SizedBox(height: 18),
              OptionCard(
                title: 'Criança',
                subtitle: 'Este é o telefone do meu filho',
                isSelected: selected == 2,
                collapsedColor: AppColors.white,
                expandedColor: AppColors.lightBlue,
                borderColor: AppColors.veryLightBlue,
                dotColor: AppColors.white,
                imagePath: 'assets/crianca.png',
                onTap: () => selectCard(2),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Continuar',
                onTap: _continuar,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}