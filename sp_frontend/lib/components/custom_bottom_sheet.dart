import 'package:flutter/material.dart';
import 'package:sp_frontend/theme/colors.dart';

class CustomSheet extends StatefulWidget {
  final List<Widget> children;
  const CustomSheet({Key? key, required this.children}) : super(key: key);

  @override
  State<CustomSheet> createState() => _CustomSheetState();
}

class _CustomSheetState extends State<CustomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize: 1,
        initialChildSize: 0.3,
        expand: false,
        builder: (context, controller) => SingleChildScrollView(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 25,
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                          color: Palette.alpha,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    ...widget.children,
                  ],
                ),
              ),
            ));
  }
}
