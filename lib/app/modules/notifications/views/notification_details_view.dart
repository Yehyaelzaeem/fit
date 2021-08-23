import 'package:app/app/models/message_details_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationDetailsView extends StatefulWidget {
  final int? id;

  const NotificationDetailsView({Key? key, this.id}) : super(key: key);

  @override
  _NotificationDetailsViewState createState() => _NotificationDetailsViewState();
}

class _NotificationDetailsViewState extends State<NotificationDetailsView> {
  bool isLoading = true;

  MessageDetailsResponse ressponse = MessageDetailsResponse();

  void getData() async {
    await ApiProvider().getMessagesDetailsData(widget.id ?? 0).then((value) async {
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

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          HomeAppbar(
            type: null,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment(0.01, -1.0),
                width: 150.0,
                height: 36.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(64.0),
                  ),
                  color: const Color(0xFF414042),
                ),
                child: Center(
                  child: Text(
                    'Message Details',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          isLoading == true
              ? CircularLoadingWidget()
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text("${ressponse.data!.subject}"),
                  ),
                ),
          isLoading == true
              ? SizedBox()
              : Center(
                  child: Html(
                    data: """${ressponse.data!.message}""",
                  ),
                ),
        ],
      ),
    );
  }
}
