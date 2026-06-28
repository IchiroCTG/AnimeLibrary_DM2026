import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

import '../models/anime.dart';
import '../models/anime_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/anime_card.dart';
import '../widgets/genre_chip.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  List<Anime> _results = [];
  String? _selectedGenre;
  bool _hasSearched = false;

  void _search(String query) {
    setState(() {
      _hasSearched = true;
      _results = AnimeData.filterBy(query: query, genre: _selectedGenre);
    });
  }

  void _clearAll() {
    setState(() {
      _ctrl.clear();
      _selectedGenre = null;
      _results = [];
      _hasSearched = false;
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(l.searchTitle, style: AppTextStyles.headline3),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Buscador ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _ctrl,
              onChanged: _search,
              style: AppTextStyles.searchText,
              decoration: InputDecoration(
                hintText: l.searchHint,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textDisabled, size: 20),
                suffixIcon: _ctrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppColors.textDisabled, size: 18),
                        onPressed: _clearAll,
                      )
                    : null,
              ),
            ),
          ),

          // ── Chips de género ───────────────────────────────
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: AnimeData.allGenres.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final genre = AnimeData.allGenres[i];
                return GenreChip(
                  genre: genre,
                  isSelected: _selectedGenre == genre,
                  onTap: () {
                    setState(() {
                      _selectedGenre = _selectedGenre == genre ? null : genre;
                    });
                    _search(_ctrl.text);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Cuerpo ────────────────────────────────────────
          Expanded(
            child: !_hasSearched
                ? _buildSuggestions(l)
                : _results.isEmpty
                    ? _buildEmpty(l)
                    : _buildResults(l),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(AppLocalizations l) {
    final popular = AnimeData.catalog.take(6).toList();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Text(l.searchPopular, style: AppTextStyles.headline3),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popular
              .map((a) => GestureDetector(
                    onTap: () {
                      _ctrl.text = a.title;
                      _search(a.title);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.surfaceVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up_rounded,
                              color: AppColors.primary, size: 14),
                          const SizedBox(width: 6),
                          Text(a.title, style: AppTextStyles.label),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 28),
        Text(l.searchAllGenres, style: AppTextStyles.headline3),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AnimeData.allGenres
              .map((g) => GenreChip(
                    genre: g,
                    onTap: () {
                      setState(() => _selectedGenre = g);
                      _search('');
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildEmpty(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              color: AppColors.textDisabled, size: 52),
          const SizedBox(height: 12),
          Text(l.searchNoResults, style: AppTextStyles.headline3),
          const SizedBox(height: 4),
          Text(l.searchNoResultsHint, style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _clearAll,
            child: Text(l.searchClear),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _results.length == 1
                ? l.homeResults(_results.length)
                : l.homeResultsPlural(_results.length),
            style: AppTextStyles.label,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _results.length,
            itemBuilder: (_, i) => AnimeCard(anime: _results[i]),
          ),
        ),
      ],
    );
  }
}
