import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/content_model.dart';

class ContentException implements Exception {
  const ContentException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ContentService {
  ContentService({DioClient? dioClient})
    : _dio = (dioClient ?? DioClient()).dio;

  final Dio _dio;

  Future<List<ContentModel>> getContents() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/contents');
      final responseData = response.data;
      final contents = responseData?['data'];

      if (contents is! List) {
        return [];
      }

      return contents
          .whereType<Map<String, dynamic>>()
          .map(ContentModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw ContentException(_resolveErrorMessage(error));
    }
  }

  String _resolveErrorMessage(DioException error) {
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

    return 'Error loading contents';
  }
}
