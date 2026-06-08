import 'package:flutter/material.dart';
import '../theme/cores.dart';
import '../widgets/bottom.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        title: const Text('LumiKids', style: TextStyle(color: Colors.white)),
        backgroundColor: Cores.azul,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.family_restroom, size: 80, color: Cores.azul),
            const SizedBox(height: 20),
            const Text('Bem-vindo ao LumiKids!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Cores.texto)),
            const SizedBox(height: 10),
            const Text('Você está logado com sucesso.', style: TextStyle(fontSize: 16, color: Cores.textoSuave)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout),
              label: const Text('SAIR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Cores.erro,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}