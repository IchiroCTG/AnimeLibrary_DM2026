import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../models/anime_data.dart';

enum AnimeState { initial, loading, loaded, error }

class AnimeViewModel extends ChangeNotifier {
  AnimeState _state = AnimeState.initial;
  List<Anime> _animes = [];
  List<Anime> _filtered = [];
  String? _selectedGenre;
  String? _selectedPlatform;
  String _query = '';
  String? _errorMessage;

  // ── Getters ───────────────────────────────────────────────
  AnimeState get state         => _state;
  List<Anime> get animes       => _filtered.isEmpty && _query.isEmpty && _selectedGenre == null && _selectedPlatform == null
                                    ? _animes
                                    : _filtered;
  String? get selectedGenre    => _selectedGenre;
  String? get selectedPlatform => _selectedPlatform;
  String  get query            => _query;
  String? get errorMessage     => _errorMessage;
  bool    get isLoading        => _state == AnimeState.loading;
  bool    get hasError         => _state == AnimeState.error;

  // ── Cargar catálogo ───────────────────────────────────────
  Future<void> loadAnimes() async {
    _state = AnimeState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _animes   = AnimeData.catalog;
      _filtered = _animes;
      _state    = AnimeState.loaded;
    } catch (e) {
      _state        = AnimeState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
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
    _filtered = AnimeData.filterBy(
      genre:    _selectedGenre,
      platform: _selectedPlatform,
      query:    _query.isEmpty ? null : _query,
    );
    notifyListeners();
  }
}