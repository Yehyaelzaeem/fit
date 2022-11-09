import 'package:app/app/models/session_response.dart';
import 'package:app/app/models/user_response.dart';
import 'package:app/app/modules/session_details/session_details.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/network_util/shared_helper.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../main_un_auth.dart';

class SessionsView extends StatefulWidget {
  const SessionsView({Key? key}) : super(key: key);

  @override
  _SessionsViewState createState() => _SessionsViewState();
}

class _SessionsViewState extends State<SessionsView> {
  bool isLoading = true;

  UserResponse ress = UserResponse();

  void getUserData() async {
    await ApiProvider().getProfile().then((value) {
      if (value.success == true) {
        setState(() {
          ress = value;
        });
        getAllSessionData();
      } else {
        Fluttertoast.showToast(msg: "$value");
        print("error");
      }
    });
  }

  SessionResponse sessionResponse = SessionResponse();

  void getAllSessionData() async {
    await ApiProvider().getSessions().then((value) {
      if (value.success == true) {
        setState(() {
          sessionResponse = value;
          isLoading = false;
        });
      } else {
        // Fluttertoast.showToast(msg: "${sessionResponse}");
        print("error");
      }
    });
  }

  bool IsLogggd = false;
  bool getLog = true;

  void getFromCash() async {
    IsLogggd = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    setState(() {
      getLog = false;
    });
    if (IsLogggd != true) {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => UnAuthView(),
      //     ),
      //     (Route<dynamic> route) => false);
    } else {
      getUserData();
    }
  }

  @override
  void initState() {
    getFromCash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getLog
            ? Center()
            : !IsLogggd
                ? MainUnAuth()
                : ListView(
                    children: [
                      SizedBox(height: 6),
                      Row(
                        children: [
                          PageLable(name: "My Sessions"),
                        ],
                      ),
                      isLoading == true
                          ? Container(child: CircularLoadingWidget())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ress.data!.nextSession == null
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
                                                        '${ress.data!.nextSession!.day}',
                                                        color: kColorPrimary,
                                                        size: 16,
                                                        bold: true),
                                                    kTextbody(
                                                      '${ress.data!.nextSession!.sessionDate}',
                                                      color: Colors.black,
                                                      size: 16,
                                                    ),
                                                  ],
                                                )),
                                            Positioned(
                                                right: 26,
                                                top: 3,
                                                child: kTextfooter(
                                                  '${ress.data!.nextSession!.status}',
                                                  color: kColorPrimary,
                                                )),
                                          ],
                                        ),
                                      ),
                                SizedBox(height: 12),
                                PageLable(name: "Completed"),
                                sessionResponse.data!.isEmpty
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
                                        itemCount: sessionResponse.data!.length,
                                        itemBuilder: (context, i) {
                                          return Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 12),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            decoration: BoxDecoration(
                                                color: sessionResponse.data![i].onPeriod ==false
                                                    ? Colors.white
                                                    : redOpacityColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    blurRadius: 3,
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
                                                                kTextbody(
                                                                    '${sessionResponse.data![i].day ?? "Monday"}',
                                                                    color:
                                                                        kColorPrimary,
                                                                    size: 16,
                                                                    bold: true),
                                                                kTextbody(
                                                                  '${sessionResponse.data![i].date}',
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
                                                                '${sessionResponse.data![i].status == "Pending" ? "Pending" : "Details"}',
                                                                hight: 35,
                                                                color: sessionResponse
                                                                            .data![
                                                                                i]
                                                                            .status ==
                                                                        "Pending"
                                                                    ? Colors
                                                                        .grey
                                                                    : kColorPrimary,
                                                                func: () {
                                                              if (sessionResponse
                                                                      .data![i]
                                                                      .status ==
                                                                  "Pending") {
                                                                print(
                                                                    "Pending Item");
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                SessionDetails(id: sessionResponse.data![i].id)));
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
                  ));
  }
}
