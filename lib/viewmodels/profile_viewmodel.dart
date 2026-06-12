import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

enum ProfileState { initial, loading, loaded, error }

class ProfileViewModel extends ChangeNotifier {
  // Claves para persistencia en SharedPreferences
  static const _keyUsername      = 'profile:username';
  static const _keyImagePath     = 'profile:image_path';
  static const _keyNotifications = 'profile:notifications';
  static const _keyLanguage      = 'profile:language';
  static const _keySubtitles     = 'profile:subtitles';

  ProfileState _state  = ProfileState.initial;
  String _username     = 'OtakuUser_2026';
  String _email        = 'usuario@libraryanime.app';
  String? _profileImagePath;
  
  int    _savedCount   = 0;
  int    _watchingCount= 0;
  int    _completedCount= 0;
  int    _pendingCount = 0;
  bool   _notifications= true;
  String _language     = 'Español';
  String _subtitles    = 'Sub ES';

  // ── Getters ───────────────────────────────────────────────
  ProfileState get state           => _state;
  String get username             => _username;
  String get email                => _email;
  String? get profileImagePath    => _profileImagePath; // Getter para la UI
  int    get savedCount           => _savedCount;
  int    get watchingCount        => _watchingCount;
  int    get completedCount       => _completedCount;
  int    get pendingCount         => _pendingCount;
  bool   get notifications        => _notifications;
  String get language             => _language;
  String get subtitles            => _subtitles;
  bool   get isLoading            => _state == ProfileState.loading;
  int    get totalAnimes          => _savedCount + _completedCount + _watchingCount + _pendingCount;

  final ImagePicker _picker = ImagePicker();

  // ── Cargar perfil ─────────────────────────────────────────
  Future<void> loadProfile() async {
    _state = ProfileState.loading;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Cargar configuraciones del usuario desde disco si existen
      _username         = prefs.getString(_keyUsername) ?? 'OtakuUser_2026';
      _profileImagePath = prefs.getString(_keyImagePath);
      _notifications    = prefs.getBool(_keyNotifications) ?? true;
      _language         = prefs.getString(_keyLanguage) ?? 'Español';
      _subtitles        = prefs.getString(_keySubtitles) ?? 'Sub ES';

      // Simular delay o peticiones de red si las hay
      await Future.delayed(const Duration(milliseconds: 200));

      // Tus contadores base se mantienen intactos
      _savedCount    = 24;
      _watchingCount = 5;
      _completedCount= 87;
      _pendingCount  = 38;
      
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
  }

  Future<void> toggleNotifications() async {
    _notifications = !_notifications;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, _notifications);
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, lang);
  }

  Future<void> setSubtitles(String sub) async {
    _subtitles = sub;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySubtitles, sub);
  }

  // ── Gestión de Foto con ImagePicker ────────────────────────
  Future<void> changeProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (pickedFile == null) return; // Usuario canceló

      // Obtener ruta permanente del sistema de archivos
      final directory = await getApplicationDocumentsDirectory();
      final String extension = p.extension(pickedFile.path);
      final String fileName = 'avatar_2026$extension';
      final String savedPath = p.join(directory.path, fileName);

      // Copiar de la caché temporal a persistencia real
      final File tempFile = File(pickedFile.path);
      await tempFile.copy(savedPath);

      _profileImagePath = savedPath;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyImagePath, savedPath);
      
    } catch (e) {
      debugPrint('Error al guardar la imagen de perfil: $e');
    }
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