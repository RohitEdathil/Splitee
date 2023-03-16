import 'package:flutter/material.dart';
import 'package:sp_frontend/util/api_client.dart';

class GroupProvider extends ChangeNotifier {
  Future<void> createGroup(String name) async {
    await client.post("group/create", {
      "name": name,
    });
  }
}
