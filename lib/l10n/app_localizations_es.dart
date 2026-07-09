// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Library Anime';

  @override
  String get tagline => 'Tu catálogo unificado de anime';

  @override
  String get navHome => 'Inicio';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navHelp => 'Ayuda';

  @override
  String get homeTitle => 'ANIME';

  @override
  String get homeSubtitle => 'Library';

  @override
  String get homeCatalog => 'Catálogo completo';

  @override
  String homeResults(Object count) {
    return '$count resultado';
  }

  @override
  String homeResultsPlural(Object count) {
    return '$count resultados';
  }

  @override
  String get homeClear => 'Limpiar';

  @override
  String get homeNoResults => 'Sin resultados';

  @override
  String get homeNoResultsHint => 'Intenta con otro filtro o nombre';

  @override
  String get homeClearFilters => 'Limpiar filtros';

  @override
  String get homeFilters => 'Filtros';

  @override
  String get homeFilterGenre => 'Filtrar por Género';

  @override
  String get homeFilterPlatform => 'Filtrar por Plataforma';

  @override
  String get homeApplyFilters => 'Aplicar filtros';

  @override
  String get homeSearchHint => 'Buscar por nombre, género, apodo...';

  @override
  String get searchTitle => 'Buscar';

  @override
  String get searchHint => 'Nombre, apodo, japonés...';

  @override
  String get searchPopular => 'Búsquedas populares';

  @override
  String get searchAllGenres => 'Todos los géneros';

  @override
  String get searchNoResults => 'Sin resultados';

  @override
  String get searchNoResultsHint => 'Intenta con otro nombre o género';

  @override
  String get searchClear => 'Limpiar búsqueda';

  @override
  String get detailStatus => 'Estado';

  @override
  String get detailGenres => 'Géneros';

  @override
  String get detailAvailableOn => 'Disponible en';

  @override
  String get detailSynopsis => 'Sinopsis';

  @override
  String get detailTechnical => 'Ficha técnica';

  @override
  String get detailStudio => 'Estudio';

  @override
  String get detailYear => 'Año de estreno';

  @override
  String get detailEpisodes => 'Episodios';

  @override
  String get detailAltTitles => 'Títulos alternativos';

  @override
  String get detailScore => 'Puntuación de la comunidad';

  @override
  String get detailScoreSource => 'Puntuación de MyAnimeList';

  @override
  String get detailScoreDesc =>
      'Basado en valoraciones de la comunidad global.';

  @override
  String get detailStory => 'Historia';

  @override
  String get detailAnimation => 'Animación';

  @override
  String get detailCharacters => 'Personajes';

  @override
  String get detailShare => 'Compartir este anime';

  @override
  String get detailSaved => 'Guardado';

  @override
  String get detailWatching => 'Viendo';

  @override
  String get detailCompleted => 'Visto';

  @override
  String get detailPending => 'Pendiente';

  @override
  String detailSavedMsg(Object title) {
    return '$title guardado en tu lista';
  }

  @override
  String detailRemovedMsg(Object title) {
    return '$title eliminado de tu lista';
  }

  @override
  String detailShareText(
    Object title,
    Object originalTitle,
    Object rating,
    Object episodes,
    Object year,
    Object platforms,
  ) {
    return '🎌 $title ($originalTitle)\n⭐ $rating/10  ·  $episodes eps  ·  $year\n📺 Disponible en: $platforms\n\nEncontrado en Library Anime 📱';
  }

  @override
  String get profileMember => 'Miembro desde enero 2026';

  @override
  String get profileInLists => 'En listas';

  @override
  String get profileCompleted => 'Completados';

  @override
  String get profileWatching => 'Viendo';

  @override
  String get profileMyLists => 'Mis Listas';

  @override
  String get profileSaved => 'Guardados';

  @override
  String get profileWatchingNow => 'Viendo ahora';

  @override
  String get profilePending => 'Pendientes';

  @override
  String get profileSettings => 'Configuración';

  @override
  String get profileNotifications => 'Notificaciones';

  @override
  String get profileSyncTest => 'Probar sincronización en segundo plano';

  @override
  String get profileSyncSnackbar =>
      'Sincronización en segundo plano programada. Revisa la notificación en unos segundos.';

  @override
  String get syncNewAnimeSingle => 'Nuevo anime disponible';

  @override
  String syncNewAnimePlural(Object count) {
    return '$count animes nuevos disponibles';
  }

  @override
  String syncNewEpisodeSingle(Object title) {
    return 'Nuevo episodio disponible de $title';
  }

  @override
  String syncNewEpisodePlural(Object count) {
    return '$count animes con nuevos episodios';
  }

  @override
  String get profileLanguage => 'Idioma preferido';

  @override
  String get profileSubtitles => 'Subtítulos por defecto';

  @override
  String get profileEvaluate => 'Evaluar la app (Beta Testing)';

  @override
  String get profileAbout => 'Acerca de Library Anime';

  @override
  String get profileLogout => 'Cerrar sesión';

  @override
  String get profileEditName => 'Editar nombre';

  @override
  String get profileEditCancel => 'Cancelar';

  @override
  String get profileEditSave => 'Guardar';

  @override
  String get helpTitle => 'Ayuda';

  @override
  String get helpCenter => 'Centro de ayuda';

  @override
  String get helpCenterDesc =>
      'Encuentra respuestas a las preguntas más frecuentes.';

  @override
  String get helpFaq => 'Preguntas frecuentes';

  @override
  String get helpContact => '¿No encontraste tu respuesta?';

  @override
  String get helpContactDesc =>
      'Escríbenos directamente y te responderemos a la brevedad.';

  @override
  String get helpContactBtn => 'support@libraryanime.app';

  @override
  String get faq1Q => '¿Qué es Library Anime?';

  @override
  String get faq1A =>
      'Library Anime es un catálogo unificado de anime. Te permite explorar miles de títulos, ver en qué plataformas de streaming están disponibles, leer sinopsis, filtrar por género o año, y guardar tus favoritos en listas personalizadas.';

  @override
  String get faq2Q => '¿Cómo busco un anime específico?';

  @override
  String get faq2A =>
      'Ve a la pestaña \"Buscar\" en el menú inferior. Puedes buscar por nombre, título alternativo (apodo en japonés o romaji), género, estudio de animación o año de emisión. Los resultados se actualizan en tiempo real.';

  @override
  String get faq3Q => '¿Cómo sé en qué plataforma puedo ver un anime?';

  @override
  String get faq3A =>
      'En la pantalla de detalle de cada anime encontrarás la sección \"Disponible en\", que muestra los íconos de las plataformas de streaming donde está disponible (Crunchyroll, Netflix, HiDive, Amazon Prime, Disney+).';

  @override
  String get faq4Q => '¿Puedo guardar animes en listas?';

  @override
  String get faq4A =>
      'Sí. Desde la pantalla de detalle de cualquier anime puedes agregarlo a tus listas: Guardados, Viendo ahora, Completados o Pendientes. Accede a tus listas desde la sección Perfil.';

  @override
  String get faq5Q => '¿La información está actualizada?';

  @override
  String get faq5A =>
      'Library Anime utiliza datos de APIs oficiales (MyAnimeList / AniList) que se actualizan periódicamente. Los nuevos episodios y temporadas se reflejan automáticamente en el catálogo.';

  @override
  String get faq6Q => '¿Puedo usar la app sin conexión?';

  @override
  String get faq6A =>
      'La búsqueda y el catálogo requieren conexión a internet. Sin embargo, tus listas personales y los animes que hayas visitado recientemente estarán disponibles en modo offline de forma limitada.';

  @override
  String get faq7Q => '¿Cómo reporto un error o información incorrecta?';

  @override
  String get faq7A =>
      'Puedes contactarnos a través de support@libraryanime.app o usar el botón \"Reportar\" dentro de la pantalla de detalle de cualquier anime. Respondemos en un plazo máximo de 48 horas hábiles.';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String aboutVersion(Object version, Object year) {
    return 'Version $version · $year';
  }

  @override
  String get aboutBadge => 'Maqueta Funcional · PDS1 2026';

  @override
  String get aboutPurpose => 'Propósito de la aplicación';

  @override
  String get aboutPurposeText =>
      'Library Anime nace de una necesidad real: la información sobre el anime está fragmentada en decenas de plataformas de streaming y sitios externos, obligando al usuario a abrir múltiples apps para encontrar un solo título.\n\nEsta aplicación centraliza el catálogo, indica la disponibilidad por plataforma, integra reseñas de la comunidad y permite filtrar por género, año y nombre —incluyendo títulos alternativos y apodos en japonés— todo desde una sola interfaz móvil.';

  @override
  String get evalTitle => 'Evaluación Beta';

  @override
  String get evalBanner => 'Beta Testing';

  @override
  String get evalBannerDesc =>
      'Ayúdanos a mejorar Library Anime con tu opinión.';

  @override
  String get evalAverage => 'Promedio actual';

  @override
  String get evalSend => 'Enviar por email';

  @override
  String get evalThanks => '¡Gracias!';

  @override
  String get evalThanksDesc =>
      'Tu evaluación fue enviada correctamente.\nTu feedback nos ayuda a mejorar.';

  @override
  String get evalBack => 'Volver';

  @override
  String get evalStarHint => 'Toca las estrellas para calificar';

  @override
  String get evalEmailError =>
      'No se pudo abrir la app de correo. Instala Gmail e inténtalo de nuevo.';

  @override
  String get listEmpty => 'No hay animes en esta lista';

  @override
  String get listEmptyHint =>
      'Explora el catálogo principal para añadir tus series favoritas.';

  @override
  String get splashTagline => 'Tu catálogo unificado de anime';

  @override
  String get statusAiring => 'En Emisión';

  @override
  String get statusFinished => 'Finalizado';

  @override
  String get statusUpcoming => 'Próximamente';

  @override
  String get airing => 'EN EMISIÓN';
}
