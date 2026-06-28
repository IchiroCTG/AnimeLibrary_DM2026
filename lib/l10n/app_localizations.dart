import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Library Anime'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In es, this message translates to:
  /// **'Tu catálogo unificado de anime'**
  String get tagline;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get navSearch;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @navHelp.
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get navHelp;

  /// No description provided for @homeTitle.
  ///
  /// In es, this message translates to:
  /// **'ANIME'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Library'**
  String get homeSubtitle;

  /// No description provided for @homeCatalog.
  ///
  /// In es, this message translates to:
  /// **'Catálogo completo'**
  String get homeCatalog;

  /// No description provided for @homeResults.
  ///
  /// In es, this message translates to:
  /// **'{count} resultado'**
  String homeResults(Object count);

  /// No description provided for @homeResultsPlural.
  ///
  /// In es, this message translates to:
  /// **'{count} resultados'**
  String homeResultsPlural(Object count);

  /// No description provided for @homeClear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get homeClear;

  /// No description provided for @homeNoResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get homeNoResults;

  /// No description provided for @homeNoResultsHint.
  ///
  /// In es, this message translates to:
  /// **'Intenta con otro filtro o nombre'**
  String get homeNoResultsHint;

  /// No description provided for @homeClearFilters.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get homeClearFilters;

  /// No description provided for @homeFilters.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get homeFilters;

  /// No description provided for @homeFilterGenre.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por Género'**
  String get homeFilterGenre;

  /// No description provided for @homeFilterPlatform.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por Plataforma'**
  String get homeFilterPlatform;

  /// No description provided for @homeApplyFilters.
  ///
  /// In es, this message translates to:
  /// **'Aplicar filtros'**
  String get homeApplyFilters;

  /// No description provided for @homeSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre, género, apodo...'**
  String get homeSearchHint;

  /// No description provided for @searchTitle.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre, apodo, japonés...'**
  String get searchHint;

  /// No description provided for @searchPopular.
  ///
  /// In es, this message translates to:
  /// **'Búsquedas populares'**
  String get searchPopular;

  /// No description provided for @searchAllGenres.
  ///
  /// In es, this message translates to:
  /// **'Todos los géneros'**
  String get searchAllGenres;

  /// No description provided for @searchNoResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsHint.
  ///
  /// In es, this message translates to:
  /// **'Intenta con otro nombre o género'**
  String get searchNoResultsHint;

  /// No description provided for @searchClear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar búsqueda'**
  String get searchClear;

  /// No description provided for @detailStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get detailStatus;

  /// No description provided for @detailGenres.
  ///
  /// In es, this message translates to:
  /// **'Géneros'**
  String get detailGenres;

  /// No description provided for @detailAvailableOn.
  ///
  /// In es, this message translates to:
  /// **'Disponible en'**
  String get detailAvailableOn;

  /// No description provided for @detailSynopsis.
  ///
  /// In es, this message translates to:
  /// **'Sinopsis'**
  String get detailSynopsis;

  /// No description provided for @detailTechnical.
  ///
  /// In es, this message translates to:
  /// **'Ficha técnica'**
  String get detailTechnical;

  /// No description provided for @detailStudio.
  ///
  /// In es, this message translates to:
  /// **'Estudio'**
  String get detailStudio;

  /// No description provided for @detailYear.
  ///
  /// In es, this message translates to:
  /// **'Año de estreno'**
  String get detailYear;

  /// No description provided for @detailEpisodes.
  ///
  /// In es, this message translates to:
  /// **'Episodios'**
  String get detailEpisodes;

  /// No description provided for @detailAltTitles.
  ///
  /// In es, this message translates to:
  /// **'Títulos alternativos'**
  String get detailAltTitles;

  /// No description provided for @detailScore.
  ///
  /// In es, this message translates to:
  /// **'Puntuación de la comunidad'**
  String get detailScore;

  /// No description provided for @detailScoreSource.
  ///
  /// In es, this message translates to:
  /// **'Puntuación de MyAnimeList'**
  String get detailScoreSource;

  /// No description provided for @detailScoreDesc.
  ///
  /// In es, this message translates to:
  /// **'Basado en valoraciones de la comunidad global.'**
  String get detailScoreDesc;

  /// No description provided for @detailStory.
  ///
  /// In es, this message translates to:
  /// **'Historia'**
  String get detailStory;

  /// No description provided for @detailAnimation.
  ///
  /// In es, this message translates to:
  /// **'Animación'**
  String get detailAnimation;

  /// No description provided for @detailCharacters.
  ///
  /// In es, this message translates to:
  /// **'Personajes'**
  String get detailCharacters;

  /// No description provided for @detailShare.
  ///
  /// In es, this message translates to:
  /// **'Compartir este anime'**
  String get detailShare;

  /// No description provided for @detailSaved.
  ///
  /// In es, this message translates to:
  /// **'Guardado'**
  String get detailSaved;

  /// No description provided for @detailWatching.
  ///
  /// In es, this message translates to:
  /// **'Viendo'**
  String get detailWatching;

  /// No description provided for @detailCompleted.
  ///
  /// In es, this message translates to:
  /// **'Visto'**
  String get detailCompleted;

  /// No description provided for @detailPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get detailPending;

  /// No description provided for @detailSavedMsg.
  ///
  /// In es, this message translates to:
  /// **'{title} guardado en tu lista'**
  String detailSavedMsg(Object title);

  /// No description provided for @detailRemovedMsg.
  ///
  /// In es, this message translates to:
  /// **'{title} eliminado de tu lista'**
  String detailRemovedMsg(Object title);

  /// No description provided for @detailShareText.
  ///
  /// In es, this message translates to:
  /// **'🎌 {title} ({originalTitle})\n⭐ {rating}/10  ·  {episodes} eps  ·  {year}\n📺 Disponible en: {platforms}\n\nEncontrado en Library Anime 📱'**
  String detailShareText(
    Object episodes,
    Object originalTitle,
    Object platforms,
    Object rating,
    Object title,
    Object year,
  );

  /// No description provided for @profileMember.
  ///
  /// In es, this message translates to:
  /// **'Miembro desde enero 2026'**
  String get profileMember;

  /// No description provided for @profileInLists.
  ///
  /// In es, this message translates to:
  /// **'En listas'**
  String get profileInLists;

  /// No description provided for @profileCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completados'**
  String get profileCompleted;

  /// No description provided for @profileWatching.
  ///
  /// In es, this message translates to:
  /// **'Viendo'**
  String get profileWatching;

  /// No description provided for @profileMyLists.
  ///
  /// In es, this message translates to:
  /// **'Mis Listas'**
  String get profileMyLists;

  /// No description provided for @profileSaved.
  ///
  /// In es, this message translates to:
  /// **'Guardados'**
  String get profileSaved;

  /// No description provided for @profileWatchingNow.
  ///
  /// In es, this message translates to:
  /// **'Viendo ahora'**
  String get profileWatchingNow;

  /// No description provided for @profilePending.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get profilePending;

  /// No description provided for @profileSettings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get profileSettings;

  /// No description provided for @profileNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get profileNotifications;

  /// No description provided for @profileLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma preferido'**
  String get profileLanguage;

  /// No description provided for @profileSubtitles.
  ///
  /// In es, this message translates to:
  /// **'Subtítulos por defecto'**
  String get profileSubtitles;

  /// No description provided for @profileEvaluate.
  ///
  /// In es, this message translates to:
  /// **'Evaluar la app (Beta Testing)'**
  String get profileEvaluate;

  /// No description provided for @profileAbout.
  ///
  /// In es, this message translates to:
  /// **'Acerca de Library Anime'**
  String get profileAbout;

  /// No description provided for @profileLogout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get profileLogout;

  /// No description provided for @profileEditName.
  ///
  /// In es, this message translates to:
  /// **'Editar nombre'**
  String get profileEditName;

  /// No description provided for @profileEditCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get profileEditCancel;

  /// No description provided for @profileEditSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get profileEditSave;

  /// No description provided for @helpTitle.
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get helpTitle;

  /// No description provided for @helpCenter.
  ///
  /// In es, this message translates to:
  /// **'Centro de ayuda'**
  String get helpCenter;

  /// No description provided for @helpCenterDesc.
  ///
  /// In es, this message translates to:
  /// **'Encuentra respuestas a las preguntas más frecuentes.'**
  String get helpCenterDesc;

  /// No description provided for @helpFaq.
  ///
  /// In es, this message translates to:
  /// **'Preguntas frecuentes'**
  String get helpFaq;

  /// No description provided for @helpContact.
  ///
  /// In es, this message translates to:
  /// **'¿No encontraste tu respuesta?'**
  String get helpContact;

  /// No description provided for @helpContactDesc.
  ///
  /// In es, this message translates to:
  /// **'Escríbenos directamente y te responderemos a la brevedad.'**
  String get helpContactDesc;

  /// No description provided for @helpContactBtn.
  ///
  /// In es, this message translates to:
  /// **'support@libraryanime.app'**
  String get helpContactBtn;

  /// No description provided for @aboutTitle.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In es, this message translates to:
  /// **'Version {version} · {year}'**
  String aboutVersion(Object version, Object year);

  /// No description provided for @aboutBadge.
  ///
  /// In es, this message translates to:
  /// **'Maqueta Funcional · PDS1 2026'**
  String get aboutBadge;

  /// No description provided for @aboutPurpose.
  ///
  /// In es, this message translates to:
  /// **'Proposito de la aplicación'**
  String get aboutPurpose;

  /// No description provided for @evalTitle.
  ///
  /// In es, this message translates to:
  /// **'Evaluación Beta'**
  String get evalTitle;

  /// No description provided for @evalBanner.
  ///
  /// In es, this message translates to:
  /// **'Beta Testing'**
  String get evalBanner;

  /// No description provided for @evalBannerDesc.
  ///
  /// In es, this message translates to:
  /// **'Ayúdanos a mejorar Library Anime con tu opinión.'**
  String get evalBannerDesc;

  /// No description provided for @evalAverage.
  ///
  /// In es, this message translates to:
  /// **'Promedio actual'**
  String get evalAverage;

  /// No description provided for @evalSend.
  ///
  /// In es, this message translates to:
  /// **'Enviar por email'**
  String get evalSend;

  /// No description provided for @evalThanks.
  ///
  /// In es, this message translates to:
  /// **'¡Gracias!'**
  String get evalThanks;

  /// No description provided for @evalThanksDesc.
  ///
  /// In es, this message translates to:
  /// **'Tu evaluación fue enviada correctamente.\nTu feedback nos ayuda a mejorar.'**
  String get evalThanksDesc;

  /// No description provided for @evalBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get evalBack;

  /// No description provided for @evalStarHint.
  ///
  /// In es, this message translates to:
  /// **'Toca las estrellas para calificar'**
  String get evalStarHint;

  /// No description provided for @evalEmailError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir la app de correo. Instala Gmail e inténtalo de nuevo.'**
  String get evalEmailError;

  /// No description provided for @listEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay animes en esta lista'**
  String get listEmpty;

  /// No description provided for @listEmptyHint.
  ///
  /// In es, this message translates to:
  /// **'Explora el catálogo principal para añadir tus series favoritas.'**
  String get listEmptyHint;

  /// No description provided for @splashTagline.
  ///
  /// In es, this message translates to:
  /// **'Tu catálogo unificado de anime'**
  String get splashTagline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
