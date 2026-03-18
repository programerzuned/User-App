import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../network/network_info.dart';

class ApiClient {
  final Dio _dio;
  final int _maxRetries = 2;
  final Duration _retryDelay = const Duration(seconds: 2);

  ApiClient() : _dio = Dio() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: 20000),
      receiveTimeout: const Duration(milliseconds: 20000),
      contentType: 'application/json',
      validateStatus: (status) => status! < 500,
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // INTERNET CHECK using NetworkInfo
          bool isConnected = await NetworkInfo.checkConnectivity();
          if (!isConnected) {
            print('❌ No Internet Connection');
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: "No Internet Connection",
              ),
            );
          }

          // --- Logging Request ---
          print('┌─────────────── REQUEST ───────────────');
          print('│ Method  : ${options.method}');
          print('│ URL     : ${options.baseUrl}${options.path}');
          print('│ Headers : ${options.headers}');
          if (options.queryParameters.isNotEmpty) {
            print('│ Query   : ${options.queryParameters}');
          }
          if (options.data != null) print('│ Body    : ${options.data}');
          print('└───────────────────────────────────────');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // --- Logging Response ---
          print('┌─────────────── RESPONSE ──────────────');
          print('│ Method      : ${response.requestOptions.method}');
          print('│ URL         : ${response.requestOptions.baseUrl}${response.requestOptions.path}');
          print('│ Status Code : ${response.statusCode}');
          print('│ Response    : ${response.data}');
          print('└───────────────────────────────────────');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          // INTERNET CHECK
          bool isConnected = await NetworkInfo.checkConnectivity();
          if (!isConnected) {
            e = DioException(
              requestOptions: e.requestOptions,
              type: DioExceptionType.connectionError,
              error: 'No Internet Connection',
            );
          }
          // --- Logging Error ---
          print('┌─────────────── ERROR ─────────────────');
          print('│ Method   : ${e.requestOptions.method}');
          print('│ URL      : ${e.requestOptions.baseUrl}${e.requestOptions.path}');
          print('│ Message  : ${e.message}');
          print('│ Error    : ${e.error}');
          if (e.response != null) print('│ Response : ${e.response?.data}');
          print('└───────────────────────────────────────');

          return handler.next(e);
        },
      ),
    );
  }

  /// Retry logic
  Future<Response> _retryRequest(
      Future<Response> Function() request, {
        required String requestType,
        required String path,
      }) async {
    int attempt = 0;

    while (attempt < _maxRetries) {
      try {
        // INTERNET CHECK
        bool isConnected = await NetworkInfo.checkConnectivity();
        if (!isConnected) {
          print('⚠️ No internet connection. Attempt ${attempt + 1}/$_maxRetries');
          throw DioException(
            requestOptions: RequestOptions(path: path),
            type: DioExceptionType.connectionError,
            error: 'No internet connection',
          );
        }

        Response response = await request();
        return response;
      } catch (e) {
        attempt++;
        print('┌─────────────── RETRY ────────────────');
        print('│ Request Type : $requestType');
        print('│ URL          : $path');
        print('│ Attempt      : $attempt/$_maxRetries');
        print('│ Waiting      : ${_retryDelay.inSeconds * attempt}s');
        print('└───────────────────────────────────────');

        if (attempt < _maxRetries) {
          await Future.delayed(_retryDelay * attempt);
          continue;
        }
        rethrow;
      }
    }

    throw Exception("Max retry reached");
  }

  // ------------------- GET -------------------
  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    Future<Response> makeRequest() async {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response;
    }

    return _retryRequest(
      makeRequest,
      requestType: 'GET',
      path: path,
    );
  }
}