
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../config/navigation/navigation_services.dart';
import '../../../config/navigation/routes.dart';
import '../../../core/models/session_response.dart';
import '../../../core/models/user_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/app_values.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/utils/alerts.dart';
import '../../../core/utils/globals.dart';
import '../../../core/utils/shared_helper.dart';
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
    sessionCubit.getSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Row(
                            children: [
                              PageLable(name: "My Sessions"),
                            ],
                          ),
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
                                  : Container(
                                      width: double.infinity,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 12),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      color: Color(0xffF1F1F1),
                                      child: Stack(
                                        children: [
                                          Container(
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  kTextbody(
                                                    'Next Session',
                                                    color: Colors.black,
                                                    size: 16,
                                                  ),
                                                  kTextbody(
                                                      '${currentUser!.data!.nextSession!.day}',
                                                      color: kColorPrimary,
                                                      size: 16,
                                                      bold: true),
                                                  kTextbody(
                                                    '${currentUser!.data!.nextSession!.sessionDate}',
                                                    color: Colors.black,
                                                    size: 16,
                                                  ),
                                                ],
                                              )),
                                          Positioned(
                                              right: 26,
                                              top: 3,
                                              child: kTextfooter(
                                                '${currentUser!.data!.nextSession!.status}',
                                                color: kColorPrimary,
                                              )),
                                        ],
                                      ),
                                    ),
                              SizedBox(height: 12),
                              PageLable(name: "Completed"),
                              sessionCubit.sessionResponse!.data!.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                              vertical: 12),
                                          padding:
                                              EdgeInsets.symmetric(vertical: 6),
                                          decoration: BoxDecoration(
                                              color: sessionCubit.sessionResponse!
                                                          .data![i].onPeriod ==
                                                      false
                                                  ? Colors.white
                                                  : AppColors.redOpacityColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1),
                                                  spreadRadius: 3,
                                                )
                                              ]),
                                          child: Stack(
                                            children: [
                                              Container(
                                                  width: double.infinity,
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
                                                                .end,
                                                        children: [
                                                          Expanded(
                                                              child: SizedBox(
                                                                  width: 1)),
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                onTap:(){
                                                                  print(sessionCubit.sessionResponse!.data![i].day);
                                                                },
                                                                child: kTextbody(
                                                                    '${sessionCubit.sessionResponse!.data![i].day==' '?'Saturday':sessionCubit.sessionResponse!.data![i].day ?? "Monday"}',
                                                                    color:
                                                                        kColorPrimary,
                                                                    size: 16,
                                                                    bold: true),
                                                              ),
                                                              kTextbody(
                                                                '${sessionCubit.sessionResponse!.data![i].date}',
                                                                color: Colors
                                                                    .black,
                                                                size: 16,
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                              child: SizedBox(
                                                                  width: 1)),
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
