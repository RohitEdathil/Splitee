import 'package:flutter/material.dart';
import 'package:sp_frontend/components/nav_bar_item.dart';
import 'package:sp_frontend/theme/colors.dart';

class HomeNavigation extends StatefulWidget {
  final PageController controller;

  const HomeNavigation({Key? key, required this.controller}) : super(key: key);

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int selected = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        selected = widget.controller.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: Palette.alphaLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        boxShadow: [
          BoxShadow(
            color: Palette.alphaDark.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -1),
          )
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        NavBarItem(
          pos: 0,
          curPos: selected,
          icon: Icons.group,
          controller: widget.controller,
        ),
        NavBarItem(
          pos: 1,
          curPos: selected,
          icon: Icons.shopping_cart_rounded,
          controller: widget.controller,
        ),
        NavBarItem(
          pos: 2,
          curPos: selected,
          icon: Icons.settings_rounded,
          controller: widget.controller,
        ),
      ]),
    );
  }
}
