import 'package:flutter/material.dart';
import 'package:sp_frontend/components/white_padded_container.dart';
import 'package:sp_frontend/group/components/balance_card.dart';
import 'package:sp_frontend/group/components/view_common.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/util/empty.dart';

class BalancesView extends StatelessWidget {
  final Group group;
  const BalancesView({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ViewCommons(title: "Balances", children: [
      if (group.sortedBalances.isEmpty) const Empty(),
      for (final balance in group.sortedBalances)
        WhitePaddedContainer(child: BalanceCard(balance: balance))
    ]);
  }
}
