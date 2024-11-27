import 'dart:io';
import 'dart:isolate';

import 'package:app/config/navigation/navigation.dart';
import 'package:app/core/resources/resources.dart';
import 'package:app/core/view/components/scroll_fader.dart';
import 'package:app/core/view/views.dart';
import 'package:app/modules/home/cubits/home_cubit.dart';
import 'package:app/modules/other_calories/cubits/other_calories_cubit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../config/navigation/routes.dart';
import '../../../core/models/day_details_reposne.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/utils/alerts.dart';
import '../../../core/view/widgets/custom_bottom_sheet.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/edit_text.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../auth/cubit/auth_cubit/auth_cubit.dart';
import '../../home/view/widgets/home_drawer.dart';
import '../../main_un_auth.dart';
import '../../my_other_calories/component/category_tile.dart';
import '../../my_other_calories/my_other_calories.dart';
import '../../sessions/cubits/session_cubit.dart';
import '../../timeSleep/cubits/time_sleep_cubit.dart';
import '../../usuals/controllers/usual_controller.dart';
import '../../usuals/cubits/usual_cubit.dart';
import '../add_new_food.dart';
import '../controllers/diary_controller.dart';
import '../cubits/diary_cubit.dart';
import 'components/diary_dates_widget.dart';
import 'components/diary_section.dart';
import 'components/water_widget.dart';
import 'sleep_time_status.dart';

