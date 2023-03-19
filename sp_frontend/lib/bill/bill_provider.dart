import 'package:flutter/material.dart';
import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/util/api_client.dart';

class BillProvider extends ChangeNotifier {
  final Map<String, Bill> bills = {};
  Future<String?> createBill(
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

  Future<String?> editBill(
      String billId, String title, double amount, Map<String, double> owes,
      {String? groupId}) async {
    double sum = 0;

    // Recalculate the sum of the owes
    for (final owe in owes.values) {
      sum += owe;
    }

    // If the sum is different, adjust the first owe to account for small differences
    owes[owes.keys.first] = amount - sum + owes[owes.keys.first]!;

    final response = await client.put("bill/$billId", {
      "title": title,
      "amount": amount,
      "owes": owes,
    });

    return response["error"];
  }

  Future<void> changeStatus(String oweId, bool value) async {
    await client.put(
      "bill/status",
      {"status": value ? "PAID" : "PENDING", "oweId": oweId},
    );
  }

  Future<void> deleteBill(String billId) async {
    await client.delete("bill/delete", {
      "billId": billId,
    });
  }

  Future<Bill?> getBill(String id, {bool forceRefresh = false}) async {
    // If the bill is already in the cache, and we don't want to force a refresh, return the cached bill
    if (bills.containsKey(id) && !forceRefresh) return bills[id];

    final response = await client.get("bill/$id");
    final bill = Bill.fromJson(response);
    bills[bill.id] = bill;

    return bill;
  }
}
