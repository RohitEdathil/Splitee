import 'package:flutter/material.dart';
import 'package:sp_frontend/providers.dart';
import 'package:sp_frontend/routes.dart';
import 'package:sp_frontend/theme/page_transition.dart';

import 'package:sp_frontend/theme/theme.dart';

void main() {
  runApp(const SpliteeApp());
}

class SpliteeApp extends StatelessWidget {
  const SpliteeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderInjector(
      child: MaterialApp(
          title: 'Splitee',
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          onGenerateRoute: (settings) => pageTransition(settings, routes)),
    );
  }
}
