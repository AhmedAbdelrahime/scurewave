import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final IconData icon;
  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final ValueChanged<String>? onChanged; // Optional onChanged callback

  const CustomTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.fillColor = Colors.black54,
    this.borderColor = Colors.white70,
    this.focusedBorderColor = Colors.blueAccent,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 2.0,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      cursorColor: focusedBorderColor,
      onChanged: onChanged, // Use the onChanged callback if provided
    );
  }
}
