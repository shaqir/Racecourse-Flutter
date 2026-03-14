import 'package:firebase_auth/firebase_auth.dart';

/// Maps Firebase exception codes to user-facing error messages.
///
/// Firebase throws [FirebaseAuthException] with machine-readable codes.
/// This mapper converts them to human-readable strings for display.
class AuthErrorMapper {
  static String mapException(Object error) {
    if (error is FirebaseAuthException) {
      return _mapFirebaseCode(error.code);
    }
    if (error is FirebaseException) {
      return error.message ?? 'An unexpected error occurred';
    }
    return error.toString();
  }

  static String _mapFirebaseCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address';
      case 'wrong-password':
        return 'Incorrect password — please try again';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts — please try again later';
      case 'email-already-in-use':
        return 'An account with this email already exists';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'network-request-failed':
        return 'Network error — check your connection';
      case 'requires-recent-login':
        return 'Please sign in again to complete this action';
      case 'invalid-credential':
        return 'Invalid credentials — please try again';
      default:
        return 'Authentication failed ($code)';
    }
  }
}
