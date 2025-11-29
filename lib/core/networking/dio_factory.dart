import 'package:aura_project/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static late Dio dio;
  static void init() async {
    const timeout = Duration(seconds: 120);
    dio =
        Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: timeout,
              receiveTimeout: timeout,
              sendTimeout: timeout,
            ),
          )
          ..interceptors.add(
            PrettyDioLogger(
              request: true,
              requestBody: true,
              requestHeader: true,
              responseBody: true,
            ),
          );
  }

  static Future<Response> postData({
    required String path,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    Map<String, dynamic> headers = {};
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

  static Future<Response> getData({required String path, String? token}) async {
    Map<String, dynamic> headers = {'Accept': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await dio.get(path, options: Options(headers: headers));
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
