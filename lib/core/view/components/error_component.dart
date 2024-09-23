// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../resources/resources.dart';
// import '../views.dart';
//
// class ErrorComponent extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;
//
//   const ErrorComponent({required this.message, required this.onRetry, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SvgPicture.asset(AppImages.forgotPassword, width: deviceWidth * 0.5),
//             const VerticalSpace(AppSize.s16),
//             CustomText(message, textAlign: TextAlign.center, color: AppColors.white),
//             const VerticalSpace(AppSize.s16),
//             CustomButton(text: AppStrings.retry, width: deviceWidth * 0.3, onPressed: onRetry)
//           ],
//         ),
//       ),
//     );
//   }
// }
