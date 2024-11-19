
import 'package:app/core/resources/app_assets.dart';
import 'package:app/core/resources/font_manager.dart';
import 'package:app/core/view/views.dart';
import 'package:app/modules/diary/cubits/diary_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/app_values.dart';
import '../../../core/utils/alerts.dart';
import '../../../core/utils/globals.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../auth/cubit/auth_cubit/auth_cubit.dart';
import '../../home/cubits/home_cubit.dart';
import '../../main_un_auth.dart';
import '../../profile/cubits/profile_cubit.dart';
import '../../session_details/session_details.dart';
import '../cubits/session_cubit.dart';

bool detailsLoaded = false;
class SessionsView extends StatefulWidget {
  const SessionsView({Key? key}) : super(key: key);

  @override
  _SessionsViewState createState() => _SessionsViewState();
}

class _SessionsViewState extends State<SessionsView> {
  // bool isLoading = true;

//   UserResponse ress = UserResponse();
//
//   void getUserData() async {
//     await ApiProvider().getProfile().then((value) {
//       if (value.success == true) {
//         setState(() {
//           ress = value;
//         });
//         getAllSessionData();
//       } else {
//
// /*        setState(() {
//           ress = value;
//         });
//         SharedHelper().logout();
//         NavigationService.pushReplacementAll(context,Routes.LOGIN);*/
//         Fluttertoast.showToast(msg: "${value.message}");
//         print("error");
//       }
//     });
//   }
//
//   SessionResponse sessionResponse = SessionResponse();
//
//   void getAllSessionData() async {
//     await ApiProvider().getSessions().then((value) async{
//       if (value.success == true) {
//         setState(() {
//           sessionResponse = value;
//           isLoading = false;
//         });
//         // final result = await Connectivity().checkConnectivity();
//         // if (result != ConnectivityResult.none) {
//         //   if(!detailsLoaded){
//         //     detailsLoaded = true;
//         //   sessionResponse.data!.forEach((element) async{
//         //     await ApiProvider().getSessionDetails(element.id);
//         //     await Future.delayed(Duration(milliseconds: 200));
//         //   });
//         //   detailsLoaded = true;
//         //   }
//         // }
//       } else {
//         final result = await Connectivity().checkConnectivity();
//         if (result != ConnectivityResult.none) {
//         // SharedHelper().logout();
//         NavigationService.pushReplacementAll(context,Routes.loginScreen);
//         }
// //        Fluttertoast.showToast(msg: "${value.message}");
//         print("error");
//       }
//     });
//   }
//
//   bool IsLogggd = false;
//   bool getLog = true;
//
//   void getFromCash() async {
//     IsLogggd = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
//     setState(() {
//       getLog = false;
//     });
//     if (IsLogggd != true) {
//       // Navigator.pushAndRemoveUntil(
//       //     context,
//       //     MaterialPageRoute(
//       //       builder: (context) => UnAuthView(),
//       //     ),
//       //     (Route<dynamic> route) => false);
//     } else {
//       getUserData();
//     }
//   }
  late final SessionCubit sessionCubit;
  late final ProfileCubit profileCubit;
  late final AuthCubit authCubit;
  late final HomeCubit homeCubit;

