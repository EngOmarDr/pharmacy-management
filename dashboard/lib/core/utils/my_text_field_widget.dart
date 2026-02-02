import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
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
      this.focusNode, this.fieldSubmit});

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? lText;
  final String? hText;
  final Widget? preIcon;
  final Widget? sufIcon;
  final int? maxL;
  final bool obText;
  final FocusNode? focusNode;
  final TextInputType? keyType;
  final List<TextInputFormatter>? format;
  final ValueChanged<String>? fieldSubmit;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obText,
      controller: controller,
      keyboardType: keyType,
      inputFormatters: format,
      maxLength: maxL,
      focusNode: focusNode,
      validator: validator ?? nullValidate,
      onFieldSubmitted: fieldSubmit,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
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

extension Gap on MyTextField {
  gap() {
    return Column(
      children: [this, const SizedBox(height: 15)],
    );
  }
}
