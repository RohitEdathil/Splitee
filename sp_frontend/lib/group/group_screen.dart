import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/components/nav_bar_item.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/home/components/nav_bar.dart';
import 'package:sp_frontend/theme/colors.dart';

class GroupScreen extends StatefulWidget {
  final String groupId;
  const GroupScreen({super.key, required this.groupId});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  int active = 0;

  final PageController controller = PageController();
  int curPos = 0;

  @override
  Widget build(BuildContext context) {
    final group = context.watch<GroupProvider>().getGroup(widget.groupId);

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
              scrolledUnderElevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(group.name,
                        style: Theme.of(context).textTheme.headlineLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 60),
                      child: Row(
                        children: [
                          NavBarItem(
                              icon: Icons.shopping_cart,
                              pos: 0,
                              controller: controller,
                              curPos: curPos),
                          NavBarItem(
                              icon: Icons.sync_alt_rounded,
                              pos: 1,
                              controller: controller,
                              curPos: curPos),
                          NavBarItem(
                              icon: Icons.difference_outlined,
                              pos: 2,
                              controller: controller,
                              curPos: curPos),
                          NavBarItem(
                              icon: Icons.settings,
                              pos: 3,
                              controller: controller,
                              curPos: curPos),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Palette.beta,
                      thickness: 1,
                    ),
                    for (int i = 0; i < 10; i++)
                      Container(
                        height: 100,
                        width: double.infinity,
                        color: Palette.alpha,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}
