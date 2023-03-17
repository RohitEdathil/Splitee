import 'package:flutter/material.dart';
import 'package:sp_frontend/util/api_client.dart';

class BillProvider extends ChangeNotifier {
  Future<String?> createGroup(
      String title, double amount, Map<String, double> owes,
      {String? groupId}) async {
    final response = await client.post("bill/create", {
      "title": title,
      "amount": amount,
      if (groupId != null) "groupId": groupId,
      "owes": owes,
    });

    return response["error"];
  }
}
