import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  User? get currentUser => _auth.currentUser;

  /// Datos directos del usuario autenticado
  String? get email => _auth.currentUser?.email;
  String? get uid   => _auth.currentUser?.uid;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Red de seguridad: si el usuario existe en Auth pero por algún
      // motivo no tiene documento en Firestore, lo crea (no pisa datos
      // existentes gracias al chequeo interno de createUserIfNotExists).
      if (_auth.currentUser?.email != null) {
        await _firestore.createUserIfNotExists(_auth.currentUser!.email!);
      }

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Error';
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crear documento base del usuario en Firestore
      await _firestore.createUserIfNotExists(email);

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Error desconocido';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}