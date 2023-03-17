import 'package:flutter/material.dart';
import 'package:sp_frontend/components/user_display.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_modal.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
  });

  final MapEntry<BaseUser, double> balance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserDispaly(user: balance.key),
          Text(
              balance.value > 0
                  ? "+${balance.value.toStringAsFixed(2)}"
                  : balance.value.toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: balance.value < 0
                      ? Palette.beta
                      : balance.value > 0
                          ? Palette.alpha
                          : Palette.alphaDark))
        ],
      ),
    );
  }
}
