import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/components/screen_title.dart';
import 'package:sp_frontend/home/components/group_card.dart';
import 'package:sp_frontend/user/user_provider.dart';
import 'package:sp_frontend/util/empty.dart';

class GroupView extends StatelessWidget {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 70.0, left: 20.0, right: 20.0, bottom: 64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenTitle(title: 'Groups'),
            for (final group in user.currentUser!.groups)
              GroupCard(group: group),
            if (user.currentUser!.groups.isEmpty) const Empty()
          ],
        ),
      ),
    );
  }
}
