import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

//SplashScreen AnimeLibrary.
class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
  with SingleTickerProviderStateMixin{
    late AnimationController _controller;
    late Animation<double> _fadeAnimation;
    late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation, 
          child: ScaleTransition(
            scale: _scaleAnimation, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                //Logo
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.45),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: AppColors.textPrimary,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),

                // Nombre
                Text('Library', style:AppTextStyles.headline1),
                Text('ANIME', style: AppTextStyles.headline1.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 6,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 8),

                Text ('Tu catálogo unificado de anime', 
                style: AppTextStyles.bodySmall,),
                
              ],
            )
          )
        )
      ),
    );
  }
}
