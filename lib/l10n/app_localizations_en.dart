// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Library Anime';

  @override
  String get tagline => 'Your unified anime catalog';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navProfile => 'Profile';

  @override
  String get navHelp => 'Help';

  @override
  String get homeTitle => 'ANIME';

  @override
  String get homeSubtitle => 'Library';

  @override
  String get homeCatalog => 'Full catalog';

  @override
  String homeResults(Object count) {
    return '$count result';
  }

  @override
  String homeResultsPlural(Object count) {
    return '$count results';
  }

  @override
  String get homeClear => 'Clear';

  @override
  String get homeNoResults => 'No results';

  @override
  String get homeNoResultsHint => 'Try a different filter or name';

  @override
  String get homeClearFilters => 'Clear filters';

  @override
  String get homeFilters => 'Filters';

  @override
  String get homeFilterGenre => 'Filter by Genre';

  @override
  String get homeFilterPlatform => 'Filter by Platform';

  @override
  String get homeApplyFilters => 'Apply filters';

  @override
  String get homeSearchHint => 'Search by name, genre, nickname...';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Name, nickname, Japanese...';

  @override
  String get searchPopular => 'Popular searches';

  @override
  String get searchAllGenres => 'All genres';

  @override
  String get searchNoResults => 'No results';

  @override
  String get searchNoResultsHint => 'Try a different name or genre';

  @override
  String get searchClear => 'Clear search';

  @override
  String get detailStatus => 'Status';

  @override
  String get detailGenres => 'Genres';

  @override
  String get detailAvailableOn => 'Available on';

  @override
  String get detailSynopsis => 'Synopsis';

  @override
  String get detailTechnical => 'Technical sheet';

  @override
  String get detailStudio => 'Studio';

  @override
  String get detailYear => 'Release year';

  @override
  String get detailEpisodes => 'Episodes';

  @override
  String get detailAltTitles => 'Alternative titles';

  @override
  String get detailScore => 'Community score';

  @override
  String get detailScoreSource => 'MyAnimeList score';

  @override
  String get detailScoreDesc => 'Based on global community ratings.';

  @override
  String get detailStory => 'Story';

  @override
  String get detailAnimation => 'Animation';

  @override
  String get detailCharacters => 'Characters';

  @override
  String get detailShare => 'Share this anime';

  @override
  String get detailSaved => 'Saved';

  @override
  String get detailWatching => 'Watching';

  @override
  String get detailCompleted => 'Completed';

  @override
  String get detailPending => 'Pending';

  @override
  String detailSavedMsg(Object title) {
    return '$title saved to your list';
  }

  @override
  String detailRemovedMsg(Object title) {
    return '$title removed from your list';
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
    return '🎌 $title ($originalTitle)\n⭐ $rating/10  ·  $episodes eps  ·  $year\n📺 Available on: $platforms\n\nFound on Library Anime 📱';
  }

  @override
  String get profileMember => 'Member since January 2026';

  @override
  String get profileInLists => 'In lists';

  @override
  String get profileCompleted => 'Completed';

  @override
  String get profileWatching => 'Watching';

  @override
  String get profileMyLists => 'My Lists';

  @override
  String get profileSaved => 'Saved';

  @override
  String get profileWatchingNow => 'Watching now';

  @override
  String get profilePending => 'Pending';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileLanguage => 'Preferred language';

  @override
  String get profileSubtitles => 'Default subtitles';

  @override
  String get profileEvaluate => 'Rate the app (Beta Testing)';

  @override
  String get profileAbout => 'About Library Anime';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileEditName => 'Edit name';

  @override
  String get profileEditCancel => 'Cancel';

  @override
  String get profileEditSave => 'Save';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpCenter => 'Help center';

  @override
  String get helpCenterDesc =>
      'Find answers to the most frequently asked questions.';

  @override
  String get helpFaq => 'Frequently asked questions';

  @override
  String get helpContact => 'Didn\'t find your answer?';

  @override
  String get helpContactDesc =>
      'Write to us directly and we\'ll get back to you shortly.';

  @override
  String get helpContactBtn => 'support@libraryanime.app';

  @override
  String get aboutTitle => 'About';

  @override
  String aboutVersion(Object version, Object year) {
    return 'Version $version · $year';
  }

  @override
  String get aboutBadge => 'Functional Mockup · PDS1 2026';

  @override
  String get aboutPurpose => 'App purpose';

  @override
  String get evalTitle => 'Beta Evaluation';

  @override
  String get evalBanner => 'Beta Testing';

  @override
  String get evalBannerDesc =>
      'Help us improve Library Anime with your feedback.';

  @override
  String get evalAverage => 'Current average';

  @override
  String get evalSend => 'Send by email';

  @override
  String get evalThanks => 'Thank you!';

  @override
  String get evalThanksDesc =>
      'Your evaluation was submitted successfully.\nYour feedback helps us improve.';

  @override
  String get evalBack => 'Go back';

  @override
  String get evalStarHint => 'Tap the stars to rate';

  @override
  String get evalEmailError =>
      'Could not open mail app. Install Gmail and try again.';

  @override
  String get listEmpty => 'No anime in this list';

  @override
  String get listEmptyHint =>
      'Explore the main catalog to add your favorite series.';

  @override
  String get splashTagline => 'Your unified anime catalog';
}
