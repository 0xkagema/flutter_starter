import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'app.dart';
import 'core/http/client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.instance.init();

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
