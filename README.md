# Library Anime 📺

> **Maqueta Funcional — PDS1 2026-01**  
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

El tiempo promedio de decisión de un usuario para elegir qué ver supera los 20 minutos por sesión, con una alta tasa de abandono causada por la fricción del descubrimiento.

### Solución propuesta

**Library Anime** es una aplicación móvil de catálogo unificado de anime desarrollada en Flutter. Centraliza en una sola interfaz la información de miles de títulos, indica su disponibilidad por plataforma de streaming, permite filtrar por género, año, nombre y apodo (incluyendo títulos en japonés/romaji), e integra reseñas y puntuaciones de la comunidad.

### Justificación de solución móvil

| Factor | Justificación |
|---|---|
| **Ubicuidad** | El usuario busca contenido en cualquier lugar y momento, no solo frente a un computador |
| **Push Notifications** | Imposible implementar alertas de nuevos episodios en una solución web estática |
| **Contexto de uso** | El consumo de streaming ocurre mayoritariamente desde dispositivos móviles |
| **UX nativa** | Gestos, transiciones y navegación nativa mejoran la experiencia frente a una PWA |

---

## 2. Funcionalidades y Requerimientos

### Historias de Usuario

| ID | Historia | Criterios de aceptación |
|---|---|---|
| **HU-01** | Como **aficionado al anime**, quiero **buscar un título por nombre o apodo en japonés**, para **encontrarlo rápidamente sin recordar su nombre oficial** | La búsqueda responde en tiempo real. Acepta nombre, título alternativo y tags en japonés/romaji |
| **HU-02** | Como **usuario**, quiero **filtrar el catálogo por género y plataforma de streaming**, para **encontrar anime que pueda ver con mi suscripción actual** | Los filtros se combinan. El resultado se actualiza inmediatamente. Se puede limpiar con un botón |
| **HU-03** | Como **usuario**, quiero **ver la ficha completa de un anime** (sinopsis, estudio, rating, episodios, plataformas), para **decidir si vale la pena verlo sin salir de la app** | La pantalla de detalle incluye todos los campos del modelo. La portada se carga desde red |
| **HU-04** | Como **usuario registrado**, quiero **guardar animes en listas personales** (Viendo, Completados, Pendientes), para **llevar un registro de mi historial de visualización** | El botón guardar muestra confirmación. Las listas son visibles en el perfil |
| **HU-05** | Como **usuario nuevo**, quiero **ver una pantalla de bienvenida** al abrir la app, para **identificar visualmente el producto antes de ingresar al catálogo** | La Splash Screen se muestra por 2.5 segundos con animación y navega automáticamente al Home |
| **HU-06** | Como **usuario**, quiero **consultar preguntas frecuentes** sobre el funcionamiento de la app, para **resolver mis dudas sin contactar soporte** | La pantalla Ayuda contiene FAQs expansibles con respuestas coherentes al dominio |
| **HU-07** | Como **usuario**, quiero **conocer las tecnologías y el propósito de la app**, para **confiar en su origen y funcionamiento** | La pantalla Acerca de contiene descripción del producto, equipo y fuentes de datos |

---

### Matriz de Requerimientos

#### Requerimientos Funcionales (RF)

| ID | Descripción | Prioridad | Pantalla |
|---|---|---|---|
| **RF-01** | El sistema debe mostrar el catálogo completo de anime en formato de grilla de 2 columnas | Alta | Home |
| **RF-02** | El sistema debe permitir filtrar el catálogo por género, plataforma de streaming y texto libre | Alta | Home |
| **RF-03** | El sistema debe navegar a la pantalla de detalle al seleccionar un anime de la grilla | Alta | Home → Detail |
| **RF-04** | El sistema debe mostrar la ficha completa del anime: título, sinopsis, géneros, plataformas, estudio, episodios, año, rating y títulos alternativos | Alta | Detail |
| **RF-05** | El sistema debe mostrar una Splash Screen con animación al iniciar la app | Media | Splash |
| **RF-06** | El sistema debe proveer navegación principal mediante BottomNavigationBar con 4 secciones | Alta | MainScaffold |
| **RF-07** | El sistema debe mostrar el perfil del usuario con estadísticas y listas personales | Media | Profile |
| **RF-08** | El sistema debe proveer una sección de ayuda con preguntas frecuentes expansibles | Baja | Help |
| **RF-09** | El sistema debe mostrar información del producto, tecnologías y equipo de desarrollo | Baja | About |
| **RF-10** | El sistema debe mostrar el badge de disponibilidad por plataforma de streaming | Alta | Detail |

#### Requerimientos No Funcionales (RNF)

| ID | Descripción | Categoría |
|---|---|---|
| **RNF-01** | La aplicación debe compilar y ejecutarse en Android 8.0+ e iOS 14+ | Compatibilidad |
| **RNF-02** | Las transiciones entre pantallas no deben superar 320ms | Rendimiento |
| **RNF-03** | Ningún color, tipografía o estilo debe estar hardcodeado fuera de `app_colors.dart`, `app_text_styles.dart` y `app_theme.dart` | Mantenibilidad |
| **RNF-04** | La estructura de carpetas debe seguir separación por responsabilidades: `screens/`, `widgets/`, `models/`, `theme/`, `navigation/` | Arquitectura |
| **RNF-05** | El catálogo debe soportar filtros combinados (género + plataforma + texto) sin degradación perceptible de rendimiento | Rendimiento |
| **RNF-06** | Todos los strings visibles al usuario deben ser coherentes con el dominio del anime | Contextualización |
| **RNF-07** | El historial de commits debe ser atómico, descriptivo y en español o inglés técnico | Control de versiones |
| **RNF-08** | Las imágenes de portada deben cargarse desde red con estado de carga y estado de error | Usabilidad |

