import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/anime_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../viewmodels/anime_viewmodel.dart';
import '../widgets/anime_card.dart';
import '../widgets/genre_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnimeViewModel>().loadAnimes();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Consumer<AnimeViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // ── AppBar ──────────────────────────────────────
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
                      Text(l.homeSubtitle, style: AppTextStyles.bodySmall),
                      Text(
                        l.homeTitle,
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
                    onPressed: () => _showFilterSheet(context, vm, l),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Buscador ───────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: vm.setQuery,
                        style: AppTextStyles.searchText,
                        decoration: InputDecoration(
                          hintText: l.homeSearchHint,
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppColors.textDisabled, size: 20),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      color: AppColors.textDisabled, size: 18),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    vm.clearFilters();
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Chips género ───────────────────────────
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
                            isSelected: vm.selectedGenre == genre,
                            onTap: () => vm.setGenre(
                              vm.selectedGenre == genre ? null : genre,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Chips plataforma ───────────────────────
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: AnimeData.allPlatforms.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final platform = AnimeData.allPlatforms[i];
                          final isSelected = vm.selectedPlatform == platform;
                          return GestureDetector(
                            onTap: () => vm.setPlatform(
                              isSelected ? null : platform,
                            ),
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

                    // ── Header resultados ──────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
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
                          Text(
                            vm.selectedGenre != null ||
                                    vm.selectedPlatform != null ||
                                    vm.query.isNotEmpty
                                ? (vm.animes.length == 1
                                    ? l.homeResults(vm.animes.length)
                                    : l.homeResultsPlural(vm.animes.length))
                                : l.homeCatalog,
                            style: AppTextStyles.headline3,
                          ),
                          const Spacer(),
                          if (vm.selectedGenre != null ||
                              vm.selectedPlatform != null ||
                              vm.query.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                _searchCtrl.clear();
                                vm.clearFilters();
                              },
                              child: Text(l.homeClear,
                                  style: AppTextStyles.label
                                      .copyWith(color: AppColors.primary)),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // ── Loading ────────────────────────────────────
              if (vm.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )

              // ── Error ──────────────────────────────────────
              else if (vm.hasError)
                SliverFillRemaining(
                  child: Center(
                    child: Text(vm.errorMessage ?? 'Error',
                        style: AppTextStyles.bodyMedium),
                  ),
                )

              // ── Sin resultados ─────────────────────────────
              else if (vm.animes.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded,
                            color: AppColors.textDisabled, size: 48),
                        const SizedBox(height: 12),
                        Text(l.homeNoResults, style: AppTextStyles.headline3),
                        const SizedBox(height: 4),
                        Text(l.homeNoResultsHint,
                            style: AppTextStyles.bodySmall),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            _searchCtrl.clear();
                            vm.clearFilters();
                          },
                          child: Text(l.homeClearFilters),
                        ),
                      ],
                    ),
                  ),
                )

              // ── Grilla ────────────────────────────────────
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => AnimeCard(anime: vm.animes[index]),
                      childCount: vm.animes.length,
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
      },
    );
  }

  void _showFilterSheet(BuildContext context, AnimeViewModel vm, AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FilterSheet(vm: vm, l: l),
    );
  }
}

// ── Filter Sheet ───────────────────────────────────────────
class _FilterSheet extends StatelessWidget {
  final AnimeViewModel vm;
  final AppLocalizations l;
  const _FilterSheet({required this.vm, required this.l});

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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(l.homeFilterGenre, style: AppTextStyles.headline3),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AnimeData.allGenres
                .map((g) => GenreChip(
                      genre: g,
                      isSelected: vm.selectedGenre == g,
                      onTap: () {
                        vm.setGenre(vm.selectedGenre == g ? null : g);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Text(l.homeFilterPlatform, style: AppTextStyles.headline3),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AnimeData.allPlatforms.map((p) {
              final isSelected = vm.selectedPlatform == p;
              return GestureDetector(
                onTap: () {
                  vm.setPlatform(isSelected ? null : p);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(p,
                      style: AppTextStyles.label.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      )),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
