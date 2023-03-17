import 'package:flutter/material.dart';
import 'package:sp_frontend/bill/bill_modal.dart';
import 'package:sp_frontend/theme/colors.dart';

class BillCard extends StatelessWidget {
  final BaseBill bill;
  const BillCard({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
