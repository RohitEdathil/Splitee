import 'package:flutter/material.dart';
import 'package:sp_frontend/theme/colors.dart';

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
