import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final IconData prefixIcon;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;

  final IconButton? suffixIcon;
  final TextInputType? textInputType;

  const CustomFormField({
    Key? key,
    this.textInputType,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon,
    required this.controller,
    required this.hintText,
    required this.validator,
    required this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: textInputType,
      obscureText: obscureText,
      maxLines: maxLines,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF59b7b9),
            width: 2.0,
          ),
        ),
        fillColor: const Color(0xff242c4e),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.white,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
