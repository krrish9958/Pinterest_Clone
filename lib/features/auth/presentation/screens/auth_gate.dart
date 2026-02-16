import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:pinterest_clone/core/network/dio_client.dart';
import 'package:pinterest_clone/features/home/presentation/screens/main_screen.dart';
import 'sign_in_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  static const Duration _signedOutGracePeriod = Duration(milliseconds: 800);
  bool _canShowSignedOut = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_signedOutGracePeriod, () {
      if (!mounted) return;
      setState(() {
        _canShowSignedOut = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClerkAuthBuilder(
      signedInBuilder: (context, authState) {
        DioClient.attachClerkAuth(authState);
        return const MainScreen();
      },
      signedOutBuilder: (context, authState) {
        if (_canShowSignedOut == false) {
          return const _AuthHydrationScreen();
        }
        DioClient.attachClerkAuth(null);
        return const SignInScreen();
      },
    );
  }
}

class _AuthHydrationScreen extends StatelessWidget {
  const _AuthHydrationScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.2),
        ),
      ),
    );
  }
}
