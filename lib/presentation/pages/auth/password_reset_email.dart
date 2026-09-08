import 'package:flutter/material.dart';
import 'package:flutter_starter/extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PasswordResetEmailPage extends StatefulWidget {
  const PasswordResetEmailPage({super.key});

  @override
  State<PasswordResetEmailPage> createState() => _PasswordResetEmailPageState();
}

class _PasswordResetEmailPageState extends State<PasswordResetEmailPage> {
  final _emailController = TextEditingController();

  bool _isSuccess = false;

  Widget _successMessage(String email) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // success lottie animation
        SizedBox(
          height: 200,
          child: Lottie.asset('assets/lottie/success.json', repeat: false),
        ),
        SizedBox(height: 5),
        Text(
          'A password reset link has been sent to $email. Please check your email to reset your password.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 5),
        ElevatedButton(
          onPressed: () {
            //navigate back to the sign-in page
            context.go('/sign-in');
          },
          child: const Text('Back to Sign In'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            constraints: BoxConstraints.loose(const Size(600, 600)),
            padding: const EdgeInsets.all(16),
            child: _isSuccess
                ? _successMessage(_emailController.text)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reset Password',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      // instructions
                      SizedBox(height: 5),
                      Text(
                        'Enter your email address below and we will send you a link to reset your password.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 5),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        controller: _emailController,
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                //navigate back to the sign-in page
                                context.go('/sign-in');
                              },
                              child: const Text('Cancel'),
                            ),
                            SizedBox(width: 5),

                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  // TODO: implement password reset logic to the auth service and hook it here

                                  await Future.delayed(
                                    const Duration(seconds: 3),
                                  ); // Simulate a network call
                                  // Handle password reset logic here
                                  final email = _emailController.text;
                                  // You can call your password reset function here
                                  context.showSuccessToast(
                                    'Password reset requested for email: $email',
                                  );

                                  setState(() {
                                    _isSuccess = true;
                                  });
                                } catch (e) {
                                  context.showErrorToast(
                                    'An error occurred: $e',
                                  );
                                }
                              },
                              child: const Text('Send Reset Link'),
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
}
