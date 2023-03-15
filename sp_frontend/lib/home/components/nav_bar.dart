import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Palette.alphaLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final int pos;
  final int curPos;
  final PageController controller;
  const NavBarItem(
      {Key? key,
      required this.icon,
      required this.pos,
      required this.controller,
      required this.curPos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.animateToPage(
          pos,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        ),
        child: AnimatedScale(
          scale: curPos == pos ? 1.1 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: curPos == pos ? Palette.alpha : Palette.alphaDark,
                ),
                AnimatedScale(
                  scale: curPos == pos ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                    padding: EdgeInsets.all(
                      curPos == pos ? 4 : 0,
                    ),
                    child: Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Palette.alpha,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
