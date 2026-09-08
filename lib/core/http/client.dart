import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// 1. EXCEPTIONS
// ============================================================================

/// Base exception class for all API-related errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

/// Thrown when the user is not authenticated (HTTP 401).
/// This explicitly signals that the person is not logged in or their session expired.
class UnauthorizedException extends ApiException {
  const UnauthorizedException(
    super.message, {
    super.statusCode = 401,
    super.data,
  });
}

/// Thrown when the user does not have permission to access a resource (HTTP 403).
class ForbiddenException extends ApiException {
  const ForbiddenException(super.message, {super.statusCode = 403, super.data});
}

/// Thrown when a requested resource is not found (HTTP 404).
class NotFoundException extends ApiException {
  const NotFoundException(super.message, {super.statusCode = 404, super.data});
}

/// Thrown for bad requests or validation errors (HTTP 400).
class BadRequestException extends ApiException {
  const BadRequestException(
    super.message, {
    super.statusCode = 400,
    super.data,
  });
}

/// Thrown when the Django server encounters an internal error (HTTP 500+).
class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode = 500, super.data});
}

/// Thrown for connectivity, timeout, or DNS issues.
class NetworkException extends ApiException {
  const NetworkException(super.message, {super.statusCode, super.data});
}

// ============================================================================
// 2. TOKEN STORAGE
// ============================================================================

/// Manages persistent storage of JWT access and refresh tokens using SharedPreferences.
/// Keeps values in-memory for instant synchronous access in interceptors.
class TokenStorage {
  static const String _accessTokenKey = 'jwt_access_token';
  static const String _refreshTokenKey = 'jwt_refresh_token';

  String? _accessToken;
  String? _refreshToken;
  SharedPreferences? _prefs;

  TokenStorage({String? initialAccessToken, String? initialRefreshToken})
    : _accessToken = initialAccessToken,
      _refreshToken = initialRefreshToken;

  /// Loads tokens from SharedPreferences into memory.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _accessToken = _prefs?.getString(_accessTokenKey);
    _refreshToken = _prefs?.getString(_refreshTokenKey);
  }

  /// Current access token in memory.
  String? get accessToken => _accessToken;

  /// Current refresh token in memory.
  String? get refreshToken => _refreshToken;

  /// Returns true if an access token is stored.
  bool get hasToken => _accessToken != null && _accessToken!.isNotEmpty;

  /// Saves access and optional refresh token to memory and SharedPreferences.
  Future<void> saveTokens({required String access, String? refresh}) async {
    _accessToken = access;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(_accessTokenKey, access);

    if (refresh != null && refresh.isNotEmpty) {
      _refreshToken = refresh;
      await _prefs?.setString(_refreshTokenKey, refresh);
    }
  }

  /// Clears stored tokens on logout or session expiration.
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.remove(_accessTokenKey);
    await _prefs?.remove(_refreshTokenKey);
  }
}

// ============================================================================
// 3. AUTH INTERCEPTOR (JWT + AUTO REFRESH)
// ============================================================================

