
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class Buttons extends StatelessWidget {
  final String buttonText;
  final double height;
  final double width;
  final Color backgroundColor;
  final Function() onTap;
  final bool? loading;

  const Buttons({
    Key? key,
    required this.buttonText,
    required this.height,
    required this.width,
    required this.backgroundColor,
    required this.onTap,
    this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: AppColors.buttonColor),
            borderRadius: BorderRadius.circular(8)),
        child: Center(

          child: loading == true ?
             const CircleAvatar(
                radius: 12,
                  backgroundColor: Colors.black54,
                  child: CupertinoActivityIndicator(color: Colors.white,)) :
          Text(
            buttonText,
            style: const TextStyle(
                color: Color(0xffffffff),
                fontSize: 16,
                fontFamily: "JetBrainsMono"),
          ),
        ),
      ),
    );
  }
}