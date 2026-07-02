import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnimeViewModel>().loadAnimes();
    });

    // Detectar cuando el usuario llega al 90% del scroll
    _scrollCtrl.addListener(() {
      final vm = context.read<AnimeViewModel>();
      if (_scrollCtrl.position.pixels >=
              _scrollCtrl.position.maxScrollExtent * 0.9 &&
          !vm.isLoadingMore &&
          vm.hasMoreCatalog &&
          !vm.isLoading) {
        vm.loadMoreCatalog();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
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
            controller: _scrollCtrl,
            slivers: [
              // ── AppBar ──────────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                expandedHeight: 110,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsets.only(left: 16, bottom: 12),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.homeSubtitle,
                          style: AppTextStyles.bodySmall),
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
                    icon: const Icon(Icons.refresh_rounded),
                    color: AppColors.textSecondary,
                    onPressed: () => vm.loadAnimes(forceRefresh: true),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune_rounded),
                    color: AppColors.textSecondary,
                    onPressed: () =>
                        _showFilterSheet(context, vm, l),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Banner offline ─────────────────────────
                    if (vm.isOffline)
                      Container(
                        margin:
                            const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.warning
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.warning
                                  .withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off_rounded,
                                color: AppColors.warning, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Modo offline — mostrando datos guardados',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.warning),
                            ),
                          ],
                        ),
                      ),

                    // ── Buscador ───────────────────────────────
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                                      color: AppColors.textDisabled,
                                      size: 18),
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
                    if (vm.allGenres.isNotEmpty)
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: vm.allGenres.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final genre = vm.allGenres[i];
                            return GenreChip(
                              genre: genre,
                              isSelected: vm.selectedGenre == genre,
                              onTap: () => vm.setGenre(
                                vm.selectedGenre == genre
                                    ? null
                                    : genre,
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 12),

                    // ── Chips plataforma ───────────────────────
                    if (vm.allPlatforms.isNotEmpty)
                      SizedBox(
                        height: 36,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: vm.allPlatforms.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final platform = vm.allPlatforms[i];
                            final isSelected =
                                vm.selectedPlatform == platform;
                            return GestureDetector(
                              onTap: () => vm.setPlatform(
                                isSelected ? null : platform,
                              ),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.surfaceVariant,
                                  borderRadius:
                                      BorderRadius.circular(20),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
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
                                    : l.homeResultsPlural(
                                        vm.animes.length))
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
                                  style: AppTextStyles.label.copyWith(
                                      color: AppColors.primary)),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // ── Loading inicial ────────────────────────────
              if (vm.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary),
                  ),
                )

              // ── Error / Timeout ────────────────────────────
              else if (vm.hasError)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            vm.state == AnimeState.timeout
                                ? Icons.timer_off_rounded
                                : Icons.cloud_off_rounded,
                            color: AppColors.textDisabled,
                            size: 52,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            vm.errorMessage ?? 'Error desconocido',
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () =>
                                vm.loadAnimes(forceRefresh: true),
                            icon:
                                const Icon(Icons.refresh_rounded),
                            label: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
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
                        Text(l.homeNoResults,
                            style: AppTextStyles.headline3),
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
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          AnimeCard(anime: vm.animes[index]),
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

                // ── Indicador "cargando más" ───────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: vm.isLoadingMore
                          ? const CircularProgressIndicator(
                              color: AppColors.primary, strokeWidth: 2)
                          : vm.hasMoreCatalog
                              ? const SizedBox.shrink()
                              : Text(
                                  '— Fin del catálogo —',
                                  style: AppTextStyles.bodySmall,
                                ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet(
      BuildContext context, AnimeViewModel vm, AppLocalizations l) {
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

// ── Filter Sheet ───────────────────────────────────────────────
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
            children: vm.allGenres
                .map((g) => GenreChip(
                      genre: g,
                      isSelected: vm.selectedGenre == g,
                      onTap: () {
                        vm.setGenre(
                            vm.selectedGenre == g ? null : g);
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
            children: vm.allPlatforms.map((p) {
              final isSelected = vm.selectedPlatform == p;
              return GestureDetector(
                onTap: () {
                  vm.setPlatform(isSelected ? null : p);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
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
