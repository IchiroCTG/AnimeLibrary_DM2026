# Library Anime 📺

> **Piloto de Alta Fidelidad Técnica — PDS3 2026-01**
> Ruta de implementación: **R1 · "Enterprise Readiness"**
> Programación de Dispositivos Móviles · Universidad de Talca
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

**Library Anime** es una aplicación móvil de catálogo unificado de anime desarrollada en Flutter. Centraliza en una sola interfaz un catálogo dinámico consumido desde la API de **AniList (GraphQL)**, indica disponibilidad por plataforma de streaming, permite filtrar por género, año, nombre y apodo, e integra listas personales y perfil **sincronizados en la nube**.

### Ruta seleccionada — R1 "Enterprise Readiness"

Para este hito final se adoptó la **Ruta 1**, orientada a llevar el producto a un estado maduro y productivo mediante un **Backend as a Service (Firebase)**. Se implementó:

- 🔐 **Autenticación e Identidad** con Firebase Auth (Email/Password) y protección reactiva de sesión.
- ☁️ **Sincronización Cloud** de perfil y listas de usuario en Cloud Firestore.
- 🔄 **Trabajo Asíncrono** en segundo plano con WorkManager + notificaciones locales push.
- 🌐 **Internacionalización (i18n)** completa de la interfaz en Español e Inglés.

### Evolución PDS2 → PDS3

| PDS2 — Prototipo Funcional | PDS3 — Piloto Enterprise Readiness |
|---|---|
| ✕ Firebase solo como PoC aislada (`poc_screen.dart`) | ✓ Firebase integrado end-to-end: Auth + Firestore en el flujo principal |
| ✕ Sin autenticación real | ✓ Login / Registro con Firebase Auth y sesión reactiva (`AuthViewModel`) |
| ✕ Listas y perfil solo en `shared_preferences` (local) | ✓ `shared_preferences` como caché + **Firestore como fuente de verdad** cuando hay sesión |
| ✕ Catálogo estático de 15 títulos hardcodeados | ✓ Catálogo dinámico vía API REST/GraphQL de AniList con caché offline-first |
| ✕ Sin trabajo en segundo plano | ✓ `WorkManager` sincroniza el catálogo cada 15 min y notifica novedades |
| ✕ Interfaz solo en español | ✓ i18n con `flutter_localizations` + `.arb` (ES/EN), selector en Perfil |
| ✕ Sin protección de rutas | ✓ `SplashScreen` + `authStateChanges` redirigen a `Login` si no hay sesión activa |

---

## 2. Arquitectura MVVM

### Diagrama de capas

```
┌─────────────────────────────────────────────────────────────┐
│                           VIEW                               │
│  SplashScreen · LoginScreen · HomeScreen · DetailScreen      │
│  SearchScreen · ProfileScreen · EvaluationScreen · ListScreen│
│                    ↕ Consumer<VM> / context.watch()          │
├─────────────────────────────────────────────────────────────┤
│                        VIEW MODEL                             │
│  AuthViewModel       → login, registro, sesión (Auth stream) │
│  AnimeViewModel       → catálogo AniList, filtros, estado     │
│  FavoritesViewModel   → listas persistentes (SP + Firestore)  │
│  ProfileViewModel     → perfil, configuración (SP + Firestore)│
│  LocaleViewModel      → idioma activo de la app (i18n)        │
│  HomeViewModel        → índice navegación, búsqueda           │
│                    ↕ notifyListeners()                        │
├─────────────────────────────────────────────────────────────┤
│                          MODEL                                 │
│  Anime (dominio)      → 14 campos, getters calculados          │
│  AniListService       → cliente GraphQL sobre AniList API       │
│  AniListRepository    → orquesta red + caché offline-first      │
│  SharedPreferences    → persistencia local / caché              │
│  FirestoreService     → users/{uid} + favorites (subcolección)  │
│  FirebaseAuth         → identidad y sesión del usuario           │
│  BackgroundSyncService→ WorkManager · sync periódica (15 min)    │
│  NotificationService  → notificaciones locales (flutter_local_   │
│                          notifications)                          │
└─────────────────────────────────────────────────────────────┘
```

