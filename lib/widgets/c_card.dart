import 'package:flutter/material.dart';

class CCard extends StatelessWidget {
  const CCard(
      {super.key,
      required this.child,
      this.radius,
      this.elevation = 5,
      this.width,
      this.height,
      this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final BorderRadius? radius;
  final double elevation;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
          color: const Color(0xff474958),
          boxShadow: [BoxShadow(blurRadius: elevation, color: Colors.black26)],
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
          borderRadius: radius ??
              const BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: Radius.circular(20),
              )),
      child: child,
    );
  }
}
