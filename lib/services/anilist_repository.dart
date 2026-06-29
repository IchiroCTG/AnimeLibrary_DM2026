import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/anime.dart';
import 'anilist_service.dart';

/// Repositorio que combina AniList API + caché local (SharedPreferences).
/// Estrategia Offline-First:
///   1. Intenta obtener datos frescos de la API.
///   2. Si hay error o timeout, retorna la última caché válida.
///   3. Si no hay caché, lanza excepción.
class AniListRepository {
  static const _keyCatalog  = 'cache:anilist:catalog';
  static const _keyTimestamp = 'cache:anilist:timestamp';
  // Caché válida por 1 hora
  static const _cacheTtlMs  = 3600000;

  final AniListService _service;

  AniListRepository({AniListService? service})
      : _service = service ?? AniListService();

  // ── Obtener catálogo ──────────────────────────────────────
  Future<List<Anime>> getCatalog({bool forceRefresh = false}) async {
    // Si no se fuerza refresh y hay caché vigente, la retornamos
    if (!forceRefresh && await _isCacheValid()) {
      final cached = await _loadFromCache();
      if (cached != null) return cached;
    }

    try {
      final animes = await _service.fetchCatalog(perPage: 30);
      await _saveToCache(animes);
      return animes;
    } catch (e) {
      // Fallback: intentar caché aunque esté vencida
      final cached = await _loadFromCache();
      if (cached != null) return cached;

      // Si no hay caché, usar datos estáticos como último recurso
      return _staticFallback();
    }
  }

  // ── Búsqueda ──────────────────────────────────────────────
  Future<List<Anime>> search(String query, {String? genre}) async {
    try {
      return await _service.search(query, genre: genre);
    } catch (e) {
      // En offline, filtrar sobre la caché local
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
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    return age < _cacheTtlMs;
  }

  Future<List<Anime>?> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCatalog);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => _animeFromMap(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToCache(List<Anime> animes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(animes.map(_animeToMap).toList());
    await prefs.setString(_keyCatalog, encoded);
    await prefs.setInt(
        _keyTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  // ── Serialización Anime ←→ Map ────────────────────────────
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

  // ── Fallback estático (sin red y sin caché) ───────────────
  List<Anime> _staticFallback() => const [
        Anime(
          id: 'offline_001',
          title: 'Sin conexión',
          originalTitle: 'オフライン',
          synopsis:
              'No se pudo cargar el catálogo. Verifica tu conexión a internet e intenta de nuevo.',
          coverUrl: '',
          rating: 0.0,
          releaseYear: 0,
          episodes: 0,
          status: 'Desconocido',
          genres: [],
          platforms: [],
          studio: '',
        ),
      ];
}
