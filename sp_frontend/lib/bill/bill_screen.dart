import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/bill/bill_create_screen.dart';
import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/bill/bill_provider.dart';
import 'package:sp_frontend/components/medium_button.dart';
import 'package:sp_frontend/components/user_display.dart';
import 'package:sp_frontend/components/white_padded_container.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/theme/page_transition.dart';
import 'package:sp_frontend/user/user_provider.dart';

class BillScreen extends StatefulWidget {
  final Group? group;
  final String billId;
  const BillScreen({super.key, this.group, required this.billId});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final Map<String, bool> _isChanging = {};
  bool _isDeleting = false;
  bool _doneOnce = false;
  Bill? bill;
  Group? group;

  /// Checks if the user is the creditor of the bill
  bool _userIsCreditor(BuildContext context, Bill bill) =>
      context.read<UserProvider>().currentUser!.id == bill.creditor.id;

  Future<void> _changeStatus(bool value, Owe owe, BuildContext context) async {
    final billProvider = context.read<BillProvider>();
    final groupProvider = context.read<GroupProvider>();
    final userProvider = context.read<UserProvider>();

    setState(() {
      _isChanging[owe.id] = true;
    });

    // Call the API to change the status
    await billProvider.changeStatus(owe.id, value);

    // Reload the bill based on whether it is a group bill or not
    if (group != null) {
      await groupProvider.fetchGroup(group!.id);
      group = groupProvider.getGroup(group!.id);
    } else {
      await userProvider.reload();
      bill = await billProvider.getBill(bill!.id, forceRefresh: true);
    }

    setState(() {
      _isChanging[owe.id] = false;
    });
  }

  void _goToEditScreen(BuildContext context) async {
    final billProvider = context.read<BillProvider>();
    final groupProvider = context.read<GroupProvider>();

    // Go to the edit screen
    await Navigator.of(context).push(PageRouteBuilder(
        transitionsBuilder: transitionMaker,
        pageBuilder: (_, __, ___) => BillCreateScreen(
              group: group,
              bill: bill!,
            )));
    setState(() {
      // Reload the bill based on whether it is a group bill or not
      if (group != null) {
        if (mounted) {
          group = groupProvider.getGroup(group!.id);
          bill = group!.getBill(widget.billId);
        }
      } else {
        if (mounted) {
          bill = billProvider.bills[widget.billId]!;
        }
      }

      _isChanging.clear();
      // Reset the _isChanging map
      for (var owe in bill!.owes) {
        _isChanging[owe.id] = false;
      }
    });
  }

  Future<void> _deleteBill(BuildContext context) async {
    final billProvider = context.read<BillProvider>();
    final groupProvider = context.read<GroupProvider>();
    final userProvider = context.read<UserProvider>();

    setState(() {
      _isDeleting = true;
    });

    await billProvider.deleteBill(widget.billId);

    if (group != null) {
      await groupProvider.fetchGroup(group!.id);
    } else {
      await userProvider.reload();
    }

    setState(() {
      _isDeleting = false;
    });

    if (context.mounted) Navigator.of(context).pop();
  }

  Widget _proxyBuild(Bill bill, BuildContext context) {
    // Initialize the _isChanging map
    if (_isChanging.isEmpty) {
      for (var owe in bill.owes) {
        _isChanging[owe.id] = false;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Heading
          Text(bill.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 20),

          // Paid By
          WhitePaddedContainer(
            child: Row(
              children: [
                Text(
                  "Paid by",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 20),
                UserDispaly(user: bill.creditor)
              ],
            ),
          ),

          // Amount
          WhitePaddedContainer(
            child: Row(
              children: [
                Text(
                  "Amount",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 20),
                Text(
                  "₹${bill.amount.toStringAsFixed(2)}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),

          // Participants
          WhitePaddedContainer(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Participants",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              for (final owe in bill.owes)
                // Each owe
                Row(
                  children: [
                    _isChanging[owe.id]!
                        ? const SpinKitPulse(
                            color: Palette.alpha,
                            size: 48,
                          )
                        : Checkbox(
                            value: owe.status == OweStatus.paid,
                            fillColor: MaterialStateProperty.all(Palette.alpha),
                            onChanged: _userIsCreditor(context, bill)
                                ? (v) => _changeStatus(v!, owe, context)
                                : null),
                    UserDispaly(user: owe.debtor),
                    const Spacer(),
                    const Text("₹"),
                    SizedBox(
                        width: 70,
                        child: Text(
                          owe.amount.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ))
                  ],
                ),
            ],
          )),

          // Edit Button
          if (_userIsCreditor(context, bill)) ...[
            const SizedBox(height: 10),
            MediumButton(
                text: "Edit",
                icon: Icons.edit,
                callback: () => _goToEditScreen(context),
                color: Palette.alpha),
            const SizedBox(height: 10),
            _isDeleting
                ? const SpinKitPulse(
                    color: Palette.beta,
                    size: 48,
                  )
                : MediumButton(
                    text: "Delete",
                    color: Palette.beta,
                    callback: () => _deleteBill(context),
                    icon: Icons.delete_outline),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    group = group ?? widget.group;

    if (group != null) {
      bill = group!.getBill(widget.billId);
    }

    final billProvider = context.read<BillProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: bill != null
          ? _proxyBuild(bill!, context)
          : FutureBuilder(
              // Force refresh only once
              future:
                  billProvider.getBill(widget.billId, forceRefresh: !_doneOnce),
              builder: (context, snapshot) {
                if (!_doneOnce) {
                  _doneOnce = true;
                }

                if (snapshot.hasError) {
                  if (kDebugMode) {
                    print(snapshot.error);
                  }
                }

                if (snapshot.hasData) {
                  bill = snapshot.data as Bill;
                  return _proxyBuild(bill!, context);
                } else {
                  // Show a loading indicator
                  return const Center(
                    child: SpinKitPulse(
                      color: Palette.alpha,
                      size: 48,
                    ),
                  );
                }
              }),
    );
  }
}