### Inyección de dependencias

Los ViewModels que dependen de Firebase (`AuthViewModel`, `AnimeViewModel`, `FavoritesViewModel`) se instancian una sola vez en `_LibraryAnimeAppState.initState()` — antes del primer `build` — para poder suscribirse a `authStateChanges` desde el arranque y así reaccionar a cambios de sesión en cualquier punto de la app:

```dart
_authSub = authVm.authStateChanges.listen((user) {
  if (user == null) {
    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login, (route) => false,
    );
  }
});
```

Luego se inyectan en el árbol mediante `MultiProvider`:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider.value(value: authVm),
    ChangeNotifierProvider.value(value: animeVm),
    ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ChangeNotifierProvider(create: (_) => ProfileViewModel()),
    ChangeNotifierProvider.value(value: favoritesVm),
    ChangeNotifierProvider.value(value: localeVm),
  ],
  child: MaterialApp(...),
)
```

La UI consume el estado con `Consumer<T>` o `context.watch<T>()`. Toda mutación de datos ocurre exclusivamente en el ViewModel mediante `notifyListeners()`, nunca en el widget.

### Estructura de carpetas

```
lib/
├── main.dart                      # Entry point, Firebase.initializeApp, WorkManager, MultiProvider
├── firebase_options.dart          # Configuración Firebase (generado por FlutterFire CLI)
├── theme/
│   ├── app_colors.dart            # Paleta centralizada
│   ├── app_text_styles.dart       # Tipografía Poppins
│   └── app_theme.dart             # ThemeData global dark
├── models/
│   ├── anime.dart                 # Clase de dominio
│   └── anime_data.dart            # Dataset semilla / utilidades
├── l10n/
│   ├── app_es.arb                 # Strings base en español
│   ├── app_en.arb                 # Strings base en inglés
│   ├── app_localizations.dart     # Delegate + acceso a strings intercambiables
│   ├── app_localizations_es.dart  # Traducciones ES generadas
│   └── app_localizations_en.dart  # Traducciones EN generadas
├── viewmodels/
│   ├── auth_viewmodel.dart        # Login, registro, logout y stream de sesión (Firebase Auth)
│   ├── anime_viewmodel.dart       # Catálogo AniList y filtros
│   ├── favorites_viewmodel.dart   # Listas persistentes: SharedPreferences + Firestore
│   ├── profile_viewmodel.dart     # Perfil + imagen + configuración (SP + Firestore)
│   ├── locale_viewmodel.dart      # Idioma activo de la app
│   └── home_viewmodel.dart        # Navegación bottom bar
├── screens/
│   ├── splash_screen.dart         # Decide ruta inicial según sesión (Login o Main)
│   ├── login_screen.dart          # Login / registro con Firebase Auth
│   ├── home_screen.dart
│   ├── detail_screen.dart         # Share + botones de lista
│   ├── search_screen.dart
│   ├── profile_screen.dart        # Image picker, listas, idioma, logout
│   ├── list_screen.dart           # Vista de lista específica
│   ├── evaluation_screen.dart     # Beta testing con JSON
│   ├── help_screen.dart
│   ├── about_screen.dart
│   └── poc/
│       └── poc_screen.dart        # PoC histórica de Firestore (PDS2)
├── services/
│   ├── anilist_service.dart         # Cliente GraphQL — consumo de la API AniList
│   ├── anilist_repository.dart      # Orquesta red + caché local offline-first
│   ├── firestore_service.dart       # users/{uid}: perfil + subcolección favorites
│   ├── background_sync_service.dart # WorkManager: sync periódica del catálogo (15 min)
│   └── notification_service.dart    # Notificaciones locales de novedades detectadas
├── widgets/
│   ├── anime_card.dart
│   ├── genre_chip.dart
│   ├── platform_badge.dart
│   └── rating_bar.dart
└── navigation/
    ├── app_routes.dart            # Rutas centralizadas (incluye /login)
    └── main_scalffold.dart        # BottomNavigationBar
