import 'package:flutter/material.dart';
import '../design_system/colors.dart';
import 'criar_perfil_crianca.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  bool _aiEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Child selector pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 44,
                                height: 28,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      child: _buildAvatar(22, AppColors.lightBlue),
                                    ),
                                    Positioned(
                                      left: 16,
                                      child: _buildAvatar(22, AppColors.veryLightBlue),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'filho',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),

                        // Profile avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.veryLightBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.lightBlue, width: 2),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.secondary,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Usage Time Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '59 min',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 42,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tempo de uso',
                                    style: TextStyle(
                                      color: AppColors.white.withOpacity(0.8),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 52,
                                        height: 52,
                                        child: CircularProgressIndicator(
                                          value: 0.59 / 24,
                                          strokeWidth: 5,
                                          backgroundColor:
                                              AppColors.white.withOpacity(0.25),
                                          valueColor:
                                              const AlwaysStoppedAnimation<Color>(
                                                  AppColors.white),
                                          strokeCap: StrokeCap.round,
                                        ),
                                      ),
                                      Text(
                                        '59m',
                                        style: TextStyle(
                                          color: AppColors.white.withOpacity(0.9),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Most Used Apps
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'APPS mais utilizados',
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildAppUsageItem(
                                Icons.videogame_asset_rounded, '3h', true),
                            _buildAppUsageItem(
                                Icons.play_circle_fill_rounded, '3h', false),
                            _buildAppUsageItem(
                                Icons.chat_bubble_rounded, '3h', false),
                            _buildAppUsageItem(
                                Icons.music_note_rounded, null, false),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // AI Card
                        _buildFeatureCard(
                          title: 'Inteligência Artificial (IA)',
                          subtitle: 'Analisar comportamento em tempo real',
                          trailing: Switch(
                            value: _aiEnabled,
                            onChanged: (val) =>
                                setState(() => _aiEnabled = val),
                            activeColor: AppColors.white,
                            activeTrackColor: AppColors.primary,
                            inactiveThumbColor: AppColors.white,
                            inactiveTrackColor:
                                AppColors.lightBlue.withOpacity(0.4),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Site Blocking Card
                        _buildFeatureCard(
                          title: 'Bloqueio de sites',
                          subtitle: 'Sites personalizados bloqueados',
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // FAB — abre CriarPerfilCriancaPage
            Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CriarPerfilCriancaPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 1.5),
      ),
      child: Icon(Icons.person, size: size * 0.6, color: AppColors.primary),
    );
  }

  Widget _buildAppUsageItem(IconData icon, String? label, bool isHighlighted) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHighlighted ? AppColors.primary : AppColors.veryLightBlue,
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isHighlighted ? AppColors.white : AppColors.secondary,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        if (label != null)
          Text(
            label,
            style: TextStyle(
              color: AppColors.black.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          )
        else
          const SizedBox(height: 17),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }
}