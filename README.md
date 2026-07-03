# Library Anime 📺

> **Prototipo Funcional — PDS2 2026-01**  
> Programación para Dispositivos Móviles · Universidad de Talca  
> Desarrollador: Pablo Gutiérrez

---

## 1. Definición del Producto

### Problema identificado

La información sobre anime se encuentra fragmentada en más de ocho plataformas de streaming y sitios externos independientes (Crunchyroll, Netflix, HiDive, MyAnimeList, AniList, entre otros). Esto obliga al usuario a abrir múltiples aplicaciones para responder preguntas básicas como:

- ¿En qué plataforma está disponible este título?
- ¿Cuántos episodios tiene? ¿Está finalizado o en emisión?
- ¿Qué título alternativo tiene en japonés?
- ¿Qué otros géneros me pueden gustar?

### Solución propuesta

**Library Anime** es una aplicación móvil de catálogo unificado de anime desarrollada en Flutter. Centraliza en una sola interfaz la información de 15 títulos reales, indica su disponibilidad por plataforma de streaming, permite filtrar por género, año, nombre y apodo, e integra listas personales persistentes y evaluación de usuarios.

---

## 2. Arquitectura MVVM

### Diagrama de capas

```
┌─────────────────────────────────────────────────────────┐
│                        VIEW                             │
│  HomeScreen · DetailScreen · ProfileScreen              │
│  SearchScreen · EvaluationScreen · ListScreen           │
│                    ↕ Consumer<VM> / context.watch()     │
├─────────────────────────────────────────────────────────┤
│                     VIEW MODEL                          │
│  AnimeViewModel      → filtros, catálogo, estado        │
│  FavoritesViewModel  → listas persistentes (SP)         │
│  ProfileViewModel    → perfil, configuración (SP)       │
│  HomeViewModel       → índice navegación, búsqueda      │
│                    ↕ notifyListeners()                  │
├─────────────────────────────────────────────────────────┤
│                       MODEL                             │
│  Anime (dominio)     → 14 campos, getters calculados    │
│  AnimeData           → catálogo estático + filterBy()   │
│  SharedPreferences   → persistencia key-value           │
│  Firestore           → base de datos en la nube (PoC)   │
└─────────────────────────────────────────────────────────┘
```

### Inyección de dependencias

Los ViewModels se inyectan en el árbol de widgets mediante `MultiProvider` en `main.dart`:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AnimeViewModel()),
    ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ChangeNotifierProvider(create: (_) => ProfileViewModel()),
    ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
  ],
  child: MaterialApp(...),
)
```

La UI consume el estado con `Consumer<T>` o `context.watch<T>()`. Toda mutación de datos ocurre exclusivamente en el ViewModel mediante `notifyListeners()`, nunca en el widget.

### Estructura de carpetas

```
lib/
├── main.dart                      # Entry point + MultiProvider
├── firebase_options.dart          # Configuración Firebase (generado por FlutterFire CLI)
├── theme/
│   ├── app_colors.dart            # Paleta centralizada
│   ├── app_text_styles.dart       # Tipografía Poppins
│   └── app_theme.dart             # ThemeData global dark
├── models/
│   ├── anime.dart                 # Clase de dominio
│   └── anime_data.dart            # Dataset + filterBy()
├── l10n/
│   ├──app_en.arb                  # Archivo base de incoporación de intercambio de palabras hacia el idioma ingles
│   ├──app_es.arb                  # Archivo base de incoporación de intercambio de palabras hacia el idioma español
│   ├──app_localizations_es.dart   # Archivo dart encargado de contener la traduccion en español de las variables intercambiables
│   ├──app_localizations_en.dart   # Archivo dart encargado de contener la traduccion en ingles de las variables intercambiables
│   └──app_localizations.dart      # Archivo dart encargado de contener las variables intercambiables que usan los archivos de sus respectivos idiomas.
├── viewmodels/
│   ├── anime_viewmodel.dart       # Catálogo y filtros
│   ├── favorites_viewmodel.dart   # Listas persistentes
│   ├── auth_viewmodel.dart        # Sistema de Autenthicacion Firebase
│   ├── profile_viewmodel.dart     # Perfil + imagen + configuración
│   ├── locale_viewmodel.dart      # Idioma de la App
│   └── home_viewmodel.dart        # Navegación bottom bar
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── detail_screen.dart         # Share + botones de lista
│   ├── search_screen.dart
│   ├── profile_screen.dart        # Image picker + listas reales
│   ├── list_screen.dart           # Vista de lista específica
│   ├── evaluation_screen.dart     # Beta testing con JSON
│   ├── help_screen.dart
│   ├── about_screen.dart
│   └── poc/
│       └── poc_screen.dart        # Prueba de concepto Firestore
├── services
│   ├── anilist_repository.dart      # Solicitudes a la Api y Visual
│   ├── anilist_service.dart         # Coneccion con la Api
│   ├── background_sync_service.dart # Comparativa de informacion nueva
│   └── notification_service.dart    # Informa los cambios detectado por background y notifica localmente
├── widgets/
│   ├── anime_card.dart
│   ├── genre_chip.dart
│   ├── platform_badge.dart
│   └── rating_bar.dart
└── navigation/
    ├── app_routes.dart            # Rutas centralizadas
    └── main_scalffold.dart        # BottomNavigationBar
