import 'dart:async';

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../viewmodels/anime_viewmodel.dart';
import '../widgets/anime_card.dart';
import '../widgets/genre_chip.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  String? _selectedGenre;
  bool _hasSearched = false;

  // Debounce para no lanzar request en cada tecla
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollCtrl.addListener(() {
      final vm = context.read<AnimeViewModel>();
      if (_scrollCtrl.position.pixels >=
              _scrollCtrl.position.maxScrollExtent * 0.9 &&
          !vm.isLoadingMoreSearch &&
          vm.hasMoreSearch) {
        vm.loadMoreSearch();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.isEmpty && _selectedGenre == null) {
      setState(() => _hasSearched = false);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _doSearch(value);
    });
  }

  void _doSearch(String query) {
    setState(() => _hasSearched = true);
    context.read<AnimeViewModel>().performSearch(
          query,
          genre: _selectedGenre,
        );
  }

  void _clearAll() {
    _debounce?.cancel();
    _ctrl.clear();
    setState(() {
      _selectedGenre = null;
      _hasSearched   = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l  = AppLocalizations.of(context)!;
    final vm = context.watch<AnimeViewModel>();

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
              onChanged: _onChanged,
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
          if (vm.allGenres.isNotEmpty)
            SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: vm.allGenres.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final genre = vm.allGenres[i];
                  return GenreChip(
                    genre: genre,
                    isSelected: _selectedGenre == genre,
                    onTap: () {
                      setState(() {
                        _selectedGenre =
                            _selectedGenre == genre ? null : genre;
                      });
                      _doSearch(_ctrl.text);
                    },
                  );
                },
              ),
            ),

          const SizedBox(height: 16),

          // ── Cuerpo ────────────────────────────────────────
          Expanded(
            child: !_hasSearched
                ? _buildSuggestions(l, vm)
                : _buildResults(l, vm),
          ),
        ],
      ),
    );
  }

  // ── Sugerencias iniciales ─────────────────────────────────
  Widget _buildSuggestions(AppLocalizations l, AnimeViewModel vm) {
    final popular = vm.animes.take(6).toList();

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
                      _doSearch(a.title);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppColors.surfaceVariant),
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
          children: vm.allGenres
              .map((g) => GenreChip(
                    genre: g,
                    onTap: () {
                      setState(() => _selectedGenre = g);
                      _doSearch('');
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ── Resultados con scroll infinito ────────────────────────
  Widget _buildResults(AppLocalizations l, AnimeViewModel vm) {
    final results = vm.searchResults;

    // Spinner mientras llega la primera página
    if (results.isEmpty && vm.isLoadingMoreSearch) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (results.isEmpty) {
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
            TextButton(onPressed: _clearAll, child: Text(l.searchClear)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            results.length == 1
                ? l.homeResults(results.length)
                : l.homeResultsPlural(results.length),
            style: AppTextStyles.label,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            // +1 para el indicador al final
            itemCount: results.length + (vm.hasMoreSearch ? 1 : 0),
            itemBuilder: (_, i) {
              if (i == results.length) {
                // Indicador de carga al final
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: vm.isLoadingMoreSearch
                        ? const CircularProgressIndicator(
                            color: AppColors.primary, strokeWidth: 2)
                        : const SizedBox.shrink(),
                  ),
                );
              }
              return AnimeCard(anime: results[i]);
            },
          ),
        ),
      ],
    );
  }
}
