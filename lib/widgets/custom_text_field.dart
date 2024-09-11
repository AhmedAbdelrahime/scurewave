import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.keyboardType,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.label,
  });

  final TextInputType keyboardType;
  final TextEditingController controller;
  final String hintText;
  final String? validator;
  final String? label;
  final bool isPassword;
  final IconData icon;

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: TextFormField(
            cursorColor: Colors.blue,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            controller: widget.controller,
            style: const TextStyle(color: Colors.white), // Input text color
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.blue.withOpacity(0.2),
              filled: true,
              prefixIcon: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: _toggleVisibility,
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return widget.validator;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
