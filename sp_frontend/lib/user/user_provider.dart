import 'package:flutter/material.dart';
import 'package:sp_frontend/user/user_modal.dart';
import 'package:sp_frontend/util/api_client.dart';

class UserProvider extends ChangeNotifier {
  User? currentUser;
  String? userId;
  Future<void> load(String userId) async {
    this.userId = userId;
    final response = await client.get('user/$userId');
    currentUser = User.fromJson(response);
  }

  Future<void> reload() async {
    if (userId != null) {
      await load(userId!);
    }
  }
}
