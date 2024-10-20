import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/resources.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool showDefaultBackButton;
  final Widget? title;
  final List<Widget>? actions;
  final double? actionsPadding;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final Color? bgColor;
  final Widget? flexibleSpace;
  final bool isDarkStatusBar;
  final double elevation;
  final double? toolbarHeight;
  final ShapeBorder? shape;

  const CustomAppbar({
    this.leading,
    this.showDefaultBackButton = true,
    this.title,
    this.actions,
    this.actionsPadding,
    this.bottom,
    this.bgColor,
    this.flexibleSpace,
    this.toolbarHeight,
    this.shape,
    this.centerTitle = false,
    this.isDarkStatusBar = true,
    this.elevation = AppSize.s0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      shape: shape,
      automaticallyImplyLeading: showDefaultBackButton,

      actions: actions != null
          ? [
              Padding(
                padding:  EdgeInsetsDirectional.only(end: actionsPadding ?? AppPadding.p16),
                child: Center(child: Row(children: actions!)),
              ),
            ]
          : null,
      backgroundColor: bgColor?? AppColors.offWhite,

      elevation: elevation,
      centerTitle: centerTitle,
      flexibleSpace: flexibleSpace,
      toolbarHeight: toolbarHeight,
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: isDarkStatusBar ? Brightness.dark : Brightness.light,
        statusBarBrightness: isDarkStatusBar ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
