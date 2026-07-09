# POC.md — Architecture Decision Record

## Rama: feature/poc_firebase_baas → integrado en develop (PDS3, Ruta 1 "Enterprise Readiness")

---

## ADR-1 — Adopción de Firebase como stack BaaS (PDS2 → PDS3)

### Contexto — Riesgo Evaluado
Library Anime necesita persistir listas personales de usuario (Guardados,
Completados, Viendo, Pendientes) y un catálogo de animes accesible offline.
El riesgo principal era la asincronía de Firestore bajo condiciones de
conectividad inestable en dispositivos móviles. Sin validar este riesgo
antes de la implementación completa, se incurría en deuda técnica grave.

### Decisión — Librería y Estrategia Adoptada
Se adoptó Firebase + FlutterFire como stack BaaS principal:
- `cloud_firestore ^5.4.4` — persistencia y sincronización en tiempo real
- `firebase_auth ^5.3.1` — autenticación de usuarios
- `firebase_storage ^12.3.2` — almacenamiento de imágenes

La PoC inicial validó la lectura de la colección `animes` desde Firestore
con manejo de errores y estados de carga. Conexión confirmada sin errores
en emulador Android.

### Consecuencias — Resultado
✓ Viabilidad técnica confirmada. Se integró a `develop` siguiendo el plan
original (interfaz de repositorio, inyección de dependencias, migración del
catálogo estático, reglas de seguridad).

---

## ADR-2 — Autenticación e Identidad (Indicador 4 · 10%)

### Contexto
La app no tenía autenticación real de usuarios en PDS2 (listas y perfil
solo en `shared_preferences`, sin noción de sesión).

### Decisión
Se implementó `firebase_auth` con login/registro por Email + Password:
- `LoginScreen` — formulario de email / contraseña, login o registro.
- `AuthViewModel` — expone `signIn()` / `register()` contra
  `FirebaseAuth.instance`.
- `FirestoreService.createUserIfNotExists()` — crea el documento base del
  usuario en Firestore al primer login.
- `SplashScreen` — decide la ruta inicial según `authVm.currentUser`
  (`/main` o `/login`).
- Suscripción global a `authStateChanges` en `main.dart`: si la sesión se
  pierde, redirige a `Login` de inmediato.

### Consecuencias
✓ Sesión reactiva y navegación protegida en toda la app.
Limitación: por ahora solo se soporta Email/Password; Google Sign-In queda
fuera de alcance de esta Ruta.

---

## ADR-3 — Modelo de datos y Sincronización Cloud (Indicador 5 · 10%)

### Contexto
Con autenticación real disponible, era necesario definir dónde vive la
"fuente de verdad" de los datos de usuario y cómo conviven con la caché
local heredada de PDS2.

### Decisión
Modelo de datos en Firestore:

```
users (colección)
└ {uid} (documento)
   · email
   · username
   · notifications
   · language
   · subtitles
   · updatedAt
   └ favorites (subcolección)
      └ {animeId} → { saved, watching, completed, pending: bool }
```

Estrategia Offline-First adoptada:
1. `ProfileViewModel` / `FavoritesViewModel` leen primero de
   `shared_preferences` (respuesta instantánea).
2. Con sesión activa, se refresca desde Firestore; si hay datos remotos,
   sobrescriben la caché local.
3. Cada escritura a Firestore corre en segundo plano dentro de `try/catch`:
   si falla, el dato ya quedó persistido localmente.
4. Favoritos usan un campo booleano independiente por lista
   (`saved`/`watching`/`completed`/`pending`), evitando que una lista
   sobrescriba a otra.

### Consecuencias
✓ Firestore pasa a ser la fuente de verdad; `shared_preferences` queda
como caché, no como almacenamiento primario.
Limitación: requiere reglas de seguridad Firestore (`users/{uid}` solo
editable por su dueño) configuradas antes de producción — pendiente de
documentar en detalle en el README.

