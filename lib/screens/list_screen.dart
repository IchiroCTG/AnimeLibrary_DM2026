import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/anime_card.dart';

class ListScreen extends StatelessWidget {
  final String title;
  final List<Anime> animes;

  const ListScreen({
    super.key,
    required this.title,
    required this.animes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: AppTextStyles.headline3),
        centerTitle: true,
      ),
      body: animes.isEmpty ? _buildEmptyState() : _buildAnimeGrid(animes),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_rounded,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay animes en esta lista',
              style: AppTextStyles.headline3
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Explora el catálogo principal para añadir tus series favoritas.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimeGrid(List<Anime> animes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: animes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.64,
      ),
      itemBuilder: (context, index) => AnimeCard(anime: animes[index]),
    );
  }
}