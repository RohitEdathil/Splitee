import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/auth/auth_provider.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  void _init(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final user = context.read<UserProvider>();

    final navigator = Navigator.of(context);

    // Initializes auth module
    await auth.init();

    // Sends to login screen if not logged in
    if (!auth.isAuthenticated) {
      navigator.pushReplacementNamed('/login');
      return;
    }

    // Loads user detail and sends to home
    await user.load(auth.userId!);
    navigator.pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    _init(context);

    return const Scaffold(
      body: Center(
          child: SpinKitPulse(
        color: Palette.alpha,
      )),
    );
  }
}
