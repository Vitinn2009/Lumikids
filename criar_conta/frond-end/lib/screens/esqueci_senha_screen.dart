import 'package:flutter/material.dart';
import '../theme/cores.dart';
import '../widgets/campo_texto.dart';
import '../widgets/bottom.dart';
import '../services/user.server.dart';
import 'login_screen.dart';

class EsqueciSenhaScreen extends StatefulWidget {
const EsqueciSenhaScreen({super.key});

@override
State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
final _emailController = TextEditingController();
final UserService _userService = UserService();

String? _erroEmail;

void _enviarLink() {
final email = _emailController.text.trim();

if (email.isEmpty) {
  setState(() {
    _erroEmail = 'Por favor, informe o seu e-mail.';
  });
  return;
}

if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
  setState(() {
    _erroEmail = 'Informe um e-mail válido.';
  });
  return;
}

if (!_userService.emailExists(email)) {
  setState(() {
    _erroEmail = 'Este e-mail não está cadastrado.';
  });
  return;
}

setState(() {
  _erroEmail = null;
});

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text(
      'Link de recuperação enviado! Verifique seu e-mail.',
    ),
    backgroundColor: Cores.sucesso,
    duration: Duration(seconds: 3),
  ),
);

}

void _voltarLogin() {
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => const LoginScreen(),
),
);
}

@override
void dispose() {
_emailController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Cores.fundo,
body: SafeArea(
child: Column(
children: [
Expanded(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(
horizontal: 26,
vertical: 36,
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
_buildHeader(),
const SizedBox(height: 40),

                if (_erroEmail != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Cores.erro.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Cores.erro,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _erroEmail!,
                            style: const TextStyle(
                              color: Cores.erro,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                _buildTextoExplicativo(),
                const SizedBox(height: 28),

                CampoTexto(
                  controller: _emailController,
                  label: 'E-mail',
                  icone: Icons.email_outlined,
                  tipoTeclado: TextInputType.emailAddress,
                ),

                const SizedBox(height: 32),

                _buildBotaoEnviar(),

                const SizedBox(height: 20),

                _buildLinkVoltarLogin(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        const BottomBar(),
      ],
    ),
  ),
);

}

Widget _buildHeader() => Column(
children: [
const SizedBox(height: 14),
const Text(
'LumiKids',
style: TextStyle(
fontSize: 13,
color: Cores.azulMedio,
fontWeight: FontWeight.w700,
letterSpacing: 2,
),
),
const SizedBox(height: 4),
const Text(
'Recuperar Senha',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.w800,
color: Cores.texto,
letterSpacing: -0.5,
),
),
const SizedBox(height: 16),
Container(
height: 2,
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [
Cores.azul.withOpacity(0),
Cores.azul.withOpacity(0.4),
Cores.azul.withOpacity(0),
],
),
),
),
],
);

Widget _buildTextoExplicativo() => const Text(
'Digite o e-mail cadastrado para receber as instruções de recuperação.',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 14,
color: Cores.textoSuave,
height: 1.5,
),
);

Widget _buildBotaoEnviar() => Container(
height: 56,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(18),
gradient: const LinearGradient(
colors: [
Color(0xFF2F70FF),
Color(0xFF72A8FF),
],
),
boxShadow: [
BoxShadow(
color: Cores.azul.withOpacity(0.4),
blurRadius: 14,
offset: const Offset(0, 6),
),
],
),
child: ElevatedButton(
onPressed: _enviarLink,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.transparent,
shadowColor: Colors.transparent,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
),
child: const Text(
'ENVIAR LINK DE RECUPERAÇÃO',
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w800,
letterSpacing: 1.5,
color: Colors.white,
),
),
),
);

Widget _buildLinkVoltarLogin() => Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text(
'Lembrou a senha? ',
style: TextStyle(
color: Cores.textoSuave,
fontSize: 14,
),
),
GestureDetector(
onTap: _voltarLogin,
child: const Text(
'Voltar ao login',
style: TextStyle(
color: Cores.azul,
fontSize: 14,
fontWeight: FontWeight.w800,
),
),
),
],
);
}
