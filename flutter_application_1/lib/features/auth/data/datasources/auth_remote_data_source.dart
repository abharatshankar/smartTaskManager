import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  AuthRemoteDataSource({required this.apiClient, required this.tokenStorage});

  Future<UserModel> login(String email, String password) async {
    final data = await apiClient.post(ApiConstants.loginPath, {'email': email, 'password': password});
    final token = data['access_token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Login token missing from server response');
    }
    await tokenStorage.saveToken(token);
    await tokenStorage.saveUsername((data['username'] ?? '') as String);
    return me();
  }

  Future<void> register(String username, String email, String password) async {
    await apiClient.post(ApiConstants.registerPath, {'username': username, 'email': email, 'password': password});
  }

  Future<UserModel> me() async {
    final data = await apiClient.get(ApiConstants.mePath);
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> logout() async {
    try {
      await apiClient.post(ApiConstants.logoutPath, {});
    } catch (_) {}
    await tokenStorage.clearAll();
  }
}
