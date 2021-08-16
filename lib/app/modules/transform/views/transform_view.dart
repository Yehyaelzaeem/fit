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
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 8,
                childAspectRatio: 2,
                children: List.generate(ressponse.data!.length, (index) {
                  return Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width / 2.3,
                      height: MediaQuery.of(context).size.width / 2.3,
                      child: ressponse.data![index].type == "image"
                          ? Image.network(
                              "${ressponse.data![index].content}",
                              fit: BoxFit.cover,
                            )
                          : Html(data: """${ressponse.data![index].content}"""));
                }),
              ),
            )
    ]));
  }
}
