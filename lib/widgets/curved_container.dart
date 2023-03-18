import 'package:flutter/material.dart';
import 'custom_clipper.dart';

class CurvedContainer extends StatelessWidget {
  final double height;
  final Color contaienerColor;

  const CurvedContainer({
    Key? key,
    required this.height,
    required this.contaienerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OvalTopBorderClipper(),
      child: Container(
        color: contaienerColor,
        height: height,
      ),
    );
  }
}