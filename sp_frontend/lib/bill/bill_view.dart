import 'package:flutter/material.dart';
import 'package:sp_frontend/bill/bill_modal.dart';

class BillView extends StatelessWidget {
  final Bill? bill;
  final String billId;
  const BillView({super.key, this.bill, required this.billId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill'),
      ),
      body: const Placeholder(),
    );
  }
}
