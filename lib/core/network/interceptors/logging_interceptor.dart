import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';

class LoggingInterceptor extends Interceptor {
  static const _redactedKeys = {
    'authorization',
    'x-firebase-appcheck',
    'password',
    'access_token',
    'refresh_token',
    'token',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!FlavorConstants.isProd) {
      final safeHeaders = _redactHeaders(options.headers);
      // ignore: avoid_print
      print('[NET] --> ${options.method} ${options.uri} headers:$safeHeaders');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!FlavorConstants.isProd) {
      // ignore: avoid_print
      print('[NET] <-- ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!FlavorConstants.isProd) {
      // ignore: avoid_print
      print(
        '[NET] ERR ${err.response?.statusCode} ${err.requestOptions.uri}: ${err.message}',
      );
    }
    handler.next(err);
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) =>
      headers.map(
        (k, v) =>
            MapEntry(k, _redactedKeys.contains(k.toLowerCase()) ? '***' : v),
      );
}
