import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);
}

class SignInScreen extends StatefulWidget {
  final FutureOr<void> Function(Credentials credentials) onSignIn;

  const SignInScreen({required this.onSignIn, super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Card(
        child: Container(
          constraints: BoxConstraints.loose(const Size(600, 600)),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign in',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 5),
              TextField(
                decoration: const InputDecoration(labelText: 'Username'),
                controller: _usernameController,
              ),
              SizedBox(height: 5),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: () {
                          context.go('/reset-password');
                        },
                        child: Text('Forgot Password?'),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await widget.onSignIn(
                                    Credentials(
                                      _usernameController.text,
                                      _passwordController.text,
                                    ),
                                  );
                                } catch (_) {
                                  // Error is handled by caller (toast in router)
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                        child: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Sign in'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
