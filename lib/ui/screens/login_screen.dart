import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void _goToLobby(BuildContext ctx) =>
      Navigator.of(ctx).pushReplacementNamed('/lobby');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (prev, next) {
      next.whenData((user) {
        if (user != null) {
          _goToLobby(context);
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Multiplayer Tic-Tac-Toe',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                  onPressed: () => ref
                      .read(authViewModelProvider.notifier)
                      .signInWithGoogle(),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.facebook),
                  label: const Text('Sign in with Facebook'),
                  onPressed: () => ref
                      .read(authViewModelProvider.notifier)
                      .signInWithFacebook(),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  child: const Text('Continue with Email'),
                  onPressed: () {
                    _showEmailDialog(context, ref);
                  },
                ),
                const SizedBox(height: 24),
                if (authState.isLoading) const CircularProgressIndicator(),
                if (authState.hasError)
                  Text(
                    'Error: ${authState.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEmailDialog(BuildContext ctx, WidgetRef ref) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          title: const Text('Email Login / Register'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Display name (required for register)',
                ),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            //  LOGIN BUTTON
            ElevatedButton(
              onPressed: () async {
                final email = emailCtrl.text.trim();
                final pass = passCtrl.text.trim();

                await ref
                    .read(authViewModelProvider.notifier)
                    .signInWithEmail(email, pass);

                Navigator.pop(ctx);
              },
              child: const Text('Login'),
            ),

            //  REGISTER BUTTON
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final email = emailCtrl.text.trim();
                final pass = passCtrl.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Display name is required to register'),
                    ),
                  );
                  return;
                }

                await ref
                    .read(authViewModelProvider.notifier)
                    .registerWithEmail(email, pass, name);

                Navigator.pop(ctx);
              },
              child: const Text('Register'),
            ),
          ],
        );
      },
    );
  }
}
