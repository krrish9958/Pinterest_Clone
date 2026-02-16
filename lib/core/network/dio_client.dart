import 'package:dio/dio.dart';
import 'package:clerk_flutter/clerk_flutter.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.pexels.com/v1/',
    ),
  );

  static ClerkAuthState? _authState;
  static bool _authInterceptorAttached = false;
  static bool _isConfigured = false;

  static void configure({required String pexelsApiKey}) {
    if (_isConfigured) return;
    _isConfigured = true;
    dio.options.headers['Authorization'] = pexelsApiKey;
  }

  static void attachClerkAuth(ClerkAuthState? authState) {
    _authState = authState;

    if (_authInterceptorAttached) return;
    _authInterceptorAttached = true;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authState = _authState;

          try {
            if (authState != null && authState.isSignedIn) {
              final sessionToken = await authState.sessionToken();
              options.headers['X-Clerk-Session-Token'] = sessionToken.jwt;

              if (options.extra['useClerkBearer'] == true) {
                options.headers['Authorization'] = 'Bearer ${sessionToken.jwt}';
              }
            } else {
              options.headers.remove('X-Clerk-Session-Token');
            }
          } catch (_) {
            // Do not block network calls if token retrieval fails.
            options.headers.remove('X-Clerk-Session-Token');
          }

          handler.next(options);
        },
      ),
    );
  }
}
