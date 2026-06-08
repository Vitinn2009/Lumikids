import 'package:flutter/material.dart';
import 'screens/registrar_sreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LumiKids',
      debugShowCheckedModeBanner: false,
      home: const CadastroScreen(),
    );
  }
}