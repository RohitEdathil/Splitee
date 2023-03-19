import 'package:flutter/material.dart';
import 'package:sp_frontend/bill/bill_create_screen.dart';
import 'package:sp_frontend/components/custom_bottom_sheet.dart';
import 'package:sp_frontend/group/add_group_sheet.dart';

import 'package:sp_frontend/home/components/nav_bar.dart';
import 'package:sp_frontend/home/views/bills_view.dart';
import 'package:sp_frontend/home/views/settings_view.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/home/views/group_view.dart';
import 'package:sp_frontend/theme/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController controller = PageController();
  int page = 0;
  bool isBottomSheetOpen = false;
  late PersistentBottomSheetController sheetController;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      // Close bottom sheet if open when page changes
      if (isBottomSheetOpen) {
        sheetController.close();
        isBottomSheetOpen = false;
      }
      setState(() {
        page = controller.page!.round();
      });
    });
  }

  void _groupAdd(BuildContext context) {
    // Close bottom sheet if open when button is pressed
    if (isBottomSheetOpen) {
      sheetController.close();
      isBottomSheetOpen = false;
      return;
    }

    sheetController = Scaffold.of(context).showBottomSheet(
      (context) => const CustomSheet(children: [AddGroupSheet()]),
      backgroundColor: Palette.alphaLight,
      elevation: 0,
    );
    isBottomSheetOpen = true;

    // Set isBottomSheetOpen to false when bottom sheet is closed
    sheetController.closed.then((value) {
      isBottomSheetOpen = false;
    });
  }

  void _billAdd(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
        transitionsBuilder: transitionMaker,
        pageBuilder: (_, __, ___) => const BillCreateScreen()));
  }

  Widget? _getFloatingActionButton() {
    // Only show for first two pages
    if (page == 2) return null;

    return Builder(builder: (context) {
      return FloatingActionButton(
        backgroundColor: Palette.alpha,
        foregroundColor: Palette.alphaLight,
        onPressed: () => page == 0 ? _groupAdd(context) : _billAdd(context),
        child: Icon(page == 0 ? Icons.group_add : Icons.add_shopping_cart),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _getFloatingActionButton(),
      body: PageView(
        controller: controller,
        children: const [
          GroupView(),
          BillsView(),
          SettingsView(),
        ],
      ),
      bottomNavigationBar: HomeNavigation(
        controller: controller,
      ),
    );
  }
}
