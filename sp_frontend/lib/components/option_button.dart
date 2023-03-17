import 'package:flutter/material.dart';
import 'package:sp_frontend/components/white_padded_container.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const OptionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return WhitePaddedContainer(
        child: TextButton.icon(
            onPressed: onPressed, icon: Icon(icon), label: Text(text)));
  }
}
