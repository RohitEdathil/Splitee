import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/theme/colors.dart';

class GroupScreen extends StatelessWidget {
  final String groupId;
  const GroupScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final group = context.watch<GroupProvider>().getGroup(groupId);

    return group == null
        ? const Scaffold(
            body: Center(
              child: SpinKitPulse(
                color: Palette.alpha,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              foregroundColor: Palette.alpha,
              actions: [
                IconButton(
                  onPressed: () {},
                  tooltip: "Edit name",
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {},
                  tooltip: "Group QR code",
                  icon: const Icon(Icons.qr_code_2),
                ),
                IconButton(
                  onPressed: () {},
                  tooltip: "Leave group",
                  icon: const Icon(Icons.logout_rounded),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Text(group.name,
                          style: Theme.of(context).textTheme.headlineLarge),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
