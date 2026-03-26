import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'repositories/auth_repository.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'services/dummy_json_auth_api.dart';
import 'services/firebase_google_auth_service.dart';
import 'services/local_notification_service.dart';
import 'services/session_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = LocalNotificationService();
  final notificationsReady = await notificationService.initialize();
  final firebaseService = FirebaseGoogleAuthService();
  final authRepository = AuthRepository(
    api: DummyJsonAuthApi(),
    sessionStorage: SessionStorage(),
    firebaseService: firebaseService,
  );
  final googleReady = await authRepository.warmUpGoogle();

  final authController = AuthController(
    repository: authRepository,
    notificationService: notificationService,
  )
    ..setNotificationAvailability(notificationsReady)
    ..setGoogleAvailability(googleReady);

  unawaited(authController.bootstrap());

  runApp(Lab10App(controller: authController));
}

class Lab10App extends StatelessWidget {
  const Lab10App({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1C5D99),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    final theme = baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );

    return ChangeNotifierProvider.value(
      value: controller,
      child: MaterialApp(
        title: 'Lab 10 Authentication Suite',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const _RootRouter(),
      ),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return switch (controller.status) {
      AuthStatus.checking => const SplashScreen(),
      AuthStatus.unauthenticated => const LoginScreen(),
      AuthStatus.authenticated => const HomeScreen(),
    };
  }
}
