import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:meal_planner_app/core/config/app_config.dart';
import 'package:meal_planner_app/core/network/auth_interceptor.dart';
import 'package:meal_planner_app/core/storage/secure_storage.dart';

/// HTTP client configured with interceptors and base options
class DioClient {
  late final Dio _dio;
  final SecureStorage _storage;
  final Logger _logger = Logger();

  DioClient({required SecureStorage storage}) : _storage = storage {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.apiTimeout,
        receiveTimeout: AppConfig.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(_storage),
      _LoggingInterceptor(_logger),
    ]);
  }

  /// Get the Dio instance
  Dio get dio => _dio;
}

/// Interceptor for logging requests and responses
class _LoggingInterceptor extends Interceptor {
  final Logger _logger;

  _LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.debug) {
      _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
      _logger.d('Headers: ${options.headers}');
      if (options.data != null) {
        _logger.d('Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConfig.debug) {
      _logger.i(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      _logger.i('Data: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.debug) {
      _logger.e(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      _logger.e('Message: ${err.message}');
      if (err.response?.data != null) {
        _logger.e('Error Data: ${err.response?.data}');
      }
    }
    handler.next(err);
  }
}
