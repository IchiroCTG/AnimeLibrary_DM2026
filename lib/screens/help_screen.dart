import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ayuda')),
    body: const Center(
      child: Text('¿Necesitas ayuda? Contáctanos')),
  );
}