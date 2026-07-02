import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../navigation/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final authVm = context.read<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton( onPressed: _loading ? null : () async {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                final navigator = Navigator.of(context);

                final error = await authVm.signIn(
                  _emailController.text,
                  _passwordController.text,
                );

                if (!mounted) return;

                if (error == null) {
                  navigator.pushReplacementNamed(AppRoutes.main);
                } else {
                  setState(() {
                    _error = error;
                  });
                }

                setState(() {
                  _loading = false;
                });
              },
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Ingresar'),
            ),
                const SizedBox(height: 8),
            TextButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() {
                        _loading = true;
                        _error = null;
                      });

                      final error = await authVm.register(
                        _emailController.text,
                        _passwordController.text,
                      );

                      setState(() {
                        _loading = false;
                        _error = error;
                      });
                    },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}