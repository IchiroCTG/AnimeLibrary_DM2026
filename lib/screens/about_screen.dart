import 'package:flutter/material.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Library Anime - Versión 1.0\n'
        'Desarrollada por IchiroCTG\n2026\n\n'
        'Esta es una aplicación desarrollada en flutter\n'
        'para ayudar a la busqueda de anime disponibles en diferentes'
        'plataformas de streaming\n'),
      ),
    );
  }
}