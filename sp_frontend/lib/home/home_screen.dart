import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/auth/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Home Screen',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          TextButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logOut();
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Log Out'))
        ],
      ),
    ));
  }
}
