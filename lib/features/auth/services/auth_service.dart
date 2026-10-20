import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/app_user.dart';
import 'auth_exception.dart';

/// Contract defining all authentication operations required by Hisab.
abstract class BaseAuthService {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AppUser> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AppUser?> signInWithGoogle();

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerified();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updateDisplayName(String displayName);

  Future<void> signOut();
}

/// Production implementation of [BaseAuthService] backed by Firebase Authentication
/// and Google Sign-In.
class FirebaseAuthService implements BaseAuthService {
  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUser.fromFirebaseUser(user);
    });
  }

  @override
  AppUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return AppUser.fromFirebaseUser(user);
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          code: 'null-user',
          message: 'Sign in failed: user session not found.',
        );
      }
      return AppUser.fromFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      debugPrint('Firebase login exception: [${e.code}] ${e.message}');
      throw AuthException.fromFirebase(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      debugPrint('Unknown login exception: $e');
      throw AuthException.general(
        'Failed to log in. Please try again.',
        'unknown',
        e,
      );
    }
  }

  @override
  Future<AppUser> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          code: 'null-user',
          message: 'Account creation failed: user session not found.',
        );
      }

      // Update Firebase display name
      final trimmedName = displayName.trim();
      if (trimmedName.isNotEmpty) {
        try {
          await user.updateDisplayName(trimmedName);
          await user.reload();
        } catch (e) {
          debugPrint('Non-fatal display name update error: $e');
        }
      }

      // Send email verification
      try {
        await user.sendEmailVerification();
      } catch (e) {
        debugPrint('Non-fatal initial verification email error: $e');
      }

      final refreshedUser = _firebaseAuth.currentUser ?? user;
      return AppUser.fromFirebaseUser(refreshedUser);
    } on fb.FirebaseAuthException catch (e) {
      debugPrint('Firebase registration exception: [${e.code}] ${e.message}');
      throw AuthException.fromFirebase(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      debugPrint('Unknown registration exception: $e');
      throw AuthException.general(
        'Failed to create account. Please try again.',
        'unknown',
        e,
      );
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the Google account picker
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final fb.AuthCredential credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException(
          code: 'null-user',
          message: 'Google sign-in completed but user record was empty.',
        );
      }

      return AppUser.fromFirebaseUser(user);
    } on fb.FirebaseAuthException catch (e) {
      debugPrint('Firebase Google sign-in exception: [${e.code}] ${e.message}');
      throw AuthException.fromFirebase(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      final msg = e.toString().toLowerCase();
      if (msg.contains('canceled') ||
          msg.contains('cancelled') ||
          msg.contains('popup_closed_by_user')) {
        return null;
      }
      debugPrint('Google sign-in exception: $e');
      throw AuthException.general(
        'Google Sign-In failed. Please check your network and Google Play Services.',
        'google-signin-error',
        e,
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException(
        code: 'no-user',
        message: 'No active session found. Please log in first.',
      );
    }
    try {
      await user.sendEmailVerification();
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    } catch (e) {
      throw AuthException.general(
        'Failed to send verification email.',
        'unknown',
        e,
      );
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    try {
      await user.reload();
      final freshUser = _firebaseAuth.currentUser;
      return freshUser?.emailVerified ?? false;
    } catch (e) {
      debugPrint('Error reloading user for email verification: $e');
      return user.emailVerified;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    } catch (e) {
      throw AuthException.general(
        'Failed to send password reset email. Please try again.',
        'unknown',
        e,
      );
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    try {
      await user.updateDisplayName(displayName.trim());
      await user.reload();
    } catch (e) {
      debugPrint('Failed to update display name on Firebase: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Non-fatal Google signOut error: $e');
    }
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint('Firebase signOut error: $e');
    }
  }
}