```

---

## 3. Servicios Integrados

### Firebase Firestore (PoC integrada)

La prueba de concepto valida la conexión asíncrona con Firestore desde la aplicación principal. Accesible desde el menú de perfil → PoC Firestore.

```dart
final snap = await FirebaseFirestore.instance
    .collection('animes')
    .limit(5)
    .get();
```

### shared_preferences — Persistencia local

Las listas del usuario sobreviven entre sesiones usando pares clave-valor:

| Clave | Contenido |
|---|---|
| `list:saved` | IDs de animes guardados |
| `list:watching` | IDs en "Viendo ahora" |
| `list:completed` | IDs completados |
| `list:pending` | IDs pendientes |
| `profile:username` | Nombre de usuario |
| `profile:image_path` | Ruta local de foto de perfil |
| `profile:notifications` | Preferencia de notificaciones |

### share_plus — Interoperabilidad

Desde `DetailScreen` el usuario puede compartir cualquier anime al ecosistema nativo del dispositivo (WhatsApp, correo, redes sociales):

```dart
SharePlus.instance.share(
  ShareParams(
    text: '🎌 ${anime.title}\n⭐ ${anime.rating}/10\n📺 ${platforms}',
  ),
);
```

---

## 4. Jerarquía de Navegación

```
SplashScreen
    └── MainScaffold (BottomNavigationBar)
            ├── [0] HomeScreen
            │       └── DetailScreen  ← share_plus + listas
            ├── [1] SearchScreen
            ├── [2] ProfileScreen
            │       ├── ListScreen    ← Guardados / Viendo / Completados / Pendientes
            │       ├── EvaluationScreen ← Beta Testing JSON
            │       └── AboutScreen
            └── [3] HelpScreen
