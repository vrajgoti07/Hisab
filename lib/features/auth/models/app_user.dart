import 'package:firebase_auth/firebase_auth.dart' as fb;

/// Represents an authenticated user in the Hisab application.
class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;
  final bool isAnonymous;
  final String? providerId;

  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
    this.isAnonymous = false,
    this.providerId,
  });

  /// Factory constructor to create an [AppUser] from a Firebase [User].
  factory AppUser.fromFirebaseUser(fb.User user) {
    String? provider;
    if (user.providerData.isNotEmpty) {
      provider = user.providerData.first.providerId;
    }

    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
      providerId: provider,
    );
  }

  /// Whether the user signed in with Google (pre-verified by Google).
  bool get isGoogleUser =>
      providerId == 'google.com' ||
      (email != null && providerId?.contains('google') == true);

  /// Returns whether this account can access the protected app.
  /// Google and anonymous accounts are treated as verified,
  /// whereas email/password accounts must have [isEmailVerified] == true.
  bool get canAccessApp => isGoogleUser || isAnonymous || isEmailVerified;

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isEmailVerified,
    bool? isAnonymous,
    String? providerId,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      providerId: providerId ?? this.providerId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName &&
          isEmailVerified == other.isEmailVerified;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      isEmailVerified.hashCode;
}
