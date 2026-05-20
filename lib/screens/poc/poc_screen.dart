import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PocScreen extends StatefulWidget {
  const PocScreen({super.key});

  @override
  State<PocScreen> createState() => _PocScreenState();
}

class _PocScreenState extends State<PocScreen> {
  String _resultado = 'Sin resultados aún';
  bool _cargando = false;

  Future<void> _testFirestore() async {
    setState(() {
      _cargando = true;
      _resultado = 'Conectando a Firestore...';
    });

    try {
      final snap = await FirebaseFirestore.instance
          .collection('animes')
          .limit(5)
          .get();

      setState(() {
        _cargando = false;
        if (snap.docs.isEmpty) {
          _resultado = '✓ Conexión exitosa\nColección vacía (0 documentos)\nFirestore responde correctamente.';
        } else {
          final nombres = snap.docs.map((d) => d.id).join('\n');
          _resultado = '✓ Conexión exitosa\n${snap.docs.length} documentos:\n$nombres';
        }
      });
    } catch (e) {
      setState(() {
        _cargando = false;
        _resultado = '✗ Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'PoC — Firestore',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _cargando ? null : _testFirestore,
              child: Text(_cargando ? 'Conectando...' : 'Probar Firestore'),
            ),
            const SizedBox(height: 32),
            Text(
              _resultado,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}