
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/models/transformation_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/fit_new_app_bar.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/view/widgets/home_appbar.dart';
import 'image_viewr.dart';

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
          FitNewAppBar(
            title: "Transformations",
          ),

      isLoading == true
          ? SizedBox(
          height: 32,
          width: 48,
          child: CircularLoadingWidget())
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
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: ressponse.data![index].content!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.fill,
                        cacheManager: DefaultCacheManager(), // Use the default cache manager
                        placeholder: (ctx, url) {
                          return CircularLoadingWidget();
                        },
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   height: double.infinity,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12),
                    //       image: DecorationImage(
                    //           image:
                    //               NetworkImage(),
                    //           fit: BoxFit.contain)),
                    // ),
                  ),
                );
              })
    ]));
  }
}
