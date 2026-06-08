import 'package:flutter/material.dart';
import '../theme/cores.dart';

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