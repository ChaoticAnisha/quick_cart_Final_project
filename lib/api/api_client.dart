import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../core/constants/app_constants.dart';

class ApiClient {
  late Dio _dio;
  final SharedPreferences _prefs;

  ApiClient(this._prefs) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _prefs.getString(AppConstants.keyAccessToken);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print(' [${options.method}] ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(' [${response.statusCode}] ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('[${e.response?.statusCode}] ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  // POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters);
  }

  // PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.put(path, data: data, queryParameters: queryParameters);
  }

  // DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  // UPLOAD IMAGE
  Future<Response> uploadImage(
    String path,
    File imageFile, {
    String fieldName = 'avatar',
  }) async {
    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    return await _dio.post(
      path,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      onSendProgress: (sent, total) {
        print(' Upload: ${(sent / total * 100).toStringAsFixed(0)}%');
      },
    );
  }
}
