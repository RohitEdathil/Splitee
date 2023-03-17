import 'package:flutter/material.dart';

class ViewCommons extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const ViewCommons({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child:
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
          ),
          ...children,
        ]),
      ),
    );
  }
}
