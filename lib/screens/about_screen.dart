import 'package:anime_library/theme/app_colors.dart';
import 'package:anime_library/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _version = '1.0.1';
  static const String _year = '2026';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.aboutTitle, style: AppTextStyles.headline3),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Image.asset('assets/images/icono.png', width: 96, height: 96),
                const SizedBox(height: 16),
                Text('Library Anime', style: AppTextStyles.headline2),
                const SizedBox(height: 4),
                Text(l.aboutVersion(_version, _year),
                    style: AppTextStyles.bodySmall),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    l.aboutBadge,
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(l.aboutPurpose, style: AppTextStyles.headline3),
          Text(
            'Library Anime nace de una necesidad real: la información sobre el anime está fragmentada en decenas de plataformas de streaming y sitios externos, obligando al usuario a abrir múltiples apps para encontrar un solo título.\n\n'
            'Esta aplicación centraliza el catálogo, indica la disponibilidad por plataforma, integra reseñas de la comunidad y permite filtrar por género, año y nombre —incluyendo títulos alternativos y apodos en japonés— todo desde una sola interfaz móvil.',
            style: AppTextStyles.bodySmall.copyWith(height: 1.7),
          ),
        ],
      ),
    );
  }
}
