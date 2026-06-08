import 'package:flutter/material.dart';
import '../theme/cores.dart';
import '../widgets/campo_texto.dart';
import '../widgets/bottom.dart';
import '../services/user.server.dart';
import 'home_screen.dart';

class CriarPerfilCriancaScreen extends StatefulWidget {
  const CriarPerfilCriancaScreen({super.key});

  @override
  State<CriarPerfilCriancaScreen> createState() =>
      _CriarPerfilCriancaScreenState();
}

class _CriarPerfilCriancaScreenState extends State<CriarPerfilCriancaScreen> {
  final _nomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  String? _erroNome;
  String? _erroData;

  final UserService _userService = UserService();

  // ------------------------------------------------------------
  // VALIDAÇÃO
  // ------------------------------------------------------------
  bool _validar() {
    bool valido = true;
    setState(() {
      final nomeError = _userService.validateName(_nomeController.text);
      if (nomeError != null) {
        _erroNome = nomeError;
        valido = false;
      } else {
        _erroNome = null;
      }

      final dataStr = _dataNascimentoController.text;
      if (dataStr.isEmpty) {
        _erroData = 'Informe a data de nascimento';
        valido = false;
      } else {
        try {
          final partes = dataStr.split('/');
          final dia = int.parse(partes[0]);
          final mes = int.parse(partes[1]);
          final ano = int.parse(partes[2]);
          final dataNasc = DateTime(ano, mes, dia);
          final idade = _userService.calculateAge(dataNasc);

          if (idade >= 18) {
            _erroData = 'A criança deve ter menos de 18 anos';
            valido = false;
          } else {
            _erroData = null;
          }
        } catch (e) {
          _erroData = 'Data inválida';
          valido = false;
        }
      }
    });
    return valido;
  }

  void _criar() async {
    if (_validar()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Perfil criado com sucesso!'),
            ],
          ),
          backgroundColor: Cores.sucesso,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.azul,
      body: Column(
        children: [
          _buildHeader(),
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
                            _buildCard(),
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

  Widget _buildHeader() => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(26, 32, 26, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'LumiKids',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Proteja cada passo\ncom carinho.',
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

  Widget _buildCard() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Perfil da criança:',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Cores.texto,
          letterSpacing: 0.2,
        ),
      ),
      const SizedBox(height: 20),
      CampoTexto(
        controller: _nomeController,
        label: 'Nome da criança',
        icone: Icons.person_outline_rounded,
        errorText: _erroNome,
      ),
      const SizedBox(height: 16),
      _buildCampoData(),
      const SizedBox(height: 28),
      _buildBotao(),
    ],
  );

  Widget _buildCampoData() => CampoTexto(
    controller: _dataNascimentoController,
    label: 'Data de nascimento:',
    icone: Icons.cake_outlined,
    readOnly: true,
    errorText: _erroData,
    onTap: () async {
      final data = await showDatePicker(
        context: context,
        initialDate: DateTime(2015),
        firstDate: DateTime(1990),
        lastDate: DateTime.now(),
        builder: (context, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Cores.azul),
          ),
          child: child!,
        ),
      );
      if (data != null) {
        setState(() {
          _dataNascimentoController.text =
              '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
        });
      }
    },
  );

  Widget _buildBotao() => Container(
    height: 56,
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
      onPressed: _criar,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: const Text(
        'CRIAR',
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