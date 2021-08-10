import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SessionDetails extends StatefulWidget {
  const SessionDetails({Key? key}) : super(key: key);

  @override
  _SessionDetailsState createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppbar(
            type: null,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Body Composition",
                        style: TextStyle(color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                height: 45,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    color: kColorAccent,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50), bottomRight: Radius.circular(50))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "${DateTime.now().toString().substring(0, 10)} - 11 : 50 PM",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          infoRow("Height :", "160 Cm"),
          infoRow("Total Weight :", "70 KG"),
          infoRow("Fat Percentage :", "30%"),
          infoRow("Muscles Percentage :", "20%"),
          infoRow("Water Percentage :", "50%"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              kButton("Follow Up", paddingH: 20),
            ],
          ),
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
          tableItem(),
          tableItem(),
          tableItem(),
          tableItem(),
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

  Widget tableItem(// String? date, String? protine, String? carps, String? total
      ) {
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
                      "04-06-2021",
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
                      "0/350",
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
                      "0/1200",
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
                      "0/1500",
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
