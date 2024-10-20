import 'package:flutter/material.dart';

import '../../../config/navigation/navigation_services.dart';
import '../../resources/resources.dart';
import 'custom_text.dart';

class FitNewAppBar extends StatelessWidget {
  final String title;
  const FitNewAppBar({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:AppSize.s16,vertical: AppSize.s32),
      child: Row(
        children: [
          InkWell(
              onTap: (){
                NavigationService.goBack(context);
              },
              child: Icon(Icons.arrow_back,color: AppColors.black,)),
          SizedBox(width: AppSize.s24,),
          CustomText(
            title,
            fontSize: FontSize.s20,
            fontWeight: FontWeightManager.medium,
          ),
        ],
      ),
    );
  }
}
