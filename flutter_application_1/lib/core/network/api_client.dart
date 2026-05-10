import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/app_exception.dart';
import '../storage/token_storage.dart';

class ApiClient {
  ApiClient(this._tokenStorage)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            headers: {'Accept': 'application/json'},
          ),
        );

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<Options> _options({Map<String, dynamic>? headers}) async {
    final token = await _tokenStorage.getToken();
    final mergedHeaders = <String, dynamic>{...?headers};
    if (token != null && token.isNotEmpty) mergedHeaders['Authorization'] = 'Bearer $token';
    return Options(headers: mergedHeaders);
  }

  Future<dynamic> get(String path) async {
    try {
      final res = await _dio.get(path, options: await _options());
      return res.data;
    } on DioException catch (e) {
      throw AppException(_parseError(e));
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    try {
      final res = await _dio.post(path, data: data, options: await _options(headers: {'Content-Type': 'application/json'}));
      return res.data;
    } on DioException catch (e) {
      throw AppException(_parseError(e));
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> data) async {
    try {
      final res = await _dio.put(path, data: data, options: await _options(headers: {'Content-Type': 'application/json'}));
      return res.data;
    } on DioException catch (e) {
      throw AppException(_parseError(e));
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final res = await _dio.delete(path, options: await _options());
      return res.data;
    } on DioException catch (e) {
      throw AppException(_parseError(e));
    }
  }

  String _parseError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'] ?? data['error'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return e.message ?? 'Network error';
  }
}