```

---

## 3. Servicios Integrados (Ruta 1 — Enterprise Readiness)

### 3.1 Autenticación e Identidad (Firebase Auth)

`LoginScreen` permite iniciar sesión o registrarse con email/contraseña a través de `AuthViewModel`. Al registrarse se crea automáticamente el documento base del usuario en Firestore:

```dart
Future<String?> signIn(String email, String password) async {
  await _auth.signInWithEmailAndPassword(email: email, password: password);
  if (_auth.currentUser?.email != null) {
    await _firestore.createUserIfNotExists(_auth.currentUser!.email!);
  }
  notifyListeners();
}
```

**Protección de sesión reactiva:** `SplashScreen` decide la ruta inicial (`/main` o `/login`) según `authVm.currentUser`, y una suscripción a `authStateChanges` en `main.dart` saca al usuario a `Login` de inmediato si la sesión se pierde en cualquier momento (token expirado, cierre remoto, etc.), sin depender de reiniciar la app.

### 3.2 Sincronización Cloud (Cloud Firestore)

El modelo de datos migró desde `shared_preferences` puro hacia una estrategia híbrida: **local como caché + Firestore como fuente de verdad** cuando hay sesión activa.

```
users (colección)
└── {uid} (documento)
    ├── email, username, notifications, language, subtitles, updatedAt
    └── favorites (subcolección)
        └── {animeId} → { saved: bool, watching: bool, completed: bool, pending: bool }
```

- **Perfil:** `ProfileViewModel.loadProfile()` lee primero de `shared_preferences` (respuesta instantánea) y luego intenta refrescar desde Firestore; si hay datos remotos, sobreescriben la caché local.
- **Favoritos:** cada anime guarda **un campo booleano por lista** en vez de un único campo `list`, permitiendo que un título pertenezca a varias listas a la vez sin sobreescribirse entre sí:

```dart
Future<void> addFavorite(String animeId, String list) async {
  await _userDoc.collection('favorites').doc(animeId)
      .set({list: true}, SetOptions(merge: true));
}
```

- Toda escritura a Firestore se realiza en segundo plano y con manejo de errores (`try/catch` + log), de modo que si no hay conexión el dato ya quedó persistido localmente y no se rompe el flujo (estrategia **offline-first**).

### 3.3 Trabajo Asíncrono en segundo plano (WorkManager + Notificaciones Push)

`BackgroundSyncService` registra una tarea periódica con `WorkManager` (cada 15 minutos, con restricción de red conectada) que se ejecuta **aunque la app esté cerrada**:

```dart
await Workmanager().registerPeriodicTask(
  kCatalogSyncTask, kCatalogSyncTask,
  frequency: const Duration(minutes: 15),
  constraints: Constraints(networkType: NetworkType.connected),
);
```

En cada ejecución compara el catálogo remoto de AniList contra el último estado conocido:

- Si aparecen **animes nuevos** en el catálogo → notificación local.
- Si un anime que el usuario tiene en **"Guardados" o "Viendo"** sube su conteo de episodios → notificación local con el título afectado.

Las notificaciones se disparan mediante `flutter_local_notifications` (`NotificationService`), y el usuario puede activar/desactivar esta sincronización desde Perfil (`ProfileViewModel.toggleNotifications()`), lo que registra o cancela la tarea de WorkManager en caliente.

### 3.4 Internacionalización (i18n)

La interfaz completa (no así el contenido que entrega la API) está disponible en **Español** e **Inglés**, usando el mecanismo estándar de Flutter:

- `l10n.yaml` + archivos `app_es.arb` / `app_en.arb` → generan `AppLocalizations`.
- `LocaleViewModel` persiste el idioma elegido y se inyecta en `MaterialApp.locale`.
- Cada pantalla accede a los strings vía `AppLocalizations.of(context)!.claveDeTexto`.
- El selector de idioma está disponible en `ProfileScreen`.

### 3.5 Consumo de API REST/GraphQL — AniList (heredado, con caché offline-first)

`AniListRepository` orquesta el consumo de la API pública de AniList y aplica una estrategia de caché con TTL de 1 hora sobre `shared_preferences`: si la petición de red falla, sirve el último catálogo válido almacenado, permitiendo operar sin conexión.

### 3.6 shared_preferences — Persistencia y caché local

| Clave | Contenido |
|---|---|
| `list:saved` / `list:watching` / `list:completed` / `list:pending` | IDs de animes por lista (caché local, espejo de Firestore) |
| `profile:username` / `profile:image_path` / `profile:notifications` / `profile:language` / `profile:subtitles` | Configuración de perfil (caché local, espejo de Firestore) |
| `cache:anilist:catalog` / `cache:anilist:timestamp` | Caché offline-first del catálogo AniList |
| `sync:known_anime_ids` / `sync:episodes_counts` | Estado de referencia usado por `BackgroundSyncService` para detectar novedades |

### 3.7 share_plus — Interoperabilidad

Desde `DetailScreen` el usuario puede compartir cualquier anime al ecosistema nativo del dispositivo (WhatsApp, correo, redes sociales) mediante `SharePlus.instance.share(ShareParams)`.

---

## 4. Jerarquía de Navegación

```
SplashScreen  ── decide ruta según sesión (authStateChanges) ──┐
    ├── (sin sesión) → LoginScreen ── login/registro OK ──┐    │
    └── (con sesión) ────────────────────────────────────┴────┤
                                                                ↓
                                       MainScaffold (BottomNavigationBar)
                                           ├── [0] HomeScreen
                                           │       └── DetailScreen  ← share_plus + listas
                                           ├── [1] SearchScreen
                                           ├── [2] ProfileScreen
                                           │       ├── ListScreen       ← Guardados / Viendo / Completados / Pendientes
                                           │       ├── EvaluationScreen ← Beta Testing JSON
                                           │       ├── AboutScreen
                                           │       └── Logout ── AuthViewModel.signOut() → LoginScreen
                                           └── [3] HelpScreen
