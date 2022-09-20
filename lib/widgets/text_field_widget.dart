
import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class TextFields {
  static Widget emailTextField(
      BuildContext context, {
        String? hintText,
        TextEditingController? controller,
        String? validaterMsg,
        double widthPercentage = 1.0,
        Function(String)? onChanged,
      }) {
    return TextFormField(
      style: const TextStyle(
          color: AppColors.hintTextColor, fontFamily: "JetBrainsMono"),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            fontSize: 12,
            color: AppColors.headingColor,
            fontFamily: "JetBrainsMono"),
      ),
      validator: (value) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern as String);
        return (!regex.hasMatch(value?.replaceAll(' ', '') ?? ''))
            ? validaterMsg
            : null;
      },
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
    );
  }

  static Widget normalTextField(
      BuildContext context, {
        String? hintText,
        TextInputType? keyboardType,
        String? path,
        TextEditingController? controller,
        bool readOnly = false,
        String? validationmessage,
        TextInputType? inputType,
        int? maxLength,
        // String? Function(String?)? validator,
      }) {
    return TextFormField(
      style: const TextStyle(
        color: AppColors.hintTextColor,
      ),
      //  cursorColor: AppColors.textInputColor,
      maxLength: maxLength,
      controller: controller,

      readOnly: readOnly,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        return (value!.isEmpty) ? validationmessage : null;
      },
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }

  static Widget passwordTextField(
      BuildContext context, {
        String? hintText,
        TextEditingController? controller,
        String? validaterMsg,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
        style: const TextStyle(
            color: AppColors.hintTextColor, fontFamily: "JetBrainsMono"),
        controller: controller,
        obscureText: true,
        // cursorColor: AppColors.textInputColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
              fontSize: 12,
              color: AppColors.headingColor,
              fontFamily: "JetBrainsMono"),
        ),
        validator: (value) {
          if (value != null && value.length < 10) {
            return validaterMsg;
          } else {
            return null;
          }
        });
  }
}


class TextfieldsLableText extends StatelessWidget {
  String label;
  TextfieldsLableText({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 16,
          color: AppColors.headingColor,
          fontFamily: "JetBrainsMono"),
    );
  }
}