---

## ADR-4 — Trabajo Asíncrono en Segundo Plano (Indicadores 6 y 7 · 15%)

### Contexto
PDS2 no tenía ningún mecanismo para detectar contenido nuevo sin que el
usuario abriera la app manualmente.

### Decisión
Se integró `workmanager` para registrar una tarea periódica (cada 15 min,
con red conectada). El flujo, orquestado por `BackgroundSyncService`, es:

`WorkManager` → compara IDs y episodios actuales vs. último estado
conocido (`sync:known_anime_ids`, `sync:episodes_counts` en
`SharedPreferences`) → si hay novedades → dispara notificación local vía
`flutter_local_notifications`.

El usuario controla esta sincronización desde `Perfil → Notificaciones`
(`ProfileViewModel.toggleNotifications`), registrando o cancelando la
tarea en caliente.

### Consecuencias
✓ Notificaciones funcionan con la app cerrada.
Decisión adicional (post-implementación): como el isolate de WorkManager
no tiene `BuildContext`, el texto de la notificación no puede usar
`AppLocalizations.of(context)`. Se optó por leer el idioma persistido
directamente desde `SharedPreferences` (`app:locale`) dentro del propio
servicio, para mantener la notificación coherente con el idioma elegido
por el usuario incluso en segundo plano.

---

## ADR-5 — Internacionalización (Indicador 8 · 10%)

### Contexto
La interfaz estaba disponible solo en español.

### Decisión
Pipeline estándar de Flutter: `l10n.yaml` → `app_es.arb` / `app_en.arb` →
clases `AppLocalizations` generadas con getters tipados por clave →
`LocaleViewModel` persiste el idioma en `shared_preferences` →
`MaterialApp.locale` reconstruye la UI en caliente.

### Consecuencias
✓ Toda la interfaz (menús, botones, formularios, mensajes de error, y las
notificaciones de segundo plano vía ADR-4) respeta el idioma elegido.
Fuera de alcance: el contenido entregado por la API de AniList (títulos,
sinopsis) se muestra en su idioma original, sin traducir.

---

## ADR-6 — Estrategia Offline-First sobre el catálogo (Indicador 9 · 5%)

### Contexto
El catálogo pasó de ser estático (15 títulos) a dinámico vía API AniList,
lo que introduce dependencia de red para una función central de la app.

### Decisión
`AniListRepository` orquesta red + caché:
- Con conexión: `AnimeViewModel.load()` → `AniListRepository.getCatalog()`
  → `AniListService` (query GraphQL) → parseo a `List<Anime>` → caché con
  TTL de 1 hora.
- Sin conexión / error: se captura la excepción y se recurre a
  `_loadFromCache()` desde `SharedPreferences`, mostrando el último
  catálogo válido. La búsqueda también degrada, filtrando localmente sobre
  el catálogo cacheado.
- `BackgroundSyncService` (ADR-4) reutiliza este mismo repositorio con
  `forceRefresh: true` para comparar versiones cada 15 min.

### Consecuencias
✓ La app sigue siendo utilizable sin conexión.
Limitación: el TTL de 1 hora es un valor fijo; no se implementó ajuste
dinámico según el tipo de red (WiFi/datos móviles).

---

## Estado actual y pendientes

| Área | Estado |
|---|---|
| Autenticación (ADR-2) | ✅ Integrado a `develop` |
| Firestore + Offline-First (ADR-3) | ✅ Integrado — reglas de seguridad detalladas: pendiente de documentar en README |
| WorkManager + Notificaciones (ADR-4) | ✅ Integrado |
| i18n (ADR-5) | ✅ Integrado |
| Caché de catálogo (ADR-6) | ✅ Integrado |
| Video de exposición formal | ⏳ Pendiente de grabación/publicación |

*Última actualización: PDS3 2026-01 — Ruta 1 Enterprise Readiness.*