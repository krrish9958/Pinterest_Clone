import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pinterest_clone/core/network/dio_client.dart';
import 'router/app_router.dart';

String _clerkPublishableKey = '';
String _pexelsApiKey = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Keep startup resilient when .env is not present in local/dev builds.
  }

  _clerkPublishableKey = dotenv.env['CLERK_PUBLISHABLE_KEY'] ??
      const String.fromEnvironment('CLERK_PUBLISHABLE_KEY');
  _pexelsApiKey =
      dotenv.env['PEXELS_API_KEY'] ?? const String.fromEnvironment('PEXELS_API_KEY');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    if (_clerkPublishableKey.isEmpty || _pexelsApiKey.isEmpty) {
      final missingVars = <String>[
        if (_clerkPublishableKey.isEmpty) 'CLERK_PUBLISHABLE_KEY',
        if (_pexelsApiKey.isEmpty) 'PEXELS_API_KEY',
      ].join(', ');
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Missing: $missingVars. Provide via .env or --dart-define.',
            ),
          ),
        ),
      );
    }

    DioClient.configure(pexelsApiKey: _pexelsApiKey);

    return ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: _clerkPublishableKey,
        httpConnectionTimeout: const Duration(seconds: 15),
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE60023),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          chipTheme: ChipThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            side: BorderSide.none,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF1F1F1),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: const BorderSide(color: Colors.black12),
            ),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
            ),
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