```

Si en cualquier momento la sesión se pierde (token expirado, logout remoto), la app navega automáticamente a `LoginScreen` sin pasar por el Splash.

---

## 5. Reporte de QA — Beta Testing (PDS2, línea base)

> Instrumento y resultados recolectados durante PDS2, previos a la incorporación de los servicios avanzados de esta entrega. Se mantienen como línea base de referencia; una nueva ronda de evaluación del Piloto queda propuesta como trabajo futuro inmediato.

### Instrumento

9 preguntas estructuradas en JSON, organizadas en 3 secciones, calificadas con estrellas (0–5). El instrumento se carga desde `assets/data/evaluation.json` y se envía por email al evaluador mediante `url_launcher` con `mailto:`.

### Resultados por sección

| Sección | Promedio |
|---------|----------|
| Usabilidad | **4.78 / 5.0** |
| Contenido | **4.53 / 5.0** |
| Recomendación | **4.39 / 5.0** |
| **General** | **4.56 / 5.0** |

### Qué motivó los cambios de esta entrega

- **Recomendación** fue la sección más baja en PDS2 (4.39); dos evaluadores conocedores de la industria señalaron la falta de datos en tiempo real. → Resuelto migrando el catálogo estático a la **API de AniList**.
- Se identificó como deuda técnica de alta prioridad la **autenticación real** y la **ampliación del catálogo**. → Resuelto en esta entrega con Firebase Auth + AniList.
- Se identificó como deuda de prioridad media las **notificaciones push** y el **modo offline**. → Resuelto con WorkManager + notificaciones locales, y caché offline-first en el repositorio de AniList.

### Trabajos futuros — Deuda técnica restante

| Prioridad | Item |
|-----------|------|
| Alta | Nueva ronda de Beta Testing sobre el Piloto (post autenticación y sync cloud) |
| Media | Login social (Google Sign-In) además de Email/Password |
| Media | Reglas de seguridad de Firestore para producción (actualmente en modo desarrollo) |
| Baja | Estadísticas de uso calculadas dinámicamente desde el historial real del usuario |
| Baja | Tema claro / oscuro seleccionable por el usuario |

---

## 6. Material de apoyo

| Recurso | Enlace |
|---|---|
| 🎥 Video de exposición PDS3 | *Pendiente de publicación* |
| 📊 Presentación PDS3 | *Ver `LibraryAnime_PDS3.pptx` en el repositorio* |
| 🎥 Video de exposición PDS2 | https://youtu.be/6ASpjCjZBV4 |
| 📊 Presentación PDS2 | https://docs.google.com/presentation/d/12c6spLz72tjrNdc0BNQN-0Nh50_u-rb0v55z5il2FKc/edit?usp=sharing |
| 📦 Repositorio | https://github.com/IchiroCTG/AnimeLibrary_DM2026.git |
| 📝 Registro de decisiones (PoC → integración) | [`POC.md`](./POC.md) |

---

## 7. Guía de instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/IchiroCTG/AnimeLibrary_DM2026.git
cd library_anime

# 2. Instalar dependencias
flutter pub get

# 3. Configurar Firebase (requiere flutterfire CLI y proyecto propio o
#    acceso al proyecto "library-anime-88d29")
flutterfire configure

# 4. Generar las clases de localización (i18n)
flutter gen-l10n

# 5. Verificar entorno
flutter doctor

# 6. Ejecutar la app
flutter run
```

