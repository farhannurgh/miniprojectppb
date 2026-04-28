import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/constants/app_colors.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'screens/auth/firebase_setup_screen.dart';
import 'screens/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? firebaseError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    firebaseError = error.toString();
  }

  if (firebaseError == null) {
    try {
      await NotificationService.initialize();
    } catch (_) {}
  }

  runApp(LaporPakApp(firebaseError: firebaseError));
}

class LaporPakApp extends StatelessWidget {
  const LaporPakApp({super.key, this.firebaseError});

  final String? firebaseError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LaporPak',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        scaffoldBackgroundColor: AppColors.surface,
        useMaterial3: true,
      ),
      home: firebaseError == null
          ? const SplashScreen()
          : FirebaseSetupScreen(errorMessage: firebaseError!),
    );
  }
}
