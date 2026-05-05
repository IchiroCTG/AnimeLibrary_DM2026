import 'dart:async';
import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {  // ← verifica que el widget aún existe
        Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();  // ← cancela el timer si el widget se destruye antes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icono.png',
              width: 96,
              height: 96,
            ),
            const SizedBox(height: 24),
            Text('Library', style: AppTextStyles.headline1),
            Text(
              'ANIME',
              style: AppTextStyles.headline1.copyWith(
                color: AppColors.primary,
                letterSpacing: 6,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu catálogo unificado de anime',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}