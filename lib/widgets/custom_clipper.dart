import 'package:flutter/cupertino.dart';

class OvalTopBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, 60);
    path.quadraticBezierTo(75, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - size.width / 4, 0, size.width, 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}