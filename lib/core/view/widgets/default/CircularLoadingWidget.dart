import 'package:app/core/resources/app_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

import '../../../resources/app_assets.dart';

class CircularLoadingWidget extends StatefulWidget {
  final bool white;

  CircularLoadingWidget({this.white = false});

  @override
  State<CircularLoadingWidget> createState() => _CircularLoadingWidgetState();
}

class _CircularLoadingWidgetState extends State<CircularLoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // One second for a complete cycle
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation and reverse each time

    // Set up the fade animation (opacity between 0 and 1)
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,

      child: Center(
        child:
        FadeTransition(
          opacity: _animation, // Use the animated opacity
          child: Padding(
            padding: const EdgeInsets.only(bottom:AppSize.s64),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 100),
              child: Image.asset(
                AppImages.kLogoColumn,
                width: double.infinity,
              ),
            ),
          ),
        ),

        // Lottie.asset(
        //   'assets/loader.json',
        // ),
      ),
    );
  }
}
