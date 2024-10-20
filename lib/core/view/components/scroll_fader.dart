import 'package:app/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ScrollFader extends StatelessWidget {
  late final Color fromColor;
  late final Color toColor;

  final Widget child;
  ScrollFader({
    Key? key,
    required this.child,
    this.fromColor = AppColors.lightGrey,
    this.toColor = Colors.white10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: child),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  this.fromColor,
                  this.toColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10.0),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  this.fromColor,
                  this.toColor,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10.0),
          ),
        ),
      ],
    );
  }
}