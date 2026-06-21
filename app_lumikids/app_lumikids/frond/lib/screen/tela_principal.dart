import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/services_api.dart';
import 'criar_perfil_crianca.dart';
import 'tipo_usuario.dart';

// ── Modelo auxiliar ──────────────────────────────────────────────────────────
class _App {
  final IconData icon;
  final String label;
  final String time;
  const _App(this.icon, this.label, this.time);
}

// ── Widget ───────────────────────────────────────────────────────────────────
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  // ── Estado ──────────────────────────────────────────────────────────────────
  bool _aiEnabled = true;

  final ApiService _apiService = ApiService();

  // ── Cores ───────────────────────────────────────────────────────────────────
  static const Color _bg       = Color(0xFFF7FBFF);
  static const Color _card     = Colors.white;
  static const Color _primary  = Color(0xFF4F7EFF);
  static const Color _textDark = Color(0xFF1A1D2E);
  static const Color _textGray = Color(0xFF9098A9);

  // ── Init ────────────────────────────────────────────────────────────────────
  @override


  // ── Helpers ─────────────────────────────────────────────────────────────────
  TextStyle _t(double size, {FontWeight w = FontWeight.w500, Color? c, double ls = 0}) =>
      GoogleFonts.nunito(fontSize: size, fontWeight: w, color: c ?? _textDark, letterSpacing: ls);

  BoxDecoration get _cardDeco => BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      );

  // ── Logout ──────────────────────────────────────────────────────────────────
  Future<void> _fazerLogout() async {
    await _apiService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const EscolhaUsuarioPage()),
      (_) => false,
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Olá! 👋', style: _t(22, w: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('Veja o uso do celular hoje.', style: _t(14, c: _textGray)),
                        const SizedBox(height: 24),
                        _usageCard(),
                        const SizedBox(height: 28),
                        Text('APPS MAIS USADOS', style: _t(11, w: FontWeight.w800, c: _textGray, ls: 1.2)),
                        const SizedBox(height: 14),
                        _appRow(),
                        const SizedBox(height: 28),
                        Text('CONTROLES', style: _t(11, w: FontWeight.w800, c: _textGray, ls: 1.2)),
                        const SizedBox(height: 14),
                        _aiCard(),
                        const SizedBox(height: 12),
                        _blockCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _fab(),
          ],
        ),
      ),
    );
  }

  // ── Top bar ──────────────────────────────────────────────────────────────────
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.child_care_rounded, color: _primary, size: 18),
                const SizedBox(width: 8),
                Text('Filho', style: _t(14, w: FontWeight.w700)),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down_rounded, color: _textGray, size: 18),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => SafeArea(
                child: ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: Text('Sair', style: _t(16, w: FontWeight.w700, c: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(context);
                    _fazerLogout();
                  },
                ),
              ),
            ),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _card,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Icon(Icons.person_rounded, color: _textGray, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card de uso ──────────────────────────────────────────────────────────────
  Widget _usageCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDeco,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tempo de uso hoje', style: _t(13, c: _textGray)),
              const SizedBox(height: 6),
              Text('59 min', style: _t(38, w: FontWeight.w900, ls: -1)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Limite: 2h por dia', style: _t(12, w: FontWeight.w700, c: _primary)),
              ),
            ],
          ),
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 59 / 120,
                  strokeWidth: 6,
                  backgroundColor: Colors.black.withOpacity(0.06),
                  valueColor: AlwaysStoppedAnimation<Color>(_primary),
                  strokeCap: StrokeCap.round,
                ),
                Text('49%', style: _t(12, w: FontWeight.w800, c: _primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Apps ─────────────────────────────────────────────────────────────────────
  Widget _appRow() {
    final items = [
      const _App(Icons.videogame_asset_rounded,  'Jogos',  '3h'),
      const _App(Icons.play_circle_fill_rounded, 'Vídeos', '1h'),
      const _App(Icons.chat_bubble_rounded,      'Chat',   '30m'),
      const _App(Icons.music_note_rounded,       'Música', '—'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((a) {
        return Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Icon(a.icon, color: _textDark, size: 26),
            ),
            const SizedBox(height: 8),
            Text(a.label, style: _t(12, w: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(a.time, style: _t(11, c: _textGray)),
          ],
        );
      }).toList(),
    );
  }

  // ── Card IA ──────────────────────────────────────────────────────────────────
  Widget _aiCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: _cardDeco,
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: _primary, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Inteligência Artificial', style: _t(15, w: FontWeight.w800)),
                const SizedBox(height: 3),
                Text('Analisa comportamento em tempo real', style: _t(12, c: _textGray)),
              ],
            ),
          ),
          Switch(
            value: _aiEnabled,
            onChanged: (v) => setState(() => _aiEnabled = v),
            activeColor: Colors.white,
            activeTrackColor: _primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFDDE3EE),
          ),
        ],
      ),
    );
  }

  // ── Card bloqueio ────────────────────────────────────────────────────────────
  Widget _blockCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: _cardDeco,
        child: Row(
          children: [
            Icon(Icons.block_rounded, color: Colors.redAccent, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bloqueio de sites', style: _t(15, w: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text('Sites personalizados bloqueados', style: _t(12, c: _textGray)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: _textGray, size: 15),
          ],
        ),
      ),
    );
  }

  // ── FAB ──────────────────────────────────────────────────────────────────────
  Widget _fab() {
    return Positioned(
      bottom: 28,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CriarPerfilCriancaPage()),
          ),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: _primary.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}