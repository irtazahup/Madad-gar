import 'package:flutter/material.dart';

InputDecoration customInputDecoration(String hint, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: const Color(0xFF1877F2)),
    hintText: hint,
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}
