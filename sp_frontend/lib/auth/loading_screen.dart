import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/auth/auth_provider.dart';
import 'package:sp_frontend/theme/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  void _authInitialised(AuthProvider auth, BuildContext context) {
    if (auth.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    auth.init().then((_) => _authInitialised(auth, context));

    return const Scaffold(
      body: Center(
          child: SpinKitRotatingCircle(
        color: Palette.alpha,
      )),
    );
  }
}