  @override
  void initState() {
    // getFromCash();
    sessionCubit = BlocProvider.of<SessionCubit>(context);
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    authCubit = BlocProvider.of<AuthCubit>(context);
    homeCubit = BlocProvider.of<HomeCubit>(context);
    getData();
    super.initState();
  }
  getData()async{
    sessionCubit.getSessions();
    await BlocProvider.of<DiaryCubit>(context).sendAndRefresh();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.offWhite,
        body: !authCubit.isAuthed
                ? MainUnAuth()
                : BlocConsumer<SessionCubit, SessionStates>(
                    listener: (context, state) {
                    if (state is GetSessionFailureState) {
                    Alerts.showSnackBar(context, state.failure.message,duration: Time.t2s);
                    }

                    if (state is GetSessionSuccessState) {
                    Alerts.closeAllSnackBars(context);

                    }
                    },
                    builder: (context, state) => state is GetSessionLoadingState
                    ? Container(child: CircularLoadingWidget())
                    : ListView(
                        children: [
                          SizedBox(height: 6),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              currentUser?.data?.nextSession == null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18),
                                      child: Center(
                                          child: Text(
                                        " You Have No Sessions, Book Your Next Session",
                                      )),
                                    )
                                  : Stack(
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
                                          child: Stack(
                                            children: [
                                              Container(
                                                  width: double.infinity,
                                                  child: Column(

                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
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
                                                          '${currentUser!.data!.nextSession!.status}',
                                                          color: AppColors.white,
                                                        ),
                                                      ),
                                                      VerticalSpace(AppSize.s8),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: AppSize.s8),
                                                            child: CustomText(
                                                              'Next Session',
                                                              color: Colors.white,
                                                              fontSize: FontSize.s20,
                                                              fontWeight: FontWeightManager.semiBold,
                                                            ),
                                                          ),
                                                          VerticalSpace(AppSize.s8),
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: AppSize.s8),
                                                            child: CustomText(
                                                                '${currentUser!.data!.nextSession!.day}',
                                                                color: AppColors.black,
                                                                fontSize: FontSize.s20,
                                                                fontWeight: FontWeightManager.semiBold),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                CustomText(
                                                                  DateFormat('dd/MM/yyyy').format(DateFormat("dd/MM/yyyy hh:mm a").parse(currentUser!.data!.nextSession!.sessionDate!)),
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: FontSize.s16,
                                                                ),
                                                                HorizontalSpace(AppSize.s12),
                                                                CustomText(
                                                                  DateFormat('hh:mm a').format(DateFormat("dd/MM/yyyy hh:mm a").parse(currentUser!.data!.nextSession!.sessionDate!)),
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: FontSize.s16,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),


                                                    ],
                                                  )),
                                              // Positioned(
                                              //     right: 26,
                                              //     top: 3,
                                              //     child: kTextfooter(
                                              //       '${currentUser!.data!.nextSession!.status}',
                                              //       color: kColorPrimary,
                                              //     )),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                              SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:AppSize.s16,vertical: AppSize.s8),
                                child: CustomText('Completed',
                                fontWeight: FontWeightManager.semiBold,
                                  fontSize: FontSize.s20,
                                ),
                              ),
                              sessionCubit.sessionResponse!.data!.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:AppSize.s16,vertical: AppSize.s8),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 18),
                                        child: Text("No Sessions Yet"),
                                      )),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: sessionCubit.sessionResponse!.data!.length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 12,horizontal: AppSize.s12),
                                          padding:
                                          EdgeInsets.symmetric(
                                              vertical: AppSize.s16,),
                                          decoration: BoxDecoration(
                                              color: sessionCubit.sessionResponse!
                                                          .data![i].onPeriod ==
                                                      false
                                                  ? Colors.white
                                                  : AppColors.redOpacityColor,
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color: Colors.grey
                                              //         .withOpacity(0.2),
                                              //     blurRadius: 1,
                                              //     offset: Offset(0, 1),
                                              //     spreadRadius: 3,
                                              //   )
                                              // ],
                                          borderRadius: BorderRadius.circular(AppSize.s12),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(horizontal:AppSize.s12),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          // HorizontalSpace(AppSize.s16),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              InkWell(  
                                                                onTap:(){
                                                                  print(sessionCubit.sessionResponse!.data![i].day);
                                                                },
                                                                child: CustomText(
                                                                    '${sessionCubit.sessionResponse!.data![i].day==' '?'Saturday':sessionCubit.sessionResponse!.data![i].day ?? "Monday"}',
                                                                    color:
                                                                        AppColors.primary,
                                                                    fontWeight: FontWeightManager.medium,
                                                                    fontSize: FontSize.s18,),
                                                              ),
                                                              VerticalSpace(AppSize.s8),
                                                              Row(
                                                                children: [
                                                                  CustomText(
                                                                    DateFormat('dd/MM/yyyy').format(DateFormat("dd/MM/yyyy hh:mm a").parse(sessionCubit.sessionResponse!.data![i].date!)),
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: FontSize.s16,
                                                                  ),
                                                                  HorizontalSpace(AppSize.s12),
                                                                  CustomText(
                                                                    DateFormat('hh:mm a').format(DateFormat("dd/MM/yyyy hh:mm a").parse(sessionCubit.sessionResponse!.data![i].date!)),
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: FontSize.s16,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                              child: SizedBox(
                                                                  width: 1)),
                                                          sessionCubit.sessionResponse!.data![i].status != "Pending" ?
                                                          InkWell(
                                                              onTap: (){
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => SessionDetails(
                                                                            id: sessionCubit.sessionResponse
                                                                            !.data![i]
                                                                                .id)));
                                                              },
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
                                                                  child: SvgPicture.asset(AppIcons.arrowRight))):
                                                          kButton(
                                                              '${sessionCubit.sessionResponse!.data![i].status == "Pending" ? "Pending" : "Details"}',
                                                              hight: 35,
                                                              color: sessionCubit.sessionResponse
                                                                          !.data![
                                                                               i]
                                                                          .status ==
                                                                      "Pending"
                                                                  ? Colors.grey
                                                                  : kColorPrimary,
                                                              func: () {
                                                            if (sessionCubit.sessionResponse
                                                                    !.data![i]
                                                                    .status ==
                                                                "Pending") {
                                                              print(
                                                                  "Pending Item");
                                                            } else {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => SessionDetails(
                                                                          id: sessionCubit.sessionResponse
                                                                              !.data![i]
                                                                              .id)));
                                                            }
                                                          }),
                                                          SizedBox(width: 12),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        );
                                      })
                            ],
                          ),
                        ],
                      )));
  }
}
