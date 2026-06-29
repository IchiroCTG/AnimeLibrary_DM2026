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

  /// Inyectar FavoritesViewModel para sincronizar catálogo.
  void setFavoritesViewModel(FavoritesViewModel vm) {
    _favoritesVm = vm;
  }

  AnimeState _state = AnimeState.initial;
  List<Anime> _animes     = [];
  List<Anime> _filtered   = [];
  String? _selectedGenre;
  String? _selectedPlatform;
  String  _query          = '';
  String? _errorMessage;
  bool    _isOffline      = false;

  // ── Getters ───────────────────────────────────────────────
  AnimeState get state            => _state;
  bool       get isLoading        => _state == AnimeState.loading;
  bool       get hasError         => _state == AnimeState.error || _state == AnimeState.timeout;
  bool       get isOffline        => _isOffline;
  String?    get errorMessage     => _errorMessage;
  String?    get selectedGenre    => _selectedGenre;
  String?    get selectedPlatform => _selectedPlatform;
  String     get query            => _query;

  List<Anime> get animes {
    final hasFilter = _query.isNotEmpty ||
        _selectedGenre != null ||
        _selectedPlatform != null;
    return hasFilter ? _filtered : _animes;
  }

  List<String> get allGenres {
    final genres = _animes.expand((a) => a.genres).toSet().toList()..sort();
    return genres;
  }

  List<String> get allPlatforms {
    final platforms = _animes.expand((a) => a.platforms).toSet().toList()..sort();
    return platforms;
  }

  // ── Cargar catálogo ───────────────────────────────────────
  Future<void> loadAnimes({bool forceRefresh = false}) async {
    if (_state == AnimeState.loading) return;

    _state        = AnimeState.loading;
    _isOffline    = false;
    _errorMessage = null;
    notifyListeners();

    try {
      _animes   = await _repo.getCatalog(forceRefresh: forceRefresh);
      _filtered = _animes;
      _state    = AnimeState.loaded;

      // Sincronizar catálogo con FavoritesViewModel
      _favoritesVm?.updateCatalog(_animes);
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('timeout') || msg.contains('TimeoutException')) {
        _state        = AnimeState.timeout;
        _errorMessage = 'Tiempo de espera agotado. Verifica tu conexión.';
      } else {
        _state        = AnimeState.error;
        _errorMessage = 'No se pudo conectar con AniList.';
      }
      if (_animes.isEmpty) _isOffline = true;
    }

    notifyListeners();
  }

  // ── Búsqueda directa en API (para SearchScreen) ───────────
  Future<List<Anime>> searchAnimes(String query, {String? genre}) async {
    return _repo.search(query, genre: genre);
  }

  // ── Filtros ───────────────────────────────────────────────
  void setGenre(String? genre) {
    _selectedGenre = genre;
    _applyFilters();
  }

  void setPlatform(String? platform) {
    _selectedPlatform = platform;
    _applyFilters();
  }

  void setQuery(String query) {
    _query = query;
    _applyFilters();
  }

  void clearFilters() {
    _selectedGenre    = null;
    _selectedPlatform = null;
    _query            = '';
    _filtered         = _animes;
    notifyListeners();
  }

  void _applyFilters() {
    _filtered = _animes.where((a) {
      final matchGenre    = _selectedGenre == null || a.genres.contains(_selectedGenre);
      final matchPlatform = _selectedPlatform == null || a.platforms.contains(_selectedPlatform);
      final matchQuery    = _query.isEmpty ||
          a.title.toLowerCase().contains(_query.toLowerCase()) ||
          a.originalTitle.toLowerCase().contains(_query.toLowerCase()) ||
          a.tags.any((t) => t.toLowerCase().contains(_query.toLowerCase()));
      return matchGenre && matchPlatform && matchQuery;
    }).toList();
    notifyListeners();
  }
}
