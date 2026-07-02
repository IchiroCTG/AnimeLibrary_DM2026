import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Error desconocido';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}