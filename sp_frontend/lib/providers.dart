import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/auth/auth_provider.dart';
import 'package:sp_frontend/bill/bill_provider.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/user/user_provider.dart';

class ProviderInjector extends StatelessWidget {
  final Widget child;
  const ProviderInjector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create: (_) => BillProvider()),
      ],
      child: child,
    );
  }
}
