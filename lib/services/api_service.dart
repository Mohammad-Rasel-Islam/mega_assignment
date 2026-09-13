import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Custom exception type so callers can display user-friendly messages.
// ─────────────────────────────────────────────────────────────────────────────
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

// ─────────────────────────────────────────────────────────────────────────────
// Callback type used by ApiService so it can trigger a global logout
// without importing providers (avoids circular dependencies).
// ─────────────────────────────────────────────────────────────────────────────
typedef OnUnauthorized = Future<void> Function();

/// Core Dio-based HTTP client for the Laravel REST API.
///
/// Usage:
///   final api = ApiService();
///   final data = await api.get(ApiEndpoints.products);
class ApiService {
  late final Dio _dio;
  final StorageService _storage = StorageService();

  // Optional callback invoked when the server returns 401 (token expired).
  OnUnauthorized? onUnauthorized;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // ── Interceptors ──────────────────────────────────────────────────────
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _attachToken,
        onError: _handleError,
      ),
    );

    // Pretty-print requests/responses in debug mode
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));
  }

  // ── Interceptor Handlers ─────────────────────────────────────────────────

  Future<void> _attachToken(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _handleError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final path = err.requestOptions.path;
    final isAuthEndpoint =
        path.endsWith(ApiEndpoints.login) || path.endsWith(ApiEndpoints.register);

    if (err.response?.statusCode == 401 && !isAuthEndpoint) {
      // Token expired or invalid — trigger global logout
      await onUnauthorized?.call();
      handler.reject(DioException(
        requestOptions: err.requestOptions,
        error: const ApiException('Session expired. Please log in again.',
            statusCode: 401),
      ));
      return;
    }
    handler.next(err);
  }

  // ── Public HTTP helpers ──────────────────────────────────────────────────

  /// GET  /endpoint  →  returns response data (dynamic)
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// POST /endpoint  →  returns response data (dynamic)
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// PUT /endpoint  →  returns response data (dynamic)
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: data, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// DELETE /endpoint  →  returns response data (dynamic)
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ── Error mapping ────────────────────────────────────────────────────────

  ApiException _mapDioError(DioException e) {
    // If already wrapped by our interceptor
    if (e.error is ApiException) return e.error as ApiException;

    final statusCode = e.response?.statusCode;

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const ApiException(
        'Connection timed out. Please check your internet connection.',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return const ApiException(
        'Cannot reach the server. Please check your internet connection.',
      );
    }

    // Try to extract a human-readable message from the JSON body
    final body = e.response?.data;
    String? serverMessage;
    if (body is Map) {
      if (body['message'] != null && body['message'].toString().isNotEmpty) {
        serverMessage = body['message'].toString();
      } else if (body['errors'] is Map && (body['errors'] as Map).isNotEmpty) {
        final firstError = (body['errors'] as Map).values.first;
        if (firstError is List && firstError.isNotEmpty) {
          serverMessage = firstError.first.toString();
        } else if (firstError != null) {
          serverMessage = firstError.toString();
        }
      } else if (body['error'] != null) {
        serverMessage = body['error'].toString();
      }
    }

    switch (statusCode) {
      case 400:
        return ApiException(
            serverMessage ?? 'Bad request. Please check your input.',
            statusCode: statusCode);
      case 401:
        return ApiException(
            serverMessage ?? 'Unauthorized. Please log in again.',
            statusCode: statusCode);
      case 403:
        return ApiException(
            serverMessage ?? 'You don\'t have permission for this action.',
            statusCode: statusCode);
      case 404:
        return ApiException(serverMessage ?? 'Resource not found.',
            statusCode: statusCode);
      case 422:
        return ApiException(
            serverMessage ?? 'Validation error. Please check your input.',
            statusCode: statusCode);
      case 429:
        return ApiException(
            serverMessage ?? 'Too many requests. Please slow down.',
            statusCode: statusCode);
      case 500:
      case 502:
      case 503:
        return ApiException(
            serverMessage ?? 'Server error. Please try again later.',
            statusCode: statusCode);
      default:
        return ApiException(
            serverMessage ?? 'An unexpected error occurred.',
            statusCode: statusCode);
    }
  }
}
