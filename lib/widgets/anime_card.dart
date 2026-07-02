import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/anime.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../navigation/app_routes.dart';
import 'rating_bar.dart';
import 'genre_chip.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;

  const AnimeCard({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.detail,
        arguments: anime,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Portada ──────────────────────────────────────
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    anime.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textDisabled,
                        size: 32,
                      ),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),

                  // Degradado inferior
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.surface, Colors.transparent],
                        ),
                      ),
                    ),
                  ),

                  // Badge de estado (En emisión) — localizado
                  if (anime.isAiring)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l.airing,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Rating en esquina superior derecha
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: RatingBar(rating: anime.rating, compact: true),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info inferior ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title,
                    style: AppTextStyles.cardTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${anime.releaseYear}  ·  ${anime.episodes} eps.',
                    style: AppTextStyles.cardSubtitle,
                  ),
                  const SizedBox(height: 6),
                  GenreChip(genre: anime.primaryGenre, small: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
