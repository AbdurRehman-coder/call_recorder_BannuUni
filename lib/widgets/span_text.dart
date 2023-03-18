import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Constants/colors.dart';


class SpanText extends StatelessWidget {
  final String? firsttext;
  final String? secondtext;
  final Function()? onClicked;
  const SpanText({Key? key, this.firsttext, this.secondtext, this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
          text: firsttext,
          style: const TextStyle(
              color: AppColors.headingColor,
              wordSpacing: 2,
              fontSize: 17,
              fontFamily: "JetBrainsMono"),
          children: <TextSpan>[
            TextSpan(
                text: secondtext,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "JetBrainsMono",
                    color: AppColors.buttonColor,
                    wordSpacing: 2,
                    fontSize: 17),
                recognizer: TapGestureRecognizer()..onTap = () => onClicked),

          ],
        ));
  }
}