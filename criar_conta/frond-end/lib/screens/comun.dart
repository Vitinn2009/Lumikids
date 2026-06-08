import 'package:flutter/material.dart';

// CORES
class Cores {
  static const azul = Color(0xFF2F70FF);
  static const azulMedio = Color(0xFF4186D6);
  static const azulClaro = Color(0xFFDDEBFF);
  static const azulSombra = Color(0x332F70FF);
  static const erro = Color(0xFFE53935);
  static const sucesso = Color(0xFF2E7D32);
  static const texto = Color(0xFF1A1A2E);
  static const textoSuave = Color(0xFF7A8099);
  static const fundo = Color(0xFFF5F8FF);
}

// CAMPO DE TEXTO REUTILIZÁVEL
class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.controller,
    required this.label,
    required this.icone,
    this.tipoTeclado = TextInputType.text,
    this.errorText,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icone;
  final TextInputType tipoTeclado;
  final String? errorText;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final temErro = errorText != null && errorText!.isNotEmpty;
    return TextField(
      controller: controller,
      keyboardType: tipoTeclado,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 15, color: Cores.texto, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Cores.textoSuave, fontSize: 15),
        errorText: temErro ? errorText : null,
        errorStyle: const TextStyle(color: Cores.erro, fontSize: 12),
        prefixIcon: Icon(icone, color: temErro ? Cores.erro : Cores.azulMedio, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: temErro ? const Color(0xFFFFF0F0) : Cores.azulClaro.withOpacity(0.35),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: temErro ? Cores.erro : Cores.azulClaro, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: temErro ? Cores.erro : Cores.azul, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Cores.erro, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Cores.erro, width: 2),
        ),
      ),
    );
  }
}

// CARD DE TIPO (RESPONSÁVEL / CRIANÇA)
class CardTipo extends StatelessWidget {
  const CardTipo({
    super.key,
    required this.tipo,
    required this.label,
    required this.icone,
    required this.selecionado,
    required this.onTap,
  });

  final String tipo;
  final String label;
  final IconData icone;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: 130,
        height: 120,
        decoration: BoxDecoration(
          color: selecionado ? Cores.azul : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selecionado ? Cores.azul : Cores.azulClaro, width: 2),
          boxShadow: [
            BoxShadow(
              color: selecionado ? Cores.azulSombra : Colors.black12,
              blurRadius: selecionado ? 16 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selecionado ? Colors.white.withOpacity(0.2) : Cores.azulClaro,
                shape: BoxShape.circle,
              ),
              child: Icon(icone, size: 32, color: selecionado ? Colors.white : Cores.azul),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selecionado ? Colors.white : Cores.azulMedio,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BARRA INFERIOR FIXA
class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height * 0.05;
    return Container(
      height: altura,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Cores.azul,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Center(
        child: Text(
          'LumiKids',
          style: TextStyle(color: Colors.white, fontSize: altura * 0.4, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}