/// Dio QueuedInterceptor that attaches JWT tokens to requests,
/// handles automatic token refresh when receiving a 401 Unauthorized,
/// and triggers [onUnauthenticated] callback when the user is not logged in.
class JwtAuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final TokenStorage tokenStorage;
  final String baseUrl;
  final String authHeaderPrefix;
  VoidCallback? onUnauthenticated;

  /// Separate Dio instance for token refresh to avoid recursive interceptor loops.
  late final Dio _refreshDio;

  JwtAuthInterceptor({
    required this.dio,
    required this.tokenStorage,
    required this.baseUrl,
    this.authHeaderPrefix = 'JWT',
    this.onUnauthenticated,
  }) {
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if the request explicitly opts out of authentication
    final requiresAuth = options.extra['requiresAuth'] ?? true;

    if (requiresAuth && tokenStorage.hasToken) {
      options.headers['Authorization'] =
          '$authHeaderPrefix ${tokenStorage.accessToken}';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isAuthEndpoint = err.requestOptions.path.contains('/auth/jwt/');
    final statusCode = err.response?.statusCode;

    // Handle 401 Unauthorized
    if (statusCode == 401) {
      // 1. If login or refresh endpoint failed with 401, don't attempt to refresh
      if (isAuthEndpoint) {
        if (err.requestOptions.path.contains('/auth/jwt/refresh/')) {
          await tokenStorage.clear();
          onUnauthenticated?.call();
        }
        return handler.next(err);
      }

      // 2. Try refreshing the token if we have a refresh token
      final refreshToken = tokenStorage.refreshToken;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final refreshResponse = await _refreshDio.post(
            '/auth/jwt/refresh/',
            data: {'refresh': refreshToken},
          );

          if (refreshResponse.statusCode == 200 &&
              refreshResponse.data is Map<String, dynamic>) {
            final newAccessToken = refreshResponse.data['access'] as String;
            final newRefreshToken = refreshResponse.data['refresh'] as String?;

            // Save refreshed tokens
            await tokenStorage.saveTokens(
              access: newAccessToken,
              refresh: newRefreshToken,
            );

            // Retry original request with new token
            final requestOptions = err.requestOptions;
            requestOptions.headers['Authorization'] =
                '$authHeaderPrefix $newAccessToken';

            final clonedResponse = await dio.fetch(requestOptions);
            return handler.resolve(clonedResponse);
          }
        } catch (_) {
          // Token refresh failed (e.g., refresh token expired)
          await tokenStorage.clear();
          onUnauthenticated?.call();
          return handler.next(err);
        }
      }

      // 3. No refresh token available - user is not logged in
      await tokenStorage.clear();
      onUnauthenticated?.call();
    }

    return handler.next(err);
  }
}

// ============================================================================
// 4. API CLIENT / HTTP SERVICE
// ============================================================================

/// Clean and simple HTTP client to interface with Django API + Djoser JWT.
/// Supports all HTTP methods, file uploading, exception handling, and token management.
class ApiClient {
  static ApiClient? _instance;

  /// Default singleton instance for convenience across the app.
  static ApiClient get instance {
    _instance ??= ApiClient();
    return _instance!;
  }

  final Dio _dio;
  final TokenStorage tokenStorage;
  final String baseUrl;
  late final JwtAuthInterceptor _authInterceptor;

