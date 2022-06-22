import 'package:app/app/models/general_response.dart';
import 'package:app/app/models/messages_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'notification_details_view.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool isLoading = true;
  bool showLoader = false;

  MessagesResponse ressponse = MessagesResponse();

  void getData() async {
    await ApiProvider().getMessagesData().then((value) async {
      if (value.success == true) {
        setState(() {
          ressponse = value;
          isLoading = false;
        });
      } else {
        setState(() {
          ressponse = value;
        });
        Fluttertoast.showToast(msg: "Check Internet Connection");
        print("error");
      }
    });
  }

  GeneralResponse deleteRessponse = GeneralResponse();

  void deleteMessage(int? id, int? index) async {
    print(id);
    await ApiProvider().deleteMessage(id!).then((value) async {
      if (value.success == true) {
        setState(() {
          deleteRessponse = value;
          isLoading = false;
          ressponse.data!.removeAt(index ?? 0);
        });
      } else {
        setState(() {
          deleteRessponse = value;
        });
        Fluttertoast.showToast(msg: "${deleteRessponse.message}");
        print("error");
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ListView(
          children: [
            HomeAppbar(type: null),
            SizedBox(height: 10),
            Row(
              children: [
                PageLable(name: "Messagses"),
              ],
            ),
            isLoading == true
                ? CircularLoadingWidget()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ressponse.data!.length,
                    itemBuilder: (context, index) {
                      return messageRow(ressponse.data![index], index);
                    })
          ],
        ),
        showLoader == false
            ? SizedBox()
            : Container(
                child: Center(
                  child: CircularLoadingWidget(),
                ),
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(.9),
              )
      ],
    ));
  }

  Widget messageRow(Data element, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotificationDetailsView(
                      id: element.id,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: 6),
                        kTextHeader('Subject:', paddingV: 12, color: kColorPrimary, align: TextAlign.start),
                        kTextHeader('${element.subject}', paddingV: 12, color: Colors.black, align: TextAlign.start),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      deleteMessage(element.id, index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: element.viewStatus == false ? kColorPrimary : Colors.grey[300],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kTextbody(element.viewStatus == false ? "Click To See Info" : "Seen", paddingH: 12, paddingV: 12, align: TextAlign.start, color: element.viewStatus == true ? Colors.black : Colors.white),
                  element.viewStatus == false
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.circle,
                            color: kColorPrimary,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.check,
                            color: kColorPrimary,
                          ),
                        ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(),
              child: kTextfooter(element.date ?? "", paddingH: 0, paddingV: 0, align: TextAlign.end, color: kColorPrimary),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
