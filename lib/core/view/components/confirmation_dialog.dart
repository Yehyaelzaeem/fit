import 'package:flutter/material.dart';

import '../../../config/localization/l10n/l10n.dart';
import '../../../config/navigation/navigation_services.dart';
import '../../resources/resources.dart';
import '../views.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String? confirmText;
  final bool hasNoButton;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    required this.title,
    this.confirmText,
    this.hasNoButton = true,
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s20)),
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p40, vertical: AppPadding.p24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s20),
          color: AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              title,
              fontSize: FontSize.s16,
              fontWeight: FontWeightManager.semiBold,
              textAlign: TextAlign.center,
            ),
            const VerticalSpace(AppSize.s56),
            if (!hasNoButton)
              CustomButton(
                width: AppSize.s150,
                text: confirmText ?? L10n.tr(context).yes,
                onPressed: () {
                  NavigationService.goBack(context);
                  onConfirm();
                },
              ),
            if (hasNoButton)
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      // text: confirmText ?? 'نعم',
                      text: confirmText ?? L10n.tr(context).yes,
                      onPressed: () {
                        NavigationService.goBack(context);
                        onConfirm();
                      },
                    ),
                  ),
                  const HorizontalSpace(AppSize.s16),
                  Expanded(
                    child: CustomButton(
                      isOutlined: true,
                      color: AppColors.white,
                      textColor: AppColors.black,
                      // text: 'لا',
                      text: L10n.tr(context).no,
                      onPressed: () => NavigationService.goBack(context),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
