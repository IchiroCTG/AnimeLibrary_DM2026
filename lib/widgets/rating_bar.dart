import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Barra de puntuación con estrella y valor numérico.
class RatingBar extends StatelessWidget {
  final double rating;
  final bool compact;

  const RatingBar({super.key, required this.rating, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppColors.warning,
          size: compact ? 14 : 18,
        ),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: compact
              ? AppTextStyles.labelSmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.w700)
              : AppTextStyles.rating,
        ),
        if (!compact) ...[
          const SizedBox(width: 4),
          Text('/10', style: AppTextStyles.bodySmall),
        ],
      ],
    );
  }
}

/// Encabezado de sección con línea decorativa.
class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.headline3),
        const Spacer(),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!, style: AppTextStyles.label.copyWith(color: AppColors.primary)),
          ),
      ],
    );
  }
}
