import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        page = controller.page!.round();
      });
    });
  }

  void _groupAdd() {}
  void _billAdd() {}

  Widget? _getFloatingActionButton() {
    if (page == 2) return null;

    return FloatingActionButton(
      backgroundColor: Palette.alpha,
      foregroundColor: Palette.alphaLight,
      onPressed: page == 0 ? _groupAdd : _billAdd,
      child: Icon(page == 0 ? Icons.group_add : Icons.add_shopping_cart),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _getFloatingActionButton(),
      body: PageView(
        controller: controller,
        children: [
          GroupView(),
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
