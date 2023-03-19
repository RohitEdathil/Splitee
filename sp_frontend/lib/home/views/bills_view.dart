import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/components/screen_title.dart';
import 'package:sp_frontend/group/components/bill_card.dart';
import 'package:sp_frontend/user/user_modal.dart';
import 'package:sp_frontend/user/user_provider.dart';
import 'package:sp_frontend/components/empty.dart';

class BillsView extends StatefulWidget {
  const BillsView({super.key});

  @override
  State<BillsView> createState() => _BillsViewState();
}

class _BillsViewState extends State<BillsView> {
  bool _isCredit = true;

  void _setCredit(bool isCredit) {
    setState(() {
      _isCredit = isCredit;
    });
  }

  /// Filters the bills of the user based on [_isCredit]
  List<BaseBill> _getBills(User user) {
    return user.bills.where((bill) => bill.isCreditor == _isCredit).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser!;

    final bills = _getBills(user);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 70.0, left: 20.0, right: 20.0, bottom: 64.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const ScreenTitle(title: "Individual"),
          Row(
            children: [
              ChoiceChip(
                label: const Text("Credit"),
                selected: _isCredit,
                onSelected: (_) => _setCredit(true),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text("Debit"),
                selected: !_isCredit,
                onSelected: (_) => _setCredit(false),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (bills.isEmpty) const Empty(),
          for (final bill in bills) BillCard(bill: bill),
        ]),
      ),
    );
  }
}
