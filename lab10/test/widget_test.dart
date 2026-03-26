import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lab10/controllers/auth_controller.dart';
import 'package:lab10/repositories/auth_repository.dart';
import 'package:lab10/screens/login_screen.dart';
import 'package:lab10/services/dummy_json_auth_api.dart';
import 'package:lab10/services/firebase_google_auth_service.dart';
import 'package:lab10/services/local_notification_service.dart';
import 'package:lab10/services/session_storage.dart';

void main() {
  testWidgets('Login screen renders headline and CTA', (tester) async {
    final controller = AuthController(
      repository: AuthRepository(
        api: DummyJsonAuthApi(),
        sessionStorage: SessionStorage(),
        firebaseService: FirebaseGoogleAuthService(),
      ),
      notificationService: LocalNotificationService(),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text('Authenticate'), findsOneWidget);
    expect(find.textContaining('DummyJSON'), findsOneWidget);
    expect(find.text('Login with API'), findsOneWidget);
  });
}
