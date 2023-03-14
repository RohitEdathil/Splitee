import 'package:flutter/material.dart';

Route pageTransition(RouteSettings settings,
        Map<String, Widget Function(BuildContext)> routes) =>
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          routes[settings.name]!(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 1.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
