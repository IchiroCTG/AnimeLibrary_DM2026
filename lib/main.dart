import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'navigation/app_routes.dart';
import 'theme/app_theme.dart';
import 'viewmodels/anime_viewmodel.dart';
import 'viewmodels/favorites_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/locale_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  // Cargar locale guardado antes de arrancar la app
  final localeVm = LocaleViewModel();
  await localeVm.load();

  runApp(LibraryAnimeApp(localeVm: localeVm));
}

class LibraryAnimeApp extends StatelessWidget {
  final LocaleViewModel localeVm;
  const LibraryAnimeApp({super.key, required this.localeVm});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnimeViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider.value(value: localeVm),
      ],
      child: Consumer<LocaleViewModel>(
        builder: (context, locVm, _) {
          return MaterialApp(
            title: 'Library Anime',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,

            // ── i18n ──────────────────────────────────────────
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