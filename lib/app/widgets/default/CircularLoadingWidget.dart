import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CircularLoadingWidget extends StatelessWidget {
  final bool white;

  CircularLoadingWidget({this.white = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Lottie.asset('assets/loader.json'),

      ),
    );
  }
}
