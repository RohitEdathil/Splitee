import 'package:flutter/material.dart';
import 'package:sp_frontend/routes.dart';

Route pageTransition(RouteSettings settings,
        Map<String, Widget Function(BuildContext)> routes) =>
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        // If there are arguments, use the routesWithArgs map
        if (settings.arguments != null) {
          return routesWithArgs[settings.name]!(
              context, settings.arguments as String);
        }

        return routes[settings.name]!(context);
      },
      transitionsBuilder: transitionMaker,
    );

/// Creates a custom transition for page routes
Widget transitionMaker(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  final tween = Tween(begin: const Offset(0, 1.0), end: Offset.zero)
      .chain(CurveTween(curve: Curves.ease));
  return FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: animation.drive(tween),
      child: child,
    ),
  );
}
