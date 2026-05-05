import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../navigation/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header expandible con avatar ───────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A1040), AppColors.background],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            border: Border.all(
                                color: AppColors.background, width: 3),
                          ),
                          child: const Icon(Icons.person_rounded,
                              color: AppColors.textPrimary, size: 38),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('OtakuUser_2026',
                                style: AppTextStyles.headline3),
                            Text('Miembro desde enero 2026',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats ──────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(value: '154', label: 'Animes'),
                        Container(width: 1, height: 36, color: AppColors.surfaceVariant),
                        _StatItem(value: '2,340', label: 'Episodios'),
                        Container(width: 1, height: 36, color: AppColors.surfaceVariant),
                        _StatItem(value: '4.8', label: 'Rating prom.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Mis listas ─────────────────────────────
                  Text('Mis Listas', style: AppTextStyles.headline3),
                  const SizedBox(height: 12),
                  _ListTileItem(icon: Icons.bookmark_rounded,      color: AppColors.primary,   label: 'Guardados',    count: 24),
                  _ListTileItem(icon: Icons.check_circle_rounded,  color: AppColors.success,   label: 'Completados',  count: 87),
                  _ListTileItem(icon: Icons.play_arrow_rounded,    color: AppColors.secondary, label: 'Viendo ahora', count: 5),
                  _ListTileItem(icon: Icons.schedule_rounded,      color: AppColors.warning,   label: 'Pendientes',   count: 38),

                  const SizedBox(height: 24),

                  // ── Configuración ──────────────────────────
                  Text('Configuración', style: AppTextStyles.headline3),
                  const SizedBox(height: 12),
                  _SettingItem(
                    icon: Icons.notifications_rounded,
                    label: 'Notificaciones',
                    trailing: Switch(
                      value: true,
                      onChanged: (_) {},
                      activeColor: AppColors.primary,
                    ),
                  ),
                  _SettingItem(icon: Icons.language_rounded,  label: 'Idioma preferido',       value: 'Español'),
                  _SettingItem(icon: Icons.subtitles_rounded, label: 'Subtítulos por defecto', value: 'Sub ES'),
                  _SettingItem(
                    icon: Icons.info_outline_rounded,
                    label: 'Acerca de Library Anime',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                      label: Text('Cerrar sesión',
                          style: AppTextStyles.button.copyWith(color: AppColors.error)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value, style: AppTextStyles.headline2.copyWith(color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.bodySmall),
      ]);
}

class _ListTileItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int count;
  const _ListTileItem({required this.icon, required this.color, required this.label, required this.count});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(label, style: AppTextStyles.bodyMedium),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('$count', style: AppTextStyles.label.copyWith(color: color)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textDisabled, size: 20),
          ]),
        ),
      );
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _SettingItem({required this.icon, required this.label, this.value, this.trailing, this.onTap});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: AppColors.textSecondary, size: 22),
          title: Text(label, style: AppTextStyles.bodyMedium),
          trailing: trailing ?? Row(mainAxisSize: MainAxisSize.min, children: [
            if (value != null) Text(value!, style: AppTextStyles.bodySmall),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textDisabled, size: 20),
          ]),
        ),
      );
}
