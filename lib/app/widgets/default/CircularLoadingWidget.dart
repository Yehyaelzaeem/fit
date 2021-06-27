import 'package:app/app/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CircularLoadingWidget extends StatelessWidget {
  final bool white;
  CircularLoadingWidget({this.white = false});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(
          color: white ? Colors.white : kColorPrimary,
        ),
      ),
    );
  }
}
