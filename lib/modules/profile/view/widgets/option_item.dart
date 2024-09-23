import 'package:flutter/material.dart';

import '../../../../core/resources/resources.dart';
import '../../../../core/view/views.dart';

class OptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget trailing;

  const OptionItem({required this.icon, required this.title, required this.onTap,
    this.trailing = const CustomIcon(Icons.arrow_forward_ios, size: AppSize.s16, color: AppColors.primary),

    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CustomIcon(icon, color: AppColors.primary),
          const HorizontalSpace(AppSize.s16),
          CustomText(title),
          const Spacer(),
          const HorizontalSpace(AppSize.s8),
          trailing
        ],
      ),
    );
  }
}
