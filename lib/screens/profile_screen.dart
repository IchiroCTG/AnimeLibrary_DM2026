import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../navigation/app_routes.dart';
import '../services/background_sync_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/locale_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

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

  void _showEditNameDialog(BuildContext context, ProfileViewModel profileVm, AppLocalizations l) {
    final controller = TextEditingController(text: profileVm.username);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l.profileEditName, style: AppTextStyles.headline3),
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
            child: Text(l.profileEditCancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                profileVm.updateUsername(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: Text(l.profileEditSave,
                style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Consumer2<ProfileViewModel, FavoritesViewModel>(
      builder: (context, profileVm, favVm, _) {
        if (profileVm.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

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

        final hasCustomImage = profileVm.profileImagePath != null &&
            profileVm.profileImagePath!.isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // ── Header ────────────────────────────────────────
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
                                      border: Border.all(
                                          color: AppColors.background, width: 3),
                                      image: hasCustomImage
                                          ? DecorationImage(
                                              image: FileImage(File(
                                                  profileVm.profileImagePath!)),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: !hasCustomImage
                                        ? const Icon(Icons.person_rounded,
                                            color: AppColors.textPrimary,
                                            size: 38)
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
                                      child: const Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.white,
                                          size: 12),
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
                                    Text(profileVm.username,
                                        style: AppTextStyles.headline3),
                                    const SizedBox(width: 6),
                                    GestureDetector(
                                      onTap: () => _showEditNameDialog(
                                          context, profileVm, l),
                                      child: const Icon(Icons.edit_rounded,
                                          color: AppColors.textSecondary,
                                          size: 16),
                                    ),
                                  ],
                                ),
                                Text(profileVm.email,
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
                      // ── Stats ──────────────────────────────────────
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
                              value:
                                  '${favVm.savedCount + favVm.watchingCount + favVm.completedCount + favVm.pendingCount}',
                              label: l.profileInLists,
                            ),
                            Container(
                                width: 1,
                                height: 36,
                                color: AppColors.surfaceVariant),
                            _StatItem(
                              value: '${favVm.completedCount}',
                              label: l.profileCompleted,
                            ),
                            Container(
                                width: 1,
                                height: 36,
                                color: AppColors.surfaceVariant),
                            _StatItem(
                              value: '${favVm.watchingCount}',
                              label: l.profileWatching,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Mis listas ─────────────────────────────────
                      Text(l.profileMyLists, style: AppTextStyles.headline3),
                      const SizedBox(height: 12),
                      _ListTileItem(
                        icon: Icons.bookmark_rounded,
                        color: AppColors.primary,
                        label: l.profileSaved,
                        count: favVm.savedCount,
                        onTap: () {
                          if (!favVm.isLoaded) return;
                          Navigator.pushNamed(context, AppRoutes.listScreen,
                              arguments: {
                                'title': l.profileSaved,
                                'animes': favVm.savedAnimes
                              });
                        },
                      ),
                      _ListTileItem(
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success,
                        label: l.profileCompleted,
                        count: favVm.completedCount,
                        onTap: () {
                          if (!favVm.isLoaded) return;
                          Navigator.pushNamed(context, AppRoutes.listScreen,
                              arguments: {
                                'title': l.profileCompleted,
                                'animes': favVm.completedAnimes
                              });
                        },
                      ),
                      _ListTileItem(
                        icon: Icons.play_arrow_rounded,
                        color: AppColors.secondary,
                        label: l.profileWatchingNow,
                        count: favVm.watchingCount,
                        onTap: () {
                          if (!favVm.isLoaded) return;
                          Navigator.pushNamed(context, AppRoutes.listScreen,
                              arguments: {
                                'title': l.profileWatchingNow,
                                'animes': favVm.watchingAnimes
                              });
                        },
                      ),
                      _ListTileItem(
                        icon: Icons.schedule_rounded,
                        color: AppColors.warning,
                        label: l.profilePending,
                        count: favVm.pendingCount,
                        onTap: () {
                          if (!favVm.isLoaded) return;
                          Navigator.pushNamed(context, AppRoutes.listScreen,
                              arguments: {
                                'title': l.profilePending,
                                'animes': favVm.pendingAnimes
                              });
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Configuración ──────────────────────────────
                      Text(l.profileSettings, style: AppTextStyles.headline3),
                      const SizedBox(height: 12),
                      _SettingItem(
                        icon: Icons.notifications_rounded,
                        label: l.profileNotifications,
                        trailing: Switch(
                          value: profileVm.notifications,
                          onChanged: (_) => profileVm.toggleNotifications(),
                          activeColor: AppColors.primary,
                        ),
                      ),
                      _SettingItem(
                        icon: Icons.sync_rounded,
                        label: 'Probar sincronización en segundo plano',
                        iconColor: AppColors.primary,
                        onTap: () async {
                          await BackgroundSyncService.runOnceForTesting();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Sincronización en segundo plano programada. '
                                  'Revisa la notificación en unos segundos.',
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      // ── Idioma (cambia el locale real de la app) ───
                      Consumer<LocaleViewModel>(
                        builder: (context, locVm, _) => _SettingItem(
                          icon: Icons.language_rounded,
                          label: l.profileLanguage,
                          value: locVm.locale?.languageCode == 'en'
                              ? 'English'
                              : 'Español',
                          onTap: () {
                            final next =
                                locVm.locale?.languageCode == 'es'
                                    ? const Locale('en')
                                    : const Locale('es');
                            locVm.setLocale(next);
                          },
                        ),
                      ),

                      _SettingItem(
                        icon: Icons.subtitles_rounded,
                        label: l.profileSubtitles,
                        value: profileVm.subtitles,
                        onTap: () {
                          final nuevosSubs =
                              profileVm.subtitles == 'Sub ES' ? 'Sub EN' : 'Sub ES';
                          profileVm.setSubtitles(nuevosSubs);
                        },
                      ),
                      _SettingItem(
                        icon: Icons.rate_review_rounded,
                        label: l.profileEvaluate,
                        iconColor: AppColors.primary,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.evaluation),
                      ),
                      _SettingItem(
                        icon: Icons.info_outline_rounded,
                        label: l.profileAbout,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.about),
                      ),
                      const SizedBox(height: 24),

                      // ── Cerrar sesión ──────────────────────────────
                      // La navegación a Login ya no se hace aquí: el
                      // listener de authStateChanges en main.dart la
                      // maneja de forma centralizada para cualquier
                      // pérdida de sesión (manual o no).
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final authVm = context.read<AuthViewModel>();
                            await authVm.signOut();
                          },
                          icon: const Icon(Icons.logout_rounded,
                              color: AppColors.error),
                          label: Text(l.profileLogout,
                              style: AppTextStyles.button
                                  .copyWith(color: AppColors.error)),
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
      },
    );
  }
}

// ── Widgets internos ────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            style: AppTextStyles.headline2.copyWith(color: AppColors.primary)),
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
  const _ListTileItem(
      {required this.icon,
      required this.color,
      required this.label,
      required this.count,
      this.onTap});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(label, style: AppTextStyles.bodyMedium),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('$count',
                style: AppTextStyles.label.copyWith(color: color)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textDisabled, size: 20),
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
  const _SettingItem(
      {required this.icon,
      required this.label,
      this.value,
      this.trailing,
      this.onTap,
      this.iconColor});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          onTap: onTap,
          leading:
              Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
          title: Text(label, style: AppTextStyles.bodyMedium),
          trailing: trailing ??
              Row(mainAxisSize: MainAxisSize.min, children: [
                if (value != null)
                  Text(value!, style: AppTextStyles.bodySmall),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textDisabled, size: 20),
              ]),
        ),
      );
}