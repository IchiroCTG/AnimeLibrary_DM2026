import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _db.collection('users').doc(_uid);

  Future<void> createUserIfNotExists(String email) async {
    final snap = await _userDoc.get();

    if (!snap.exists) {
      await _userDoc.set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ── Perfil / datos del usuario ─────────────────────────────
  /// Guarda (merge) los datos de perfil/configuración del usuario.
  /// No pisa otros campos existentes en el documento (favoritos aparte,
  /// que viven en una subcolección).
  Future<void> saveProfile(Map<String, dynamic> data) async {
    await _userDoc.set(
      {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Devuelve los datos de perfil guardados en Firestore, o null si el
  /// documento no existe todavía (p. ej. usuario recién migrado).
  Future<Map<String, dynamic>?> getProfile() async {
    final snap = await _userDoc.get();
    return snap.data();
  }

  // ── Favoritos ───────────────────────────────────────────────
  // Cada anime guarda un documento con UN CAMPO BOOLEANO POR LISTA
  // (saved / watching / completed / pending), en vez de un solo campo
  // 'list'. Esto permite que un mismo anime pertenezca a varias listas
  // a la vez sin que una sobreescriba a la otra, y evita que al sacarlo
  // de una lista se borre por error su pertenencia a otra.
  Future<void> addFavorite(String animeId, String list) async {
    await _userDoc.collection('favorites').doc(animeId).set(
      {list: true},
      SetOptions(merge: true),
    );
  }

  Future<void> removeFavorite(String animeId, String list) async {
    await _userDoc.collection('favorites').doc(animeId).set(
      {list: false},
      SetOptions(merge: true),
    );
  }

  Future<void> loadFavoritesInto({
    required Set<String> saved,
    required Set<String> watching,
    required Set<String> completed,
    required Set<String> pending,
  }) async {
    final snap = await _userDoc.collection('favorites').get();

    for (final doc in snap.docs) {
      final data = doc.data();
      if (data['saved'] == true) saved.add(doc.id);
      if (data['watching'] == true) watching.add(doc.id);
      if (data['completed'] == true) completed.add(doc.id);
      if (data['pending'] == true) pending.add(doc.id);
    }
  }
}