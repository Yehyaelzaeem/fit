import 'package:app/core/resources/app_values.dart';
import 'package:flutter/material.dart';

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
      duration: const Duration(milliseconds: 500), // One second for a complete cycle
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation and reverse each time

    // Set up the fade animation (opacity between 0 and 1)
    _animation = Tween<double>(begin: .5, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height:deviceHeight - 100,
      width: deviceWidth,
      color: Colors.white,

      child: Center(
        child:
        Padding(
            padding: const EdgeInsets.only(bottom: AppSize.s82),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSize.s64),
              child: Image.asset(
                'assets/img/fit_loader.gif',
                // AppImages.kLogoColumn,
                // width: double.infinity,
              ),
            ),
          ),
        // ScaleTransition(
        //   scale: _animation,
        // child: Padding(
        //     padding: const EdgeInsets.only(bottom: AppSize.s64),
        //     child: Container(
        //       margin: const EdgeInsets.symmetric(horizontal: 100),
        //       child: Image.asset(
        //         // 'assets/img/loader.gif',
        //         AppImages.kLogoColumn,
        //         width: double.infinity,
        //       ),
        //     ),
        //   ),
        // ),

        // Lottie.asset(
        //   'assets/loader.json',
        // ),
      ),
    );
  }
}
