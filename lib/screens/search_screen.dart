import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Búsqueda')),
    body: const Center(
      child: Text('Funcionalidad de búsqueda'),
    ),
  );
}