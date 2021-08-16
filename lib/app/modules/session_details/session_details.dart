import 'package:app/app/models/sessions_details_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SessionDetails extends StatefulWidget {
  final int? id;

  const SessionDetails({Key? key, this.id}) : super(key: key);

  @override
  _SessionDetailsState createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetails> {
  bool isLoading = true;

  SessionDetailsResponse sessionResponse = SessionDetailsResponse();

  void getAllSessionData() async {
    await ApiProvider().getSessionDetails(widget.id).then((value) {
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

  @override
  void initState() {
    getAllSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppbar(
            type: null,
          ),
          isLoading == true
              ? CircularLoadingWidget()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PageLable(name: "Body Composition"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(
                            Icons.download_sharp,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        child: Text(
                          "${DateTime.now().toString().substring(0, 10)} - 11 : 50 PM",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                    infoRow("Height :", "${sessionResponse.data!.height} "),
                    infoRow("Total Weight :", "${sessionResponse.data!.totalWeight}"),
                    infoRow("Fat Percentage :", "${sessionResponse.data!.fats}"),
                    infoRow("Muscles Percentage :", "${sessionResponse.data!.muscles}"),
                    infoRow("Water Percentage :", "${sessionResponse.data!.water}"),
                    Container(
                        color: kColorAccent,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text(
                                    "Date",
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text(
                                    "Proteins",
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text(
                                    "Carbs & Fats",
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text(
                                    "Total",
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 30,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: sessionResponse.data!.followUpTable!.length,
                        itemBuilder: (context, index) {
                          return tableItem(sessionResponse.data!.followUpTable![index]);
                        }),
                    Center(child: kButton("Follow Up", hight: 45)),
                  ],
                )
        ],
      ),
    );
  }

  Widget infoRow(String? lable, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            Text(
              "${lable}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "${value}",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableItem(FollowUpTable table) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
          color: Colors.grey[300],
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "${table.date}",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "${table.proteinsCalories!.taken}/${table.proteinsCalories!.imposed}",
                      style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "${table.carbsFatsCalories!.taken}/${table.carbsFatsCalories!.imposed}",
                      style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      "${table.proteinsCalories!.taken! + table.carbsFatsCalories!.taken!}/"
                          "${table.proteinsCalories!.imposed! + table.carbsFatsCalories!.imposed!}",
                      style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
