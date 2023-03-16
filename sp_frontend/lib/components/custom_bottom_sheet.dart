import 'package:flutter/material.dart';
import 'package:sp_frontend/theme/colors.dart';

class CustomSheet extends StatefulWidget {
  final List<Widget> children;
  const CustomSheet({Key? key, required this.children}) : super(key: key);

  @override
  State<CustomSheet> createState() => _CustomSheetState();
}

class _CustomSheetState extends State<CustomSheet> {
  final scrollController = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize: 0.5,
        controller: scrollController,
        initialChildSize: 0.3,
        snap: true,
        expand: false,
        builder: (context, controller) => SingleChildScrollView(
              controller: controller,
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
