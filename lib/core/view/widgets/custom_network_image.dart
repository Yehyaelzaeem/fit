import 'package:flutter/material.dart';

import '../../resources/resources.dart';

class CustomNetworkImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const CustomNetworkImage({
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = AppSize.s0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: FadeInImage.assetNetwork(
        image: image,
        width: width,
        height: height,
        placeholder: AppImages.placeholder,
        fit: fit,
        placeholderFit: BoxFit.cover,
        imageErrorBuilder: (_, __, ___) => Image.asset(
          AppImages.placeholder,
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
