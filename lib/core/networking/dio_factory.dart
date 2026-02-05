import 'dart:io';

import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/api_constants.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static late Dio dio;
  static Future<void> init() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(storage: FileStorage("$appDocPath/.cookies/"));

    const timeout = Duration(seconds: 120);
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      CookieManager(jar),

      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = LocalStorage.token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            if (error.requestOptions.path.contains('refresh-token')) {
              return handler.next(error);
            }

            print("⚠️ Token Expired! Attempting to refresh...");

            try {
              final response = await dio.get('users/auth/refresh-token');

              if (response.statusCode == 200) {
                String newToken = response.data['token'];

                print("✅ Token Refreshed Successfully!");

                await LocalStorage.saveToken(newToken);

                final RequestOptions requestOptions = error.requestOptions;

                requestOptions.headers['Authorization'] = 'Bearer $newToken';

                final clonedRequest = await dio.fetch(requestOptions);

                return handler.resolve(clonedRequest);
              }
            } catch (e) {
              print("❌ Refresh Token Failed: $e");
              await LocalStorage.clearToken();
            }
          }
          return handler.next(error);
        },
      ),

      PrettyDioLogger(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    ]);
  }

  static Future<Response> postData({
    required String path,
    required dynamic data,
    String? token,
  }) async {
    Map<String, dynamic> headers = {
      'Content-Type': data is FormData
          ? 'multipart/form-data'
          : 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await dio.post(
      path,
      data: data,
      options: Options(headers: headers),
    );

    return response;
  }

  static Future<Response> putData({
    required String path,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    Map<String, dynamic> headers = {};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await dio.put(
      path,
      data: data,
      options: Options(headers: headers),
    );
    return response;
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    Map<String, dynamic> headers = {'Accept': 'application/json'};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response;
  }

  static Future<Response> patchData({
    required String path,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    Map<String, dynamic> headers = {};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await dio.patch(
      path,
      data: data,
      options: Options(headers: headers),
    );
    return response;
  }

  static Future<Response> deleteData({
    required String path,
    String? token,
  }) async {
    Map<String, dynamic> headers = {};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await dio.delete(path, options: Options(headers: headers));
    return response;
  }
}
