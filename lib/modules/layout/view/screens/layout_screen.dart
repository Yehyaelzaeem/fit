import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../core/resources/app_assets.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/globals.dart';
import '../../cubits/layout_cubit.dart';
import '../widgets/bnb_item.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<LayoutCubit, LayoutStates>(
        buildWhen: (prevState, state) => state is LayoutSetIndexState,
        builder: (context, state) =>
            BlocProvider.of<LayoutCubit>(context).screens[BlocProvider.of<LayoutCubit>(context).currentIndex],
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   buttonBackgroundColor: AppColors.primary,
      //   backgroundColor: AppColors.transparent,
      //   animationDuration: Time.t300ms,
      //
      //   index: BlocProvider.of<LayoutCubit>(context).currentIndex,
      //   onTap: (value){
      //     if(value==2){
      //       invokeIfAuthenticated(context,
      //           callback: ()=> BlocProvider.of<LayoutCubit>(context).setCurrentIndex(value)
      //       );
      //     }else{
      //     BlocProvider.of<LayoutCubit>(context).setCurrentIndex(value);
      //     }
      //     setState(() {
      //
      //     });
      //   },
      //   items: [
      //     BNBItem(icon: AppIcons.home, title: L10n.tr(context).home,isSelected: BlocProvider.of<LayoutCubit>(context).currentIndex==0),
      //     BNBItem(icon: AppIcons.categories, title: L10n.tr(context).categories,isSelected: BlocProvider.of<LayoutCubit>(context).currentIndex==1),
      //     BNBItem(icon: AppIcons.plus, title: L10n.tr(context).addAd,isSelected: BlocProvider.of<LayoutCubit>(context).currentIndex==2),
      //     BNBItem(icon: AppIcons.tools, title: L10n.tr(context).maintenance,isSelected: BlocProvider.of<LayoutCubit>(context).currentIndex==3),
      //     BNBItem(icon: AppIcons.user, title: L10n.tr(context).myProfile,isSelected: BlocProvider.of<LayoutCubit>(context).currentIndex==4),
      //   ],
      // ),
    );
  }
}
