import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/bill/bill_provider.dart';
import 'package:sp_frontend/components/medium_button.dart';
import 'package:sp_frontend/components/user_display.dart';
import 'package:sp_frontend/components/white_padded_container.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_provider.dart';

class BillScreen extends StatefulWidget {
  final Group? group;
  final String billId;
  const BillScreen({super.key, this.group, required this.billId});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final Map<Owe, bool> _isChanging = {};
  bool _isDeleting = false;

  bool _userIsCreditor(BuildContext context, Bill bill) =>
      context.read<UserProvider>().currentUser!.id == bill.creditor.id;

  Future<void> _changeStatus(bool value, Owe owe, BuildContext context) async {
    final billProvider = context.read<BillProvider>();

    setState(() {
      _isChanging[owe] = true;
    });
    await billProvider.changeStatus(owe.id, value);

    owe.status = value ? OweStatus.paid : OweStatus.pending;

    setState(() {
      _isChanging[owe] = false;
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

    if (widget.group != null) {
      await groupProvider.fetchGroup(widget.group!.id);
    } else {
      await userProvider.reload();
    }

    setState(() {
      _isDeleting = false;
    });

    if (mounted) Navigator.of(context).pop();
  }

  Widget _proxyBuild(Bill bill, BuildContext context) {
    if (_isChanging.isEmpty) {
      for (var owe in bill.owes) {
        _isChanging[owe] = false;
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
                Row(
                  children: [
                    if (_userIsCreditor(context, bill))
                      _isChanging[owe]!
                          ? const SpinKitPulse(
                              color: Palette.alpha,
                              size: 48,
                            )
                          : Checkbox(
                              value: owe.status == OweStatus.paid,
                              onChanged: (v) =>
                                  _changeStatus(v!, owe, context)),
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
                callback: () {},
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
    final bill = widget.group!.getBill(widget.billId);

    final billProvider = context.read<BillProvider>();

    return Scaffold(
        appBar: AppBar(),
        body: bill != null
            ? _proxyBuild(bill, context)
            : Text("Not implemented"));
  }
}
