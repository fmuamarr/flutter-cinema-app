import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'log_response.dart';

enum MethodRequest { get, post, put, delete, patch }

class ApiProvider {
  final Dio dio;

  ApiProvider({
    required String baseUrl,
    int duration = 60,
    Map<String, String>? defaultHeaders,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: Duration(seconds: duration),
           receiveTimeout: Duration(seconds: duration),
           headers:
               defaultHeaders ??
               {
                 'Content-Type': 'application/json',
                 'Accept': 'application/json',
               },
         ),
       ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 150,
      ),
    );
  }

  Future<dynamic> call(
    String url, {
    MethodRequest method = MethodRequest.get,
    dynamic request,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? token,
    bool useFormData = false,
  }) async {
    headers ??= {};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode && request != null) {
      debugPrint(' API Request [$url]:');
      if (request is Map<String, dynamic>) {
        LogResponse.logJsonResponse(url, request);
      } else {
        debugPrint(request.toString());
      }
    }

    dynamic reqBody;
    if (request != null) {
      if (useFormData && request is Map<String, dynamic>) {
        reqBody = FormData.fromMap(request);
      } else {
        reqBody = request;
      }
    }

    Response response;

    try {
      final options = Options(headers: headers);

      switch (method) {
        case MethodRequest.get:
          response = await dio.get(
            url,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case MethodRequest.post:
          response = await dio.post(
            url,
            data: reqBody,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case MethodRequest.put:
          response = await dio.put(
            url,
            data: reqBody,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case MethodRequest.delete:
          response = await dio.delete(
            url,
            data: reqBody,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case MethodRequest.patch:
          response = await dio.patch(
            url,
            data: reqBody,
            queryParameters: queryParameters,
            options: options,
          );
          break;
      }

      if (kDebugMode && response.data != null) {
        debugPrint('API Response [$url]:');
        if (response.data is Map<String, dynamic>) {
          LogResponse.logPlainJson(url, response.data as Map<String, dynamic>);
        }
      }

      return response.data;
    } on DioException catch (e) {
      debugPrint('DioException [$url]: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error [$url]: $e');
      rethrow;
    }
  }

  // Future<void> downloadFile(
  //   String url,
  //   String savePath, {
  //   Function(int received, int total)? onProgress,
  // }) async {
  //   await dio.download(
  //     url,
  //     savePath,
  //     onReceiveProgress: (received, total) {
  //       if (onProgress != null) {
  //         onProgress(received, total);
  //       }
  //     },
  //   );
  // }
}
