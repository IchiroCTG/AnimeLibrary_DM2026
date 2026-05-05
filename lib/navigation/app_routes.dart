import 'package:flutter/material.dart';

import '../models/anime.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/help_screen.dart';
import '../screens/about_screen.dart';
import '../navigation/main_scalffold.dart';

// rutas centrales de la aplicación - evita string en el code

abstract final class AppRoutes{
  static const String splash = '/';
  static const String main = '/main';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String help = '/help';
  static const String about = '/about';

  static Route <dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case splash:
        return _fade(const SplashScreen());

      case main:
        return _fade(const MainScaffold());

      case home:
        return _slide(const HomeScreen());

      case detail:
        final anime = settings.arguments as Anime;
        return _slide(DetailScreen(anime: anime));
      case profile:
        return _slide(const ProfileScreen());

      case search:
        return _slide(const SearchScreen());
      
      case help:
        return _slide(const HelpScreen());
      
      case about:
        return _slide(const AboutScreen());
      
      default:
        return _fade(const HomeScreen());

    }  
  }

  // Transiciones
  
  static PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
    pageBuilder: (_,  __, ___) => page,
    transitionsBuilder: (_, animation, __, child) =>
      FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 400),
  );

  static PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
    pageBuilder: (_, __ , ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final tween = Tween<Offset>(
        begin: const Offset(1.0, 0.0), 
        end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: child);            
    },
    transitionDuration: const Duration(milliseconds: 320),
  );
}