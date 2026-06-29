import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Badge de plataforma de streaming.
/// Maneja nombres exactos y variantes que retorna AniList.
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
    'Amazon Prime Video': _PlatformInfo(
      color: AppColors.amazonPrime,
      icon: Icons.local_shipping_rounded,
      label: 'Prime',
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
    'Funimation': _PlatformInfo(
      color: Color(0xFF5B2D8E),
      icon: Icons.play_arrow_rounded,
      label: 'Funimation',
    ),
    'Hulu': _PlatformInfo(
      color: Color(0xFF1CE783),
      icon: Icons.tv_rounded,
      label: 'Hulu',
    ),
    'Apple TV': _PlatformInfo(
      color: Color(0xFF555555),
      icon: Icons.apple_rounded,
      label: 'Apple TV',
    ),
    'HBO Max': _PlatformInfo(
      color: Color(0xFF002BE7),
      icon: Icons.movie_rounded,
      label: 'HBO Max',
    ),
  };

  /// Busca la plataforma ignorando mayúsculas y variantes de nombre.
  _PlatformInfo? _resolve() {
    // Búsqueda exacta primero
    if (_platforms.containsKey(platform)) return _platforms[platform];

    // Búsqueda parcial (ej: "Amazon Prime Video" → "Amazon Prime")
    final lower = platform.toLowerCase();
    for (final entry in _platforms.entries) {
      if (lower.contains(entry.key.toLowerCase()) ||
          entry.key.toLowerCase().contains(lower)) {
        return entry.value;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final info = _resolve();
    final color = info?.color ?? AppColors.textSecondary;
    final icon = info?.icon ?? Icons.play_arrow_rounded;
    // Truncar nombres muy largos
    final label = info?.label ?? (platform.length > 10
        ? '${platform.substring(0, 10)}…'
        : platform);

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
