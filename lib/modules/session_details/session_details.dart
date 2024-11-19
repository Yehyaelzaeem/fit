
import 'package:app/core/resources/app_colors.dart';
import 'package:app/core/view/views.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/navigation/navigation_services.dart';
import '../../core/models/sessions_details_response.dart';
import '../../core/resources/app_values.dart';
import '../../core/resources/resources.dart';
import '../../core/services/api_provider.dart';
import '../../core/utils/alerts.dart';
import '../../core/view/widgets/custom_bottom_sheet.dart';
import '../../core/view/widgets/custom_text.dart';
import '../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../core/view/widgets/default/app_buttons.dart';
import '../../core/view/widgets/default/text.dart';
import '../../core/view/widgets/fit_new_app_bar.dart';
import '../home/view/widgets/home_appbar.dart';
import '../pdf_viewr.dart';
import '../sessions/cubits/session_cubit.dart';
import '../transform/views/image_viewr.dart';


class SessionDetails extends StatefulWidget {
  final int? id;

  const SessionDetails({Key? key, this.id}) : super(key: key);

  @override
  _SessionDetailsState createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetails> {

  late final SessionCubit sessionCubit;

  @override
  void initState() {
    // getFromCash();
    sessionCubit = BlocProvider.of<SessionCubit>(context);
    getAllSessionData();
    super.initState();
  }

  void getAllSessionData() async {
    sessionCubit.fetchSessionDetails(widget.id);
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: ListView(
        children: [


          BlocConsumer<SessionCubit, SessionStates>(
          listener: (context, state) {
            if (state is GetSessionDetailsFailureState) {
              Alerts.showSnackBar(context, state.failure.message,duration: Time.t2s);
            }

            if (state is GetSessionDetailsSuccessState) {
              Alerts.closeAllSnackBars(context);

            }
          },
          builder: (context, state) => state is GetSessionDetailsLoadingState?
          Container(
            color: AppColors.white,
            child: Column(
              children: [
                FitNewAppBar(
                  title: "Body composition",

                ),
                CircularLoadingWidget(),
              ],
            ),
          )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FitNewAppBar(
                      title: "Body composition",
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => CustomImageViewer(
                    //                       image:
                    //                           "${sessionCubit.sessionDetailsResponse!.data!.bodyComposition}",
                    //                       tite: "Body Composition",
                    //                     )));
                    //         // downloadFile(sessionCubit.sessionDetailsResponse!.data!.bodyComposition!);
                    //       },
                    //       child: Container(
                    //         width: 80,
                    //         height: 40,
                    //         padding: const EdgeInsets.symmetric(horizontal: 0),
                    //         margin: EdgeInsets.symmetric(
                    //             horizontal: 18, vertical: 4),
                    //         decoration: BoxDecoration(
                    //           // color: Colors.grey[200],
                    //           borderRadius: BorderRadius.circular(64),
                    //         ),
                    //         child: Image.asset(
                    //           "assets/img/view.png",
                    //           color: kColorPrimary,
                    //           fit: BoxFit.contain,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),

                    Stack(
                      children: [
                        SvgPicture.asset(AppImages.cards,
                          width: deviceWidth,
                          fit: BoxFit.cover,

                        ),
                        Container(
                          width: double.infinity,

                          margin:
                          EdgeInsets.symmetric(vertical: 12),
                          padding:
                          EdgeInsets.symmetric(vertical: AppSize.s2,horizontal: AppSize.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(AppSize.s8),
                                width: AppSize.s125,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.customBlack,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSize.s16),bottomRight: Radius.circular(AppSize.s12))
                                ),
                                child: kTextfooter(
                                  '${sessionCubit.sessionDetailsResponse!.data!.status}',
                                  color: AppColors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      'Session',
                                      color: Colors.white,
                                      fontSize: FontSize.s20,
                                      fontWeight: FontWeightManager.semiBold,
                                    ),
                                    VerticalSpace(AppSize.s8),
                                    CustomText(DateFormat('EEEE').format(DateFormat("EEEE, dd/MM/yyyy hh:mm a").parse(sessionCubit.sessionDetailsResponse!.data!.date!)),
                                      color: AppColors.black, fontWeight: FontWeightManager.semiBold, fontSize: FontSize.s20,),
                                    VerticalSpace(AppSize.s8),
                                    CustomText(DateFormat('dd/MM/yyyy  hh:mm a').format(DateFormat("EEEE, dd/MM/yyyy hh:mm a").parse(sessionCubit.sessionDetailsResponse!.data!.date!)),
                                      color: AppColors.white, fontWeight: FontWeightManager.medium, fontSize: FontSize.s18,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: AppSize.s12,horizontal: AppSize.s12),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       CustomText(DateFormat('EEEE').format(DateFormat("EEEE, dd/MM/yyyy hh:mm a").parse(sessionCubit.sessionDetailsResponse!.data!.date!)),
                    //         color: AppColors.primary, fontWeight: FontWeightManager.semiBold, fontSize: FontSize.s18,),
                    //       VerticalSpace(AppSize.s6),
                    //       CustomText(DateFormat('dd, MMM, yy  hh:mm a').format(DateFormat("EEEE, dd/MM/yyyy hh:mm a").parse(sessionCubit.sessionDetailsResponse!.data!.date!)),
                    //         color: AppColors.black, fontWeight: FontWeightManager.medium, fontSize: FontSize.s16,),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: AppSize.s12),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSize.s16)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 6,
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                //   childAspectRatio: 1.4,
                                //     crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
                                children: [
                                  // infoRow("Height :", "${sessionCubit.sessionDetailsResponse!.data!.height} "),
                                  infoRow("Total Weight :",
                                      "${sessionCubit.sessionDetailsResponse!.data!.totalWeight}"),
                                  infoRow(
                                      "Fats % :", "${sessionCubit.sessionDetailsResponse!.data!.fats}"),
                                  infoRow("Muscles % :",
                                      "${sessionCubit.sessionDetailsResponse!.data!.muscles}"),
                                  infoRow(
                                      "Water % :", "${sessionCubit.sessionDetailsResponse!.data!.water}"),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  VerticalSpace(AppSize.s20),
                                  InkWell(

                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CustomImageViewer(
                                                image:
                                                "${sessionCubit.sessionDetailsResponse!.data!.bodyComposition}",
                                                tite: "Body Composition",
                                              )));
                                      // downloadFile(sessionResponse.data!.bodyComposition!);
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(horizontal: 0),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      decoration: BoxDecoration(
                                        // color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(64),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/paper.svg",
                                        color: kColorPrimary,
                                      ),
                                    ),
                                  ),

                                  VerticalSpace(AppSize.s24),

                                  Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomButton(text: "Follow up",
                                            height: 42,
                                            borderRadius: AppSize.s24,
                                            padding: EdgeInsets.all(6),
                                            onPressed: () {
                                              _launchURL(sessionCubit.sessionDetailsResponse!.data!.followUp!);
                                            }),
                                      )),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     SizedBox(),
                    //     Center(
                    //         child: kButton("Follow up", hight: 45, func: () {
                    //       _launchURL(sessionCubit.sessionDetailsResponse!.data!.followUp!);
                    //     })),
                    //   ],
                    // ),

                    VerticalSpace(AppSize.s16),
                    
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSize.s4),
                        child: Container(
                          padding: EdgeInsets.all(AppSize.s8),
                          decoration: BoxDecoration(
                              color: AppColors.customBlack,
                              // borderRadius: BorderRadius.circular(AppSize.s8),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.1),
                              //     blurRadius: 2,
                              //     spreadRadius: 2,
                              //     offset: Offset(0, 0),
                              //   ),
                              // ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Icon(Icons.calendar_month_outlined,color: AppColors.primary,),
                              HorizontalSpace(AppSize.s12),

                              CustomText(
                                "Day to Day Details",
                                    color: AppColors.white,
                                  fontSize: AppSize.s16
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),


                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: sessionCubit.sessionDetailsResponse!.data!.followUpTable!.length,
                        itemBuilder: (context, index) {
                          return TableWidget(table:
                              sessionCubit.sessionDetailsResponse!.data!.followUpTable![index]);
                        }),
                  ],
                ))
        ],
      ),
    );
  }

  Widget infoRow(String? lable, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              "${lable}",
                  fontWeight: FontWeightManager.regular,
                color: AppColors.customBlack,
                fontSize: FontSize.s14
            ),
            HorizontalSpace(AppSize.s4),
            CustomText(
              "${value}",
                  fontWeight: FontWeightManager.semiBold,
                  fontSize: FontSize.s18,
                  color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget rowItem(CarbsFatsTable item) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              kTextbody(' ${item.qty} ',
                  color: Colors.black, bold: false, size: 14),
              Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey[500]!)),
                  child: kTextbody('${item.quality}',
                      color: Color(int.parse("0xFF${item.color}")),
                      bold: false,
                      size: 12)),
              kTextbody('${item.calories} Cal',
                  color: Colors.black, bold: false, size: 16),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }



  void onClick() async {
    Permission permission = Permission.storage;
    bool status = await permission.status.isGranted;
    if (status) {
      downloadFile('${sessionCubit.sessionDetailsResponse!.data!.bodyComposition}');
    } else {
      print('Permission is granted: $status');
      final requestStatus = permission.request();
      print('Request Status: ${await requestStatus.isGranted}');
    }
  }

  void downloadFile(String url) async {
    // try {
    // Dio dio = Dio();
    // List<Directory>? directories = await getExternalStorageDirectories();
    // directories!.forEach((element) {
    //   print(element.path);
    // });
    // String filePath = '/sdcard/download/${url.split("/").last}.jpeg';
    // print(filePath);
    // await dio.download(url, filePath, onReceiveProgress: (received, total) {
    //   String progress = ((received / total) * 100).toStringAsFixed(0) + "%";
    //   print('Progress: $progress');
    //   _showProgressNotification();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PDFPreview(res: "$url", name: "Body Composition")));

    // });
    // } catch (e) {
    //   if (e.hashCode == 17) {
    //     print("Exist");
    //   } else {
    //     print(e);
    //   }
    // }
  }

  void _launchURL(_url) async => await launch(_url);

