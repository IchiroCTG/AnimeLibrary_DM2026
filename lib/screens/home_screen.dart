import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../models/anime_data.dart';
import '../navigation/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/anime_card.dart';
import '../widgets/genre_chip.dart';
import '../widgets/rating_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  String? _selectedGenre;
  String? _selectedPlatform;
  List<Anime> _results = AnimeData.catalog;

  // Géneros más populares para la fila de chips
  static const List<String> _topGenres = [
    'Acción', 'Aventura', 'Drama', 'Comedia',
    'Sci-Fi', 'Romance', 'Thriller', 'Deportes',
  ];

  void _applyFilters() {
    setState(() {
      _results = AnimeData.filterBy(
        genre:    _selectedGenre,
        platform: _selectedPlatform,
        query:    _searchCtrl.text,
      );
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedGenre    = null;
      _selectedPlatform = null;
      _searchCtrl.clear();
      _results = AnimeData.catalog;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFilters =
        _selectedGenre != null || _selectedPlatform != null || _searchCtrl.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ──────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            expandedHeight: 110,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Library', style: AppTextStyles.bodySmall),
                  Text(
                    'ANIME',
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 4,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                color: AppColors.textSecondary,
                onPressed: () => _showFilterSheet(context),
                tooltip: 'Filtros',
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Buscador ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => _applyFilters(),
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre, género, apodo...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.textDisabled, size: 20),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded,
                                  color: AppColors.textDisabled, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                _applyFilters();
                              },
                            )
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Chips de género ───────────────────────────
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _topGenres.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final genre = _topGenres[i];
                      return GenreChip(
                        genre: genre,
                        isSelected: _selectedGenre == genre,
                        onTap: () {
                          setState(() {
                            _selectedGenre =
                                _selectedGenre == genre ? null : genre;
                          });
                          _applyFilters();
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ── Chips de plataforma ───────────────────────
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: AnimeData.allPlatforms.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final platform = AnimeData.allPlatforms[i];
                      final isSelected = _selectedPlatform == platform;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPlatform =
                                isSelected ? null : platform;
                          });
                          _applyFilters();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            platform,
                            style: AppTextStyles.label.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ── Header de resultados ──────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4, height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        hasFilters
                            ? '${_results.length} resultado${_results.length != 1 ? "s" : ""}'
                            : 'Catálogo completo',
                        style: AppTextStyles.headline3,
                      ),
                      const Spacer(),
                      if (hasFilters)
                        TextButton(
                          onPressed: _clearFilters,
                          child: Text(
                            'Limpiar',
                            style: AppTextStyles.label
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── Grilla de animes (Master) ─────────────────────
          _results.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded,
                            color: AppColors.textDisabled, size: 48),
                        const SizedBox(height: 12),
                        Text('Sin resultados', style: AppTextStyles.headline3),
                        const SizedBox(height: 4),
                        Text('Intenta con otro filtro o nombre',
                            style: AppTextStyles.bodySmall),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Limpiar filtros'),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          AnimeCard(anime: _results[index]),
                      childCount: _results.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // ── Bottom sheet de filtros avanzados ─────────────────────────
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FilterSheet(
        selectedGenre:    _selectedGenre,
        selectedPlatform: _selectedPlatform,
        onApply: (genre, platform) {
          setState(() {
            _selectedGenre    = genre;
            _selectedPlatform = platform;
          });
          _applyFilters();
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ── Filter Bottom Sheet ────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  final String? selectedGenre;
  final String? selectedPlatform;
  final void Function(String? genre, String? platform) onApply;

  const _FilterSheet({
    required this.selectedGenre,
    required this.selectedPlatform,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _genre;
  late String? _platform;

  @override
  void initState() {
    super.initState();
    _genre    = widget.selectedGenre;
    _platform = widget.selectedPlatform;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text('Filtrar por Género', style: AppTextStyles.headline3),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AnimeData.allGenres.map((g) => GenreChip(
              genre: g,
              isSelected: _genre == g,
              onTap: () => setState(() => _genre = _genre == g ? null : g),
            )).toList(),
          ),

          const SizedBox(height: 20),
          Text('Filtrar por Plataforma', style: AppTextStyles.headline3),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AnimeData.allPlatforms.map((p) {
              final isSelected = _platform == p;
              return GestureDetector(
                onTap: () => setState(() => _platform = isSelected ? null : p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(p,
                      style: AppTextStyles.label.copyWith(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      )),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onApply(_genre, _platform),
              child: const Text('Aplicar filtros'),
            ),
          ),
        ],
      ),
    );
  }
}
