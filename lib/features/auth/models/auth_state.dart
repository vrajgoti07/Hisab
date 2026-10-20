/// Application authentication state representing the active user session.
class AuthState {
  final bool isLoggedIn;
  final String? uid;
  final String? email;
  final String? userName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool isEmailVerified;
  final bool isGoogleUser;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.isLoggedIn = false,
    this.uid,
    this.email,
    this.userName,
    this.photoUrl,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.isGoogleUser = false,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? uid,
    String? email,
    String? userName,
    String? photoUrl,
    String? phoneNumber,
    bool? isEmailVerified,
    bool? isGoogleUser,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isGoogleUser: isGoogleUser ?? this.isGoogleUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
