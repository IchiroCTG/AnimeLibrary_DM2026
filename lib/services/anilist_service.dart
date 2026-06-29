import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/anime.dart';

/// Servicio que consume la API GraphQL de AniList.
/// Endpoint: https://graphql.anilist.co
/// No requiere API key — es pública.
class AniListService {
  static const _url = 'https://graphql.anilist.co';

  // ── Query GraphQL ─────────────────────────────────────────
  // Retorna los top animes por popularidad con todos los campos
  // que necesita el modelo Anime.
  static const _query = r'''
  query ($page: Int, $perPage: Int) {
    Page(page: $page, perPage: $perPage) {
      media(type: ANIME, sort: POPULARITY_DESC, isAdult: false) {
        id
        title {
          romaji
          english
          native
        }
        description(asHtml: false)
        coverImage {
          large
          extraLarge
        }
        averageScore
        startDate {
          year
        }
        episodes
        status
        genres
        studios(isMain: true) {
          nodes {
            name
          }
        }
        trailer {
          id
          site
        }
        synonyms
        streamingEpisodes {
          site
        }
      }
    }
  }
  ''';

  // ── Fetch catálogo ────────────────────────────────────────
  Future<List<Anime>> fetchCatalog({int page = 1, int perPage = 20}) async {
    final response = await http
        .post(
          Uri.parse(_url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'query': _query,
            'variables': {'page': page, 'perPage': perPage},
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('AniList error ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final mediaList =
        data['data']['Page']['media'] as List<dynamic>;

    return mediaList
        .map((m) => _mapToAnime(m as Map<String, dynamic>))
        .toList();
  }

  // ── Búsqueda por texto ────────────────────────────────────
  Future<List<Anime>> search(String query,
      {String? genre, int perPage = 20}) async {
    const searchQuery = r'''
    query ($search: String, $genre: String, $perPage: Int) {
      Page(perPage: $perPage) {
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

    final variables = <String, dynamic>{'perPage': perPage};
    if (query.isNotEmpty) variables['search'] = query;
    if (genre != null) variables['genre'] = genre;

    final response = await http
        .post(
          Uri.parse(_url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'query': searchQuery, 'variables': variables}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('AniList error ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final mediaList = data['data']['Page']['media'] as List<dynamic>;
    return mediaList
        .map((m) => _mapToAnime(m as Map<String, dynamic>))
        .toList();
  }

  // ── Mapeo JSON → Anime ────────────────────────────────────
  Anime _mapToAnime(Map<String, dynamic> m) {
    final titles = m['title'] as Map<String, dynamic>;
    final title = (titles['english'] as String?) ??
        (titles['romaji'] as String?) ??
        'Unknown';
    final originalTitle =
        (titles['native'] as String?) ?? (titles['romaji'] as String?) ?? '';

    // Descripción: limpiar saltos de línea extra
    final rawDesc = (m['description'] as String?) ?? '';
    final synopsis = rawDesc
        .replaceAll(RegExp(r'<[^>]*>'), '') // quitar HTML residual
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .trim();

    // Portada
    final cover = m['coverImage'] as Map<String, dynamic>;
    final coverUrl = (cover['extraLarge'] as String?) ??
        (cover['large'] as String?) ??
        '';

    // Rating: AniList usa 0-100, convertimos a 0-10
    final rawScore = m['averageScore'] as int?;
    final rating = rawScore != null ? rawScore / 10.0 : 0.0;

    // Año
    final startDate = m['startDate'] as Map<String, dynamic>?;
    final releaseYear = (startDate?['year'] as int?) ?? 0;

    // Episodios
    final episodes = (m['episodes'] as int?) ?? 0;

    // Status
    final rawStatus = (m['status'] as String?) ?? '';
    final status = _mapStatus(rawStatus);

    // Géneros
    final genres = (m['genres'] as List<dynamic>?)
            ?.map((g) => g as String)
            .toList() ??
        [];

    // Estudio principal
    final studiosData = m['studios'] as Map<String, dynamic>?;
    final studioNodes =
        (studiosData?['nodes'] as List<dynamic>?) ?? [];
    final studio = studioNodes.isNotEmpty
        ? (studioNodes.first as Map<String, dynamic>)['name'] as String
        : 'Desconocido';

    // Trailer
    final trailerData = m['trailer'] as Map<String, dynamic>?;
    String? trailerUrl;
    if (trailerData != null && trailerData['site'] == 'youtube') {
      trailerUrl =
          'https://www.youtube.com/embed/${trailerData['id']}';
    }

    // Tags / synonyms
    final tags = (m['synonyms'] as List<dynamic>?)
            ?.map((s) => s as String)
            .toList() ??
        [];

    // Plataformas desde streamingEpisodes
    final streaming =
        (m['streamingEpisodes'] as List<dynamic>?) ?? [];
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

  // ── Mapear status de AniList → texto de la app ────────────
  String _mapStatus(String raw) {
    switch (raw) {
      case 'RELEASING':
        return 'En Emisión';
      case 'FINISHED':
        return 'Finalizado';
      case 'NOT_YET_RELEASED':
        return 'Próximamente';
      case 'CANCELLED':
        return 'Cancelado';
      default:
        return raw;
    }
  }
}
