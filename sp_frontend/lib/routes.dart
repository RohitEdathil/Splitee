import 'package:flutter/material.dart';
import 'package:sp_frontend/auth/loading_screen.dart';
import 'package:sp_frontend/auth/login_screen.dart';
import 'package:sp_frontend/home/home_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => const LoadingScreen(),
  '/login': (context) => const LoginScreen(),
  '/home': (context) => const HomeScreen(),
};
