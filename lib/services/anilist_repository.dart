import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/anime.dart';
import 'anilist_service.dart';

/// Repositorio con paginación y caché offline.
/// Estrategia Offline-First:
///   1. Intenta API → guarda en caché.
///   2. Sin red → retorna última caché válida.
///   3. Sin caché → lista vacía.
class AniListRepository {
  static const _keyCatalog   = 'cache:anilist:catalog';
  static const _keyTimestamp = 'cache:anilist:timestamp';
  static const _cacheTtlMs   = 3600000; // 1 hora
  static const _perPage      = 50;

  final AniListService _service;

  AniListRepository({AniListService? service})
      : _service = service ?? AniListService();

  // ── Página inicial (refresh o primer arranque) ────────────
  Future<List<Anime>> getCatalog({bool forceRefresh = false}) async {
    if (!forceRefresh && await _isCacheValid()) {
      final cached = await _loadFromCache();
      if (cached != null && cached.isNotEmpty) return cached;
    }

    try {
      final animes =
          await _service.fetchCatalog(page: 1, perPage: _perPage);
      await _saveToCache(animes);
      return animes;
    } catch (_) {
      final cached = await _loadFromCache();
      return cached ?? [];
    }
  }

  // ── Cargar página adicional (scroll infinito) ─────────────
  Future<List<Anime>> loadPage(int page) async {
    try {
      return await _service.fetchCatalog(page: page, perPage: _perPage);
    } catch (_) {
      return [];
    }
  }

  // ── Búsqueda ──────────────────────────────────────────────
  Future<List<Anime>> search(String query, {String? genre}) async {
    try {
      return await _service.search(query, genre: genre);
    } catch (_) {
      final cached = await _loadFromCache();
      if (cached == null) return [];
      final q = query.toLowerCase();
      return cached.where((a) {
        final matchQuery = q.isEmpty ||
            a.title.toLowerCase().contains(q) ||
            a.originalTitle.toLowerCase().contains(q) ||
            a.tags.any((t) => t.toLowerCase().contains(q));
        final matchGenre =
            genre == null || a.genres.contains(genre);
        return matchQuery && matchGenre;
      }).toList();
    }
  }

  // ── Caché ─────────────────────────────────────────────────
  Future<bool> _isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_keyTimestamp);
    if (ts == null) return false;
    return DateTime.now().millisecondsSinceEpoch - ts < _cacheTtlMs;
  }

  Future<List<Anime>?> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCatalog);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => _animeFromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToCache(List<Anime> animes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _keyCatalog, jsonEncode(animes.map(_animeToMap).toList()));
    await prefs.setInt(
        _keyTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  // ── Serialización ─────────────────────────────────────────
  Map<String, dynamic> _animeToMap(Anime a) => {
        'id': a.id,
        'title': a.title,
        'originalTitle': a.originalTitle,
        'synopsis': a.synopsis,
        'coverUrl': a.coverUrl,
        'rating': a.rating,
        'releaseYear': a.releaseYear,
        'episodes': a.episodes,
        'status': a.status,
        'genres': a.genres,
        'platforms': a.platforms,
        'studio': a.studio,
        'trailerUrl': a.trailerUrl,
        'tags': a.tags,
      };

  Anime _animeFromMap(Map<String, dynamic> m) => Anime(
        id: m['id'] as String,
        title: m['title'] as String,
        originalTitle: m['originalTitle'] as String,
        synopsis: m['synopsis'] as String,
        coverUrl: m['coverUrl'] as String,
        rating: (m['rating'] as num).toDouble(),
        releaseYear: m['releaseYear'] as int,
        episodes: m['episodes'] as int,
        status: m['status'] as String,
        genres: List<String>.from(m['genres'] as List),
        platforms: List<String>.from(m['platforms'] as List),
        studio: m['studio'] as String,
        trailerUrl: m['trailerUrl'] as String?,
        tags: List<String>.from(m['tags'] as List? ?? []),
      );
}
