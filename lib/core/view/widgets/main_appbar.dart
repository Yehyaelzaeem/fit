import 'package:flutter/material.dart';

import '../../resources/resources.dart';
import '../views.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final double? actionsPadding;

  const MainAppbar({required this.title, this.actions, this.actionsPadding, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      showDefaultBackButton: true,
      actions: actions,
      centerTitle: true,
      actionsPadding: actionsPadding,
      title: CustomText(
        title,
        fontSize: FontSize.s14,
        fontWeight: FontWeightManager.semiBold,
        color: AppColors.primary,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
