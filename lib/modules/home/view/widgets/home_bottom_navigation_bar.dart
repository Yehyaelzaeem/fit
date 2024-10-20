import 'package:app/core/resources/app_colors.dart';
import 'package:app/core/resources/resources.dart';
import 'package:app/core/view/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/view/widgets/default/text.dart';
import '../../../diary/controllers/diary_controller.dart';
import '../../../diary/cubits/diary_cubit.dart';
import '../../cubits/home_cubit.dart';

class HomeBottomNavigationBar extends StatefulWidget {
   HomeBottomNavigationBar({super.key});

  @override
  State<HomeBottomNavigationBar> createState() => _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  late final HomeCubit homeCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeCubit = BlocProvider.of<HomeCubit>(context);

  }


  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomAppBar(
       // shape: widget.notchedShape,
        elevation: 0,
        color: Colors.transparent,
        //notchMargin: widget.floatingMargin,

        //clipBehavior: Clip.antiAliasWithSaveLayer,
        //shape: CircularNotchedRectangle(),
        child: buildBottomNavigationBar(),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        padding: EdgeInsets.only(top: AppSize.s16),
        height: AppSize.s125,
          width: double.infinity,
        decoration: BoxDecoration( color: AppColors.customBlack,

          // borderRadius: BorderRadius.vertical(
          //     top: Radius.elliptical(
          //         500, 110.0)),
        ),
        alignment: Alignment.bottomCenter,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              homeCubit.currentIndex.value = 0;
              // final controllerHome = Get.find<HomeController>(tag: 'home');
              // controllerHome.onInit();
            },
            child: Container(
              height: AppSize.s68,
              width: 100,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: AppColors.customBlack,
                        shape: BoxShape.circle,
                        boxShadow: homeCubit.currentIndex.value == 0?[BoxShadow(
                            blurRadius: 14,
                            offset: Offset(0,0),
                            color: Color(0xff8B8B8B).withOpacity(0.25)
                        )]:null,
                      ),
                      child: SvgPicture.asset(
                              AppIcons.homeBottom,
                              width: 26,
                              height: 26,
                        color: homeCubit.currentIndex.value == 0?AppColors.primary:AppColors.offWhite,
                      ),
                    ),
                    kTextbody(
                      'Home',
                      paddingV: AppSize.s1,
                      color: homeCubit.currentIndex.value == 0
                          ? AppColors.PRIMART_COLOR
                          : AppColors.offWhite,
                    ),

                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              homeCubit.currentIndex.value = 1;
              // final controllerDiary = Get.find<DiaryController>(tag: 'diary');
              BlocProvider.of<DiaryCubit>(context).onInit();
            },
            child: Container(
              height: AppSize.s82,
              width: 100,
              child: Center(
                child: Column(
                  children: [

                         Container(
                           padding: const EdgeInsets.all(10.0),
                           decoration: BoxDecoration(
                               color: AppColors.customBlack,
                               shape: BoxShape.circle,
                               boxShadow: homeCubit.currentIndex.value == 1?[BoxShadow(
                                 blurRadius: 14,
                                 offset: Offset(0,0),
                                 color: Color(0xff8B8B8B).withOpacity(0.25)
                               )]:null,
                           ),

                           child: SvgPicture.asset(
                                               AppIcons.notebook,
                                               width: 26,
                                               height: 26,
                             color: homeCubit.currentIndex.value == 1?AppColors.primary:AppColors.offWhite,
                                             ),
                         ),
                    kTextbody('Diary',
                        paddingV: AppSize.s1,
                        color: homeCubit.currentIndex.value == 1
                            ? AppColors.PRIMART_COLOR
                            : AppColors.offWhite),
                    VerticalSpace(AppSize.s12)
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              homeCubit.currentIndex.value = 2;
            },
            child: Container(
              height: AppSize.s68,
              width: 100,
              child: Center(
                child: Column(
                  children: [
                     Container(
                       padding: const EdgeInsets.all(10.0),
                       decoration: BoxDecoration(
                         color: AppColors.customBlack,
                         shape: BoxShape.circle,
                         boxShadow: homeCubit.currentIndex.value == 2?[BoxShadow(
                             blurRadius: 14,
                             offset: Offset(0,0),
                             color: Color(0xff8B8B8B).withOpacity(0.25)
                         )]:null,
                       ),
                       child: Image.asset(
                              AppImages.doctor,
                              width: 26,
                              height: 26,
                         color: homeCubit.currentIndex.value == 2?AppColors.primary:AppColors.offWhite,
                       ),
                     ),
                    kTextbody('Sessions',
                        paddingV: AppSize.s1,
                        color: homeCubit.currentIndex.value == 2
                            ? AppColors.PRIMART_COLOR
                            : AppColors.offWhite),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from the bottom left corner
    path.lineTo(0, size.height);

    // Create a curve from bottom left to bottom right
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    // Close the path (back to starting point)
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TopHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start at the bottom left
    path.lineTo(0, size.height);

    // Draw an arc (half-circle) at the top
    path.arcToPoint(
      Offset(size.width, size.height),
      radius: Radius.elliptical(size.width / 2, size.height),
      clockwise: false,
    );

    // Close the path to the bottom right
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

/*
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}*/

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double curveHeight = 40; // Height of the curve

    // The control point and end point of the curve
    Offset controlPoint = Offset(size.width / 2, curveHeight);
    Offset endPoint = Offset(size.width, curveHeight);

    Path path = Path()
    // Start from the top-left corner
      ..moveTo(0, curveHeight)
    // Draw the curve using quadraticBezierTo
      ..quadraticBezierTo(controlPoint.dx, 0, endPoint.dx, curveHeight)
    // Continue drawing the rest of the path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}