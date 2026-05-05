import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Chip de género reutilizable con color dinámico por género.
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

  @override
  Widget build(BuildContext context) {
    final color = AppColors.genreColors[genre] ?? AppColors.secondary;

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
          genre,
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
