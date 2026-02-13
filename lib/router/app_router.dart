import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/features/auth/presentation/screens/auth_gate.dart';
import '../features/home/presentation/screens/pin_detail_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authState = ClerkAuth.of(context, listen: false);
      final isSignedIn = authState.isSignedIn;
      final isDetailRoute = state.matchedLocation == '/detail';

      if (!isSignedIn && isDetailRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const AuthGate()),

      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PinDetailScreen(id: extra['id'], imageUrl: extra['imageUrl']);
        },
      ),
    ],
  );
});
