import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleViewModel extends ChangeNotifier {
  static const _keyLocale = 'app:locale';

  Locale _locale = const Locale('es');

  Locale get locale => _locale;
  bool get isSpanish => _locale.languageCode == 'es';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLocale) ?? 'es';
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, locale.languageCode);
  }

  Future<void> toggleLocale() async {
    final next = _locale.languageCode == 'es'
        ? const Locale('en')
        : const Locale('es');
    await setLocale(next);
  }
}