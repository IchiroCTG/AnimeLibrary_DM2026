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
    Object episodes,
    Object originalTitle,
    Object platforms,
    Object rating,
    Object title,
    Object year,
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
  String get aboutTitle => 'Acerca de';

  @override
  String aboutVersion(Object version, Object year) {
    return 'Version $version · $year';
  }

  @override
  String get aboutBadge => 'Maqueta Funcional · PDS1 2026';

  @override
  String get aboutPurpose => 'Proposito de la aplicación';

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
}
