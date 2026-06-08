import 'package:flutter/material.dart';
import '../theme/cores.dart';

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