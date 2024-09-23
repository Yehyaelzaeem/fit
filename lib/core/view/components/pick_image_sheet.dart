// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../config/localization/l10n/l10n.dart';
// import '../../../config/navigation/navigation_services.dart';
// import '../../resources/resources.dart';
// import '../views.dart';
//
// class PickImageSheet extends StatelessWidget {
//   final void Function(File? image) onPickImage;
//   final void Function(List<File> images)? onPickMultipleImages;
//
//   const PickImageSheet({required this.onPickImage, this.onPickMultipleImages, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (onPickMultipleImages != null)
//           CustomButton(
//             isOutlined: true,
//             onPressed: () async {
//               final List<File> images = await Pickers.pickMultiImages();
//               NavigationService.goBack(context);
//               onPickMultipleImages!(images);
//             },
//             child: Row(
//               children: [
//                 CustomIcon(Icons.image),
//                 HorizontalSpace(AppSize.s8),
//                 CustomText(L10n.tr(context).moreThanOneImage)
//               ],
//             ),
//           ),
//         if (onPickMultipleImages != null) const VerticalSpace(AppSize.s12),
//         CustomButton(
//           isOutlined: true,
//           onPressed: () async {
//             final File? image = await Pickers.pickImage(ImageSource.gallery);
//             NavigationService.goBack(context);
//             onPickImage(image);
//           },
//           child: Row(
//             children: [
//               CustomIcon(Icons.image_outlined),
//               HorizontalSpace(AppSize.s8),
//               CustomText(L10n.tr(context).gallery)
//             ],
//           ),
//         ),
//         const VerticalSpace(AppSize.s12),
//         CustomButton(
//           isOutlined: true,
//           onPressed: () async {
//             final File? image = await Pickers.pickImage(ImageSource.camera);
//             NavigationService.goBack(context);
//             onPickImage(image);
//           },
//           child: Row(
//             children: [
//               CustomIcon(Icons.camera_alt),
//               HorizontalSpace(AppSize.s8),
//               CustomText(L10n.tr(context).camera),
//             ],
//           ),
//         ),
//         const VerticalSpace(AppSize.s12),
//         CustomButton(
//           onPressed: () => NavigationService.goBack(context),
//           color: AppColors.red,
//           child: Row(
//             children: [
//               CustomIcon(Icons.cancel, color: AppColors.white),
//               HorizontalSpace(AppSize.s8),
//               CustomText(L10n.tr(context).cancel, color: AppColors.white)
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
