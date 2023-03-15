import 'package:flutter/material.dart';
import 'package:sp_frontend/components/custom_bottom_sheet.dart';
import 'package:sp_frontend/group/add_group_screen.dart';

import 'package:sp_frontend/home/components/nav_bar.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/home/group_view.dart';

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

    sheetController.closed.then((value) {
      isBottomSheetOpen = false;
    });
  }

  void _billAdd(BuildContext context) {}

  Widget? _getFloatingActionButton() {
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
        children: [
          const GroupView(),
          Container(),
          Container(),
        ],
      ),
      bottomNavigationBar: HomeNavigation(
        controller: controller,
      ),
    );
  }
}
