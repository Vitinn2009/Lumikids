import 'package:flutter/material.dart';
import '../theme/cores.dart';
import '../widgets/bottom.dart';

class VincularScreen extends StatefulWidget {
  const VincularScreen({super.key});

  @override
  State<VincularScreen> createState() => _VincularScreenState();
}

class _VincularScreenState extends State<VincularScreen> {
  final TextEditingController _idController = TextEditingController();
  String? _erroId;
  bool _isLoading = false;

  void _vincular() async {
    final id = _idController.text.trim();
    if (id.isEmpty) {
      setState(() => _erroId = 'Digite o ID de conexão');
      return;
    }
    setState(() {
      _isLoading = true;
      _erroId = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Vínculo realizado com sucesso!'),
            ],
          ),
          backgroundColor: Cores.sucesso,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.azul,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 36,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildBody(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    const BottomBar(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 26, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Botão voltar alinhado à esquerda
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'LumiKids',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Vincular criança',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildBody() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Cores.azulClaro,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.link_rounded,
          size: 44,
          color: Cores.azul,
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        'Digite o ID de conexão\ndo seu filho',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Cores.texto,
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'O responsável deve ter gerado esse código para você.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Cores.textoSuave,
        ),
      ),
      const SizedBox(height: 32),
      TextField(
        controller: _idController,
        keyboardType: TextInputType.text,
        style: const TextStyle(fontSize: 15, color: Cores.texto),
        decoration: InputDecoration(
          hintText: 'Ex: ABC-1234',
          hintStyle: const TextStyle(color: Cores.textoSuave),
          errorText: _erroId,
          prefixIcon: const Icon(Icons.key_rounded, color: Cores.azulMedio),
          filled: true,
          fillColor: Cores.azulClaro.withOpacity(0.35),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Cores.azulClaro, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Cores.azul, width: 2),
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
      ),
      const SizedBox(height: 40),
      _buildBotao(),
    ],
  );

  Widget _buildBotao() => Container(
    height: 56,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: const LinearGradient(
        colors: [Color(0xFF2F70FF), Color(0xFF72A8FF)],
      ),
      boxShadow: [
        BoxShadow(
          color: Cores.azulSombra,
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: _isLoading ? null : _vincular,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'VINCULAR',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
    ),
  );
}