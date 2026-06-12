import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isSearchVisible = false;

  // ── Getters ───────────────────────────────────────────────
  int  get currentIndex     => _currentIndex;
  bool get isSearchVisible  => _isSearchVisible;

  // ── Navegación BottomBar ──────────────────────────────────
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ── Buscador ──────────────────────────────────────────────
  void toggleSearch() {
    _isSearchVisible = !_isSearchVisible;
    notifyListeners();
  }

  void hideSearch() {
    _isSearchVisible = false;
    notifyListeners();
  }
}