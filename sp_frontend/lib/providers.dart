import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/auth/auth_provider.dart';

class ProviderInjector extends StatelessWidget {
  final Widget child;
  const ProviderInjector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider()),
      ],
      child: child,
    );
  }
}