// Future<void> _showProgressNotification() async {
//   const int maxProgress = 5;
//   for (int i = 0; i <= maxProgress; i++) {
//     await Future<void>.delayed(const Duration(seconds: 1), () async {
//       final AndroidNotificationDetails androidPlatformChannelSpecifics =
//           AndroidNotificationDetails(
//               'progress channel', 'progress channel', 'progress channel description',
//               channelShowBadge: false,
//               importance: Importance.defaultImportance,
//               priority: Priority.defaultPriority,
//               showProgress: false,
//               onlyAlertOnce: true,
//               maxProgress: maxProgress,
//               progress: i);
//       final NotificationDetails platformChannelSpecifics =
//           NotificationDetails(android: androidPlatformChannelSpecifics);
//       await FlutterLocalNotificationsPlugin().show(
//         0,
//         'Body Composition',
//         'Image Downloaded',
//         platformChannelSpecifics,
//         payload: 'item x',
//       );
//     });
//   }
// }
}


class TableWidget extends StatelessWidget {
  final FollowUpTable table;
  const TableWidget({super.key,required this.table});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ExpandableNotifier(
            initialExpanded: false,
            child: ScrollOnExpand(
              scrollOnExpand: false,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: false,
                ),
                header:
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSize.s12,horizontal: AppSize.s12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(DateFormat('EEEE,').format(DateFormat("EEEE, dd/MM/yyyy").parse(table.date!)),
                        color: AppColors.primary, fontWeight: FontWeightManager.semiBold, fontSize: FontSize.s18,),
                      HorizontalSpace(AppSize.s6),
                      CustomText(DateFormat('dd/MM/yyyy').format(DateFormat("EEEE, dd/MM/yyyy").parse(table.date!)),
                        color: AppColors.black, fontWeight: FontWeightManager.medium, fontSize: FontSize.s16,),

                      Spacer(),

                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     CustomText(DateFormat('EEEE,').format(DateFormat("EEEE, dd/MM/yyyy").parse(table.date!)),
                      //       color: AppColors.primary, fontWeight: FontWeightManager.semiBold, fontSize: FontSize.s18,),
                      //     VerticalSpace(AppSize.s6),
                      //     CustomText(DateFormat('dd/MM/yyyy').format(DateFormat("EEEE, dd/MM/yyyy").parse(table.date!)),
                      //       color: AppColors.black, fontWeight: FontWeightManager.medium, fontSize: FontSize.s16,),
                      //   ],
                      // ),
                          if(table.caloriesTable!=null)
                            table.caloriesTable!.carbsFatsTable!.isNotEmpty ||
                                table.caloriesTable!.fatsTable!.isNotEmpty ||
                                table.caloriesTable!.proteinsCaloriesTable!.isNotEmpty
                                ? Image.asset(
                              'assets/big_logo.png',
                              scale: 20,
                            )
                                : SizedBox(),
                    ],
                  ),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     kTextbody("  Date  ", bold: true),
                //     SizedBox(
                //       width: 14,
                //     ),
                //     kTextbody("${table.date}", bold: true),
                //     Spacer(),
                //     if(table.caloriesTable!=null)
                //       table.caloriesTable!.carbsFatsTable!.isNotEmpty ||
                //           table.caloriesTable!.fatsTable!.isNotEmpty ||
                //           table.caloriesTable!.proteinsCaloriesTable!.isNotEmpty
                //           ? Image.asset(
                //         'assets/big_logo.png',
                //         scale: 20,
                //       )
                //           : SizedBox(),
                //   ],
                // ),
                expanded: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kTextbody('  Proteins  '),
                        kTextbody('  Carbs  '),
                        kTextbody('  Fats  '),
                        kTextbody('  Total  '),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kTextbody(
                          "${table.proteinsCalories?.taken} / ${table.proteinsCalories?.imposed}",
                        ),
                        kTextbody(
                          "${table.carbsFatsCalories?.taken} / ${table.carbsFatsCalories?.imposed}",
                        ),
                        kTextbody(
                          "${table.fatsCalories?.taken} / ${table.fatsCalories?.imposed}",
                        ),
                        kTextbody(
                          "${table.total?.taken} / ${table.total?.imposed}",
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    Center(
                        child: InkWell(
                        child: Container(
                            width: 38,
                            height: 38,
                            padding: const EdgeInsets.all(9),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFF7FC902)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: SvgPicture.asset(AppIcons.arrowRight)), onTap: () {
                          CustomSheet(
                              hight: MediaQuery.of(context).size.height * 0.4,
                              context: context,
                              widget: Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                  top: 20.0,
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: ListView(
                                    children: [
                                      VerticalSpace(AppSize.s6),
                                      Row(
                                        children: [
                                          CustomText(
                                            "Water : ",
                                                fontSize: FontSize.s18,
                                                fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                          CustomText(
                                            "${table.water} ml",
                                                fontSize: FontSize.s18,
                                                fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                      VerticalSpace(AppSize.s6),
                                      Divider(),
                                      Row(
                                        children: [
                                          CustomText(
                                            "Workout Details: ",

                                            fontSize: FontSize.s18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                            ),
                                          // CustomText(
                                          //   "${table.workout != null ? table.workout!.workoutType : "Not Yet"}",
                                          //
                                          //       fontSize: FontSize.s18,
                                          //       fontWeight: FontWeight.w500
                                          //   ),
                                        ],
                                      ),
                                      CustomText(
                                        "${table.workout != null ? table.workout!.workoutDesc : "   "}",
                                          // color: kColorPrimary,
                                          fontSize: FontSize.s16,
                                          fontWeight: FontWeight.w500

                                      ),
                                      VerticalSpace(AppSize.s6),
                                      Divider(),
                                      Row(
                                        children: [
                                          CustomText(
                                            "Sleep time : ",
                                              color: kColorPrimary,
                                              fontSize: FontSize.s18,
                                              fontWeight: FontWeight.w600
                                          ),
                                          CustomText(
                                            "${table.sleepingTime != null ? table.sleepingTime?.sleepingDuration : "Not Yet"}",
                                              fontSize: FontSize.s18,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ],
                                      ),
                                      VerticalSpace(AppSize.s4),
                                      CustomText(
                                        "${table.sleepingTime != null ? table.sleepingTime?.sleepingStatus?.name : "   "}",
                                          fontSize: FontSize.s14,
                                          fontWeight: FontWeightManager.medium
                                      ),
                                      VerticalSpace(AppSize.s6),
                                      Divider(),
                                      CustomText(
                                        "Proteins",
                                          fontSize: FontSize.s18,
                                          fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                      table.caloriesTable!.proteinsCaloriesTable!
                                          .isEmpty
                                          ? Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 50),
                                        child: Center(
                                          child: Text("No Data To Show"),
                                        ),
                                      )
                                          : ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: table.caloriesTable!
                                              .proteinsCaloriesTable!.length,
                                          itemBuilder: (context, inIndex) {
                                            return rowItem(table.caloriesTable!
                                                .proteinsCaloriesTable![inIndex],context);
                                          }),
                                      VerticalSpace(AppSize.s6),
                                      Divider(),
                                      CustomText(
                                        "Carbs",
                                          fontSize: FontSize.s18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                      table.caloriesTable!.carbsFatsTable!.isEmpty
                                          ? Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 50),
                                        child: Center(
                                          child: Text("No Data To Show"),
                                        ),
                                      )
                                          : ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: table.caloriesTable!
                                              .carbsFatsTable!.length,
                                          itemBuilder: (context, inIndex) {
                                            return rowItem(table.caloriesTable!
                                                .carbsFatsTable![inIndex],context);
                                          }),
                                      VerticalSpace(AppSize.s6),
                                      Divider(),
                                      CustomText(
                                        "Fats",
                                          fontSize: FontSize.s18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                      // table.caloriesTable!.fatsTable!.isEmpty
                                      table.caloriesTable!.fatsTable!.isEmpty
                                          ? Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 50),
                                        child: Center(
                                          child: Text("No Data To Show"),
                                        ),
                                      )
                                          : ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: table
                                              .caloriesTable!.fatsTable!.length,
                                          itemBuilder: (context, inIndex) {
                                            return rowItem(table.caloriesTable!
                                                .fatsTable![inIndex],context);
                                          }),
                                      VerticalSpace(AppSize.s6),
                                    ],
                                  ),
                                ),
                              ));
                        })),
                  ],
                ),
                collapsed: const SizedBox(),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  );
                },
              ),
            ),
          ),
        ),
      );

  }


  Widget rowItem(CarbsFatsTable item,BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              kTextbody(' ${item.qty} ',
                  color: Colors.black, bold: false, size: 14),
              Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey[500]!)),
                  child: kTextbody('${item.quality}',
                      color: Color(int.parse("0xFF${item.color}")),
                      bold: false,
                      size: 12)),
              kTextbody('${item.calories} Cal',
                  color: Colors.black, bold: false, size: 16),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

}
