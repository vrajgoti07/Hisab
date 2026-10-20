class AuthState {
  final bool isLoggedIn;
  final String? phoneNumber;
  final String? email;
  final String? userName;
  final bool isOtpSent;
  final String? activeOtp;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.isLoggedIn = false,
    this.phoneNumber,
    this.email,
    this.userName,
    this.isOtpSent = false,
    this.activeOtp,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? phoneNumber,
    String? email,
    String? userName,
    bool? isOtpSent,
    String? activeOtp,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      activeOtp: activeOtp ?? this.activeOtp,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
