import 'dart:math';

import 'package:flutter/material.dart';

class ResponsiveService {
  static const Size _designSize = Size(411, 866);
  static const bool _splitScreenMode = false;

  static Size _switchableDesignSize(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ? _designSize : const Size(866, 411);
  }

  static double fullScreenHeight(BuildContext context, {double ratio = 1}) =>
      MediaQuery.of(context).size.height * ratio;

  static double fullScreenWidth(BuildContext context, {double ratio = 1}) => MediaQuery.of(context).size.width * ratio;

  static double availableScreenHeight(BuildContext context, {double ratio = 1}) =>
      (MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.vertical) * ratio;

  static double availableScreenWidth(BuildContext context, {double ratio = 1}) =>
      (MediaQuery.of(context).size.width - MediaQuery.of(context).viewPadding.horizontal) * ratio;

  static Orientation orientation(BuildContext context) => MediaQuery.of(context).orientation;

  static double deviceTopPadding(BuildContext context) => MediaQuery.of(context).padding.top;

  static double deviceBottomPadding(BuildContext context) => MediaQuery.of(context).padding.bottom;

  static double deviceBottomViewPadding(BuildContext context) => MediaQuery.of(context).viewPadding.bottom;

  static double deviceKeyboardHeight(BuildContext context) => MediaQuery.of(context).viewInsets.bottom;

  static double textScaleFactor(BuildContext context) => MediaQuery.of(context).textScaleFactor;

  static double devicePixelRatio(BuildContext context) => MediaQuery.of(context).devicePixelRatio;

  static double scaleWidth(BuildContext context) =>
      availableScreenWidth(context) / _switchableDesignSize(context).width;

  static double scaleHeight(BuildContext context) =>
      (_splitScreenMode ? max(availableScreenHeight(context), 700) : availableScreenHeight(context)) /
      _switchableDesignSize(context).height;

  static double scaleRadius(BuildContext context) => min(scaleWidth(context), scaleHeight(context));

  static double scaleText(BuildContext context) => min(scaleWidth(context), scaleHeight(context));
}
