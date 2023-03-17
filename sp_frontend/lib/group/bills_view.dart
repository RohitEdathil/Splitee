import 'package:flutter/material.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/util/empty.dart';

import 'package:sp_frontend/group/components/bill_card.dart';

class BillsView extends StatelessWidget {
  final Group group;
  const BillsView({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Text("Bills", style: Theme.of(context).textTheme.headlineSmall),
          ),
          if (group.bills.isEmpty) const Empty(),
          for (final bill in group.bills) BillCard(bill: bill)
        ]),
      ),
    );
  }
}
