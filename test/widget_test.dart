import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporpak/screens/auth/firebase_setup_screen.dart';

void main() {
  testWidgets('firebase setup screen shows guidance', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FirebaseSetupScreen(errorMessage: 'Firebase belum dikonfigurasi'),
      ),
    );

    expect(find.text('Firebase belum siap'), findsOneWidget);
    expect(find.text('Checklist setup:'), findsOneWidget);
  });
}
