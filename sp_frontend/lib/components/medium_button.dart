import 'package:flutter/material.dart';

class MediumButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback callback;
  final IconData icon;
  const MediumButton({
    Key? key,
    required this.text,
    required this.color,
    required this.callback,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: TextButton.icon(
        onPressed: callback,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          overlayColor:
              MaterialStateProperty.all(Colors.white.withOpacity(0.3)),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: MaterialStateProperty.all(color),
        ),
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
    );
  }
}