bool first = true;
class DiaryView extends StatefulWidget {
  DiaryView();


  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {

  late final DiaryCubit diaryCubit;
  late final HomeCubit homeCubit;
  late final AuthCubit authCubit;
  late final OtherCaloriesCubit otherCaloriesCubit;


  @override
  void initState() {
    super.initState();
    diaryCubit = BlocProvider.of<DiaryCubit>(context);
    authCubit = BlocProvider.of<AuthCubit>(context);
    homeCubit = BlocProvider.of<HomeCubit>(context);
    otherCaloriesCubit = BlocProvider.of<OtherCaloriesCubit>(context);
   load();
  }

  load()async{
    homeCubit.loadHomePage();
    await diaryCubit.onInit();
      if(first){
        BlocProvider.of<TimeSleepCubit>(context).getSleepingTimesData();
        // BlocProvider.of<SessionCubit>(context).getSessionsAll();
        BlocProvider.of<UsualCubit>(context).getMyUsualMeals();
        diaryCubit.fetchOtherCalories();
        first = false;
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
        // drawer: Obx(() => Container(
        //     key: Key('drawer_${authCubit.isAuthed}'),
        //     child: HomeDrawer())),
        body: BlocConsumer<DiaryCubit, DiaryState>(
            listener: (context, state) {
              if (state is DiaryFailure) {
                // Alerts.showSnackBar(context, state.failure.message,duration: Time.t2s*3);
              }

              if (state is DiaryLoaded) {
                Alerts.closeAllSnackBars(context);

              }
            },
            builder: (context, state) {
          if (!authCubit.isAuthed) return MainUnAuth();
          if (diaryCubit.showLoader.value || diaryCubit.isLoading.value)
            if(state is DiaryLoading)
            return Container(
                child: CircularLoadingWidget(), color: Colors.white);
          if (!diaryCubit.isLoading.value &&
              diaryCubit.noSessions.value == true)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 200),
              child: Center(
                child: Text(
                  "Book Your Next Session",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17),
                ),
              ),
            );

          return ListView(
            children: [
              //* Header + eye Icon
              // header(),

              Column(
                children: [
                  //* Diary Dates
                  DiaryDatesWidget(),

                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              diaryCubit.downloadFile(context,diaryCubit.dayDetailsResponse!.data!.pdf!);
                            },  child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppSize.s8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText('Calories calculator'),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(vertical: AppSize.s6),
                                  margin: EdgeInsets.symmetric(horizontal: AppSize.s12, vertical: 4),
                                  // height: double.infinity,
                                  decoration: BoxDecoration(
                                    // color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(64),
                                  ),
                                  child: Image.asset(
                                    "assets/img/view.png",
                                    color: kColorPrimary,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                        ),
                        HorizontalSpace(AppSize.s12),
                        InkWell(
                          onTap: (){
                            diaryCubit.sendAndRefresh();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppSize.s8),
                            ),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),

                              child: SvgPicture.asset(
                                AppIcons.sync,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  //* Sleep
                  SleepTimeStatus(isToday: diaryCubit.chosenDay=='today'),
                  SizedBox(height: 16),
                  //*Water Header
                  WaterWidget(),
                  SizedBox(height: 16),
                  // diaryDatesOptions(),
                  // SizedBox(height: 16),
                  //*Water Header
                  // waterHeader(),
                  //*Water Bottles
                  // waterBottles(),
                  // rowWithProgressBar(
                  //     "Proteins", diaryCubit.dayDetailsResponse?.data?.proteins),


                  DiarySection(
                    iconWidget: Container(
                      width: 35,
                      height: 28,
                      decoration: ShapeDecoration(
                        color: Color(0x4C7FC902),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(AppImages.proteins,width: 20,
                        height: 20,),
                    ),
                    title: "Proteins",
                    item:diaryCubit.dayDetailsResponse?.data?.proteins,
                    diaryCubit: diaryCubit,
                    type: 'proteins',
                    caloriesDetails: diaryCubit.dayDetailsResponse?.data?.proteins?.caloriesDetails??[],
                  ),

                  DiarySection(
                      title: "Carbs",
                      item:diaryCubit.dayDetailsResponse?.data?.carbs,
                    diaryCubit: diaryCubit,
                    type: 'carbs',
                    caloriesDetails: diaryCubit.dayDetailsResponse?.data?.carbs?.caloriesDetails??[],
                    iconWidget: Container(
                      width: 35,
                      height: 28,
                      decoration: ShapeDecoration(
                        color: Color(0xFFB9E5F9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(AppImages.carbs,width: 20,
                        height: 20,),
                    ),

                  ),
                  DiarySection(
                    title: "Fats",
                    item:diaryCubit.dayDetailsResponse?.data?.fats,
                    diaryCubit: diaryCubit,
                    type: 'fats',
                    caloriesDetails: diaryCubit.dayDetailsResponse?.data?.fats?.caloriesDetails??[],
                    iconWidget: Container(
                      width: 35,
                      height: 28,
                      decoration: ShapeDecoration(
                        color: Color(0x3FCFC928),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(AppImages.fats,width: 20,
                        height: 20,),
                    ),
                  ),
                  diaryFooter(),
                ],
              )
            ],
          );
        })
    );
  }

  // Widget rowItem(CaloriesDetails item, String type) {
  //   return Container(
  //     height: 40,
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
  //
  //             Expanded(
  //               flex: 3,
  //               child: Container(
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //                 child: Row(
  //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(
  //                       flex: 8,
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           showQualityDialog(
  //                             type == 'proteins'
  //                                 ? diaryCubit
  //                                     .dayDetailsResponse!.data!.proteins!.food!
  //                                 : type == 'carbs'
  //                                     ? diaryCubit
  //                                         .dayDetailsResponse!.data!.carbs!.food!
  //                                     : diaryCubit
  //                                         .dayDetailsResponse!.data!.fats!.food!,
  //                             item,
  //                             type == 'proteins'
  //                                 ? 'proteins'
  //                                 : type == 'carbs' ? 'carbs' : 'fats',
  //                           );
  //                         },
  //                         child: Container(
  //                           margin: EdgeInsets.symmetric(
  //                               horizontal: 2, vertical: 2),
  //                           height: 34,
  //                           child: TextFormField(
  //                             textAlign: TextAlign.center,
  //                             key: Key('foodName_${item.id}_${item.qty}'),
  //                             decoration: InputDecoration(
  //                               hintText: '',
  //                               hintStyle: TextStyle(fontSize: 12),
  //                               labelStyle: TextStyle(fontSize: 12),
  //                               border: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(4),
  //                                 borderSide: BorderSide(
  //                                     color: Colors.grey, width: 1.5),
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(4),
  //                                 borderSide: BorderSide(
  //                                     color: kColorPrimary, width: 1),
  //                               ),
  //                               disabledBorder: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(4),
  //                                 borderSide: BorderSide(
  //                                     color: Colors.grey, width: 1.5),
  //                               ),
  //                               contentPadding: EdgeInsets.only(
  //                                   top: 10, bottom: 10, left: 2),
  //                             ),
  //                             style: TextStyle(
  //                                 fontSize: 12.0,
  //                                 height: 1.4,
  //                                 color: Colors.black),
  //                             enableInteractiveSelection: false,
  //                             initialValue: item.qty == null
  //                                 ? ''
  //                                 : item.qty.toString().replaceAll('.0', ''),
  //                             keyboardType: Platform.isIOS
  //                                 ? TextInputType.numberWithOptions(
  //                                     signed: true, decimal: true)
  //                                 : TextInputType.numberWithOptions(
  //                                     decimal: true, signed: false),
  //                             // keyboardType: TextInputType.number,
  //                             textInputAction: TextInputAction.done,
  //                             onFieldSubmitted: (text) {
  //                               if (text.isEmpty) return;
  //                               try {
  //                                 double qty = double.parse(text);
  //                                 Food food = Food();
  //                                 if (type == 'proteins') {
  //                                   food = diaryCubit
  //                                       .dayDetailsResponse!.data!.proteins!.food!
  //                                       .firstWhere((element) =>
  //                                           element.title == item.quality)
  //                                       ;
  //                                 } else if (type == 'carbs') {
  //                                   food = diaryCubit
  //                                       .dayDetailsResponse!.data!.carbs!.food!
  //                                       .firstWhere((element) =>
  //                                           element.title == item.quality)
  //                                       ;
  //                                 } else {
  //                                   food = diaryCubit
  //                                       .dayDetailsResponse!.data!.fats!.food!
  //                                       .firstWhere((element) =>
  //                                           element.title == item.quality)
  //                                       ;
  //                                 }
  //
  //                                 if(item.id==null&&item.randomId!=null) {
  //                                   diaryCubit.createOrUpdateFoodData(
  //                                     food,
  //                                     qty,
  //                                     type: type == 'proteins'
  //                                         ? 'proteins'
  //                                         : type == 'carbs'
  //                                         ? 'carbs'
  //                                         : 'fats',
  //                                     randomId:item.randomId,
  //                                     index:item.id,
  //                                   );
  //                                 }else{
  //
  //                                   diaryCubit.createOrUpdateFoodData(
  //                                     // item.id,
  //                                     food,
  //                                     qty,
  //                                     type: type == 'proteins'
  //                                         ? 'proteins'
  //                                         : type == 'carbs'
  //                                         ? 'carbs'
  //                                         : 'fats',
  //                                     index:item.id,
  //                                   );
  //                                 }
  //
  //                               } catch (e) {}
  //                             },
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       flex: 5,
  //                       child: FittedBox(
  //                         fit: BoxFit.scaleDown,
  //                         child: Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 1),
  //                           child: kTextbody(
  //                             item.unit == null ? '' : '${item.unit}',
  //                             color: Colors.black,
  //                             bold: false,
  //                             size: 12,
  //                             maxLines: 2,
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
  //             Expanded(
  //               flex: 4,
  //               child: Container(
  //                 margin: EdgeInsets.symmetric(horizontal: 4),
  //                 width: double.infinity,
  //                 height: 34,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     showQualityDialog(
  //                       type == 'proteins'
  //                           ? diaryCubit.dayDetailsResponse!.data!.proteins!.food!
  //                           : type == 'carbs'
  //                               ? diaryCubit.dayDetailsResponse!.data!.carbs!.food!
  //                               : diaryCubit.dayDetailsResponse!.data!.fats!.food!,
  //                       item,
  //                       type == 'proteins'
  //                           ? 'proteins'
  //                           : type == 'carbs'
  //                               ? 'carbs'
  //                               : 'fats',
  //                     );
  //                   },
  //                   child: itemWidget(
  //                     title: item.quality == null ? '' : '${item.quality}',
  //                     showDropDownArrow:
  //                         item.quality == null || '${item.quality}'.isEmpty,
  //                     color: item.color == 'FFFFFF'? '555555': item.color,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
  //             Expanded(
  //               flex: 2,
  //               child: FittedBox(
  //                 fit: BoxFit.scaleDown,
  //                 child: kTextbody(
  //                   item.calories == null ? '' : '${item.calories}',
  //                   color: Colors.black,
  //                   bold: false,
  //                   size: 16,
  //                 ),
  //               ),
  //             ),
  //             Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
  //             Expanded(
  //               flex: 1,
  //               child: DeleteItemWidget(
  //                 controller: diaryCubit,
  //                 item: item,
  //                 index: index,
  //                 type: type == 'proteins'
  //                     ? 'proteins'
  //                     : type == 'carbs'
  //                         ? 'carbs'
  //                         : 'fats',
  //               ),
  //             ),
  //             Container(width: 1, height: 38, color: Color(0xffE1E1E3)),
  //           ],
  //         ),
  //         Divider(
  //           height: 1,
  //           color: Colors.black,
  //         ),
  //       ],
  //     ),
  //   );
  // }


  Widget rowWithProgressBar(String Title, Proteins? item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    '${Title}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              kTextHeader(
                  item!=null?'${item!.caloriesTotal!.taken} / ${item.caloriesTotal!.imposed}':'',
                  bold: false,
                  size: 20,
                  color: Colors.black),
            ],
          ),
        ),
        if(item!=null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Stack(
            children: [
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 20,
                width: deviceWidth *
                    (item.caloriesTotal!.progress!.percentage!.toDouble() /
                        100),
                decoration: BoxDecoration(
                  color: Color(
                      int.parse("0xFF${item.caloriesTotal!.progress!.bg}")),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget staticBar(String type) {
    return Container(
      height: 40,
      color: Color(0xFF414042),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              child: Center(
                child: kTextbody('Quantity',
                    color: Colors.white, bold: true, size: 16),
              ),
            ),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              child: Center(
                child: kTextbody('Quality',
                    color: Colors.white, bold: true, size: 16),
              ),
            ),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 2,
            child: kTextbody('Cal.', color: Colors.white, bold: true, size: 16),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                diaryCubit.addNewRow(type);

              },
              child: Center(
                child: Container(
                    width: 26,
                    height: 26,
                    padding: EdgeInsets.all(AppSize.s2),
                    decoration: BoxDecoration(color: kColorPrimary),
                    child: Icon(
                      Icons.add,
                      color: Colors.black87,
                      size: 18,
                    )),
              ),
            ),
          ),
          Container(width: 1, height: 50, color: Color(0xffE1E1E3)),
        ],
      ),
    );
  }

  // Widget header() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Container(
  //         // padding: EdgeInsets.symmetric(horizontal:16),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.horizontal(
  //             right: Radius.circular(15.0),
  //           ),
  //           color: const Color(0xFF414042),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 4),
  //           child: Column(
  //             children: [
  //               SizedBox(height: 2),
  //               Text(
  //                 '         Calories Calculator       ',
  //                 style: TextStyle(
  //                   fontSize: 16.0,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 2,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       InkWell(
  //         onTap: () {
  //           FocusScope.of(context).requestFocus(FocusNode());
  //           diaryCubit.downloadFile(context,diaryCubit.dayDetailsResponse!.data!.pdf!);
  //         },
  //         child: Container(
  //           width: 80,
  //           height: 40,
  //           padding: const EdgeInsets.symmetric(horizontal: 0),
  //           margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
  //           // height: double.infinity,
  //           decoration: BoxDecoration(
  //             // color: Colors.grey[200],
  //             borderRadius: BorderRadius.circular(64),
  //           ),
  //           child: Image.asset(
  //             "assets/img/view.png",
  //             color: kColorPrimary,
  //             fit: BoxFit.contain,
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Widget diaryDatesOptions() {
  //   Widget dayButton = InkWell(
  //     onTap: () async{
  //       FocusScope.of(context).requestFocus(FocusNode());
  //
  //       if (!diaryCubit.isToday) {
  //         final result = await Connectivity().checkConnectivity();
  //         diaryCubit.isToday = true;
  //
  //
  //         if (result != ConnectivityResult.none) {
  //
  //           diaryCubit
  //               .getDiaryData(
  //               diaryCubit.dayDetailsResponse!.data!.days![0].date!, isSending);
  //           diaryCubit.sendSavedDiaryDataByDay();
  //
  //           diaryCubit.sendSavedSleepTimes();
  //
  //           diaryCubit.refreshDiaryDataLive(
  //               diaryCubit.dayDetailsResponse!.data!.days![0].date!);
  //         }else{
  //           diaryCubit
  //               .getDiaryData(
  //               diaryCubit.dayDetailsResponse!.data!.days![0].date!, false);
  //         }
  //       } else {
  //         diaryCubit.isToday = false;
  //         final result = await Connectivity().checkConnectivity();
  //
  //
  //         if (result != ConnectivityResult.none) {
  //
  //           print("Get Day");
  //           print(diaryCubit.dayDetailsResponse!.data!.days![1].date.toString());
  //           diaryCubit
  //               .getDiaryData(
  //               diaryCubit.dayDetailsResponse!.data!.days![1].date!, isSending);
  //           diaryCubit.sendSavedSleepTimes();
  //
  //           diaryCubit.sendSavedDiaryDataByDay();
  //           diaryCubit.refreshDiaryDataLive(
  //               diaryCubit.dayDetailsResponse!.data!.days![1].date!);
  //         }else{
  //           diaryCubit
  //               .getDiaryData(
  //               diaryCubit.dayDetailsResponse!.data!.days![1].date!, isSending);
  //         }
  //       }
  //     },
  //     child: Container(
  //       width: deviceWidth / 4,
  //       height: 50,
  //       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  //       decoration: BoxDecoration(
  //           color: kColorPrimary, borderRadius: BorderRadius.circular(4)),
  //       child: Center(
  //         child: kTextHeader(diaryCubit.isToday ? 'Yesterday' : 'Today',
  //             color: Colors.white, bold: true, size: 14),
  //       ),
  //     ),
  //   );
  //   Widget dateDisplay = Container(
  //     width: deviceWidth / 1.5,
  //     height: 50,
  //     margin: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
  //     decoration: BoxDecoration(
  //         color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
  //     child: Center(
  //       child: kTextHeader('${diaryCubit.date.value}',
  //           color: Colors.black87, bold: true, size: 14),
  //     ),
  //   );
  //   return diaryCubit.isToday == true
  //       ? Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             dayButton,
  //             dateDisplay,
  //           ],
  //         )
  //       : Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             dateDisplay,
  //             dayButton,
  //           ],
  //         );
  // }

  Widget waterHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Water : ${diaryCubit.dayDetailsResponse?.data?.water ?? ""}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          // SizedBox(),
          Icon(Icons.swap_vert, size: 25, color: kColorPrimary)
        ],
      ),
    );
  }

  Widget waterBottles() {
    return Container(
        width: double.infinity,
        child: GridView.builder(
          itemCount: diaryCubit.length.value,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  diaryCubit.updateWaterData("${index + 1}");
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  diaryCubit.waterBottlesList[index].imagePath),
                              fit: BoxFit.cover)),
                    ),
                    diaryCubit.waterBottlesList[index].selected == false
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                right: 0, left: 0, bottom: 0, top: 0),
                            child: Container(
                              child: Center(
                                child: Icon(
                                  Icons.check_circle,
                                  size: 50,
                                  color: kColorPrimary,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                  ],
                ));
          },
        ));
  }

  Widget diaryFooter() {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:AppSize.s24,vertical: AppSize.s16),
          child: Row(
            children: [

              Expanded(
                    child: CustomButton(
                      text: 'My Meals',
                      height: AppSize.s48,
                      onPressed:  () {
                        // ApiProvider().sendSavedDiaryDataByDay().then((value){
                        //
                        //   controller.getDiaryData(
                        //       controller.lastSelectedDate.value != '' ? controller.lastSelectedDate.value : DateTime
                        //           .now().toString().substring(0, 10),true);
                        // });
                        // ApiProvider().sendSavedSleepTimes();


                        NavigationService.push(context,Routes.usual).then((value)
                        {
                          // diaryCubit.getDiaryData(
                          //     diaryCubit.lastSelectedDate.value != ''
                          //         ? diaryCubit.lastSelectedDate.value
                          //         : DateTime.now()
                          //             .toString()
                          //             .substring(0, 10),
                          //     true);
                          setState(() {

                          });
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      borderRadius: AppSize.s48,
                    ),

              ),
              HorizontalSpace(AppSize.s12),
              Expanded(
                    child: CustomButton(
                      // text: 'My other calories',
                      child: Center(
                        child: FittedBox(
                          child: CustomText(
                            'My other calories',
                            fontWeight: FontWeightManager.medium,
                            color: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      height: AppSize.s48,
                      onPressed:  () async {

                        diaryCubit.sendAndRefresh();
                        dynamic result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyOtherCalories(
                                  canGoBack: true,
                                )));

                        if (result == null) {

                          diaryCubit.getDiaryData(diaryCubit.lastSelectedDate.value,false);
                          diaryCubit.getDiaryDataRefreshResponse(diaryCubit.lastSelectedDate.value);
                        }
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      borderRadius: AppSize.s48,
                    ),

              ),
            ],
          ),
        ),
        SizedBox(height: AppSize.s20),
        InkWell(
          onTap: () {
            print('diaryCubit.workDesc');
            print(diaryCubit.workDesc);
            print(diaryCubit.dayDetailsResponse?.data?.dayWorkouts?.workoutDesc);
            FocusScope.of(context).requestFocus(FocusNode());
            showCustomBottomSheet(context, diaryCubit,"workout");
            // if (diaryCubit.dayDetailsResponse!.data!.workoutDetailsType == "") {
            //   Fluttertoast.showToast(msg: "Nothing To Show ");
            // } else if (diaryCubit.dayDetailsResponse!.data!.workoutDetailsType ==
            //     "link") {
            //   diaryCubit
            //       .launchURL(diaryCubit.dayDetailsResponse!.data!.workoutDetails);
            // } else {
            //   diaryCubit
            //       .showPobUp(context,diaryCubit.dayDetailsResponse!.data!.workoutDetails!);
            // }
          },
          child: Container(
            width: double.infinity,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset(
                    AppIcons.workoutDetails,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Workout Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(
              horizontal: AppSize.s16,
            ),
            decoration: BoxDecoration(
                color: AppColors.customBlack,
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
        SizedBox(height: 12),
        InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            showCustomBottomSheet(context, diaryCubit,"notes");
          },
          child: Container(
            width: double.infinity,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset(
                    AppIcons.notes,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  "Clinic notes",
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            ),
            height: 45,
            margin: EdgeInsets.symmetric(
              horizontal: AppSize.s16,
            ),
            decoration: BoxDecoration(
                color: AppColors.notesbutton.withOpacity(0.11),
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
        SizedBox(height: deviceWidth / 14),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Row(
        //     children: [
        //       Text(
        //         "Workout",
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        //         textAlign: TextAlign.start,
        //       ),
        //     ],
        //   ),
        // ),
        // InkWell(
        //   onTap: () async {
        //     CustomSheet(
        //         context: context,
        //         widget: Padding(
        //           padding: EdgeInsets.only(top: 16),
        //           child: ListView.builder(
        //               itemCount:
        //                   diaryCubit.dayDetailsResponse!.data!.workouts!.length,
        //               itemBuilder: (context, index) {
        //                 return InkWell(
        //                   onTap: () {
        //                     FocusManager.instance.primaryFocus?.unfocus();
        //                     Navigator.pop(context);
        //                     diaryCubit.workOutData.value = diaryCubit
        //                         .dayDetailsResponse!.data!.workouts![index].title!;
        //                     diaryCubit.workOut.value = diaryCubit
        //                         .dayDetailsResponse!.data!.workouts![index].id!;
        //                     setState(() {
        //
        //                     });
        //                   },
        //                   child: Column(
        //                     children: [
        //                       Padding(
        //                         padding: const EdgeInsets.symmetric(
        //                             horizontal: 8, vertical: 16),
        //                         child: Text(
        //                           "${diaryCubit.dayDetailsResponse!.data!.workouts![index].title}",
        //                           style: TextStyle(
        //                               color: Colors.black,
        //                               fontSize: 18,
        //                               fontWeight: FontWeight.bold),
        //                         ),
        //                       ),
        //                       Divider()
        //                     ],
        //                   ),
        //                 );
        //               }),
        //         ));
        //   },
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        //     child: Container(
        //       width: double.infinity,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 16),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Text(
        //               "${diaryCubit.workOutData.value}",
        //               style: TextStyle(fontSize: 20),
        //             ),
        //             Icon(Icons.arrow_drop_down)
        //           ],
        //         ),
        //       ),
        //       height: 40,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(12),
        //         border: Border.all(
        //           color: Colors.black,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // Container(
        //   color: Colors.white,
        //   width: deviceWidth,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),
        //       SizedBox(
        //         height: 20,
        //       ),
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 8),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             kTextbody('Description', size: 20, bold: true),
        //             EditText(
        //               radius: 12,
        //               lines: 5,
        //               value: diaryCubit.workDesc,
        //               type: TextInputType.multiline,
        //               updateFunc: (text) {
        //                 diaryCubit.workDesc = text;
        //                 Echo("${diaryCubit.workDesc}");
        //               },
        //               validateFunc: (text) {},
        //             ),
        //             SizedBox(height: 8),
        //             Center(
        //               child: kButtonDefault(
        //                 'Save',
        //                 marginH: deviceWidth / 5,
        //                 paddingV: 0,
        //                 func: () {
        //                   FocusManager.instance.primaryFocus?.unfocus();
        //                   if (diaryCubit.workDesc?.trim() == "") {
        //                     Fluttertoast.showToast(
        //                         msg: "Enter Workout Description");
        //                   } else {
        //                     diaryCubit.updateWork();
        //                   }
        //                 },
        //                 shadow: true,
        //                 paddingH: 50,
        //                 loading: diaryCubit.workoutLoading.value,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }


  void showCustomBottomSheet(BuildContext context, DiaryCubit diaryCubit,String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return type=='workout'?Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
            left: 16,
            right: 16,
          ),
          child: Container(
            height: diaryCubit.dayDetailsResponse!.data!.workoutDetailsType ==
                "link"?AppSize.s350:deviceWidth*3/2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // "Workout" Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.workoutDetails,color: AppColors.grey,),
                      SizedBox(width: AppSize.s8,),
                      CustomText(
                        'Workout Details',
                        fontWeight: FontWeightManager.semiBold, fontSize: FontSize.s16,
                      ),

                      Spacer(),
                      TextButton(onPressed: (){
                        NavigationService.goBack(context);
                      }, child: CustomText(
                        'cancel'
                      )),
                      Center(
                        child: CustomButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (diaryCubit.workDesc?.trim() == "") {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text("Enter Workout Description")),
                              // );
                              Alerts.showToast("Enter Workout Description");
                            } else {

                              diaryCubit.updateWork().then((value) {
                                NavigationService.goBack(context);
                              });
                            }
                          },
                          child: diaryCubit.workoutLoading.value
                              ? CircularProgressIndicator()
                              : CustomText("Save",color: AppColors.white,),
                          color: AppColors.primary,
                          padding: EdgeInsets.symmetric(horizontal: AppSize.s16,vertical: AppSize.s8)
                          ,borderRadius: AppSize.s24,
                        ),
                      ),


            ],
                  ),
                ),
                diaryCubit.dayDetailsResponse!.data!.workoutDetailsType ==
                    "link"?InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (diaryCubit.dayDetailsResponse!.data!.workoutDetailsType == "") {
                      Fluttertoast.showToast(msg: "Nothing To Show ");
                    } else if (diaryCubit.dayDetailsResponse!.data!.workoutDetailsType ==
                        "link") {
                      diaryCubit
                          .launchURL(diaryCubit.dayDetailsResponse!.data!.workoutDetails);
                    } else {
                      diaryCubit
                          .showPobUp(context,diaryCubit.dayDetailsResponse!.data!.workoutDetails!);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Workout Details",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.upload_sharp,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    height: 45,
                    margin: EdgeInsets.symmetric(
                      horizontal: 72,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xFF414042),
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ):Expanded(
                      child: ScrollFader(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSize.s16),
                            child:
                            SelectableText(
                              diaryCubit.dayDetailsResponse!.data!.workoutDetails!,
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeightManager.regular, fontSize: FontSize.s14,
                              ),
                            ),

                          ),
                        ),
                      )
                    ),

                // Description input field
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Workout Description',
                              fontWeight: FontWeightManager.semiBold, fontSize: FontSize.s16,
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              maxLines: 5,
                              initialValue: diaryCubit.workDesc,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onChanged: (text) {
                                diaryCubit.workDesc = text;
                              },
                            ),
                            SizedBox(height: 8),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ):Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
            left: 16,
            right: 16,
          ),
          child: Container(
            height: diaryCubit.dayDetailsResponse!.data!.clinicDetailsType ==
                "link"?AppSize.s350:deviceWidth*3/2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // "Workout" Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.notes,color: AppColors.grey,),
                      SizedBox(width: AppSize.s8,),
                      CustomText(
                        'Clinic notes',
                        fontWeight: FontWeightManager.semiBold, fontSize: FontSize.s16,
                      ),

                      Spacer(),
                      TextButton(onPressed: (){
                        NavigationService.goBack(context);
                      }, child: CustomText(
                        'cancel'
                      )),
                      Center(
                        child: CustomButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (diaryCubit.clinicDesc?.trim() == "") {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text("Enter Workout Description")),
                              // );
                              Alerts.showToast("Enter Daily notes");
                            } else {

                              diaryCubit.updateNote().then((value) {
                                NavigationService.goBack(context);
                              });
                            }
                          },
                          child: diaryCubit.workoutLoading.value
                              ? CircularProgressIndicator()
                              : CustomText("Save",color: AppColors.white,),
                          color: AppColors.primary,
                          padding: EdgeInsets.symmetric(horizontal: AppSize.s16,vertical: AppSize.s8)
                          ,borderRadius: AppSize.s24,
                        ),
                      ),

                    ],
                  ),
                ),
                diaryCubit.dayDetailsResponse!.data!.clinicDetailsType ==
                    "link"?InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (diaryCubit.dayDetailsResponse!.data!.clinicDetailsType == "") {
                      Fluttertoast.showToast(msg: "Nothing To Show ");
                    } else if (diaryCubit.dayDetailsResponse!.data!.clinicDetailsType ==
                        "link") {
                      diaryCubit
                          .launchURL(diaryCubit.dayDetailsResponse!.data!.clinicDetails);
                    } else {
                      diaryCubit
                          .showPobUp(context,diaryCubit.dayDetailsResponse!.data!.clinicDetails!);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Clinic Details",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.upload_sharp,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    height: 45,
                    margin: EdgeInsets.symmetric(
                      horizontal: 72,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xFF414042),
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ):Expanded(
                    child: ScrollFader(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSize.s16),
                          child: SelectableText(
                            diaryCubit.dayDetailsResponse!.data!.clinicDetails!,
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeightManager.regular, fontSize: FontSize.s14,
                            ),
                          ),
                        ),
                      ),
                    )
                ),

                // Description input field
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Daily notes',
                              fontWeight: FontWeightManager.semiBold, fontSize: FontSize.s16,
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              maxLines: 5,
                              initialValue: diaryCubit.clinicDesc,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onChanged: (text) {
                                diaryCubit.clinicDesc = text;
                              },
                            ),
                            SizedBox(height: 8),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget itemWidget(
      {required String title, bool showDropDownArrow = false, String? color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey, width: 1),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
            key: Key('title$title'),
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: AutoSizeText(
              '$title',
              style: TextStyle(
                  fontSize: 12,
                  color: color != null
                      ? Color(int.parse("0xFF$color"))
                      : Colors.black87,
                  height: 1.2),
              textAlign: TextAlign.center,
              minFontSize: 8,
              maxLines: 2,
            ),
          )),
          if (showDropDownArrow)
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            ),
        ],
      ),
    );
  }

  void showQualityDialog(
      List<Food> food, CaloriesDetails item, String type) async {
    // show screen dialog
    dynamic result = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: AppColors.white.withOpacity(0.1),
            child: AddNewFood(
              date: diaryCubit.lastSelectedDate.value,
              list: food,
            ),
          );
        });
    if (result != null) {
      Food food = result as Food;
      item.quality = food.title;
      item.qty = food.qty;
      item.color = food.color;
      if(food.qty!=null){
        item.calories = food.qty! * food.caloriePerUnit;
        print(item.calories);
        item.unit = food.unit;
      }
      // diaryCubit.dayDetailsResponse!.data?.fats!.caloriesTotal!.taken = diaryCubit.fatsDetails
      //     .fold(0.0, (previousValue, element) => previousValue+(element.qty??0*element.calories??0));
      //
      // diaryCubit.caloriesDetails.forEach((element) {
      //   print(element.calories);
      //   print(element.toJson());
      // });
      // diaryCubit.dayDetailsResponse!.data?.proteins!.caloriesTotal!.taken = diaryCubit.caloriesDetails
      //     .fold(0.0, (previousValue, element) => previousValue+(element.qty??0*element.calories??0));
      //
      // diaryCubit.dayDetailsResponse!.data?.carbs!.caloriesTotal!.taken = diaryCubit.carbsDetails
      //     .fold(0.0, (previousValue, element) => previousValue+(element.qty??0*element.calories??0));

      /// inportant

      // diaryCubit.caloriesDetails.refresh();
      // diaryCubit.carbsDetails.refresh();
      // diaryCubit.fatsDetails.refresh();
      if (item.id == null) {
        if(item.randomId==null) {
          diaryCubit.createOrUpdateFoodData(food, food.qty!, type: type);
        }else{
          // print('CALC');
          diaryCubit.createOrUpdateFoodData(

            food,
            food.qty!,
            type: type == 'proteins'
                ? 'proteins'
                : type == 'carbs'
                ? 'carbs'
                : 'fats',
            randomId:item.randomId,
            index:item.id,
          );
          // diaryCubit.updateDiaryDataLocally(item.randomId!,food, food.qty!, type: type);
        }
      } else {
        diaryCubit.createOrUpdateFoodData(
          food, food.qty!, type: type == 'proteins'
        ? 'proteins'
            : type == 'carbs'
        ? 'carbs'
            : 'fats',
        index: item.id,
        );
      }
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

class DeleteItemWidget extends StatefulWidget {
  final CaloriesDetails item;
  final DiaryCubit controller;
  final String type;
  final int index;

  DeleteItemWidget({
    Key? key,
    required this.item,
    required this.controller,
    required this.type,
    required this.index,
  }) : super(key: key);

  @override
  State<DeleteItemWidget> createState() => _DeleteItemWidgetState();
}

class _DeleteItemWidgetState extends State<DeleteItemWidget> {
  bool deleteItem = false;

  @override
  Widget build(BuildContext context) {
    if (deleteItem)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 1.4,
            ),
          ),
        ],
      );
    return InkWell(
      // onTap: () async {
      //   // deleteItem = true;
      //   // setState(() {});
      //   if (widget.item.id == null && widget.item.randomId == null) {
      //
      //     if(widget.item.quality!=null) {
      //       final result = await Connectivity().checkConnectivity();
      //       if (result != ConnectivityResult.none){
      //         if(widget.controller.isAdding == true) {
      //           if (widget.type == 'proteins') {
      //
      //             widget.controller.caloriesDeleted.add(widget.item);
      //             await widget.controller.caloriesDetails.remove(widget.item);
      //             await widget.controller.calculateProteins();
      //
      //           }
      //           else if (widget.type == 'carbs') {
      //             widget.controller.carbsDeleted.add(widget.item);
      //             await widget.controller.carbsDetails.remove(widget.item);
      //             await widget.controller.calculateCarbs();
      //
      //           }
      //           else {
      //             widget.controller.fatsDeleted.add(widget.item);
      //             await widget.controller.fatsDetails.remove(widget.item);
      //             await widget.controller.calculateFats();
      //
      //           }
      //         }else{
      //           print("way3");
      //           await Future.delayed(Duration(seconds: 1));
      //           if (widget.type == 'proteins') {
      //             widget.controller.caloriesDeleted.add(widget.item);
      //             await widget.controller.caloriesDetails.remove(widget.item);
      //             // await widget.controller.dayDetailsResponse!.data!.proteins!.caloriesDetails.remove(widget.item);
      //             await widget.controller.calculateProteins();
      //
      //             await widget.controller.deleteItemCaloriesCached(widget.item.randomId!,
      //                 widget.controller.lastSelectedDate.value, widget.type);
      //
      //           }
      //           else if (widget.type == 'carbs') {
      //             widget.controller.carbsDeleted.add(widget.item);
      //             await widget.controller.carbsDetails.remove(widget.item);
      //             await widget.controller.calculateCarbs();
      //
      //             await widget.controller.deleteItemCarbsCached(widget.item.randomId!,
      //                 widget.controller.lastSelectedDate.value, widget.type);
      //           }
      //           else {
      //             widget.controller.fatsDeleted.add(widget.item);
      //             await widget.controller.fatsDetails.remove(widget.item);
      //             await widget.controller.calculateFats();
      //           }
      //           // await widget.controller.checkDeletion();
      //
      //         }
      //       }else{
      //         if (widget.type == 'proteins')
      //           await widget.controller.caloriesDetails.remove(widget.item);
      //         else if (widget.type == 'carbs')
      //           await widget.controller.carbsDetails.remove(widget.item);
      //         else
      //           await widget.controller.fatsDetails.remove(widget.item);
      //       }
      //     }else{
      //       if (widget.type == 'proteins')
      //         await widget.controller.caloriesDetails.remove(widget.item);
      //       else if (widget.type == 'carbs')
      //         await widget.controller.carbsDetails.remove(widget.item);
      //       else
      //         await widget.controller.fatsDetails.remove(widget.item);
      //     }
      //   } else {
      //
      //     print("way2");
      //     if(widget.item.randomId != null){
      //       if (widget.type == 'proteins')
      //         await widget.controller.deleteItemCaloriesCached(widget.item.randomId!,
      //             widget.controller.lastSelectedDate.value, widget.type);
      //       else if (widget.type == 'carbs')
      //         await widget.controller.deleteItemCarbsCached(widget.item.randomId!,
      //             widget.controller.lastSelectedDate.value, widget.type);
      //       else
      //         await widget.controller.deleteItemFatsCached(widget.item.randomId!,
      //             widget.controller.lastSelectedDate.value, widget.type);
      //
      //       setState(() {
      //       });
      //     }else {
      //
      //       CaloriesDetails deletedItem = widget.item;
      //       await widget.controller.caloriesDetails.remove(widget.item);
      //       await widget.controller.carbsDetails.remove(widget.item);
      //       await widget.controller.fatsDetails.remove(widget.item);
      //       setState(() {
      //
      //       });
      //       if (widget.type == 'proteins')
      //         await widget.controller.deleteItemCalories(deletedItem.id!,
      //             widget.controller.lastSelectedDate.value, widget.type);
      //       else if (widget.type == 'carbs')
      //         await widget.controller.deleteItemCarbs(deletedItem.id!,
      //             widget.controller.lastSelectedDate.value, widget.type);
      //       else
      //         await widget.controller.deleteItemFats(deletedItem.id!,
      //             widget.controller.lastSelectedDate.value, widget.type);
      //
      //     }
      //   }
      //
      //   deleteItem = false;
      //   // setState(() {});
      //   // FocusScope.of(context).requestFocus(FocusNode());
      //
      //   },
      onTap: () async {
        if (widget.item.randomId != null) {
          print(11);
          await widget.controller.deleteItem(
            id: null,
            randomId: widget.item.randomId!,
            quality: widget.item.quality!,
            date: widget.controller.lastSelectedDate.value,
            type: widget.type,
            isCached: true,
          );
        }
        else if (widget.item.id != null) {
          await widget.controller.deleteItem(
            id: widget.item.id!,
            quality: widget.item.quality,
            randomId: null,
            date: widget.controller.lastSelectedDate.value,
            type: widget.type,
          );
        }
        else{
          await widget.controller.deleteItemEmpty(
            index: widget.index,
            date: widget.controller.lastSelectedDate.value,
            type: widget.type,
          );
          // await widget.controller.deleteItem(
          //   id: null,
          //   randomId: null,
          //   date: widget.controller.lastSelectedDate.value,
          //   type: widget.type,
          // );
          // print('still here');

        }

        // setState(() {
        //   // Update UI after deletion
        // });
      },
      child: SvgPicture.asset(
        AppIcons.trashSvg,
        width: 26,
      ),
    );
  }
}


