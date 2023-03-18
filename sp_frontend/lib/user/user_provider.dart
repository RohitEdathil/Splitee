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
      notifyListeners();
    }
  }

  Future<void> changeName(String newName) async {
    await client.put("user", {"name": newName});
  }

  Future<void> changeEmail(String newEmail) async {
    await client.put("user", {"email": newEmail});
  }

  Future<List<BaseUser>> search(String query) async {
    if (query.isEmpty) return [];

    final response = await client.get("user/search?query=$query");
    return ((response["users"] ?? []) as List)
        .map((e) => BaseUser.fromJson(e))
        .toList();
  }
}
