import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_user.dart';
import '../services/auth_exception.dart';
import '../services/auth_service.dart';
import '../services/fake_auth_service.dart';

/// State of auth action in progress (login/signup/reset/verification).
class AuthControllerState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const AuthControllerState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  AuthControllerState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AuthControllerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

/// Controller managing async authentication actions and UI feedback.
class AuthController extends StateNotifier<AuthControllerState> {
  final BaseAuthService _authService;

  AuthController(this._authService) : super(const AuthControllerState());

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    );
    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred during login.',
      );
      return false;
    }
  }

  Future<bool> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    );
    try {
      await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Verification email sent. Please check your inbox.',
      );
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred during registration.',
      );
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    );
    try {
      final user = await _authService.signInWithGoogle();
      state = state.copyWith(isLoading: false);
      return user != null;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Google Sign-In failed. Please try again.',
      );
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    );
    try {
      await _authService.sendPasswordResetEmail(email);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password reset link sent! Check your email inbox.',
      );
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send password reset email.',
      );
      return false;
    }
  }

  Future<bool> resendVerificationEmail() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    );
    try {
      await _authService.sendEmailVerification();
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Verification email resent! Check your spam or inbox.',
      );
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to resend verification email.',
      );
      return false;
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      final isVerified = await _authService.checkEmailVerified();
      return isVerified;
    } catch (_) {
      return false;
    }
  }

  Future<void> updateDisplayName(String name) async {
    try {
      await _authService.updateDisplayName(name);
    } catch (_) {}
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.signOut();
    } finally {
      state = const AuthControllerState();
    }
  }
}

/// Provides the authentication service implementation.
/// Gracefully falls back to [FakeAuthService] in unit/widget test environments
/// where Firebase has not been initialized.
final authServiceProvider = Provider<BaseAuthService>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirebaseAuthService();
    }
  } catch (_) {}
  return FakeAuthService();
});

/// Stream of authenticated user changes directly from Firebase.
final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.authStateChanges;
});

/// Currently authenticated user snapshot.
final currentUserProvider = Provider<AppUser?>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.currentUser;
});

/// Controller for auth UI flows and state management.
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthControllerState>((ref) {
      final service = ref.watch(authServiceProvider);
      return AuthController(service);
    });
