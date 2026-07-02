import 'package:flutter/material.dart';

import '../models/anime.dart';
import '../services/anilist_repository.dart';
import 'favorites_viewmodel.dart';

enum AnimeState { initial, loading, loaded, error, timeout }

class AnimeViewModel extends ChangeNotifier {
  final AniListRepository _repo;
  FavoritesViewModel? _favoritesVm;

  AnimeViewModel({AniListRepository? repository})
      : _repo = repository ?? AniListRepository();

  void setFavoritesViewModel(FavoritesViewModel vm) {
    _favoritesVm = vm;
  }

  AnimeState _state = AnimeState.initial;
  List<Anime> _animes   = [];
  List<Anime> _filtered = [];
  String? _selectedGenre;
  String? _selectedPlatform;
  String  _query        = '';
  String? _errorMessage;
  bool    _isOffline    = false;

  // ── Paginación catálogo ───────────────────────────────────
  int  _catalogPage      = 1;
  bool _isLoadingMore    = false;
  bool _hasMoreCatalog   = true;

  // ── Paginación búsqueda ───────────────────────────────────
  int          _searchPage        = 1;
  bool         _isLoadingMoreSearch = false;
  bool         _hasMoreSearch     = false;
  List<Anime>  _searchResults     = [];
  String       _lastQuery         = '';
  String?      _lastGenre;

  // ── Getters generales ─────────────────────────────────────
  AnimeState get state         => _state;
  bool get isLoading           => _state == AnimeState.loading;
  bool get hasError            => _state == AnimeState.error ||
                                  _state == AnimeState.timeout;
  bool get isOffline           => _isOffline;
  String? get errorMessage     => _errorMessage;
  String? get selectedGenre    => _selectedGenre;
  String? get selectedPlatform => _selectedPlatform;
  String  get query            => _query;

  // ── Getters scroll infinito catálogo ─────────────────────
  bool get isLoadingMore  => _isLoadingMore;
  bool get hasMoreCatalog => _hasMoreCatalog;

  // ── Getters scroll infinito búsqueda ─────────────────────
  bool        get isLoadingMoreSearch => _isLoadingMoreSearch;
  bool        get hasMoreSearch       => _hasMoreSearch;
  List<Anime> get searchResults       => _searchResults;

  bool get _hasFilter => _query.isNotEmpty ||
      _selectedGenre != null ||
      _selectedPlatform != null;

  List<Anime> get animes => _hasFilter ? _filtered : _animes;

  List<String> get allGenres =>
      _animes.expand((a) => a.genres).toSet().toList()..sort();

  List<String> get allPlatforms =>
      _animes.expand((a) => a.platforms).toSet().toList()..sort();

  // ── Carga inicial del catálogo ────────────────────────────
  Future<void> loadAnimes({bool forceRefresh = false}) async {
    if (_state == AnimeState.loading) return;

    _state         = AnimeState.loading;
    _isOffline     = false;
    _errorMessage  = null;
    _catalogPage   = 1;
    _hasMoreCatalog = true;
    notifyListeners();

    try {
      final result =
          await _repo.getCatalog(forceRefresh: forceRefresh);
      _animes        = result.animes;
      _filtered      = _applyFiltersTo(_animes);
      _state         = AnimeState.loaded;
      _hasMoreCatalog = result.hasNextPage;
      _favoritesVm?.updateCatalog(_animes);
    } on Exception catch (e) {
      final msg = e.toString();
      _state = msg.contains('timeout') || msg.contains('TimeoutException')
          ? AnimeState.timeout
          : AnimeState.error;
      _errorMessage = _state == AnimeState.timeout
          ? 'Tiempo de espera agotado. Verifica tu conexión.'
          : 'No se pudo conectar con AniList.';
      if (_animes.isEmpty) _isOffline = true;
    }

    notifyListeners();
  }

  // ── Más páginas del catálogo ──────────────────────────────
  Future<void> loadMoreCatalog() async {
    if (_isLoadingMore || !_hasMoreCatalog || _hasFilter) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _catalogPage++;
      final result = await _repo.loadPage(_catalogPage);
      if (result.animes.isEmpty) {
        _hasMoreCatalog = false;
      } else {
        final existingIds = _animes.map((a) => a.id).toSet();
        final unique = result.animes
            .where((a) => !existingIds.contains(a.id))
            .toList();
        _animes.addAll(unique);
        _hasMoreCatalog = result.hasNextPage;
        _favoritesVm?.updateCatalog(_animes);
      }
    } catch (_) {
      _hasMoreCatalog = false;
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  // ── Búsqueda inicial ──────────────────────────────────────
  Future<void> performSearch(String query, {String? genre}) async {
    _lastQuery   = query;
    _lastGenre   = genre;
    _searchPage  = 1;
    _searchResults = [];
    _hasMoreSearch = false;
    notifyListeners();

    try {
      final result = await _repo.search(query, genre: genre, page: 1);
      _searchResults = result.animes;
      _hasMoreSearch = result.hasNextPage;
    } catch (_) {
      _searchResults = [];
      _hasMoreSearch = false;
    }

    notifyListeners();
  }

  // ── Más resultados de búsqueda ────────────────────────────
  Future<void> loadMoreSearch() async {
    if (_isLoadingMoreSearch || !_hasMoreSearch) return;

    _isLoadingMoreSearch = true;
    notifyListeners();

    try {
      _searchPage++;
      final result = await _repo.search(
        _lastQuery,
        genre: _lastGenre,
        page: _searchPage,
      );
      if (result.animes.isEmpty) {
        _hasMoreSearch = false;
      } else {
        final existingIds = _searchResults.map((a) => a.id).toSet();
        final unique = result.animes
            .where((a) => !existingIds.contains(a.id))
            .toList();
        _searchResults.addAll(unique);
        _hasMoreSearch = result.hasNextPage;
      }
    } catch (_) {
      _hasMoreSearch = false;
    }

    _isLoadingMoreSearch = false;
    notifyListeners();
  }

  // ── Filtros del catálogo ──────────────────────────────────
  void setGenre(String? genre) {
    _selectedGenre = genre;
    _filtered = _applyFiltersTo(_animes);
    notifyListeners();
  }

  void setPlatform(String? platform) {
    _selectedPlatform = platform;
    _filtered = _applyFiltersTo(_animes);
    notifyListeners();
  }

  void setQuery(String query) {
    _query = query;
    _filtered = _applyFiltersTo(_animes);
    notifyListeners();
  }

  void clearFilters() {
    _selectedGenre    = null;
    _selectedPlatform = null;
    _query            = '';
    _filtered         = _animes;
    notifyListeners();
  }

  List<Anime> _applyFiltersTo(List<Anime> source) {
    return source.where((a) {
      final matchGenre =
          _selectedGenre == null || a.genres.contains(_selectedGenre);
      final matchPlatform = _selectedPlatform == null ||
          a.platforms.contains(_selectedPlatform);
      final matchQuery = _query.isEmpty ||
          a.title.toLowerCase().contains(_query.toLowerCase()) ||
          a.originalTitle.toLowerCase().contains(_query.toLowerCase()) ||
          a.tags.any((t) => t.toLowerCase().contains(_query.toLowerCase()));
      return matchGenre && matchPlatform && matchQuery;
    }).toList();
  }
}
