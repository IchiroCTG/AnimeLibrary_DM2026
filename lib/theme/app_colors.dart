import 'package:flutter/material.dart';

class AppColors {

  // Fondos
  static const Color background    = Color(0xFF0D0F1C);
  static const Color surface       = Color(0XFF1A1C2E);
  static const Color surfaceVariant= Color(0xFFF5F5F5);

  // Acento Principal (rojo)
  static const Color primary      = Color(0XFFE63946);
  static const Color primaryLight = Color(0xFFFF6B75);
  static const Color primaryDark  = Color(0xFFB02030);

  // Acento Secundario (azul)
  static const Color secondary      = Color(0XFF7C4DFF);
  static const Color secondaryLight = Color(0xFFAB7DFF);

  // Texto
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0XFF9B9BB4);
  static const Color textDisabled  = Color(0xFF4A4A6A);

  // Estado
  static const Color success = Color(0xFF2DC653);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0XFFE63946);

  // Plataformas de streaming
  static const Color crunchyroll = Color(0xFFF47521);
  static const Color netflix     = Color(0xFFE50914);
  static const Color disneyPlus  = Color(0xFF113CCF);
  static const Color hidive      = Color(0xFF00BAAD);
  static const Color amazonPrime = Color(0xFF00A8E0);

  // Géneros — español (catálogo estático) + inglés (AniList)
  static const Map<String, Color> genreColors = {
    // ── Español ───────────────────────────────────────────
    'Acción':       Color(0xFFE63946),
    'Aventura':     Color(0xFFF59E0B),
    'Comedia':      Color(0xFF2DC653),
    'Drama':        Color(0xFF7C4DFF),
    'Fantasía':     Color(0xFF00BAAD),
    'Romance':      Color(0xFFFF6B9D),
    'Sci-Fi':       Color(0xFF00A8E0),
    'Thriller':     Color(0xFF9B9BB4),
    'Misterio':     Color(0xFF8B5CF6),
    'Slice of Life':Color(0xFF34D399),
    'Deportes':     Color(0xFF60A5FA),
    'Sobrenatural': Color(0xFFA855F7),
    'Ciencia Ficción': Color(0xFF00A8E0),
    'Terror':       Color(0xFF6D4C41),
    'Psicológico':  Color(0xFF5E35B1),
    'Música':       Color(0xFFEC407A),
    'Mecha':        Color(0xFF78909C),
    'Ecchi':        Color(0xFFFF7043),

    // ── Inglés (AniList) ──────────────────────────────────
    'Action':       Color(0xFFE63946),
    'Adventure':    Color(0xFFF59E0B),
    'Comedy':       Color(0xFF2DC653),
    // 'Drama' ya existe con el mismo valor
    'Fantasy':      Color(0xFF00BAAD),
    'Horror':       Color(0xFF6D4C41),
    'Mystery':      Color(0xFF8B5CF6),
    'Psychological':Color(0xFF5E35B1),
    'Music':        Color(0xFFEC407A),
    'Supernatural': Color(0xFFA855F7),
    'Sports':       Color(0xFF60A5FA),
    //'Mecha':        Color(0xFF78909C),
    //'Ecchi':        Color(0xFFFF7043),
    'Mahou Shoujo': Color(0xFFFF6B9D),
    'Hentai':       Color(0xFFBDBDBD),
  };
}
