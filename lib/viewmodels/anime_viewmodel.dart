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

  AnimeState _state       = AnimeState.initial;
  List<Anime> _animes     = [];
  List<Anime> _filtered   = [];
  String? _selectedGenre;
  String? _selectedPlatform;
  String  _query          = '';
  String? _errorMessage;
  bool    _isOffline      = false;

  // ── Paginación ────────────────────────────────────────────
  int  _currentPage  = 1;
  bool _isLoadingMore = false;
  bool _hasMore       = true;

  // ── Getters ───────────────────────────────────────────────
  AnimeState get state            => _state;
  bool get isLoading              => _state == AnimeState.loading;
  bool get hasError               => _state == AnimeState.error ||
                                     _state == AnimeState.timeout;
  bool get isOffline              => _isOffline;
  bool get isLoadingMore          => _isLoadingMore;
  bool get hasMore                => _hasMore;
  String? get errorMessage        => _errorMessage;
  String? get selectedGenre       => _selectedGenre;
  String? get selectedPlatform    => _selectedPlatform;
  String  get query               => _query;

  bool get _hasFilter => _query.isNotEmpty ||
      _selectedGenre != null ||
      _selectedPlatform != null;

  List<Anime> get animes => _hasFilter ? _filtered : _animes;

  List<String> get allGenres {
    return _animes.expand((a) => a.genres).toSet().toList()..sort();
  }

  List<String> get allPlatforms {
    return _animes.expand((a) => a.platforms).toSet().toList()..sort();
  }

  // ── Carga inicial ─────────────────────────────────────────
  Future<void> loadAnimes({bool forceRefresh = false}) async {
    if (_state == AnimeState.loading) return;

    _state        = AnimeState.loading;
    _isOffline    = false;
    _errorMessage = null;
    _currentPage  = 1;
    _hasMore      = true;
    notifyListeners();

    try {
      final result =
          await _repo.getCatalog(forceRefresh: forceRefresh);
      _animes   = result;
      _filtered = _applyFiltersTo(_animes);
      _state    = AnimeState.loaded;
      // Si la primera página vino completa (50), puede haber más
      _hasMore  = result.length >= 50;
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

  // ── Cargar más (scroll infinito) ──────────────────────────
  Future<void> loadMore() async {
    // No cargar si: ya cargando, sin más páginas, hay filtro activo
    if (_isLoadingMore || !_hasMore || _hasFilter) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newAnimes = await _repo.loadPage(_currentPage);

      if (newAnimes.isEmpty) {
        _hasMore = false;
      } else {
        // Evitar duplicados por ID
        final existingIds = _animes.map((a) => a.id).toSet();
        final unique =
            newAnimes.where((a) => !existingIds.contains(a.id)).toList();
        _animes.addAll(unique);
        _hasMore = newAnimes.length >= 50;
        _favoritesVm?.updateCatalog(_animes);
      }
    } catch (_) {
      _hasMore = false;
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  // ── Búsqueda directa en API ───────────────────────────────
  Future<List<Anime>> searchAnimes(String query, {String? genre}) async {
    return _repo.search(query, genre: genre);
  }

  // ── Filtros ───────────────────────────────────────────────
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
