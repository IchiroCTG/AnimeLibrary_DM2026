import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/genre_chip.dart';
import '../widgets/platform_badge.dart';
import '../widgets/rating_bar.dart';


class DetailScreen extends StatelessWidget {
  final Anime anime;

  const DetailScreen({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero header con portada ────────────────────────
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
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: AppColors.background.withValues(alpha: 0.7),
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border_rounded,
                        color: AppColors.textPrimary, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${anime.title} guardado en tu lista',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: Colors.white),
                          ),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Portada
                  Image.network(
                    anime.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: AppColors.textDisabled, size: 48),
                    ),
                  ),
                  // Degradado hacia abajo
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
                  // Info superpuesta
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estado
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
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Título
                        Text(anime.title, style: AppTextStyles.headline1),
                        Text(anime.originalTitle,
                            style: AppTextStyles.label
                                .copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        // Rating + metadata
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

          // ── Contenido principal ────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Géneros ──────────────────────────────────
                  _SectionHeader(title: 'Géneros'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: anime.genres
                        .map((g) => GenreChip(genre: g))
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Disponible en ─────────────────────────────
                  _SectionHeader(title: 'Disponible en'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: anime.platforms
                        .map((p) => PlatformBadge(platform: p))
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Sinopsis ──────────────────────────────────
                  _SectionHeader(title: 'Sinopsis'),
                  const SizedBox(height: 10),
                  Text(
                    anime.synopsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Ficha técnica ─────────────────────────────
                  _SectionHeader(title: 'Ficha técnica'),
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
                        _InfoRow(label: 'Año de estreno', value: '${anime.releaseYear}'),
                        _Divider(),
                        _InfoRow(label: 'Episodios', value: '${anime.episodes}'),
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

                  // ── Calificación ──────────────────────────────
                  _SectionHeader(title: 'Puntuación de la comunidad'),
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
                                'Basado en miles de valoraciones de la comunidad global de anime.',
                                style: AppTextStyles.bodySmall,
                              ),
                              const SizedBox(height: 12),
                              _RatingProgress(label: 'Historia',    value: 0.92),
                              _RatingProgress(label: 'Animación',   value: 0.88),
                              _RatingProgress(label: 'Personajes',  value: 0.90),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Botón ver trailer ─────────────────────────
                  if (anime.trailerUrl != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_circle_outline_rounded),
                        label: const Text('Ver Trailer'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets internos ───────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 3, height: 18,
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
              child: Text(
                value,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.right,
              ),
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
  final double value; // 0.0 - 1.0
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
              '${(value * 10).toStringAsFixed(1)}',
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.warning, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
}
