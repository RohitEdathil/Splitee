import 'package:flutter/material.dart';
import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/bill/bill_screen.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/theme/page_transition.dart';

class BillCard extends StatelessWidget {
  final BaseBill bill;
  final Group? group;
  const BillCard({super.key, required this.bill, required this.group});

  void _goToBillScreen(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => BillScreen(billId: bill.id, group: group),
        transitionsBuilder: transitionMaker));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goToBillScreen(context),
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    bill.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      color: Palette.betaDark,
                      size: 15,
                    ),
                    const SizedBox(width: 2),
                    SizedBox(
                      width: 250,
                      child: Text(bill.amount.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(color: Palette.betaDark)),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: Palette.betaDark, size: 15),
          ],
        ),
      ),
    );
  }
}
