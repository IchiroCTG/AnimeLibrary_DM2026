import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
      context.read<FavoritesViewModel>().load();
    });
  }

  // Cuadro de diálogo interactivo para actualizar el nombre de usuario de forma persistente
  void _showEditNameDialog(BuildContext context, ProfileViewModel profileVm) {
    final controller = TextEditingController(text: profileVm.username);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Editar nombre', style: AppTextStyles.headline3),
        content: TextField(
          controller: controller,
          style: AppTextStyles.searchText,
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                profileVm.updateUsername(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Guardar', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileViewModel, FavoritesViewModel>(
      builder: (context, profileVm, favVm, _) {
        // Manejo de Estado: Cargando datos
        if (profileVm.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // Manejo de Estado: Error crítico en persistencia
        if (profileVm.state == ProfileState.error) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                'Error al cargar el perfil.\nInténtalo de nuevo.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.error),
              ),
            ),
          );
        }

        // Determinar si el usuario tiene una foto de perfil personalizada en disco
        final hasCustomImage = profileVm.profileImagePath != null && profileVm.profileImagePath!.isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // ── Header expandible con Foto y Nombre ──────────
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
                            // Contenedor interactivo de la foto de perfil (ImagePicker)
                            GestureDetector(
                              onTap: () => profileVm.changeProfileImage(),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                      border: Border.all(color: AppColors.background, width: 3),
                                      image: hasCustomImage
                                          ? DecorationImage(
                                              image: FileImage(File(profileVm.profileImagePath!)),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: !hasCustomImage
                                        ? const Icon(Icons.person_rounded, color: AppColors.textPrimary, size: 38)
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text(profileVm.username, style: AppTextStyles.headline3),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => _showEditNameDialog(context, profileVm),
                                      child: const Icon(Icons.edit_rounded, color: AppColors.textSecondary, size: 16),
                                    ),
                                  ],
                                ),
                                Text(profileVm.email, style: AppTextStyles.bodySmall),
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
                      // ── Stats (Leídos en tiempo real del FavoritesViewModel) ─
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatItem(
                              value: '${favVm.savedCount + favVm.watchingCount + favVm.completedCount + favVm.pendingCount}',
                              label: 'En listas',
                            ),
                            Container(width: 1, height: 36, color: AppColors.surfaceVariant),
                            _StatItem(
                              value: '${favVm.completedCount}',
                              label: 'Completados',
                            ),
                            Container(width: 1, height: 36, color: AppColors.surfaceVariant),
                            _StatItem(
                              value: '${favVm.watchingCount}',
                              label: 'Viendo',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Mis listas ───────────────────────────────────
                      Text('Mis Listas', style: AppTextStyles.headline3),
                      const SizedBox(height: 12),
                      _ListTileItem(
                        icon: Icons.bookmark_rounded,
                        color: AppColors.primary,
                        label: 'Guardados',
                        count: favVm.savedCount,
                        onTap: () {
  print('isLoaded: ${favVm.isLoaded}');
  print('savedCount: ${favVm.savedCount}');
  print('savedAnimes: ${favVm.savedAnimes}');
  print('savedAnimes length: ${favVm.savedAnimes.length}');
  if (!favVm.isLoaded) return;
  Navigator.pushNamed(context, AppRoutes.listScreen,
      arguments: {'title': 'Guardados', 'animes': favVm.savedAnimes});
},
                      ),
                      _ListTileItem(
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success,
                        label: 'Completados',
                        count: favVm.completedCount,
                        onTap: () {
                          if (!favVm.isLoaded) return;
                          Navigator.pushNamed(context, AppRoutes.listScreen,
                              arguments: {'title': 'Completados', 'animes': favVm.completedAnimes});
                        },
                      ),
                      _ListTileItem(
                        icon: Icons.play_arrow_rounded,
                        color: AppColors.secondary,
                        label: 'Viendo ahora',
                        count: favVm.watchingCount,
                        onTap: () {
                          if (!favVm.isLoaded) return;
                          Navigator.pushNamed(context, AppRoutes.listScreen,
                            arguments: {'title': 'Viendo ahora', 'animes': favVm.watchingAnimes});
                        },
                      ),
                      _ListTileItem(
                      icon: Icons.schedule_rounded,
                      color: AppColors.warning,
                      label: 'Pendientes',
                      count: favVm.pendingCount,
                      onTap: () {
                          if (!favVm.isLoaded) return;
                          Navigator.pushNamed(context, AppRoutes.listScreen,
                          arguments: {'title': 'Pendientes', 'animes': favVm.pendingAnimes});
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Configuración Dinámica ───────────────────────
                      Text('Configuración', style: AppTextStyles.headline3),
                      const SizedBox(height: 12),
                      _SettingItem(
                        icon: Icons.notifications_rounded,
                        label: 'Notificaciones',
                        trailing: Switch(
                          value: profileVm.notifications,
                          onChanged: (_) => profileVm.toggleNotifications(),
                          activeColor: AppColors.primary,
                        ),
                      ),
                      _SettingItem(
                        icon: Icons.language_rounded,
                        label: 'Idioma preferido',
                        value: profileVm.language,
                        onTap: () {
                          // Ejemplo rápido de actualización interactiva
                          final nuevoIdioma = profileVm.language == 'Español' ? 'English' : 'Español';
                          profileVm.setLanguage(nuevoIdioma);
                        },
                      ),
                      _SettingItem(
                        icon: Icons.subtitles_rounded,
                        label: 'Subtítulos por defecto',
                        value: profileVm.subtitles,
                        onTap: () {
                          final nuevosSubs = profileVm.subtitles == 'Sub ES' ? 'Sub EN' : 'Sub ES';
                          profileVm.setSubtitles(nuevosSubs);
                        },
                      ),
                      _SettingItem(
                        icon: Icons.rate_review_rounded,
                        label: 'Evaluar la app (Beta Testing)',
                        iconColor: AppColors.primary,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.evaluation),
                      ),
                      _SettingItem(
                        icon: Icons.info_outline_rounded,
                        label: 'Acerca de Library Anime',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                      ),
                      const SizedBox(height: 24),

                      // ── Botón Cerrar Sesión ──────────────────────────
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      },
    );
  }
}

// ── Widgets internos (Sin cambios, se mantiene tu UI limpia) ────

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
  final VoidCallback? onTap;
  const _ListTileItem({required this.icon, required this.color, required this.label, required this.count, this.onTap});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
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
  final Color? iconColor;
  const _SettingItem({required this.icon, required this.label, this.value, this.trailing, this.onTap, this.iconColor});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
          title: Text(label, style: AppTextStyles.bodyMedium),
          trailing: trailing ??
              Row(mainAxisSize: MainAxisSize.min, children: [
                if (value != null) Text(value!, style: AppTextStyles.bodySmall),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textDisabled, size: 20),
              ]),
        ),
      );
}