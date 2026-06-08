import 'package:flutter/material.dart';
import '../theme/cores.dart';

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