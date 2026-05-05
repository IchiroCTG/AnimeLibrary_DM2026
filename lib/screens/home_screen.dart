import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
   appBar: AppBar(title: Text('Library Anime', style: AppTextStyles.headline3)),
    body: Center(
      child: Text('Home'),
    ),
  );
}