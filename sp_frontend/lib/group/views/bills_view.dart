import 'package:flutter/material.dart';
import 'package:sp_frontend/group/components/bill_card.dart';
import 'package:sp_frontend/group/components/view_common.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/util/empty.dart';

class BillsView extends StatelessWidget {
  final Group group;
  const BillsView({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ViewCommons(title: 'Bills', children: [
      if (group.bills.isEmpty) const Empty(),
      for (final bill in group.bills.values) BillCard(bill: bill, group: group),
    ]);
  }
}
