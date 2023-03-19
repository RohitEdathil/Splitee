import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sp_frontend/bill/bill_create_screen.dart';
import 'package:sp_frontend/components/nav_bar_item.dart';
import 'package:sp_frontend/group/views/balances_view.dart';
import 'package:sp_frontend/group/views/bills_view.dart';
import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/group/views/options_view.dart';
import 'package:sp_frontend/group/views/payments_view.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/theme/page_transition.dart';

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

  Widget? _getFloatingActionButton() {
    if (curPos >= 2) return null;

    return Builder(builder: (context) {
      return FloatingActionButton(
        backgroundColor: Palette.alpha,
        foregroundColor: Palette.alphaLight,
        onPressed: () =>
            curPos == 1 ? _magicSimplify(context) : _billAdd(context),
        child: Icon(curPos == 0
            ? Icons.add_shopping_cart
            : Icons.auto_fix_high_rounded),
      );
    });
  }

  void _billAdd(BuildContext context) {
    final group = context.read<GroupProvider>().getGroup(widget.groupId);
    Navigator.of(context).push(PageRouteBuilder(
        transitionsBuilder: transitionMaker,
        pageBuilder: (_, __, ___) => BillCreateScreen(group: group)));
  }

  void _magicSimplify(BuildContext context) {
    Navigator.pushNamed(context, '/simplify', arguments: widget.groupId);
  }

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
            floatingActionButton: _getFloatingActionButton(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(group.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Divider(
                    color: Palette.beta,
                    thickness: 1,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: (pos) {
                      setState(() {
                        curPos = pos;
                      });
                    },
                    children: [
                      BillsView(group: group),
                      PaymentsView(group: group),
                      BalancesView(group: group),
                      OptionsView(group: group),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
