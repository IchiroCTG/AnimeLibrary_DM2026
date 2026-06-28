import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

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
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

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
            Text(l.homeSubtitle, style: AppTextStyles.headline1),
            Text(
              l.homeTitle,
              style: AppTextStyles.headline1.copyWith(
                color: AppColors.primary,
                letterSpacing: 6,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.splashTagline,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
