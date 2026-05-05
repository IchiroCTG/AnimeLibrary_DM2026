import 'package:flutter/material.dart';
import '../models/anime.dart';

class DetailScreen extends StatelessWidget {
  final Anime anime;
  const DetailScreen({super.key, required this.anime});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(anime.title)),
    body: const Center(child:Text('Detalle del Anime')),
  );
}