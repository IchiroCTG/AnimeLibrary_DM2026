import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'navigation/app_routes.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized;

  runApp(const LibraryAnimeApp());
}

class LibraryAnimeApp extends StatelessWidget {
  const LibraryAnimeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Library Anime',
      debugShowCheckedModeBanner: false,

      // Tema global
      theme: AppTheme.dark,

      //Rutas Centralizadas

      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,


    );
  }
}


