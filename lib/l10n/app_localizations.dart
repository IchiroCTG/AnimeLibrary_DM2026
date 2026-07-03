import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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

  
  String get appName;

  
  String get tagline;

  
  String get navHome;

 
  String get navSearch;

  
  String get navProfile;

  
  String get navHelp;


  String get homeTitle;


  String get homeSubtitle;


  String get homeCatalog;


  String homeResults(Object count);


  String homeResultsPlural(Object count);

  
  String get homeClear;


  String get homeNoResults;

 
  String get homeNoResultsHint;

 
  String get homeClearFilters;

  
  String get homeFilters;

  
  String get homeFilterGenre;

  
  String get homeFilterPlatform;


  String get homeApplyFilters;


  String get homeSearchHint;


  String get searchTitle;


  String get searchHint;


  String get searchPopular;


  String get searchAllGenres;


  String get searchNoResults;


  String get searchNoResultsHint;


  String get searchClear;


  String get detailStatus;


  String get detailGenres;


  String get detailAvailableOn;


  String get detailSynopsis;


  String get detailTechnical;


  String get detailStudio;


  String get detailYear;


  String get detailEpisodes;

  
  String get detailAltTitles;

  
  String get detailScore;

  
  String get detailScoreSource;

  
  String get detailScoreDesc;

  
  String get detailStory;

  
  String get detailAnimation;

  
  String get detailCharacters;

  
  String get detailShare;

  
  String get detailSaved;

  
  String get detailWatching;

  
  String get detailCompleted;


  String get detailPending;


  String detailSavedMsg(Object title);


  String detailRemovedMsg(Object title);


  String detailShareText(
    Object title,
    Object originalTitle,
    Object rating,
    Object episodes,
    Object year,
    Object platforms,
  );


  String get profileMember;


  String get profileInLists;


  String get profileCompleted;


  String get profileWatching;


  String get profileMyLists;


  String get profileSaved;


  String get profileWatchingNow;


  String get profilePending;


  String get profileSettings;


  String get profileNotifications;

  
  String get profileLanguage;

  
  String get profileSubtitles;


  String get profileEvaluate;

  
  String get profileAbout;


  String get profileLogout;

 
  String get profileEditName;


  String get profileEditCancel;

  
  String get profileEditSave;


  String get helpTitle;

  
  String get helpCenter;


  String get helpCenterDesc;


  String get helpFaq;


  String get helpContact;


  String get helpContactDesc;

  String get helpContactBtn;


  String get faq1Q;


  String get faq1A;


  String get faq2Q;

  
  String get faq2A;

  
  String get faq3Q;

  
  String get faq3A;


  String get faq4Q;


 String get faq4A;


  String get faq5Q;


  String get faq5A;

 
  String get faq6Q;


  String get faq6A;


  String get faq7Q;


  String get faq7A;


  String get aboutTitle;


  String aboutVersion(Object version, Object year);


  String get aboutBadge;


  String get aboutPurpose;

 
  String get aboutPurposeText;


  String get evalTitle;


  String get evalBanner;


  String get evalBannerDesc;


  String get evalAverage;


  String get evalSend;


  String get evalThanks;


  String get evalThanksDesc;


  String get evalBack;


  String get evalStarHint;


  String get evalEmailError;


  String get listEmpty;


  String get listEmptyHint;


  String get splashTagline;


  String get statusAiring;



  String get statusFinished;


  String get statusUpcoming;


  String get airing;
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
