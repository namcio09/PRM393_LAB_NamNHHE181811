import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/app_exceptions.dart';
import '../models/user_session.dart';

class FirebaseGoogleAuthService {
  FirebaseGoogleAuthService();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile'],
  );

  bool _available = false;

  bool get isAvailable => _available;

  Future<bool> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _available = true;
    } catch (error) {
      debugPrint('Firebase init skipped: $error');
      _available = false;
    }
    return _available;
  }

  Future<UserSession> signIn() async {
    if (!_available) {
      throw AuthException(
        'Firebase/Google Sign-In is not configured. Follow the README setup.',
      );
    }

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw AuthException('Google Sign-In aborted by user');
    }

    final googleAuth = await googleUser.authentication;
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await firebase_auth.FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final user = userCredential.user;
    if (user == null) {
      throw AuthException('Unable to read Firebase user profile');
    }

    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw AuthException('Firebase did not return a valid token');
    }

    return UserSession(
      id: user.uid.hashCode,
      displayName: user.displayName ?? googleUser.displayName ?? 'Google User',
      token: token,
      email: user.email,
      avatarUrl: user.photoURL,
      provider: AuthProvider.google,
    );
  }

  Future<void> signOut() async {
    if (!_available) return;
    await firebase_auth.FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }
}
