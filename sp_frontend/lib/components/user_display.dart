import 'package:flutter/material.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_modal.dart';

class UserDispaly extends StatelessWidget {
  final BaseUser user;
  const UserDispaly({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user.name,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Opacity(
          opacity: 0.5,
          child: Text(
            user.userId,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Palette.betaDark),
          ),
        ),
      ],
    );
  }
}
