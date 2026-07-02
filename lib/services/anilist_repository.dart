import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/anime.dart';
import 'anilist_service.dart';

class AniListRepository {
  static const _keyCatalog   = 'cache:anilist:catalog';
  static const _keyTimestamp = 'cache:anilist:timestamp';
  static const _cacheTtlMs   = 3600000;

  final AniListService _service;

  AniListRepository({AniListService? service})
      : _service = service ?? AniListService();

  // ── Catálogo inicial ──────────────────────────────────────
  Future<({List<Anime> animes, bool hasNextPage})> getCatalog({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && await _isCacheValid()) {
      final cached = await _loadFromCache();
      if (cached != null && cached.isNotEmpty) {
        return (animes: cached, hasNextPage: true);
      }
    }

    try {
      final result = await _service.fetchCatalog(page: 1, perPage: 50);
      await _saveToCache(result.animes);
      return result;
    } catch (_) {
      final cached = await _loadFromCache();
      return (animes: cached ?? [], hasNextPage: false);
    }
  }

  // ── Página adicional del catálogo ─────────────────────────
  Future<({List<Anime> animes, bool hasNextPage})> loadPage(int page) async {
    try {
      return await _service.fetchCatalog(page: page, perPage: 50);
    } catch (_) {
      return (animes: <Anime>[], hasNextPage: false);
    }
  }

  // ── Búsqueda paginada ─────────────────────────────────────
  Future<({List<Anime> animes, bool hasNextPage})> search(
    String query, {
    String? genre,
    int page = 1,
  }) async {
    try {
      return await _service.search(query, genre: genre, page: page);
    } catch (_) {
      // Offline: filtrar sobre caché local solo en página 1
      if (page == 1) {
        final cached = await _loadFromCache();
        if (cached != null) {
          final q = query.toLowerCase();
          final filtered = cached.where((a) {
            final matchQ = q.isEmpty ||
                a.title.toLowerCase().contains(q) ||
                a.originalTitle.toLowerCase().contains(q) ||
                a.tags.any((t) => t.toLowerCase().contains(q));
            final matchG = genre == null || a.genres.contains(genre);
            return matchQ && matchG;
          }).toList();
          return (animes: filtered, hasNextPage: false);
        }
      }
      return (animes: <Anime>[], hasNextPage: false);
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
