import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'navigation/app_routes.dart';
import 'services/background_sync_service.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'viewmodels/anime_viewmodel.dart';
import 'viewmodels/favorites_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/locale_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Notificaciones locales: canal + permisos.
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissions();

  // Background Task: sincroniza el catálogo cada 15 min aunque la app
  // esté cerrada, y notifica si aparece contenido nuevo.
  // Se respeta la preferencia guardada por el usuario en Ajustes.
  await BackgroundSyncService.initialize();
  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled = prefs.getBool('profile:notifications') ?? true;
  if (notificationsEnabled) {
    await BackgroundSyncService.registerPeriodicSync();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0D0F1C),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  final localeVm = LocaleViewModel();
  await localeVm.load();

  runApp(LibraryAnimeApp(localeVm: localeVm));
}

class LibraryAnimeApp extends StatefulWidget {
  final LocaleViewModel localeVm;
  const LibraryAnimeApp({super.key, required this.localeVm});

  @override
  State<LibraryAnimeApp> createState() => _LibraryAnimeAppState();
}

class _LibraryAnimeAppState extends State<LibraryAnimeApp> {
  // Navigator key global: permite navegar (p. ej. mandar a Login) desde
  // fuera del árbol de widgets, cuando reaccionamos a un cambio de sesión.
  final _navigatorKey = GlobalKey<NavigatorState>();

  // Se crean una sola vez aquí (y no en build) para poder suscribirnos a
  // authStateChanges en initState antes de armar la UI.
  late final AuthViewModel authVm;
  late final FavoritesViewModel favoritesVm;
  late final AnimeViewModel animeVm;

  StreamSubscription<User?>? _authSub;
  bool _skippedInitialAuthEvent = false;

  @override
  void initState() {
    super.initState();

    authVm = AuthViewModel();

    // Crear los viewmodels aquí para poder inyectar dependencias
    favoritesVm = FavoritesViewModel();
    animeVm = AnimeViewModel();

    // Inyectar FavoritesViewModel en AnimeViewModel para sincronizar
    // el catálogo cuando se cargue desde AniList
    animeVm.setFavoritesViewModel(favoritesVm);

    // Protección de sesión reactiva: si el usuario pierde la sesión
    // mientras usa la app (token expirado, cuenta deshabilitada, cierre
    // de sesión remoto, etc.), lo saca a Login al instante, sin depender
    // de que vuelva a pasar por el Splash.
    _authSub = authVm.authStateChanges.listen((user) {
      // authStateChanges emite el estado actual apenas nos suscribimos;
      // ese primer evento ya lo maneja el Splash al decidir la ruta
      // inicial, así que lo ignoramos aquí para no navegar dos veces.
      if (!_skippedInitialAuthEvent) {
        _skippedInitialAuthEvent = true;
        return;
      }

      if (user == null) {
        // Se agenda para después del frame actual (en vez de navegar en
        // el momento exacto en que llega el evento del stream), porque
        // ese evento puede llegar a mitad de una reconstrucción de
        // widgets y chocar con el ciclo de vida del frame.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authVm),
        ChangeNotifierProvider.value(value: animeVm),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider.value(value: favoritesVm),
        ChangeNotifierProvider.value(value: widget.localeVm),
      ],
      child: Consumer<LocaleViewModel>(
        builder: (context, locVm, _) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'Library Anime',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            locale: locVm.locale,
            supportedLocales: const [
              Locale('es'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}