```

---

## 5. Reporte de QA — Beta Testing

### Instrumento

9 preguntas estructuradas en JSON, organizadas en 3 secciones, calificadas con estrellas (0–5). El instrumento se carga desde `assets/data/evaluation.json` y se envía por email al evaluador mediante `url_launcher` con `mailto:`.

### Usuarios evaluados

| # | Tipo | Promedio |
|---|------|----------|
| 1 | Compañero | 4.3 / 5.0 |
| 2 | Desconocedor | 4.9 / 5.0 |
| 3 | Compañero | 4.7 / 5.0 |
| 4 | Compañero | 4.0 / 5.0 |
| 5 | Compañero | 5.0 / 5.0 |
| 6 | Compañero | 3.7 / 5.0 |
| 7 | Compañero | 5.0 / 5.0 |
| 8 | Compañero | 4.6 / 5.0 |
| 9 | Compañero | 5.0 / 5.0 |
| 10 | Desconocedor | 4.9 / 5.0 |
| 11 | Conocedor industria | 4.2 / 5.0 |
| 12 | Conocedor industria | 4.6 / 5.0 |

### Resultados por sección

| Sección | Promedio |
|---------|----------|
| Usabilidad | **4.78 / 5.0** |
| Contenido | **4.53 / 5.0** |
| Recomendación | **4.39 / 5.0** |
| **General** | **4.56 / 5.0** |

### Por tipo de usuario

| Tipo | n | Promedio |
|------|---|----------|
| Compañeros ramo | 8 | 4.53 / 5.0 |
| Conocedores industria | 2 | 4.39 / 5.0 |
| Externos (desconocedores) | 2 | 4.89 / 5.0 |

### Qué funcionó

- **Usabilidad** fue la sección mejor evaluada (4.78). La navegación por BottomNavigationBar resultó intuitiva para todos los perfiles de usuario.
- **Usuarios externos** dieron las notas más altas (4.89), lo que indica que la app es accesible sin conocimiento técnico previo del dominio anime.
- Los filtros combinados por género y plataforma fueron valorados positivamente por todos los grupos.
- El diseño visual (tema oscuro, paleta consistente) fue destacado en múltiples evaluaciones.

### Qué falló / áreas de mejora

- **Contenido** fue la sección con mayor varianza. El usuario 6 (compañero) calificó utilidad del contenido con 2/5, señalando que el catálogo de 15 títulos es limitado para un usuario avanzado.
- **Recomendación** fue la sección más baja (4.39). Dos usuarios (conocedores) bajaron la nota de recomendación a 3/5, probablemente por la falta de datos en tiempo real desde APIs externas.
- La pantalla de perfil muestra contadores fijos en lugar de estadísticas calculadas dinámicamente desde el historial real del usuario.

### Trabajos futuros — Deuda técnica

| Prioridad | Item |
|-----------|------|
| Alta | Ampliar catálogo conectando API de MyAnimeList o AniList |
| Alta | Autenticación real con Firebase Auth (login/registro) |
| Media | Notificaciones push para nuevos episodios |
| Media | Modo offline con caché local de Firestore |
| Baja | Estadísticas de uso (tiempo viendo, géneros favoritos) |
| Baja | Tema claro / oscuro seleccionable por el usuario |

---

## 6. Material de apoyo

| Recurso | Enlace |
|---|---|
| 🎥 Video de exposición PDS2 |https://youtu.be/6ASpjCjZBV4|
| 📊 Presentación PDS2 |https://docs.google.com/presentation/d/12c6spLz72tjrNdc0BNQN-0Nh50_u-rb0v55z5il2FKc/edit?usp=sharing|
| 📦 Repositorio | https://github.com/IchiroCTG/AnimeLibrary_DM2026.git |

---

## 7. Guía de instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/IchiroCTG/AnimeLibrary_DM2026.git
cd library_anime

# 2. Instalar dependencias
flutter pub get

# 3. Verificar entorno
flutter doctor

# 4. Ejecutar la app
flutter run
```

### Dependencias principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.x.x
  cloud_firestore: ^5.x.x
  provider: ^6.x.x
  shared_preferences: ^2.x.x
  share_plus: ^10.x.x
  url_launcher: ^6.x.x
  image_picker: ^1.x.x
  path_provider: ^2.x.x
  path: ^1.x.x
```

**Flutter mínimo:** 3.3.0 · **Dart SDK:** >=3.3.0 <4.0.0 · **Android:** 8.0+ · **iOS:** 14+

---

*© 2026 Library Anime · Universidad de Talca · Programación para Dispositivos Móviles*