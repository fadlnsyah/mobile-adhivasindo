import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/content_model.dart';
import '../models/create_content_request.dart';

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

  Future<ContentModel> getContentById(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/contents/$id');
      final responseData = response.data;
      final content = responseData?['data'];

      if (content is! Map<String, dynamic>) {
        throw const ContentException('Content not found');
      }

      return ContentModel.fromJson(content);
    } on DioException catch (error) {
      throw ContentException(_resolveErrorMessage(error));
    }
  }

  Future<void> createContent(CreateContentRequest request) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/contents',
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw ContentException(_resolveErrorMessage(error));
    }
  }

  Future<void> updateContent(int id, CreateContentRequest request) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        '/contents/$id',
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw ContentException(_resolveErrorMessage(error));
    }
  }

  Future<void> deleteContent(int id) async {
    try {
      await _dio.delete<Map<String, dynamic>>('/contents/$id');
    } on DioException catch (error) {
      throw ContentException(_resolveErrorMessage(error));
    }
  }

  String _resolveErrorMessage(DioException error) {
    if (error.response?.statusCode == 401) {
      return 'Unauthorized';
    }

    if (error.response?.statusCode == 403) {
      return 'You are not allowed to modify this content.';
    }

    if (error.response?.statusCode == 404) {
      return 'Content not found';
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        error.response == null) {
      return 'Unable to connect to server';
    }

    final responseData = error.response?.data;

    if (error.response?.statusCode == 422 &&
        responseData is Map<String, dynamic>) {
      final errors = responseData['errors'];

      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }
    }

    if (responseData is Map<String, dynamic> &&
        responseData['message'] is String) {
      return responseData['message'] as String;
    }

    return 'Error loading contents';
  }
}
