import 'package:flutter/material.dart';
import 'package:sp_frontend/components/white_padded_container.dart';
import 'package:sp_frontend/group/components/payment_card.dart';
import 'package:sp_frontend/group/components/view_common.dart';
import 'package:sp_frontend/group/group_modal.dart';
import 'package:sp_frontend/components/empty.dart';

class PaymentsView extends StatelessWidget {
  final Group group;
  const PaymentsView({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ViewCommons(
      title: 'Summary',
      children: [
        if (group.payments.isEmpty) const Empty(),
        for (final payment in group.payments)
          WhitePaddedContainer(child: PaymentCard(payment: payment))
      ],
    );
  }
}
