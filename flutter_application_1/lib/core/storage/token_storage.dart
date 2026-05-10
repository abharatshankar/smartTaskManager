import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _tokenKey = 'auth_token';
  static const _usernameKey = 'auth_username';

  final FlutterSecureStorage _storage;

  const TokenStorage(this._storage);

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<void> saveUsername(String username) => _storage.write(key: _usernameKey, value: username);
  Future<String?> getUsername() => _storage.read(key: _usernameKey);
  Future<void> clearUsername() => _storage.delete(key: _usernameKey);

  Future<void> clearAll() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _usernameKey);
  }
}
