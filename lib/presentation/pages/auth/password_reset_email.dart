import 'package:flutter/material.dart';
import 'package:flutter_starter/extensions.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

class PasswordResetEmailPage extends StatefulWidget {
  const PasswordResetEmailPage({super.key});

  @override
  State<PasswordResetEmailPage> createState() => _PasswordResetEmailPageState();
}

class _PasswordResetEmailPageState extends State<PasswordResetEmailPage> {
  final _emailController = TextEditingController();

  bool _isSuccess = false;

  Widget _successMessage(String email) {
    final l10n = _getAppLocalizations(context);

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
          l10n.password_reset_email_sent(email),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 5),
        ElevatedButton(
          onPressed: () {
            //navigate back to the sign-in page
            context.go('/sign-in');
          },
          child: Text(l10n.back_to_sign_in),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _getAppLocalizations(context);

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
                        l10n.reset_password,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      // instructions
                      SizedBox(height: 5),
                      Text(
                        l10n.password_reset_instructions,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(labelText: l10n.email),
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
                              child: Text(l10n.cancel),
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
                                  if (!context.mounted) return;
                                  final email = _emailController.text;
                                  // You can call your password reset function here
                                  context.showSuccessToast(
                                    l10n.password_reset_requested(email),
                                  );

                                  setState(() {
                                    _isSuccess = true;
                                  });
                                } catch (e) {
                                  context.showErrorToast(
                                    l10n.error_occurred(e.toString()),
                                  );
                                }
                              },
                              child: Text(l10n.send_reset_link),
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
