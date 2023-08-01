import '../../../../all_export.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;

  DioClient(
    this.baseUrl,
    Object object, {
    required this.loggingInterceptor,
    required this.sharedPreferences,
  }) {
    token = sharedPreferences.getString(AppConstants.TOKEN);
    print(token);
    dio = Dio();
    dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = ResponsiveHelper.isMobilePhone()
          ? const Duration(milliseconds: 30000)
          : const Duration(minutes: 60)
      ..options.receiveTimeout = ResponsiveHelper.isMobilePhone()
          ? const Duration(milliseconds: 30000)
          : const Duration(minutes: 60)
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      };
    dio!.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (e) {
      if (e.error is FormatException) {
        throw const FormatException("Unable to process the data");
      } else {
        rethrow;
      }
    }
  }

  Future<Response> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (e) {
      if (e.error is FormatException) {
        throw const FormatException("Unable to process the data");
      } else {
        rethrow;
      }
    }
  }

  Future<Response> put(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (e) {
      if (e.error is FormatException) {
        throw const FormatException("Unable to process the data");
      } else {
        rethrow;
      }
    }
  }

  Future<Response> delete(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      if (e.error is FormatException) {
        throw const FormatException("Unable to process the data");
      } else {
        rethrow;
      }
    }
  }
}
