import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/anime.dart';
import '../services/firestore_service.dart';

/// Persiste las listas del usuario usando shared_preferences.
/// Además sincroniza las listas del usuario autenticado en Firestore.
/// Compatible con catálogo dinámico de AniList:
/// guarda los IDs y recibe el catálogo actual para resolver los animes.
class FavoritesViewModel extends ChangeNotifier {
  static const _keySaved     = 'list:saved';
  static const _keyWatching  = 'list:watching';
  static const _keyCompleted = 'list:completed';
  static const _keyPending   = 'list:pending';

  final Set<String> _saved     = {};
  final Set<String> _watching  = {};
  final Set<String> _completed = {};
  final Set<String> _pending   = {};

  final _firestore = FirestoreService();
  final _auth = FirebaseAuth.instance;

  // Catálogo actual — se actualiza desde AnimeViewModel
  List<Anime> _catalog = [];

  bool _loaded = false;

  // ── Getters ───────────────────────────────────────────────
  bool get isLoaded => _loaded;

  bool isSaved(String id)     => _saved.contains(id);
  bool isWatching(String id)  => _watching.contains(id);
  bool isCompleted(String id) => _completed.contains(id);
  bool isPending(String id)   => _pending.contains(id);

  int get savedCount     => _saved.length;
  int get watchingCount  => _watching.length;
  int get completedCount => _completed.length;
  int get pendingCount   => _pending.length;

  List<Anime> get savedAnimes     => _idsToAnimes(_saved);
  List<Anime> get watchingAnimes  => _idsToAnimes(_watching);
  List<Anime> get completedAnimes => _idsToAnimes(_completed);
  List<Anime> get pendingAnimes   => _idsToAnimes(_pending);

  // ── Actualizar catálogo desde AnimeViewModel ──────────────
  /// Llamar desde AnimeViewModel después de cargar el catálogo.
  void updateCatalog(List<Anime> catalog) {
    _catalog = catalog;
    notifyListeners();
  }

  // ── Cargar desde disco y Firestore ────────────────────────
  Future<void> load() async {
    if (_loaded) return;

    final prefs = await SharedPreferences.getInstance();
    _saved     .addAll(_read(prefs, _keySaved));
    _watching  .addAll(_read(prefs, _keyWatching));
    _completed .addAll(_read(prefs, _keyCompleted));
    _pending   .addAll(_read(prefs, _keyPending));

    if (_auth.currentUser != null) {
      await _firestore.loadFavoritesInto(
        saved: _saved,
        watching: _watching,
        completed: _completed,
        pending: _pending,
      );
    }

    _loaded = true;
    notifyListeners();
  }

  // ── Toggle helpers ────────────────────────────────────────
  Future<void> toggleSaved(String id) async {
    _toggle(_saved, id);
    await _persist(_keySaved, _saved);
    await _syncFirestore(id, 'saved', _saved.contains(id));
    notifyListeners();
  }

  Future<void> toggleWatching(String id) async {
    _toggle(_watching, id);
    await _persist(_keyWatching, _watching);
    await _syncFirestore(id, 'watching', _watching.contains(id));
    notifyListeners();
  }

  Future<void> toggleCompleted(String id) async {
    _toggle(_completed, id);
    await _persist(_keyCompleted, _completed);
    await _syncFirestore(id, 'completed', _completed.contains(id));
    notifyListeners();
  }

  Future<void> togglePending(String id) async {
    _toggle(_pending, id);
    await _persist(_keyPending, _pending);
    await _syncFirestore(id, 'pending', _pending.contains(id));
    notifyListeners();
  }

  // ── Privados ──────────────────────────────────────────────
  void _toggle(Set<String> set, String id) {
    if (set.contains(id)) {
      set.remove(id);
    } else {
      set.add(id);
    }
  }

  List<String> _read(SharedPreferences prefs, String key) {
    final raw = prefs.getString(key) ?? '';
    return raw.isEmpty ? [] : raw.split(',');
  }

  Future<void> _persist(String key, Set<String> set) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, set.join(','));
  }

  Future<void> _syncFirestore(String id, String list, bool enabled) async {
    if (_auth.currentUser == null) return;

    if (enabled) {
      await _firestore.addFavorite(id, list);
    } else {
      await _firestore.removeFavorite(id, list);
    }
  }

  /// Resuelve IDs contra el catálogo dinámico actual.
  /// Si el catálogo aún no cargó, retorna lista vacía.
  List<Anime> _idsToAnimes(Set<String> ids) {
    if (_catalog.isEmpty) return [];
    return _catalog.where((a) => ids.contains(a.id)).toList();
  }
}