### Dependencias principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  firebase_storage: ^12.3.2
  http: ^1.2.2
  cached_network_image: ^3.3.1
  provider: ^6.0.5
  shared_preferences: ^2.3.3
  share_plus: ^10.1.4
  url_launcher: ^6.1.7
  image_picker: ^0.8.7+4
  path_provider: ^2.0.14
  workmanager: ^0.9.0+2
  flutter_local_notifications: ^18.0.1
  timezone: ^0.9.4
```

**Flutter mínimo:** 3.x (Dart SDK `^3.11.3`) · **Android:** 8.0+ · **iOS:** 14+

---

## 8. Ponderación de indicadores — Ruta 1 "Enterprise Readiness"

| # | Indicador | Ponderación | Estado |
|---|---|---|---|
| 1 | Gestión de versiones, ramas semánticas e historial atómico | 5% | ✅ |
| 2 | Actualización documental (README): diagramas BaaS, reglas de seguridad y manual de despliegue | 5% | ✅ |
| 3 | Adaptación de la arquitectura (MVVM) para soportar flujos asíncronos de la nube | 5% | ✅ |
| 4 | Autenticación e Identidad: login seguro y navegación protegida por sesión | 10% | ✅ |
| 5 | Migración y Sincronización Cloud (Firestore), reemplazando el CRUD local por colecciones remotas | 10% | ✅ |
| 6 | Notificaciones Push / sincronización en segundo plano | 5% | ✅ |
| 7 | Trabajo Asíncrono: notificaciones push o sincronización en Background | 10% | ✅ |
| 8 | Internacionalización (i18n) — al menos dos idiomas | 10% | ✅ |
| 9 | Estrategia Offline-First usando la persistencia local heredada como caché de la nube | 5% | ✅ |
| 10 | Material de apoyo visual: diagramas técnicos y exposición del caso de uso | 5% | ✅ |
| 11 | Exposición formal justificando la elección del BaaS y demostrando la asincronía | 10% | ⏳ Pendiente de grabación |
| 12 | Avances continuos — Trabajo Autónomo (2 hrs/semana) | 20% | ✅ |
| | **TOTAL** | **100%** | |

---

*© 2026 Library Anime · Universidad de Talca · Programación de Dispositivos Móviles*