---

## 3. Arquitectura y Patrones

### Estructura de carpetas

```
lib/
├── main.dart                    # Entry point. Configura MaterialApp y ThemeData
├── theme/
│   ├── app_colors.dart          # Paleta centralizada. Colores por plataforma y género
│   ├── app_text_styles.dart     # Estilos tipográficos. Familia Poppins
│   └── app_theme.dart           # ThemeData global (dark). AppBar, Card, Chip, Button, Input
├── models/
│   ├── anime.dart               # Clase de dominio Anime con toda la metadata
│   └── anime_data.dart          # Dataset estático con 15 títulos reales + métodos filterBy()
├── screens/
│   ├── splash_screen.dart       # Presentación animada. Navega automáticamente al Main
│   ├── home_screen.dart         # Master: grilla filtrable del catálogo
│   ├── detail_screen.dart       # Detail: ficha completa del anime seleccionado
│   ├── search_screen.dart       # Búsqueda avanzada
│   ├── profile_screen.dart      # Perfil y listas del usuario
│   ├── help_screen.dart         # FAQs expansibles
│   └── about_screen.dart        # Info del producto y equipo
├── widgets/
│   ├── anime_card.dart          # Tarjeta reutilizable del catálogo con portada, rating y género
│   ├── genre_chip.dart          # Chip de género con color dinámico y estado seleccionado
│   ├── platform_badge.dart      # Badge de plataforma con color corporativo
│   └── rating_bar.dart          # Barra de puntuación. Modo compacto y completo
└── navigation/
    ├── app_routes.dart          # Rutas centralizadas con constantes string y transiciones
    └── main_scaffold.dart       # BottomNavigationBar con IndexedStack
```

### Decisiones técnicas

#### Patrón Lista-Detalle (Master-Detail)
`HomeScreen` actúa como **Master**: presenta la colección de animes mediante `SliverGrid`. Al seleccionar un ítem, se navega a `DetailScreen` (**Detail**) usando `Navigator.pushNamed` y pasando el objeto `Anime` completo como argumento, evitando consultas adicionales.

```dart
// En AnimeCard — transferencia de datos entre pantallas
Navigator.pushNamed(
  context,
  AppRoutes.detail,
  arguments: anime,   // objeto Anime completo
);

// En DetailScreen — recepción del argumento
final anime = settings.arguments as Anime;
```

#### Sistema de rutas centralizado
Todas las rutas están definidas como constantes `static const String` en `AppRoutes`. `MaterialApp.onGenerateRoute` delega a `AppRoutes.generateRoute`, que maneja el casting de argumentos y las transiciones animadas (fade para rutas principales, slide para pantallas de detalle).

#### ThemeData sin hardcoding
Todos los colores, tamaños de fuente y estilos son referenciados desde `AppColors` y `AppTextStyles`. Ninguna pantalla ni widget define un `Color(0x...)` o `TextStyle(fontSize: ...)` directamente. Esto garantiza coherencia visual y facilita cambios de tema globales.

#### Widgets reutilizables con bajo acoplamiento
`AnimeCard`, `GenreChip`, `PlatformBadge` y `RatingBar` reciben sus datos exclusivamente por parámetros. No acceden a estado global ni a contexto de navegación (excepto `AnimeCard`, que sí navega, pero lo hace mediante `AppRoutes`). Esto permite usarlos en cualquier pantalla sin modificación.

### Jerarquía de navegación

```
SplashScreen
    └── MainScaffold (BottomNavigationBar)
            ├── [0] HomeScreen
            │       └── DetailScreen  ← push con Anime como argumento
            ├── [1] SearchScreen
            ├── [2] ProfileScreen
            │       └── AboutScreen   ← push desde Configuración
            └── [3] HelpScreen
```

---

## 4. Material de apoyo

| Recurso | Enlace |
|---|---|
| 🎥 Video de exposición | `[INSERTAR ENLACE AL VIDEO]` |
| 📊 Presentación de slides | `https://docs.google.com/presentation/d/1jzPum2vKqLOSTuNNQ6K7FpJ8ouvKx_wK/edit?usp=sharing&ouid=116373422622507881907&rtpof=true&sd=true` |
| 📦 Repositorio | `https://github.com/IchiroCTG/AnimeLibrary_DM2026.git` |

---

## 5. Guía de instalación

```bash
# 1. Clonar el repositorio
git clone <https://github.com/IchiroCTG/AnimeLibrary_DM2026.git>
cd library_anime

# 2. Instalar dependencias
flutter pub get

# 3. Verificar entorno
flutter doctor

# 4. Ejecutar la app
flutter run
```

**Versión mínima de Flutter:** 3.3.0  
**Dart SDK:** >=3.3.0 <4.0.0  
**Plataformas:** Android 8.0+ · iOS 14+

---



*© 2026 Library Anime · Universidad de Talca · Programación para Dispositivos Móviles*
