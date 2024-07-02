import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({super.key, this.controller,  this.obscureText = false, this.validator, this.hintText, this.labelText, this.prefixIcon});
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration:  InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        errorStyle: const TextStyle(fontSize: 18.0),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.all(Radius.circular(9.0))),
      ),
    );
  }
}
