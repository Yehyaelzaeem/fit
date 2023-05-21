import 'package:app/app/models/transformation_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/modules/transform/views/image_viewr.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
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
        body: ListView(children: [
      HomeAppbar(type: null),
      SizedBox(height: 12),
      Row(
        children: [
          PageLable(name: "Transformations"),
        ],
      ),
      SizedBox(height: 12),
      isLoading == true
          ? CircularLoadingWidget()
          : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 9),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
              ),
              itemCount: ressponse.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomImageViewer(
                                  image: ressponse.data![index].content!,
                                  tite: "Transformations",
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image:
                                  NetworkImage(ressponse.data![index].content!),
                              fit: BoxFit.contain)),
                    ),
                  ),
                );
              })
    ]));
  }
}
