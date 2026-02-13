import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _resetRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resetRequested) return;

    final authState = ClerkAuth.of(context, listen: false);
    if (authState.isSignedIn == false && authState.isSigningUp) {
      _resetRequested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          authState.resetClient();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ClerkErrorListener(
          child: ClerkAuthentication(),
        ),
      ),
    );
  }
}
