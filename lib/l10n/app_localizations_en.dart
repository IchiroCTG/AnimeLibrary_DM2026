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
    Object title,
    Object originalTitle,
    Object rating,
    Object episodes,
    Object year,
    Object platforms,
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
  String get profileSyncTest => 'Test background sync';

  @override
  String get profileSyncSnackbar =>
      'Background sync scheduled. Check the notification in a few seconds.';

  @override
  String get syncNewAnimeSingle => 'New anime available';

  @override
  String syncNewAnimePlural(Object count) {
    return '$count new anime available';
  }

  @override
  String syncNewEpisodeSingle(Object title) {
    return 'New episode available for $title';
  }

  @override
  String syncNewEpisodePlural(Object count) {
    return '$count anime with new episodes';
  }

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
  String get faq1Q => 'What is Library Anime?';

  @override
  String get faq1A =>
      'Library Anime is a unified anime catalog. It lets you explore thousands of titles, see which streaming platforms they\'re available on, read synopses, filter by genre or year, and save your favorites to personal lists.';

  @override
  String get faq2Q => 'How do I search for a specific anime?';

  @override
  String get faq2A =>
      'Go to the \"Search\" tab in the bottom menu. You can search by name, alternative title (Japanese nickname or romaji), genre, animation studio, or release year. Results update in real time.';

  @override
  String get faq3Q => 'How do I know which platform streams an anime?';

  @override
  String get faq3A =>
      'On each anime\'s detail screen you\'ll find the \"Available on\" section, which shows icons for the streaming platforms where it\'s available (Crunchyroll, Netflix, HiDive, Amazon Prime, Disney+).';

  @override
  String get faq4Q => 'Can I save anime to lists?';

  @override
  String get faq4A =>
      'Yes. From any anime\'s detail screen you can add it to your lists: Saved, Watching, Completed or Pending. Access your lists from the Profile section.';

  @override
  String get faq5Q => 'Is the information up to date?';

  @override
  String get faq5A =>
      'Library Anime uses data from official APIs (MyAnimeList / AniList) that are updated periodically. New episodes and seasons are automatically reflected in the catalog.';

  @override
  String get faq6Q => 'Can I use the app offline?';

  @override
  String get faq6A =>
      'Search and the catalog require an internet connection. However, your personal lists and recently visited anime will be available in offline mode in a limited capacity.';

  @override
  String get faq7Q => 'How do I report an error or incorrect information?';

  @override
  String get faq7A =>
      'You can contact us at support@libraryanime.app or use the \"Report\" button on any anime\'s detail screen. We respond within a maximum of 48 business hours.';

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
  String get aboutPurposeText =>
      'Library Anime was born from a real need: anime information is fragmented across dozens of streaming platforms and external sites, forcing users to open multiple apps to find a single title.\n\nThis application centralizes the catalog, shows platform availability, integrates community reviews, and allows filtering by genre, year, and name — including alternative titles and Japanese nicknames — all from a single mobile interface.';

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

  @override
  String get statusAiring => 'Airing';

  @override
  String get statusFinished => 'Finished';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get airing => 'AIRING';
}
