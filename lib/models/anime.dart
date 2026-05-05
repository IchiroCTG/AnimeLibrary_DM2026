class Anime{
  final String id;
  final String title;
  final String originalTitle; // titulo en japones / romaji
  final String synopsis; 
  final String studio;
  final String coverUrl; // portada
  final double rating; // 0.0 - 10.0
  final int releaseYear; // año de estreno
  final int episodes; // numero de episodios
  final String status; // "En Emisión", "Finalizado", "Proximamente"
  final List<String> genres; // lista de géneros
  final List<String> platforms; // plataformas donde se puede ver (Netflix, Crunchyroll, etc)
  final String? trailerUrl; // url del trailer
  final List<String> tags; // etiquetas para búsqueda (ej: "shounen", "romance", etc)

  const Anime({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.synopsis,
    required this.coverUrl,
    required this.rating,
    required this.releaseYear,
    required this.episodes,
    required this.status,
    required this.genres,
    required this.platforms,
    required this.studio,
    this.trailerUrl,
    this.tags = const [],
  });

  // retornar el primer genero como genero principal
  String get primaryGenre => genres.isNotEmpty ? genres.first : 'Desconocido';


  /// Retorna si esta en emisión
  bool get isAiring => status == 'En Emisión';

  // Debuging
  @override
  String toString() => 'Anime{id_ $id, title: $title, rating: $rating}';

  @override
  bool operator ==(Object other) => other is Anime && other.id == id;

  @override
  int get hashCode => id.hashCode;
}