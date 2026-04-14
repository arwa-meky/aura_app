import 'dart:io';
import 'dart:ui';
import 'package:aura_project/core/helpers/storage/local_storage.dart';
import 'package:aura_project/core/networking/api_constants.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static late Dio dio;
  static late Dio _refreshDio;
  static VoidCallback? onSessionExpired;

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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
      ),
    );
    _refreshDio.interceptors.add(CookieManager(jar));

    dio.interceptors.addAll([
      CookieManager(jar),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = LocalStorage.token;
          if (token != null && !options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          bool isTokenExpired =
              error.response?.statusCode == 401 ||
              (error.response?.data != null &&
                  (error.response?.data['message'] == "jwt expired" ||
                      error.response?.data['message'] == "Unauthorized"));

          if (isTokenExpired) {
            if (error.requestOptions.path.contains('refresh-token')) {
              await _forceLogout();
              return handler.next(error);
            }

            try {
              print("⚠️ Session expired. Attempting to refresh token...");

              final response = await _refreshDio.get(
                '/api/v1/users/auth/refresh-token',
              );

              if (response.statusCode == 200) {
                String newToken =
                    response.data['token'] ?? response.data['data']?['token'];

                await LocalStorage.saveToken(newToken);
                print("✅ Token refreshed successfully.");

                final opts = error.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newToken';

                final retryResponse = await dio.fetch(opts);
                return handler.resolve(retryResponse);
              }
            } catch (e) {
              print("❌ Refresh flow failed: $e");
              await _forceLogout();
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),

      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    ]);
  }

  static Future<void> _forceLogout() async {
    print("🚨 Force Logout Triggered");
    await LocalStorage.clearToken();
    if (onSessionExpired != null) {
      onSessionExpired!();
    }
  }

  static Future<Response> postData({
    required String path,
    required dynamic data,
  }) async {
    return await dio.post(
      path,
      data: data,
      options: Options(
        headers: {
          'Content-Type': data is FormData
              ? 'multipart/form-data'
              : 'application/json',
        },
      ),
    );
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  static Future<Response> putData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    return await dio.put(path, data: data);
  }

  static Future<Response> patchData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    return await dio.patch(path, data: data);
  }

  static Future<Response> deleteData({required String path}) async {
    return await dio.delete(path);
  }
}
