import 'package:flutter/material.dart';
import 'package:sp_frontend/theme/colors.dart';

SnackBar customSnackBar(BuildContext context, String message) {
  return SnackBar(
    content: Text(message),
    backgroundColor: Palette.beta,
    duration: const Duration(seconds: 2),
  );
}
