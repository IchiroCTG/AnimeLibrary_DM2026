import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/background_sync_service.dart';
import '../services/firestore_service.dart';

enum ProfileState { initial, loading, loaded, error }

class ProfileViewModel extends ChangeNotifier {
  // Claves para persistencia en SharedPreferences
  static const _keyUsername      = 'profile:username';
  static const _keyImagePath     = 'profile:image_path';
  static const _keyNotifications = 'profile:notifications';
  static const _keyLanguage      = 'profile:language';
  static const _keySubtitles     = 'profile:subtitles';

  final _auth = FirebaseAuth.instance;
  final _firestore = FirestoreService();

  ProfileState _state  = ProfileState.initial;
  String _username     = 'OtakuUser_2026';
  String? _profileImagePath;

  bool   _notifications = true;
  String _language      = 'Español';
  String _subtitles     = 'Sub ES';

  // ── Getters ───────────────────────────────────────────────
  ProfileState get state        => _state;
  String get email             => _auth.currentUser?.email ?? '';
  String get username          => _username;
  String? get profileImagePath => _profileImagePath;
  bool get notifications       => _notifications;
  String get language          => _language;
  String get subtitles         => _subtitles;
  bool get isLoading           => _state == ProfileState.loading;

  final ImagePicker _picker = ImagePicker();

  // ── Cargar perfil (configuración local) ───────────────────
  Future<void> loadProfile() async {
    _state = ProfileState.loading;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      _username         = prefs.getString(_keyUsername) ?? _username;
      _profileImagePath = prefs.getString(_keyImagePath);
      _notifications    = prefs.getBool(_keyNotifications) ?? true;
      _language         = prefs.getString(_keyLanguage) ?? 'Español';
      _subtitles        = prefs.getString(_keySubtitles) ?? 'Sub ES';

      // Si hay usuario autenticado, Firestore es la fuente de verdad:
      // se usa para sincronizar el perfil entre dispositivos. Si falla
      // (sin conexión, etc.) simplemente seguimos con lo cacheado local.
      if (_auth.currentUser != null) {
        try {
          final remote = await _firestore.getProfile();
          if (remote != null) {
            _username      = remote['username'] as String? ?? _username;
            _notifications = remote['notifications'] as bool? ?? _notifications;
            _language      = remote['language'] as String? ?? _language;
            _subtitles     = remote['subtitles'] as String? ?? _subtitles;

            await prefs.setString(_keyUsername, _username);
            await prefs.setBool(_keyNotifications, _notifications);
            await prefs.setString(_keyLanguage, _language);
            await prefs.setString(_keySubtitles, _subtitles);
          }
        } catch (e) {
          debugPrint('No se pudo sincronizar el perfil con Firestore: $e');
        }
      }

      _state = ProfileState.loaded;
    } catch (_) {
      _state = ProfileState.error;
    }

    notifyListeners();
  }

  // ── Configuración Persistente ─────────────────────────────

  Future<void> updateUsername(String name) async {
    _username = name;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, name);
    await _syncToFirestore({'username': name});
  }

  Future<void> toggleNotifications() async {
    _notifications = !_notifications;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, _notifications);
    await _syncToFirestore({'notifications': _notifications});

    if (_notifications) {
      await BackgroundSyncService.registerPeriodicSync();
    } else {
      await BackgroundSyncService.cancelSync();
    }
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, lang);
    await _syncToFirestore({'language': lang});
  }

  Future<void> setSubtitles(String sub) async {
    _subtitles = sub;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySubtitles, sub);
    await _syncToFirestore({'subtitles': sub});
  }

  /// Empuja cambios de perfil a Firestore si hay usuario autenticado.
  /// Se hace en segundo plano y no bloquea la UI ni rompe el flujo si
  /// falla (p. ej. sin conexión); el dato ya quedó guardado localmente.
  Future<void> _syncToFirestore(Map<String, dynamic> data) async {
    if (_auth.currentUser == null) return;
    try {
      await _firestore.saveProfile(data);
    } catch (e) {
      debugPrint('No se pudo guardar el perfil en Firestore: $e');
    }
  }

  // ── Foto de perfil ────────────────────────────────────────
  Future<void> changeProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final extension = p.extension(pickedFile.path);
      final savedPath = p.join(directory.path, 'avatar_2026$extension');

      await File(pickedFile.path).copy(savedPath);

      _profileImagePath = savedPath;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyImagePath, savedPath);
    } catch (e) {
      debugPrint('Error al guardar la imagen de perfil: $e');
    }
  }
}