import 'package:flutter/material.dart';
import 'package:sp_frontend/theme/colors.dart';

class CustomInput extends StatelessWidget {
  final bool isPassword;
  final String hintText;
  final Color color;
  final TextEditingController controller;
  const CustomInput(
      {Key? key,
      this.isPassword = false,
      required this.controller,
      required this.hintText,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            fillColor: color,
            filled: true),
      ),
    );
  }
}