  ApiClient({
    String? baseUrl,
    TokenStorage? tokenStorage,
    VoidCallback? onUnauthenticated,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
  }) : baseUrl = baseUrl ?? 'http://127.0.0.1:8000',
       tokenStorage = tokenStorage ?? TokenStorage(),
       _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl ?? 'http://127.0.0.1:8000',
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
           },
         ),
       ) {
    _authInterceptor = JwtAuthInterceptor(
      dio: _dio,
      tokenStorage: this.tokenStorage,
      baseUrl: this.baseUrl,
      authHeaderPrefix: 'JWT',
      onUnauthenticated: onUnauthenticated,
    );
    _setupInterceptors();
  }

  /// Sets or updates the unauthenticated callback.
  set onUnauthenticated(VoidCallback? callback) {
    _authInterceptor.onUnauthenticated = callback;
  }

  /// Current unauthenticated callback.
  VoidCallback? get onUnauthenticated => _authInterceptor.onUnauthenticated;

  /// Exposes the underlying Dio instance if direct access is needed.
  Dio get rawDio => _dio;

  /// Returns true if an access token is currently stored.
  bool get isAuthenticated => tokenStorage.hasToken;

  /// Returns the current access token.
  String? get accessToken => tokenStorage.accessToken;

  /// Returns the current refresh token.
  String? get refreshToken => tokenStorage.refreshToken;

  /// Initialize token storage from local storage (call on app start).
  Future<void> init() async {
    await tokenStorage.init();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(_authInterceptor);

    // Optional debug logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint('[HTTP] $obj'),
        ),
      );
    }
  }

  // --------------------------------------------------------------------------
  // HTTP METHODS
  // --------------------------------------------------------------------------

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) async {
    try {
      final opts = _mergeAuthOption(options, requiresAuth);
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: opts,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) async {
    try {
      final opts = _mergeAuthOption(options, requiresAuth);
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: opts,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) async {
    try {
      final opts = _mergeAuthOption(options, requiresAuth);
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: opts,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) async {
    try {
      final opts = _mergeAuthOption(options, requiresAuth);
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: opts,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) async {
    try {
      final opts = _mergeAuthOption(options, requiresAuth);
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: opts,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // --------------------------------------------------------------------------
  // FILE UPLOAD METHODS
  // --------------------------------------------------------------------------

  /// Uploads a single file along with optional form fields.
  ///
  /// Supports both [filePath] (mobile/desktop) and [fileBytes] (web/in-memory).
  Future<Response<T>> uploadFile<T>(
    String path, {
    required String fileFieldName,
    String? filePath,
    List<int>? fileBytes,
    String? filename,
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) async {
    try {
      MultipartFile multipartFile;

      if (fileBytes != null) {
        multipartFile = MultipartFile.fromBytes(
          fileBytes,
          filename: filename ?? 'upload.dat',
        );
      } else if (filePath != null) {
        multipartFile = await MultipartFile.fromFile(
          filePath,
          filename: filename,
        );
      } else {
        throw const ApiException(
          'Either filePath or fileBytes must be provided for upload.',
        );
      }

      final formDataMap = <String, dynamic>{
        fileFieldName: multipartFile,
        ...?additionalData,
      };

      final formData = FormData.fromMap(formDataMap);

      final opts = _mergeAuthOption(
        options?.copyWith(contentType: 'multipart/form-data') ??
            Options(contentType: 'multipart/form-data'),
        requiresAuth,
      );

      return await _dio.post<T>(
        path,
        data: formData,
        options: opts,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic upload using pre-built [FormData].
  Future<Response<T>> uploadFormData<T>(
    String path, {
    required FormData formData,
    ProgressCallback? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) async {
    try {
      final opts = _mergeAuthOption(
        options?.copyWith(contentType: 'multipart/form-data') ??
            Options(contentType: 'multipart/form-data'),
        requiresAuth,
      );

      return await _dio.post<T>(
        path,
        data: formData,
        options: opts,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // --------------------------------------------------------------------------
  // DJANGO / DJOSER AUTHENTICATION ENDPOINTS
  // --------------------------------------------------------------------------

  /// Sign in with username and password using Djoser JWT endpoint (`/auth/jwt/create/`).
  /// Saves the returned `access` and `refresh` tokens to [TokenStorage].
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await post<Map<String, dynamic>>(
      '/auth/jwt/create/',
      data: {'username': username, 'password': password},
      requiresAuth: false,
    );

    final data = response.data!;
    final access = data['access'] as String;
    final refresh = data['refresh'] as String?;

    await tokenStorage.saveTokens(access: access, refresh: refresh);
    return data;
  }

  /// Manually refresh JWT token using Djoser refresh endpoint (`/auth/jwt/refresh/`).
  Future<String?> refreshAuthToken() async {
    final refresh = tokenStorage.refreshToken;
    if (refresh == null || refresh.isEmpty) {
      throw const UnauthorizedException(
        'User is not logged in. No refresh token found.',
      );
    }

    final response = await post<Map<String, dynamic>>(
      '/auth/jwt/refresh/',
      data: {'refresh': refresh},
      requiresAuth: false,
    );

    final newAccess = response.data?['access'] as String?;
    final newRefresh = response.data?['refresh'] as String?;

    if (newAccess != null) {
      await tokenStorage.saveTokens(access: newAccess, refresh: newRefresh);
    }
    return newAccess;
  }

  /// Logs the user out by wiping the tokens from [TokenStorage].
  Future<void> logout() async {
    await tokenStorage.clear();
  }

  /// Fetches the authenticated user profile via Djoser (`/auth/users/me/`).
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await get<Map<String, dynamic>>('/auth/users/me/');
    return response.data ?? {};
  }

  /// Register a new user via Djoser (`/auth/users/`).
  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    String? email,
    Map<String, dynamic>? extraFields,
  }) async {
    final payload = <String, dynamic>{
      'username': username,
      'password': password,
      'email': ?email,
      ...?extraFields,
    };

    final response = await post<Map<String, dynamic>>(
      '/auth/users/',
      data: payload,
      requiresAuth: false,
    );

    return response.data ?? {};
  }

  // --------------------------------------------------------------------------
  // HELPERS
  // --------------------------------------------------------------------------

  Options _mergeAuthOption(Options? options, bool requiresAuth) {
    final opts = options ?? Options();
    final extra = Map<String, dynamic>.from(opts.extra ?? {});
    extra['requiresAuth'] = requiresAuth;
    return opts.copyWith(extra: extra);
  }

  /// Parses [DioException] into descriptive typed exceptions, extracting
  /// Django REST Framework error formats (`detail`, field errors, `non_field_errors`).
  ApiException _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkException(
        'Connection timed out. Please check your internet connection.',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return const NetworkException(
        'Unable to connect to server. Ensure the backend is running.',
      );
    }

    if (error.type == DioExceptionType.cancel) {
      return const ApiException('Request was cancelled.');
    }

    final response = error.response;
    if (response != null) {
      final statusCode = response.statusCode;
      final parsedMessage = _extractDjangoErrorMessage(response.data);

      switch (statusCode) {
        case 401:
          String message = parsedMessage;
          final lower = message.toLowerCase();
          if (lower.isEmpty ||
              lower.contains('authentication credentials were not provided') ||
              lower.contains('token not valid') ||
              lower.contains('token is invalid') ||
              lower.contains('token has expired')) {
            message = 'You are not logged in. Please sign in to continue.';
          }
          return UnauthorizedException(
            message,
            statusCode: 401,
            data: response.data,
          );

        case 403:
          return ForbiddenException(
            parsedMessage.isNotEmpty
                ? parsedMessage
                : 'You do not have permission to perform this action.',
            statusCode: 403,
            data: response.data,
          );

        case 404:
          return NotFoundException(
            parsedMessage.isNotEmpty
                ? parsedMessage
                : 'The requested resource was not found.',
            statusCode: 404,
            data: response.data,
          );

        case 400:
          return BadRequestException(
            parsedMessage.isNotEmpty ? parsedMessage : 'Invalid request.',
            statusCode: 400,
            data: response.data,
          );

        case 500:
        case 502:
        case 503:
        case 504:
          return ServerException(
            parsedMessage.isNotEmpty
                ? parsedMessage
                : 'Server error ($statusCode). Please try again later.',
            statusCode: statusCode,
            data: response.data,
          );

        default:
          return ApiException(
            parsedMessage.isNotEmpty
                ? parsedMessage
                : 'Request failed with status code $statusCode.',
            statusCode: statusCode,
            data: response.data,
          );
      }
    }

    return ApiException(
      error.message ?? 'An unexpected network error occurred.',
    );
  }

  /// Extracts readable error strings from DRF error structures:
  /// - `{"detail": "Authentication credentials were not provided."}`
  /// - `{"username": ["This field is required."]}`
  /// - `{"non_field_errors": ["Invalid credentials."]}`
  /// - Direct string or list
  String _extractDjangoErrorMessage(dynamic data) {
    if (data == null) return '';

    if (data is String) return data;

    if (data is Map) {
      // 1. Check for standard DRF detail key
      if (data.containsKey('detail')) {
        final detail = data['detail'];
        return detail is String ? detail : detail.toString();
      }

      // 2. Check for non_field_errors
      if (data.containsKey('non_field_errors')) {
        final errors = data['non_field_errors'];
        if (errors is List) {
          return errors.join(', ');
        }
        return errors.toString();
      }

      // 3. Format field validation errors: e.g. "username: This field is required."
      final errorLines = <String>[];
      data.forEach((key, value) {
        if (value is List) {
          errorLines.add('$key: ${value.join(", ")}');
        } else {
          errorLines.add('$key: $value');
        }
      });

      if (errorLines.isNotEmpty) {
        return errorLines.join('\n');
      }
    }

    if (data is List) {
      return data.join(', ');
    }

    return data.toString();
  }
}
