import 'package:flutter/material.dart';
import 'package:notes_2025/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.onSaved,
    this.obscureText,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.controller,
    this.minLines,
  });
  final String? hintText;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final bool? obscureText;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
      obscureText: obscureText ?? false,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: TextInputType.multiline,
      // style: TextStyle(color: Colors.white),
      onSaved: onSaved,
      decoration: InputDecoration(
        // labelText: labelText,
        // labelStyle: TextStyle(color: kPrimaryColor),
        hintText: hintText,
        hintStyle: TextStyle(color: kPrimaryColor),
        enabledBorder: buildBorder(kPrimaryColor),
        focusedBorder: buildBorder(kPrimaryColor),
        errorBorder: buildBorder(Colors.red),
        focusedErrorBorder: buildBorder(Colors.red),
        errorStyle: TextStyle(fontSize: 15),
      ),
    );
  }

  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}
