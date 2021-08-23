import 'package:app/app/models/transformation_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransformView extends StatefulWidget {
  const TransformView({Key? key}) : super(key: key);

  @override
  _TransformViewState createState() => _TransformViewState();
}

class _TransformViewState extends State<TransformView> {
  bool isLoading = true;
  bool showLoader = false;

  TransformationsResponse ressponse = TransformationsResponse();

  void getData() async {
    await ApiProvider().getTransformationData().then((value) async {
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
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 24),
      HomeAppbar(type: null),
      SizedBox(height: 12),
      PageLable(name: "Transformations"),
      isLoading == true
          ? CircularLoadingWidget()
          : Expanded(
              child: ListView.builder(
                itemCount: ressponse.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ressponse.data![index].type == "image"
                        ? Container(
                            height: MediaQuery.of(context).size.height / 4,
                            color: Colors.grey[200],
                            child: Image.network(
                              "${ressponse.data![index].content}",
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width - 100,
                            height: MediaQuery.of(context).size.height /2.2,
                            child: Html(data: """${ressponse.data![index].content}""")),
                  );
                },
              ),
            )
    ]));
  }
}
