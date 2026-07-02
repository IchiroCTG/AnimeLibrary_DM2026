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

class LibraryAnimeApp extends StatelessWidget {
  final LocaleViewModel localeVm;
  const LibraryAnimeApp({super.key, required this.localeVm});

  @override
  Widget build(BuildContext context) {
    // Crear los viewmodels aquí para poder inyectar dependencias
    final favoritesVm = FavoritesViewModel();
    final animeVm = AnimeViewModel();

    // Inyectar FavoritesViewModel en AnimeViewModel para sincronizar
    // el catálogo cuando se cargue desde AniList
    animeVm.setFavoritesViewModel(favoritesVm);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider.value(value: animeVm),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider.value(value: favoritesVm),
        ChangeNotifierProvider.value(value: localeVm),
      ],
      child: Consumer<LocaleViewModel>(
        builder: (context, locVm, _) {
          return MaterialApp(
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