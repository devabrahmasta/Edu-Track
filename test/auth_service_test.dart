import 'dart:convert';

import 'package:edu_track/core/storage_service.dart';
import 'package:edu_track/features/auth/providers/auth_provider.dart';
import 'package:edu_track/features/auth/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService', () {
    test('posts credentials and parses the authenticated user', () async {
      late http.Request capturedRequest;
      final client = _FakeClient((request) async {
        capturedRequest = request as http.Request;
        return _response(
          200,
          jsonEncode({
            'id': 1,
            'username': 'emilys',
            'firstName': 'Emily',
            'lastName': 'Johnson',
            'email': 'emily.johnson@x.dummyjson.com',
            'accessToken': 'demo-token',
          }),
        );
      });

      final user = await AuthService(
        client: client,
      ).login(username: 'emilys', password: 'emilyspass');

      expect(
        capturedRequest.url,
        Uri.parse('https://dummyjson.com/auth/login'),
      );
      expect(capturedRequest.method, 'POST');
      expect(jsonDecode(capturedRequest.body), {
        'username': 'emilys',
        'password': 'emilyspass',
      });
      expect(user.fullName, 'Emily Johnson');
      expect(user.token, 'demo-token');
      expect(user.isOfflineSession, isFalse);
    });

    test('does not classify invalid credentials as an unavailable API', () {
      final service = AuthService(
        client: _FakeClient(
          (_) async => _response(401, '{"message":"Invalid credentials"}'),
        ),
      );

      expect(
        service.login(username: 'wrong', password: 'credentials'),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });
  });

  group('AuthProvider offline demo session', () {
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = StorageService(await SharedPreferences.getInstance());
    });

    test('accepts only the demo account when the API is unavailable', () async {
      final provider = AuthProvider(
        storageService: storage,
        authService: AuthService(
          client: _FakeClient(
            (_) async => throw http.ClientException('offline'),
          ),
        ),
      );

      final didSignIn = await provider.signIn(
        username: AuthProvider.demoUsername,
        password: AuthProvider.demoPassword,
      );

      expect(didSignIn, isTrue);
      expect(provider.user?.isOfflineSession, isTrue);

      final restoredProvider = AuthProvider(
        storageService: storage,
        authService: AuthService(
          client: _FakeClient((_) async => _response(500, '{}')),
        ),
      );
      expect(await restoredProvider.restoreSession(), isTrue);
      expect(restoredProvider.user?.username, AuthProvider.demoUsername);

      await restoredProvider.logout();
      expect(storage.getBool(StorageService.isLoggedInKey), isNull);
      expect(storage.getString(StorageService.userDataKey), isNull);
    });

    test('rejects other credentials when the API is unavailable', () async {
      final provider = AuthProvider(
        storageService: storage,
        authService: AuthService(
          client: _FakeClient(
            (_) async => throw http.ClientException('offline'),
          ),
        ),
      );

      final didSignIn = await provider.signIn(
        username: 'someone',
        password: 'password',
      );

      expect(didSignIn, isFalse);
      expect(provider.user, isNull);
      expect(provider.errorMessage, contains('demo offline'));
    });
  });
}

http.StreamedResponse _response(int statusCode, String body) {
  return http.StreamedResponse(Stream.value(utf8.encode(body)), statusCode);
}

class _FakeClient extends http.BaseClient {
  _FakeClient(this._handler);

  final Future<http.StreamedResponse> Function(http.BaseRequest request)
  _handler;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      _handler(request);
}
