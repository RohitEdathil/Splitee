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

  //TODO: View bill without group
  // Future<Bill?> getBill(String id) async {
  //   if (bills.containsKey(id)) return bills[id];
  //   final response = await client.get("bill/$id");

  //   final bill = Bill.fromJson(
  //     response["bill"],
  //   );

  //   bills[bill.id] = bill;

  //   return bill;
  // }
}
