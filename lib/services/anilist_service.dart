import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/anime.dart';

/// Servicio que consume la API GraphQL de AniList.
/// Endpoint: https://graphql.anilist.co
/// No requiere API key — es pública.
class AniListService {
  static const _url = 'https://graphql.anilist.co';

  static const _catalogQuery = r'''
  query ($page: Int, $perPage: Int) {
    Page(page: $page, perPage: $perPage) {
      pageInfo { hasNextPage }
      media(type: ANIME, sort: POPULARITY_DESC, isAdult: false) {
        id
        title { romaji english native }
        description(asHtml: false)
        coverImage { large extraLarge }
        averageScore
        startDate { year }
        episodes
        status
        genres
        studios(isMain: true) { nodes { name } }
        trailer { id site }
        synonyms
        streamingEpisodes { site }
      }
    }
  }
  ''';

  static const _searchQuery = r'''
  query ($search: String, $genre: String, $page: Int, $perPage: Int) {
    Page(page: $page, perPage: $perPage) {
      pageInfo { hasNextPage }
      media(
        type: ANIME,
        search: $search,
        genre: $genre,
        isAdult: false,
        sort: POPULARITY_DESC
      ) {
        id
        title { romaji english native }
        description(asHtml: false)
        coverImage { large extraLarge }
        averageScore
        startDate { year }
        episodes
        status
        genres
        studios(isMain: true) { nodes { name } }
        trailer { id site }
        synonyms
        streamingEpisodes { site }
      }
    }
  }
  ''';

  // ── Catálogo paginado ─────────────────────────────────────
  Future<({List<Anime> animes, bool hasNextPage})> fetchCatalog({
    int page = 1,
    int perPage = 50,
  }) async {
    final response = await http
        .post(
          Uri.parse(_url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'query': _catalogQuery,
            'variables': {'page': page, 'perPage': perPage},
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('AniList error ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final page0 = data['data']['Page'] as Map<String, dynamic>;
    final hasNext =
        (page0['pageInfo'] as Map<String, dynamic>)['hasNextPage'] as bool;
    final mediaList = page0['media'] as List<dynamic>;

    return (
      animes: mediaList
          .map((m) => _mapToAnime(m as Map<String, dynamic>))
          .toList(),
      hasNextPage: hasNext,
    );
  }

  // ── Búsqueda paginada ─────────────────────────────────────
  Future<({List<Anime> animes, bool hasNextPage})> search(
    String query, {
    String? genre,
    int page = 1,
    int perPage = 30,
  }) async {
    final variables = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };
    if (query.isNotEmpty) variables['search'] = query;
    if (genre != null) variables['genre'] = genre;

    final response = await http
        .post(
          Uri.parse(_url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'query': _searchQuery,
            'variables': variables,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('AniList error ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final page0 = data['data']['Page'] as Map<String, dynamic>;
    final hasNext =
        (page0['pageInfo'] as Map<String, dynamic>)['hasNextPage'] as bool;
    final mediaList = page0['media'] as List<dynamic>;

    return (
      animes: mediaList
          .map((m) => _mapToAnime(m as Map<String, dynamic>))
          .toList(),
      hasNextPage: hasNext,
    );
  }

  // ── Mapeo JSON → Anime ────────────────────────────────────
  Anime _mapToAnime(Map<String, dynamic> m) {
    final titles = m['title'] as Map<String, dynamic>;
    final title = (titles['english'] as String?) ??
        (titles['romaji'] as String?) ??
        'Unknown';
    final originalTitle =
        (titles['native'] as String?) ?? (titles['romaji'] as String?) ?? '';

    final rawDesc = (m['description'] as String?) ?? '';
    final synopsis = rawDesc
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .trim();

    final cover = m['coverImage'] as Map<String, dynamic>;
    final coverUrl = (cover['extraLarge'] as String?) ??
        (cover['large'] as String?) ??
        '';

    final rawScore = m['averageScore'] as int?;
    final rating = rawScore != null ? rawScore / 10.0 : 0.0;

    final startDate = m['startDate'] as Map<String, dynamic>?;
    final releaseYear = (startDate?['year'] as int?) ?? 0;

    final episodes = (m['episodes'] as int?) ?? 0;
    final rawStatus = (m['status'] as String?) ?? '';
    final status = _mapStatus(rawStatus);

    final genres = (m['genres'] as List<dynamic>?)
            ?.map((g) => g as String)
            .toList() ??
        [];

    final studiosData = m['studios'] as Map<String, dynamic>?;
    final studioNodes = (studiosData?['nodes'] as List<dynamic>?) ?? [];
    final studio = studioNodes.isNotEmpty
        ? (studioNodes.first as Map<String, dynamic>)['name'] as String
        : 'Desconocido';

    final trailerData = m['trailer'] as Map<String, dynamic>?;
    String? trailerUrl;
    if (trailerData != null && trailerData['site'] == 'youtube') {
      trailerUrl = 'https://www.youtube.com/embed/${trailerData['id']}';
    }

    final tags = (m['synonyms'] as List<dynamic>?)
            ?.map((s) => s as String)
            .toList() ??
        [];

    final streaming = (m['streamingEpisodes'] as List<dynamic>?) ?? [];
    final platforms = streaming
        .map((e) => (e as Map<String, dynamic>)['site'] as String)
        .toSet()
        .toList();

    return Anime(
      id: m['id'].toString(),
      title: title,
      originalTitle: originalTitle,
      synopsis: synopsis.isEmpty ? 'Sin sinopsis disponible.' : synopsis,
      coverUrl: coverUrl,
      rating: rating,
      releaseYear: releaseYear,
      episodes: episodes,
      status: status,
      genres: genres,
      platforms: platforms.isEmpty ? ['Crunchyroll'] : platforms,
      studio: studio,
      trailerUrl: trailerUrl,
      tags: tags,
    );
  }

  String _mapStatus(String raw) {
    switch (raw) {
      case 'RELEASING':        return 'En Emisión';
      case 'FINISHED':         return 'Finalizado';
      case 'NOT_YET_RELEASED': return 'Próximamente';
      case 'CANCELLED':        return 'Cancelado';
      default:                 return raw;
    }
  }
}
