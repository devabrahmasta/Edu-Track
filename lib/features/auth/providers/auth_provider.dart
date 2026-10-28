import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../core/storage_service.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required this._storageService, required this._authService});

  static const demoUsername = 'emilys';
  static const demoPassword = 'emilyspass';

  final StorageService _storageService;
  final AuthService _authService;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get bookmarkCount =>
      _storageService.getStringList('bookmarks')?.length ?? 0;

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> restoreSession() async {
    final isLoggedIn =
        _storageService.getBool(StorageService.isLoggedInKey) ?? false;
    if (!isLoggedIn) return false;

    final userData = _storageService.getString(StorageService.userDataKey);
    if (userData == null) {
      await _storageService.clearSession();
      return false;
    }

    try {
      final json = Map<String, dynamic>.from(jsonDecode(userData) as Map);
      _user = UserModel.fromJson(json);
    } on FormatException {
      await _storageService.clearSession();
      throw const AuthException(
        'Data sesi tersimpan rusak. Silakan masuk kembali.',
      );
    } on TypeError {
      await _storageService.clearSession();
      throw const AuthException(
        'Data sesi tersimpan tidak valid. Silakan masuk kembali.',
      );
    }

    if (_user!.username.isEmpty) {
      await _storageService.clearSession();
      _user = null;
      throw const AuthException(
        'Data sesi tersimpan tidak lengkap. Silakan masuk kembali.',
      );
    }

    notifyListeners();
    return true;
  }

  Future<bool> signIn({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(
        username: username,
        password: password,
      );
      await _saveSession(user);
      return true;
    } on InvalidCredentialsException catch (error) {
      _errorMessage = error.message;
      return false;
    } on AuthUnavailableException catch (error) {
      if (username == demoUsername && password == demoPassword) {
        await _saveSession(
          const UserModel(
            id: 1,
            username: demoUsername,
            firstName: 'Emily',
            lastName: 'Johnson',
            email: 'emily.johnson@x.dummyjson.com',
            isOfflineSession: true,
          ),
        );
        return true;
      }
      _errorMessage =
          '${error.message} Mode demo offline hanya tersedia untuk akun contoh.';
      return false;
    } on AuthException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveSession(UserModel user) async {
    await _storageService.setString(
      StorageService.userDataKey,
      jsonEncode(user.toJson()),
    );
    await _storageService.setBool(StorageService.isLoggedInKey, true);
    _user = user;
  }

  Future<void> logout() async {
    await _storageService.clearSession();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
