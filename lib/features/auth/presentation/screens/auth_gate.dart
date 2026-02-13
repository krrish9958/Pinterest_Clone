import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:pinterest_clone/core/network/dio_client.dart';
import 'package:pinterest_clone/features/home/presentation/screens/main_screen.dart';
import 'sign_in_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ClerkAuthBuilder(
      signedInBuilder: (context, authState) {
        DioClient.attachClerkAuth(authState);
        return const MainScreen();
      },
      signedOutBuilder: (context, authState) {
        DioClient.attachClerkAuth(null);
        return const SignInScreen();
      },
    );
  }
}
