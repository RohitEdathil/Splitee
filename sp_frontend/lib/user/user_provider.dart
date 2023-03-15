import 'package:flutter/material.dart';
import 'package:sp_frontend/util/api_client.dart';

class UserProvider extends ChangeNotifier {
  Future<void> init(String userId) async {
    final response = await client.get('user/$userId');
    print(response);
  }
}
