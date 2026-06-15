import 'package:flutter/material.dart';
// 1. IMPORTANTE: Altere o caminho abaixo para o local correto onde está o arquivo dessa tela
import 'screen/tipo_usuario.dart'; 

void main() {
  runApp(const MeuAplicativo());
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Monitoramento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      // 2. É aqui que a mágica acontece: definimos a sua tela como a página inicial
      home: const EscolhaUsuarioPage(), 
    );
  }
}