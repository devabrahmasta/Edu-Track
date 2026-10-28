import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  static final _loginUri = Uri.parse('https://dummyjson.com/auth/login');
  static const requestTimeout = Duration(seconds: 12);

  final http.Client _client;

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    late final http.Response response;
    try {
      response = await _client
          .post(
            _loginUri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(requestTimeout);
    } on TimeoutException {
      throw const AuthUnavailableException();
    } on http.ClientException {
      throw const AuthUnavailableException();
    }

    if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      throw const InvalidCredentialsException();
    }
    if (response.statusCode >= 500) {
      throw const AuthUnavailableException();
    }
    if (response.statusCode != 200) {
      throw const AuthException(
        'Layanan login sedang bermasalah. Coba beberapa saat lagi.',
      );
    }

    late final Map<String, dynamic> payload;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw const AuthException(
          'Respons login tidak sesuai format yang diharapkan.',
        );
      }
      payload = Map<String, dynamic>.from(decoded);
    } on FormatException {
      throw const AuthException(
        'Respons login tidak dapat dibaca. Silakan coba kembali.',
      );
    } on TypeError {
      throw const AuthException(
        'Respons login tidak sesuai format yang diharapkan.',
      );
    }

    final token =
        payload['accessToken'] as String? ?? payload['token'] as String?;
    if (token == null || token.isEmpty) {
      throw const AuthException(
        'Respons login tidak lengkap. Silakan coba kembali.',
      );
    }

    try {
      return UserModel.fromJson({...payload, 'token': token});
    } on TypeError {
      throw const AuthException('Data akun dari layanan login tidak lengkap.');
    }
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthUnavailableException extends AuthException {
  const AuthUnavailableException()
    : super('Tidak dapat terhubung ke layanan login.');
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException()
    : super('Username atau kata sandi tidak sesuai.');
}
