import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class FirebaseSetupScreen extends StatelessWidget {
  const FirebaseSetupScreen({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Firebase belum siap',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Aplikasi berhasil dibuka, tetapi konfigurasi Firebase '
                        'masih belum lengkap. Lanjutkan setup Firebase lalu jalankan ulang aplikasi.',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Checklist setup:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('1. Jalankan flutter pub get'),
                      const Text('2. Buat project Firebase'),
                      const Text(
                        '3. Tambahkan google-services.json ke android/app',
                      ),
                      const Text('4. Jalankan flutterfire configure'),
                      const Text('5. Jalankan ulang flutter run'),
                      const SizedBox(height: 16),
                      Text(
                        'Detail error:\n$errorMessage',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
