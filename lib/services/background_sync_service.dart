import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:convert';

import 'anilist_repository.dart';
import 'notification_service.dart';

const String kCatalogSyncTask = 'catalog_sync_task';


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == kCatalogSyncTask) {
      await BackgroundSyncService.syncCatalogAndNotify();
    }
    return Future.value(true);
  });
}
/// Textos de las notificaciones de sincronización.
///
/// [BackgroundSyncService] corre dentro de un isolate separado registrado
/// por WorkManager, por lo que NO tiene acceso a un [BuildContext] ni,
/// por lo tanto, a `AppLocalizations.of(context)`. Para respetar el idioma
/// elegido por el usuario igual, leemos directamente la preferencia
/// guardada en SharedPreferences (misma clave que usa LocaleViewModel)
/// y elegimos el texto correspondiente aquí.
class _SyncNotificationStrings {
  final bool isEnglish;
  const _SyncNotificationStrings(this.isEnglish);

  String newAnimeTitle(int count) {
    if (count == 1) {
      return isEnglish ? 'New anime available' : 'Nuevo anime disponible';
    }
    return isEnglish
        ? '$count new anime available'
        : '$count animes nuevos disponibles';
  }

  String newEpisodeTitle(int count, String firstTitle) {
    if (count == 1) {
      return isEnglish
          ? 'New episode available for $firstTitle'
          : 'Nuevo episodio disponible de $firstTitle';
    }
    return isEnglish
        ? '$count anime with new episodes'
        : '$count animes con nuevos episodios';
  }
}

class BackgroundSyncService {
  static const _keyKnownIds = 'sync:known_anime_ids';
  static const _keyEpisdoCounts = 'sync:episodes_counts';
  static const _keyListSaved = 'list:saved';
  static const _keyListWatching = 'list:watching';
  static const _keyLocale = 'app:locale';

  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
    );
  }

  static Future<void> registerPeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      kCatalogSyncTask,
      kCatalogSyncTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 5),
    );
  }

  static Future<void> cancelSync() async {
    await Workmanager().cancelByUniqueName(kCatalogSyncTask);
  }

  static Future<void> syncCatalogAndNotify() async {
    final prefs = await SharedPreferences.getInstance();
    final repo = AniListRepository();
    final localeCode = prefs.getString(_keyLocale) ?? 'es';
    final l10n = _SyncNotificationStrings(localeCode == 'en');

    final previousIds = (prefs.getStringList(_keyKnownIds) ?? []).toSet();

    final rawCounts = prefs.getString(_keyEpisdoCounts);
    final Map<String, dynamic> previousCounts = rawCounts == null ? {} : jsonDecode(rawCounts) as Map<String, dynamic>;
    
    final result = await repo.getCatalog(forceRefresh: true);
    final currentIds = result.animes.map((a) => a.id).toSet();
    final Map<String, int> currentCounts = {for (var a in result.animes) a.id: a.episodes};
    // Primera corrida: solo se guarda el estado base, no se notifica.
    if (previousIds.isEmpty) {
      await prefs.setStringList(_keyKnownIds, currentIds.toList());
      await prefs.setString(_keyEpisdoCounts, jsonEncode(currentCounts));
      return;
    }

    final newIds = currentIds.difference(previousIds);

    if (newIds.isNotEmpty) {
      final newTitles = result.animes
          .where((a) => newIds.contains(a.id))
          .map((a) => a.title)
          .take(3)
          .toList();

      await NotificationService.instance.init();
      await NotificationService.instance.showNewContentNotification(
        title: l10n.newAnimeTitle(newIds.length),
        body: newTitles.join(', '),
      );
    }

    final followedIds = {
      ..._readCommaList(prefs, _keyListSaved), 
      ..._readCommaList(prefs, _keyListWatching)
    }; 

    final animesConNuevoEpisodio = result.animes.where((a){
      if (newIds.contains(a.id))return false; // ya se notificó como nuevo anime
      if(!followedIds.contains(a.id)) return false; // no es un anime seguido
      final _previousCount = previousCounts[a.id] ?? 0;
      return _previousCount !=null && a.episodes > _previousCount;
    }).toList();

    if(animesConNuevoEpisodio.isNotEmpty){
      final titulos = animesConNuevoEpisodio.map((a) => a.title).take(3).toList();
      await NotificationService.instance.init();
      await NotificationService.instance.showNewContentNotification(
        title: l10n.newEpisodeTitle(
          animesConNuevoEpisodio.length,
          titulos.first,
        ),
        body: titulos.join(', ')
      );
        
    }

    await prefs.setStringList(_keyKnownIds, currentIds.toList());
    await prefs.setString(_keyEpisdoCounts, jsonEncode(currentCounts));
  }

  static Future<void> runOnceForTesting() async {
    await Workmanager().registerOneOffTask(
      '${kCatalogSyncTask}_debug_${DateTime.now().millisecondsSinceEpoch}',
      kCatalogSyncTask,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  static Set<String> _readCommaList(SharedPreferences prefs, String key) {
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    return raw.split(',').toSet();
  }
}
