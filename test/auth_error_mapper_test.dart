import 'package:flutter_test/flutter_test.dart';
import 'package:racecourse_tracks/data/services/auth_error_mapper.dart';

void main() {
  group('AuthErrorMapper', () {
    test('maps user-not-found to readable message', () {
      final fakeError = _FakeFirebaseAuthException('user-not-found');
      final message = AuthErrorMapper.mapException(fakeError);
      expect(message, contains('No account found'));
    });

    test('maps wrong-password to readable message', () {
      final fakeError = _FakeFirebaseAuthException('wrong-password');
      final message = AuthErrorMapper.mapException(fakeError);
      expect(message, contains('Incorrect password'));
    });

    test('maps unknown code with fallback', () {
      final fakeError = _FakeFirebaseAuthException('some-unknown-code');
      final message = AuthErrorMapper.mapException(fakeError);
      expect(message, contains('some-unknown-code'));
    });

    test('handles non-Firebase exceptions gracefully', () {
      final message = AuthErrorMapper.mapException(Exception('generic'));
      expect(message, isNotEmpty);
    });
  });
}

/// Minimal fake for testing without depending on firebase_auth internals.
class _FakeFirebaseAuthException implements Exception {
  final String code;
  _FakeFirebaseAuthException(this.code);

  @override
  String toString() => 'FirebaseAuthException($code)';
}
