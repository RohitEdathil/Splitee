import 'package:flutter/material.dart';
import 'package:sp_frontend/user/user_modal.dart';
import 'package:sp_frontend/util/api_client.dart';

class UserProvider extends ChangeNotifier {
  User? currentUser;
  Future<void> init(String userId) async {
    final response = await client.get('user/$userId');
    currentUser = User.fromJson(response);
  }
}
