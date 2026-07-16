import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/login_response.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService({DioClient? dioClient}) : _dio = (dioClient ?? DioClient()).dio;

  final Dio _dio;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/login',
        data: {'email': email, 'password': password},
      );

      return LoginResponse.fromJson(response.data ?? {});
    } on DioException catch (error) {
      throw AuthException(_resolveErrorMessage(error));
    }
  }

  String _resolveErrorMessage(DioException error) {
    if (error.response?.statusCode == 401) {
      return 'Invalid credentials';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        error.response == null) {
      return 'Unable to connect to server';
    }

    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic> &&
        responseData['message'] is String) {
      return responseData['message'] as String;
    }

    return 'Unable to login';
  }
}
