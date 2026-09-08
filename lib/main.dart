import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: ToastificationWrapper(
        config: ToastificationConfig(
          alignment: Alignment.bottomCenter,
          animationDuration: const Duration(milliseconds: 300),
        ),
        child: Application(),
      ),
    ),
  );
}
