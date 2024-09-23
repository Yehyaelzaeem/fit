import 'package:flutter/material.dart';

import '../views.dart';
import '../../resources/resources.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final Widget? child;
  final double? height;
  final double? width;
  final double? textHeight;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final bool isOutlined;
  final double? borderRadius;

  const CustomButton({
    Key? key,
    this.onPressed,
    this.text = "",
    this.color,
    this.textColor,
    this.child,
    this.width,
    this.height,
    this.textHeight,
    this.padding,
    this.borderRadius,
    this.isOutlined = false,
    this.fontSize = FontSize.s16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
            border: isOutlined ? Border.all(color: AppColors.lightGrey) : null,
            color: isOutlined
                ? null
                : onPressed == null
                    ? AppColors.lightGrey
                    : color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(borderRadius ?? AppSize.s8),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius ?? AppSize.s8),
            child: Container(
              padding: height != null
                  ? const EdgeInsets.symmetric(horizontal: AppPadding.p16)
                  : padding ?? const EdgeInsets.symmetric(vertical: AppPadding.p8, horizontal: AppPadding.p10),
              child: text.isNotEmpty
                  ? Center(
                      child: CustomText(
                        text,
                        color: onPressed == null ? AppColors.grey : textColor ?? AppColors.white,
                        fontWeight: FontWeightManager.medium,
                        fontSize: fontSize,
                        textAlign: TextAlign.center,
                        height: textHeight,
                      ),
                    )
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}
