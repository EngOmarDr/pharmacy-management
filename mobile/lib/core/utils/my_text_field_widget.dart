import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy/core/constant.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    this.validator,
    this.lText,
    this.preIcon,
    this.sufIcon,
    this.obText = false,
    this.keyType,
    this.format,
    this.hText,
    this.maxL,
    this.validMode,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? lText;
  final String? hText;
  final Widget? preIcon;
  final Widget? sufIcon;
  final int? maxL;
  final bool obText;
  final TextInputType? keyType;
  final List<TextInputFormatter>? format;
  final AutovalidateMode? validMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obText,
      controller: controller,
      keyboardType: keyType,
      inputFormatters: format,
      maxLength: maxL,
      validator: validator ?? nullValidate,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      textInputAction: TextInputAction.next,
      autovalidateMode: validMode ?? AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        suffixIcon: sufIcon,
        suffixIconConstraints: sufIcon == null
            ? const BoxConstraints(maxHeight: 0)
            : const BoxConstraints(),
        prefixIcon: preIcon,
        labelText: lText,
        // hintText: hText,
        // label: Text(lText.toString())
      ),
    );
  }
}
