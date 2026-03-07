import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
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
        contentType: 'application/json',
        responseType: ResponseType.json,
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
        onError: (DioException e, handler) async {
          print('[${e.response?.statusCode}] ${e.message}');
          if (e.response?.statusCode == 401) {
            await _prefs.remove(AppConstants.keyAccessToken);
            await _prefs.remove(AppConstants.keyUserId);
            await _prefs.setBool(AppConstants.keyIsLoggedIn, false);
          }
          return handler.next(e);
        },
      ),
    );
  }

  // GET — no Content-Type header to avoid CORS preflight on simple requests
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(contentType: null),
    );
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

  // PATCH
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.patch(path, data: data, queryParameters: queryParameters);
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

  // UPLOAD IMAGE — uses http.MultipartRequest which works reliably on web & mobile
  Future<Map<String, dynamic>> uploadImage(
    String path,
    XFile imageFile, {
    String fieldName = 'avatar',
  }) async {
    final token = _prefs.getString(AppConstants.keyAccessToken);
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final bytes = await imageFile.readAsBytes();
    final fileName = imageFile.name.isNotEmpty
        ? imageFile.name
        : imageFile.path.split('/').last;
    final ext = fileName.split('.').last.toLowerCase();
    final mimeType = ext == 'png' ? 'png' : ext == 'gif' ? 'gif' : 'jpeg';

    final request = http.MultipartRequest('POST', uri);
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(http.MultipartFile.fromBytes(
      fieldName,
      bytes,
      filename: fileName,
      contentType: MediaType('image', mimeType),
    ));

    debugPrint(' [POST multipart] $path');
    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    debugPrint(' [${streamed.statusCode}] $body');

    if (streamed.statusCode >= 400) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        response: Response(
          requestOptions: RequestOptions(path: path),
          statusCode: streamed.statusCode,
          data: jsonDecode(body),
        ),
      );
    }

    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {'success': false, 'message': body};
    }
  }
}
