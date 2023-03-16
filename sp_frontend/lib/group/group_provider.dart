import 'package:flutter/material.dart';
import 'package:sp_frontend/util/api_client.dart';

class GroupProvider extends ChangeNotifier {
  Future<void> createGroup(String name) async {
    await client.post("group/create", {
      "name": name,
    });
  }

  Future<String?> joinGroup(String groupId) async {
    final result = await client.post("group/join", {
      "groupId": groupId,
    });

    return result['error'];
  }
}
