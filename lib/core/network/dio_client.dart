import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';

class DioClient {
  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: const {
            Headers.acceptHeader: Headers.jsonContentType,
            Headers.contentTypeHeader: Headers.jsonContentType,
          },
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('[DIO] ${options.method} ${options.uri}');
          handler.next(options);
        },
        onError: (error, handler) {
          debugPrint('[DIO] ERROR ${error.requestOptions.uri}');
          handler.next(error);
        },
      ),
    );
  }

  final Dio dio;
}
