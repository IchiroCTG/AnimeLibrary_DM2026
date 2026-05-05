import 'anime.dart';

class AnimeData {
  AnimeData._();

  static const List<Anime> catalog = [
    Anime(
      id: '001',
      title: 'Attack on Titan',
      originalTitle: 'Shingeki no Kyojin',
      synopsis:
          'La humanidad vive encerrada tras enormes murallas que la protegen de los Titanes, gigantes humanoides devoradores de personas. Eren Yeager, tras ver a su madre ser devorada, jura exterminarlos a todos e ingresa al Cuerpo de Exploración.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/10/47347l.jpg',
      rating: 9.1,
      releaseYear: 2013,
      episodes: 87,
      status: 'Finalizado',
      genres: ['Acción', 'Drama', 'Thriller'],
      platforms: ['Crunchyroll', 'Netflix'],
      studio: 'Wit Studio / MAPPA',
      trailerUrl: 'https://www.youtube.com/embed/LHtdKWJdif4',
      tags: ['SnK', 'AoT', '進撃の巨人'],
    ),
    Anime(
      id: '002',
      title: 'Fullmetal Alchemist: Brotherhood',
      originalTitle: 'Hagane no Renkinjutsushi',
      synopsis:
          'Los hermanos Edward y Alphonse Elric intentan recuperar sus cuerpos perdidos en un ritual alquímico fallido. Su búsqueda de la Piedra Filosofal los lleva a descubrir una conspiración que amenaza al Estado.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1223/96541l.jpg',
      rating: 9.1,
      releaseYear: 2009,
      episodes: 64,
      status: 'Finalizado',
      genres: ['Acción', 'Aventura', 'Drama'],
      platforms: ['Crunchyroll', 'Netflix'],
      studio: 'Bones',
      trailerUrl: 'https://www.youtube.com/embed/--IcmZkvL0Q',
      tags: ['FMA', 'FMAB', '鋼の錬金術師'],
    ),
    Anime(
      id: '003',
      title: 'Demon Slayer',
      originalTitle: 'Kimetsu no Yaiba',
      synopsis:
          'Tanjiro Kamado se convierte en cazador de demonios tras ver masacrada a su familia. Su hermana Nezuko, transformada en demonio, permanece a su lado mientras él busca la cura y al responsable de la tragedia.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1286/99889l.jpg',
      rating: 8.6,
      releaseYear: 2019,
      episodes: 44,
      status: 'En emisión',
      genres: ['Acción', 'Fantasía', 'Aventura'],
      platforms: ['Crunchyroll', 'Netflix'],
      studio: 'ufotable',
      trailerUrl: 'https://www.youtube.com/embed/VQGCKyvzIM4',
      tags: ['KnY', '鬼滅の刃', 'Guardianes de la Noche'],
    ),
    Anime(
      id: '004',
      title: 'Death Note',
      originalTitle: 'Desu Nōto',
      synopsis:
          'Light Yagami encuentra un cuaderno sobrenatural: todo nombre escrito en él provoca la muerte. Decide usarlo para purgar al mundo de criminales, pero el detective conocido como L inicia una cacería para atraparlo.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/9/9453l.jpg',
      rating: 8.6,
      releaseYear: 2006,
      episodes: 37,
      status: 'Finalizado',
      genres: ['Thriller', 'Misterio', 'Sobrenatural'],
      platforms: ['Netflix', 'Crunchyroll'],
      studio: 'Madhouse',
      trailerUrl: 'https://www.youtube.com/embed/NlJZ-YgAt-c',
      tags: ['DN', 'デスノート'],
    ),
    Anime(
      id: '005',
      title: 'Jujutsu Kaisen',
      originalTitle: 'Jujutsu Kaisen',
      synopsis:
          'Yuji Itadori ingiere un dedo maldito del demonio Ryomen Sukuna para salvar a sus compañeros. Incorporado a la Escuela Técnica de Jujutsu, debe aprender a controlar el poder del demonio antes de ser ejecutado.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1171/109222l.jpg',
      rating: 8.7,
      releaseYear: 2020,
      episodes: 47,
      status: 'En emisión',
      genres: ['Acción', 'Sobrenatural', 'Fantasía'],
      platforms: ['Crunchyroll'],
      studio: 'MAPPA',
      trailerUrl: 'https://www.youtube.com/embed/4A_X-Dvl0ws',
      tags: ['JJK', '呪術廻戦'],
    ),
    Anime(
      id: '006',
      title: 'Spy x Family',
      originalTitle: 'Spy x Family',
      synopsis:
          'El espía conocido como Loid Forger debe formar una familia ficticia para infiltrarse en una institución de élite. Sin saber que su hija adoptada es telepática y su esposa es asesina, viven aventuras cotidianas llenas de humor.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1441/122795l.jpg',
      rating: 8.6,
      releaseYear: 2022,
      episodes: 37,
      status: 'Finalizado',
      genres: ['Acción', 'Comedia', 'Slice of Life'],
      platforms: ['Crunchyroll', 'Netflix'],
      studio: 'Wit Studio / CloverWorks',
      trailerUrl: 'https://www.youtube.com/embed/qO1Y8XF5ELQ',
      tags: ['SpyFam', 'スパイファミリー'],
    ),
    Anime(
      id: '007',
      title: 'One Piece',
      originalTitle: 'Wan Pīsu',
      synopsis:
          'Monkey D. Luffy, un joven que obtuvo poderes elásticos al comer una Fruta del Diablo, zarpa al Gran Océano para encontrar el legendario tesoro One Piece y convertirse en el Rey de los Piratas.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/6/73245l.jpg',
      rating: 8.7,
      releaseYear: 1999,
      episodes: 1100,
      status: 'En emisión',
      genres: ['Acción', 'Aventura', 'Comedia'],
      platforms: ['Crunchyroll'],
      studio: 'Toei Animation',
      trailerUrl: 'https://www.youtube.com/embed/S8_YwFLCh4U',
      tags: ['OP', 'ワンピース'],
    ),
    Anime(
      id: '008',
      title: 'Chainsaw Man',
      originalTitle: 'Chensō Man',
      synopsis:
          'Denji, un joven cazador de demonios en deuda, funde su cuerpo con su demonio Pochita convirtiéndose en el Hombre Motosierra. Reclutado por el gobierno para cazar demonios, enfrenta enemigos más poderosos de lo esperado.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1806/126216l.jpg',
      rating: 8.6,
      releaseYear: 2022,
      episodes: 12,
      status: 'En emisión',
      genres: ['Acción', 'Sobrenatural', 'Thriller'],
      platforms: ['Crunchyroll'],
      studio: 'MAPPA',
      trailerUrl: 'https://www.youtube.com/embed/q6tHAMWdsMY',
      tags: ['CSM', 'チェンソーマン'],
    ),
    Anime(
      id: '009',
      title: 'Sword Art Online',
      originalTitle: 'Sōdo Āto Onrain',
      synopsis:
          'En 2022, diez mil jugadores quedan atrapados en el VRMMORPG Sword Art Online. La única salida es completar los 100 pisos del castillo Aincrad. Morir en el juego significa morir en la realidad.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/11/39717l.jpg',
      rating: 7.2,
      releaseYear: 2012,
      episodes: 25,
      status: 'Finalizado',
      genres: ['Acción', 'Aventura', 'Romance'],
      platforms: ['Netflix', 'Crunchyroll'],
      studio: 'A-1 Pictures',
      trailerUrl: 'https://www.youtube.com/embed/6ohYYalaRQA',
      tags: ['SAO', 'ソードアート・オンライン'],
    ),
    Anime(
      id: '010',
      title: 'Violet Evergarden',
      originalTitle: 'Vaioretto Evāgāden',
      synopsis:
          'Violet Evergarden, una ex-soldado que perdió los brazos en la guerra, comienza a trabajar como escritora de cartas automática. A través de sus clientes, aprende sobre las emociones humanas y el significado de las palabras "te amo".',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1795/95088l.jpg',
      rating: 8.7,
      releaseYear: 2018,
      episodes: 13,
      status: 'Finalizado',
      genres: ['Drama', 'Fantasía', 'Slice of Life'],
      platforms: ['Netflix'],
      studio: 'Kyoto Animation',
      trailerUrl: 'https://www.youtube.com/embed/0CJeDetA45Q',
      tags: ['VE', 'ヴァイオレット・エヴァーガーデン'],
    ),
    Anime(
      id: '011',
      title: 'Haikyuu!!',
      originalTitle: 'Haikyū!!',
      synopsis:
          'Shōyō Hinata, de baja estatura pero con gran talento atlético, ingresa al equipo de voleibol del Instituto Karasuno. Su rivalidad con el genio del saque Kageyama impulsa al equipo hacia el campeonato nacional.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/7/76014l.jpg',
      rating: 8.7,
      releaseYear: 2014,
      episodes: 85,
      status: 'Finalizado',
      genres: ['Deportes', 'Comedia', 'Drama'],
      platforms: ['Netflix', 'Crunchyroll'],
      studio: 'Production I.G',
      trailerUrl: 'https://www.youtube.com/embed/q6fNnhZFOE0',
      tags: ['HQ', 'ハイキュー'],
    ),
    Anime(
      id: '012',
      title: 'Neon Genesis Evangelion',
      originalTitle: 'Shin Seiki Evangerion',
      synopsis:
          'En el año 2015, la humanidad enfrenta a seres misteriosos llamados Ángeles. Shinji Ikari es reclutado por su padre para pilotar el mecha Evangelion Unidad 01. Una obra que redefine el género y explora la psique humana.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1314/108941l.jpg',
      rating: 8.5,
      releaseYear: 1995,
      episodes: 26,
      status: 'Finalizado',
      genres: ['Sci-Fi', 'Drama', 'Misterio'],
      platforms: ['Netflix'],
      studio: 'Gainax',
      trailerUrl: 'https://www.youtube.com/embed/9xqDkH-5Bxk',
      tags: ['EVA', 'NGE', '新世紀エヴァンゲリオン'],
    ),
    Anime(
      id: '013',
      title: 'Hunter x Hunter',
      originalTitle: 'Hantā × Hantā',
      synopsis:
          'Gon Freecss descubre que su padre ausente es un legendario Cazador. Decide convertirse en uno para encontrarlo. En el camino conoce a Killua, Kurapika y Leorio, con quienes enfrenta peligrosas aventuras.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/11/33657l.jpg',
      rating: 9.0,
      releaseYear: 2011,
      episodes: 148,
      status: 'Finalizado',
      genres: ['Acción', 'Aventura', 'Fantasía'],
      platforms: ['Crunchyroll', 'Netflix'],
      studio: 'Madhouse',
      trailerUrl: 'https://www.youtube.com/embed/D9iTQRB4XRk',
      tags: ['HxH', 'ハンター×ハンター'],
    ),
    Anime(
      id: '014',
      title: 'Your Lie in April',
      originalTitle: 'Shigatsu wa Kimi no Uso',
      synopsis:
          'Kousei Arima, un pianista prodigo que dejó de escuchar la música tras la muerte de su madre, se reencuentra con la música gracias a la excéntrica violinista Kaori Miyazono. Un romance sobre arte y pérdida.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/3/67177l.jpg',
      rating: 8.7,
      releaseYear: 2014,
      episodes: 22,
      status: 'Finalizado',
      genres: ['Romance', 'Drama', 'Slice of Life'],
      platforms: ['Netflix', 'Crunchyroll'],
      studio: 'A-1 Pictures',
      trailerUrl: 'https://www.youtube.com/embed/vdGE239OFiY',
      tags: ['KimiUso', '四月は君の嘘'],
    ),
    Anime(
      id: '015',
      title: 'Steins;Gate',
      originalTitle: 'Shutainzu Gēto',
      synopsis:
          'El autoproclamado científico loco Rintarō Okabe descubre accidentalmente cómo enviar mensajes al pasado usando un microondas. Lo que comienza como un experimento inocente lo arrastra a una conspiración de viajes en el tiempo.',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/5/73199l.jpg',
      rating: 9.1,
      releaseYear: 2011,
      episodes: 24,
      status: 'Finalizado',
      genres: ['Sci-Fi', 'Thriller', 'Drama'],
      platforms: ['Crunchyroll'],
      studio: 'White Fox',
      trailerUrl: 'https://www.youtube.com/embed/27OZc-ku6is',
      tags: ['S;G', 'シュタインズ・ゲート'],
    ),
  ];

  // ── Filtros auxiliares ────────────────────────────────────────

  static List<String> get allGenres {
    final genres = catalog.expand((a) => a.genres).toSet().toList()..sort();
    return genres;
  }

  static List<String> get allPlatforms {
    final platforms = catalog.expand((a) => a.platforms).toSet().toList()..sort();
    return platforms;
  }

  static List<int> get allYears {
    final years = catalog.map((a) => a.releaseYear).toSet().toList()..sort((a, b) => b.compareTo(a));
    return years;
  }

  static List<Anime> filterBy({
    String? genre,
    String? platform,
    int? year,
    String? query,
  }) {
    return catalog.where((anime) {
      final matchGenre    = genre    == null || anime.genres.contains(genre);
      final matchPlatform = platform == null || anime.platforms.contains(platform);
      final matchYear     = year     == null || anime.releaseYear == year;
      final matchQuery    = query    == null || query.isEmpty ||
          anime.title.toLowerCase().contains(query.toLowerCase()) ||
          anime.originalTitle.toLowerCase().contains(query.toLowerCase()) ||
          anime.tags.any((t) => t.toLowerCase().contains(query.toLowerCase()));
      return matchGenre && matchPlatform && matchYear && matchQuery;
    }).toList();
  }
}
