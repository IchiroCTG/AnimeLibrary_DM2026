import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'anilist_repository.dart';
import 'notification_service.dart';

/// Nombre único de la tarea periódica registrada en WorkManager.
const String kCatalogSyncTask = 'catalog_sync_task';

/// Punto de entrada requerido por WorkManager.
///
/// IMPORTANTE: esta función corre en un ISOLATE separado del isolate
/// principal de la app (incluso con la app cerrada). Por eso:
///  - Debe ser una función de nivel superior (top-level) o estática.
///  - Debe llevar la anotación @pragma('vm:entry-point') para que el
///    compilador AOT no la elimine en modo release.
///  - No puede acceder a estado en memoria de la UI (Providers, etc.),
///    solo a fuentes externas: red y almacenamiento local.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == kCatalogSyncTask) {
      await BackgroundSyncService.syncCatalogAndNotify();
    }
    return Future.value(true);
  });
}

/// Orquesta la sincronización periódica del catálogo en segundo plano.
///
/// Estrategia (Background Task en vez de Push real):
///  1. WorkManager despierta este isolate cada ~15 min (mínimo permitido
///     por Android para tareas periódicas).
///  2. Se hace un forceRefresh contra la API REST de AniList.
///  3. Se compara el set de IDs contra la última copia cacheada localmente
///     (shared_preferences, la misma caché offline-first que ya usa
///     AniListRepository).
///  4. Si hay IDs nuevos -> se dispara una notificación local.
///  5. La nueva copia queda guardada como caché válida para la próxima
///     apertura de la app (esto también alimenta la estrategia
///     Offline-First del indicador 9).
class BackgroundSyncService {
  static const _keyKnownIds = 'sync:known_anime_ids';

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

    final previousIds = (prefs.getStringList(_keyKnownIds) ?? []).toSet();

    final result = await repo.getCatalog(forceRefresh: true);
    final currentIds = result.animes.map((a) => a.id).toSet();

    // Primera corrida: solo se guarda el estado base, no se notifica.
    if (previousIds.isEmpty) {
      await prefs.setStringList(_keyKnownIds, currentIds.toList());
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
        title: newIds.length == 1
            ? 'Nuevo anime disponible'
            : '${newIds.length} animes nuevos disponibles',
        body: newTitles.join(', '),
      );
    }

    await prefs.setStringList(_keyKnownIds, currentIds.toList());
  }

  /// Utilidad de depuración: fuerza una ejecución inmediata (one-off) sin
  /// esperar los 15 minutos del ciclo periódico. Útil para probar en la
  /// exposición sin tener que esperar a que WorkManager dispare solo.
  static Future<void> runOnceForTesting() async {
    await Workmanager().registerOneOffTask(
      '${kCatalogSyncTask}_debug_${DateTime.now().millisecondsSinceEpoch}',
      kCatalogSyncTask,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}
