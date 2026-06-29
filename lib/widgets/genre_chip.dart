import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Chip de género reutilizable.
/// Traduce automáticamente géneros de AniList (en inglés) al locale actual.
class GenreChip extends StatelessWidget {
  final String genre;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool small;

  const GenreChip({
    super.key,
    required this.genre,
    this.isSelected = false,
    this.onTap,
    this.small = false,
  });

  /// Mapa de géneros AniList (inglés) → español
  static const Map<String, String> _esTranslations = {
    'Action': 'Acción',
    'Adventure': 'Aventura',
    'Comedy': 'Comedia',
    'Drama': 'Drama',
    'Ecchi': 'Ecchi',
    'Fantasy': 'Fantasía',
    'Horror': 'Terror',
    'Mahou Shoujo': 'Mahou Shoujo',
    'Mecha': 'Mecha',
    'Music': 'Música',
    'Mystery': 'Misterio',
    'Psychological': 'Psicológico',
    'Romance': 'Romance',
    'Sci-Fi': 'Ciencia Ficción',
    'Slice of Life': 'Slice of Life',
    'Sports': 'Deportes',
    'Supernatural': 'Sobrenatural',
    'Thriller': 'Thriller',
    'Hentai': 'Hentai',
  };

  /// Devuelve el género traducido según el locale actual.
  String _localizedGenre(BuildContext context) {
    final locale = AppLocalizations.of(context)?.localeName ?? 'es';
    if (locale == 'es') {
      return _esTranslations[genre] ?? genre;
    }
    return genre; // en inglés ya viene correcto de AniList
  }

  @override
  Widget build(BuildContext context) {
    final displayGenre = _localizedGenre(context);
    final color = AppColors.genreColors[genre] ??
        AppColors.genreColors[displayGenre] ??
        AppColors.secondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: small ? 8 : 12,
          vertical: small ? 3 : 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          displayGenre,
          style: (small ? AppTextStyles.labelSmall : AppTextStyles.label)
              .copyWith(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


