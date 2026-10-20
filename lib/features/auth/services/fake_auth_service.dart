import 'dart:async';
import '../models/app_user.dart';
import 'auth_exception.dart';
import 'auth_service.dart';

/// Test and mock implementation of [BaseAuthService] for automated tests
/// and offline development.
class FakeAuthService implements BaseAuthService {
  AppUser? _user;
  final _controller = StreamController<AppUser?>.broadcast();
  bool shouldThrowError = false;
  String? errorMessage;
  bool isGoogleCanceled = false;

  FakeAuthService({AppUser? initialUser}) : _user = initialUser;

  @override
  Stream<AppUser?> get authStateChanges => _controller.stream;

  @override
  AppUser? get currentUser => _user;

  void emitUser(AppUser? user) {
    _user = user;
    _controller.add(user);
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (shouldThrowError) {
      throw AuthException(
        code: 'invalid-credential',
        message: errorMessage ?? 'Incorrect email or password.',
      );
    }
    final user = AppUser(
      uid: 'fake_uid_${email.hashCode}',
      email: email.trim(),
      displayName: 'Test User',
      isEmailVerified: true,
      providerId: 'password',
    );
    emitUser(user);
    return user;
  }

  @override
  Future<AppUser> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (shouldThrowError) {
      throw AuthException(
        code: 'email-already-in-use',
        message: errorMessage ?? 'An account already exists with this email.',
      );
    }
    final user = AppUser(
      uid: 'fake_uid_${email.hashCode}',
      email: email.trim(),
      displayName: displayName.trim(),
      isEmailVerified: false,
      providerId: 'password',
    );
    emitUser(user);
    return user;
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    if (isGoogleCanceled) return null;
    if (shouldThrowError) {
      throw AuthException(
        code: 'google-error',
        message: errorMessage ?? 'Google Sign-In failed.',
      );
    }
    const user = AppUser(
      uid: 'google_uid_12345',
      email: 'google.user@example.com',
      displayName: 'Google User',
      isEmailVerified: true,
      providerId: 'google.com',
    );
    emitUser(user);
    return user;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (shouldThrowError) {
      throw AuthException(
        code: 'too-many-requests',
        message: errorMessage ?? 'Too many requests.',
      );
    }
  }

  @override
  Future<bool> checkEmailVerified() async {
    if (_user != null) {
      final verifiedUser = _user!.copyWith(isEmailVerified: true);
      emitUser(verifiedUser);
      return true;
    }
    return false;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (shouldThrowError) {
      throw AuthException(
        code: 'invalid-email',
        message: errorMessage ?? 'Invalid email address.',
      );
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    if (_user != null) {
      emitUser(_user!.copyWith(displayName: displayName));
    }
  }

  @override
  Future<void> signOut() async {
    emitUser(null);
  }

  void dispose() {
    _controller.close();
  }
}
