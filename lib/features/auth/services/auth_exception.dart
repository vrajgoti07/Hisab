import 'package:firebase_auth/firebase_auth.dart';

/// Typed domain exception for authentication errors across Firebase and OAuth providers.
class AuthException implements Exception {
  final String code;
  final String message;
  final Object? originalError;

  const AuthException({
    required this.code,
    required this.message,
    this.originalError,
  });

  /// Factory constructor to map [FirebaseAuthException] to a friendly [AuthException].
  factory AuthException.fromFirebase(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'invalid-email':
        message = 'The email address format is invalid.';
        break;
      case 'user-disabled':
        message = 'This user account has been disabled by an administrator.';
        break;
      case 'user-not-found':
        message = 'No account found with this email address.';
        break;
      case 'wrong-password':
      case 'invalid-credential':
        message = 'Incorrect email or password. Please try again.';
        break;
      case 'email-already-in-use':
        message = 'An account is already registered with this email.';
        break;
      case 'operation-not-allowed':
        message =
            'This sign-in method is currently disabled in Firebase Console.';
        break;
      case 'weak-password':
        message = 'The password is too weak. Please use at least 6 characters.';
        break;
      case 'too-many-requests':
        message =
            'Too many failed attempts. Please wait a moment and try again.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your internet connection.';
        break;
      case 'popup-closed-by-user':
      case 'sign_in_canceled':
        message = 'Sign-in was cancelled.';
        break;
      case 'account-exists-with-different-credential':
        message =
            'An account already exists with the same email using a different provider.';
        break;
      default:
        message = e.message ?? 'An unexpected authentication error occurred.';
    }

    return AuthException(code: e.code, message: message, originalError: e);
  }

  /// General factory constructor
  factory AuthException.general(
    String message, [
    String code = 'general',
    Object? originalError,
  ]) {
    return AuthException(
      code: code,
      message: message,
      originalError: originalError,
    );
  }

  @override
  String toString() => message;
}
