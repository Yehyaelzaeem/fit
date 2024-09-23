import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_platform_widget.dart';
import '../../../resources/resources.dart';

class LoadingSpinner extends BasePlatformWidget<Widget, Widget> {
  final bool hasSmallRadius;
  final double? verticalSize;
  final double _radius;
  final double _strokeWidth;
  final Color? color;

  const LoadingSpinner({this.hasSmallRadius = false, this.color, this.verticalSize, Key? key})
      : _radius = hasSmallRadius ? AppSize.s12 : AppSize.s24,
        _strokeWidth = hasSmallRadius ? AppSize.s2 : AppSize.s3,
        super(key: key);

  @override
  Widget createCupertinoWidget(BuildContext context) {
    return SizedBox(
      height: verticalSize,
      child: Center(child: CupertinoActivityIndicator(radius: AppSize.s12, color: color)),
    );
  }

  @override
  Widget createMaterialWidget(BuildContext context) {
    return SizedBox(
      height: verticalSize,
      child: Center(
        child: SizedBox(
          height: _radius,
          width: _radius,
          child: CircularProgressIndicator(strokeWidth: _strokeWidth, color: color),
        ),
      ),
    );
  }
}
