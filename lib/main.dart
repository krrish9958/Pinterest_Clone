import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'router/app_router.dart';

String _clerkPublishableKey = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Keep startup resilient when .env is not present in local/dev builds.
  }

  _clerkPublishableKey = dotenv.env['CLERK_PUBLISHABLE_KEY'] ??
      const String.fromEnvironment('CLERK_PUBLISHABLE_KEY');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    if (_clerkPublishableKey.isEmpty) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Missing CLERK_PUBLISHABLE_KEY. Pass it with --dart-define.',
            ),
          ),
        ),
      );
    }

    return ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: _clerkPublishableKey,
        httpConnectionTimeout: const Duration(seconds: 15),
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
