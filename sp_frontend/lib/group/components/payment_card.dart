import 'package:flutter/material.dart';
import 'package:sp_frontend/components/user_display.dart';
import 'package:sp_frontend/group/group_modal.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: UserDispaly(user: payment.from)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.arrow_forward, size: 15),
          ),
          Expanded(flex: 2, child: UserDispaly(user: payment.to)),
          Expanded(
              flex: 2,
              child: Text("₹${payment.amount}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}
