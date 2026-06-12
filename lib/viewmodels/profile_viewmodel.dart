import 'package:flutter/material.dart';

enum ProfileState { initial, loading, loaded, error }

class ProfileViewModel extends ChangeNotifier {
  ProfileState _state  = ProfileState.initial;
  String _username     = 'OtakuUser_2026';
  String _email        = 'usuario@libraryanime.app';
  int    _savedCount   = 0;
  int    _watchingCount= 0;
  int    _completedCount= 0;
  int    _pendingCount = 0;
  bool   _notifications= true;
  String _language     = 'Español';
  String _subtitles    = 'Sub ES';

  // ── Getters ───────────────────────────────────────────────
  ProfileState get state          => _state;
  String get username             => _username;
  String get email                => _email;
  int    get savedCount           => _savedCount;
  int    get watchingCount        => _watchingCount;
  int    get completedCount       => _completedCount;
  int    get pendingCount         => _pendingCount;
  bool   get notifications        => _notifications;
  String get language             => _language;
  String get subtitles            => _subtitles;
  bool   get isLoading            => _state == ProfileState.loading;
  int    get totalAnimes          => _savedCount + _completedCount + _watchingCount + _pendingCount;

  // ── Cargar perfil ─────────────────────────────────────────
  Future<void> loadProfile() async {
    _state = ProfileState.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 200));

    _savedCount    = 24;
    _watchingCount = 5;
    _completedCount= 87;
    _pendingCount  = 38;
    _state         = ProfileState.loaded;

    notifyListeners();
  }

  // ── Configuración ─────────────────────────────────────────
  void toggleNotifications() {
    _notifications = !_notifications;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void setSubtitles(String sub) {
    _subtitles = sub;
    notifyListeners();
  }

  void updateUsername(String name) {
    _username = name;
    notifyListeners();
  }

  // ── Listas ────────────────────────────────────────────────
  void incrementSaved() {
    _savedCount++;
    notifyListeners();
  }

  void incrementWatching() {
    _watchingCount++;
    notifyListeners();
  }

  void incrementCompleted() {
    _completedCount++;
    notifyListeners();
  }
}