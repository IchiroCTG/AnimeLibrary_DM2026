import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Badge de plataforma de streaming con color corporativo.
class PlatformBadge extends StatelessWidget {
  final String platform;
  final bool showLabel;
  final double size;

  const PlatformBadge({
    super.key,
    required this.platform,
    this.showLabel = true,
    this.size = 28,
  });

  static const Map<String, _PlatformInfo> _platforms = {
    'Crunchyroll': _PlatformInfo(
      color: AppColors.crunchyroll,
      icon: Icons.play_circle_fill_rounded,
      label: 'Crunchyroll',
    ),
    'Netflix': _PlatformInfo(
      color: AppColors.netflix,
      icon: Icons.live_tv_rounded,
      label: 'Netflix',
    ),
    'HiDive': _PlatformInfo(
      color: AppColors.hidive,
      icon: Icons.waves_rounded,
      label: 'HiDive',
    ),
    'Amazon Prime': _PlatformInfo(
      color: AppColors.amazonPrime,
      icon: Icons.local_shipping_rounded,
      label: 'Prime',
    ),
    'Disney+': _PlatformInfo(
      color: AppColors.disneyPlus,
      icon: Icons.stars_rounded,
      label: 'Disney+',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final info = _platforms[platform];
    final color = info?.color ?? AppColors.textSecondary;
    final icon  = info?.icon  ?? Icons.play_arrow_rounded;
    final label = info?.label ?? platform;

    if (!showLabel) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
        child: Icon(icon, color: color, size: size * 0.55),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformInfo {
  final Color color;
  final IconData icon;
  final String label;
  const _PlatformInfo({
    required this.color,
    required this.icon,
    required this.label,
  });
}