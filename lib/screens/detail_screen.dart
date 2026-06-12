import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/anime.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../widgets/genre_chip.dart';
import '../widgets/platform_badge.dart';
import '../widgets/rating_bar.dart';

class DetailScreen extends StatelessWidget {
  final Anime anime;
  const DetailScreen({super.key, required this.anime});

  // ── Compartir vía share_plus ───────────────────────────────
 void _share() {
  final platforms = anime.platforms.join(', ');

  Share.share(
    ' ${anime.title} (${anime.originalTitle})\n'
    ' ${anime.rating}/10 · ${anime.episodes} eps · ${anime.releaseYear}\n'
    ' Disponible en: $platforms\n\n'
    '${anime.synopsis.length > 120 ? anime.synopsis.substring(0, 120) + '…' : anime.synopsis}\n\n'
    'Encontrado en Library Anime 📱',
  );
}

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesViewModel>(
      builder: (context, favVm, _) {
        final isSaved = favVm.isSaved(anime.id);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // ── Hero header ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 380,
                pinned: true,
                backgroundColor: AppColors.background,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: AppColors.background.withValues(alpha: 0.7),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  // Botón compartir
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      backgroundColor: AppColors.background.withValues(alpha: 0.7),
                      child: IconButton(
                        icon: const Icon(Icons.share_rounded,
                            color: AppColors.textPrimary, size: 20),
                        onPressed: _share,
                        tooltip: 'Compartir',
                      ),
                    ),
                  ),
                  // Botón guardar (reactivo al ViewModel)
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    child: CircleAvatar(
                      backgroundColor: AppColors.background.withValues(alpha: 0.7),
                      child: IconButton(
                        icon: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: isSaved
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          size: 20,
                        ),
                        onPressed: () async {
                          await favVm.toggleSaved(anime.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  favVm.isSaved(anime.id)
                                      ? '${anime.title} guardado en tu lista'
                                      : '${anime.title} eliminado de tu lista',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: Colors.white),
                                ),
                                backgroundColor: favVm.isSaved(anime.id)
                                    ? AppColors.success
                                    : AppColors.surfaceVariant,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        anime.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.image_not_supported_outlined,
                              color: AppColors.textDisabled, size: 48),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.3, 1.0],
                            colors: [Colors.transparent, AppColors.background],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: anime.isAiring
                                    ? AppColors.success
                                    : AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                anime.status.toUpperCase(),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(anime.title, style: AppTextStyles.headline1),
                            Text(anime.originalTitle,
                                style: AppTextStyles.label
                                    .copyWith(color: AppColors.textSecondary)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                RatingBar(rating: anime.rating),
                                const SizedBox(width: 16),
                                Text(
                                  '${anime.releaseYear}  ·  ${anime.episodes} eps.',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Contenido ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Listas rápidas ────────────────────────
                      _QuickLists(anime: anime, favVm: favVm),
                      const SizedBox(height: 24),

                      // ── Géneros ───────────────────────────────
                      const _SectionHeader(title: 'Géneros'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: anime.genres
                            .map((g) => GenreChip(genre: g))
                            .toList(),
                      ),
                      const SizedBox(height: 24),

                      // ── Disponible en ─────────────────────────
                      const _SectionHeader(title: 'Disponible en'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: anime.platforms
                            .map((p) => PlatformBadge(platform: p))
                            .toList(),
                      ),
                      const SizedBox(height: 24),

                      // ── Sinopsis ──────────────────────────────
                      const _SectionHeader(title: 'Sinopsis'),
                      const SizedBox(height: 10),
                      Text(
                        anime.synopsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Ficha técnica ─────────────────────────
                      const _SectionHeader(title: 'Ficha técnica'),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(label: 'Estudio', value: anime.studio),
                            _Divider(),
                            _InfoRow(
                                label: 'Año de estreno',
                                value: '${anime.releaseYear}'),
                            _Divider(),
                            _InfoRow(
                                label: 'Episodios',
                                value: '${anime.episodes}'),
                            _Divider(),
                            _InfoRow(label: 'Estado', value: anime.status),
                            if (anime.tags.isNotEmpty) ...[
                              _Divider(),
                              _InfoRow(
                                label: 'Títulos alternativos',
                                value: anime.tags.join('  ·  '),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Puntuación ────────────────────────────
                      const _SectionHeader(title: 'Puntuación de la comunidad'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  anime.rating.toStringAsFixed(1),
                                  style: AppTextStyles.headline1.copyWith(
                                    color: AppColors.warning,
                                    fontSize: 48,
                                  ),
                                ),
                                const Icon(Icons.star_rounded,
                                    color: AppColors.warning, size: 28),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Puntuación de MyAnimeList',
                                      style: AppTextStyles.bodyMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Basado en valoraciones de la comunidad global.',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  const SizedBox(height: 12),
                                  _RatingProgress(
                                      label: 'Historia', value: 0.92),
                                  _RatingProgress(
                                      label: 'Animación', value: 0.88),
                                  _RatingProgress(
                                      label: 'Personajes', value: 0.90),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Botón compartir ───────────────────────
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _share,
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('Compartir este anime'),
                        ),
                      ),
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

// ── Listas rápidas (Guardar / Viendo / Completado / Pendiente) ─

class _QuickLists extends StatelessWidget {
  final Anime anime;
  final FavoritesViewModel favVm;
  const _QuickLists({required this.anime, required this.favVm});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _ListBtn(
        icon: Icons.bookmark_rounded,
        label: 'Guardado',
        active: favVm.isSaved(anime.id),
        color: AppColors.primary,
        onTap: () => favVm.toggleSaved(anime.id),
      ),
      _ListBtn(
        icon: Icons.play_arrow_rounded,
        label: 'Viendo',
        active: favVm.isWatching(anime.id),
        color: AppColors.secondary,
        onTap: () => favVm.toggleWatching(anime.id),
      ),
      _ListBtn(
        icon: Icons.check_circle_rounded,
        label: 'Visto',
        active: favVm.isCompleted(anime.id),
        color: AppColors.success,
        onTap: () => favVm.toggleCompleted(anime.id),
      ),
      _ListBtn(
        icon: Icons.schedule_rounded,
        label: 'Pendiente',
        active: favVm.isPending(anime.id),
        color: AppColors.warning,
        onTap: () => favVm.togglePending(anime.id),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buttons,
      ),
    );
  }
}

class _ListBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;
  const _ListBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? color : AppColors.surfaceVariant,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: active ? color : AppColors.textDisabled, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: active ? color : AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets internos ────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.headline3),
        ],
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: Text(label, style: AppTextStyles.label),
            ),
            Expanded(
              child: Text(value,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.right),
            ),
          ],
        ),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: AppColors.surfaceVariant,
      );
}

class _RatingProgress extends StatelessWidget {
  final String label;
  final double value;
  const _RatingProgress({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(label, style: AppTextStyles.bodySmall),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppColors.surfaceVariant,
                  color: AppColors.warning,
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              (value * 10).toStringAsFixed(1),
              style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.warning, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
}