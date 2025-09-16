import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {bool isAdded = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isAdded ? Colors.green : Colors.red,
      duration: const Duration(seconds: 2),
    ),
  );
}
