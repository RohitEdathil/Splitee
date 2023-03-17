import 'package:flutter/material.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/util/api_client.dart';

class GroupProvider extends ChangeNotifier {
  Map<String, Group> groups = {};

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

  Future<void> fetchGroup(String groupId) async {
    groups[groupId] = Group.fromJson(await client.get("group/$groupId"));
    notifyListeners();
  }

  Future<void> changeName(String groupId, String newName) async {
    await client.put("group/$groupId", {
      "name": newName,
    });
  }

  Group? getGroup(String groupId) {
    fetchGroup(groupId);

    return groups[groupId];
  }

  Future<void> leaveGroup(String groupId) async {
    await client.post("group/leave", {
      "groupId": groupId,
    });
  }
}
