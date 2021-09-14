// import 'package:app/app/models/faq_response.dart';
// import 'package:app/app/modules/home/home_appbar.dart';
// import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
// import 'package:app/app/widgets/default/text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/faq_controller.dart';
//
// class FaqView extends GetView<FaqController> {
//   var sellectedIndex = 0.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 48),
//           HomeAppbar(type: null),
//           SizedBox(height: 12),
//           Container(
//             alignment: Alignment(0.01, -1.0),
//             width: Get.width / 2.4,
//             padding: EdgeInsets.symmetric(horizontal: 4),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.horizontal(
//                 right: Radius.circular(15.0),
//               ),
//               color: const Color(0xFF414042),
//             ),
//             child: Center(
//               child: Text(
//                 'FAQ',
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           Obx(() {
//             if (controller.faqResponse.value.success == true) {
//               for (int i = 0; i < controller.faqResponse.value.data.length; i++)
//                 GestureDetector(
//                   onTap: () {
//                     controller.selectedFaq.value = i;
//                   },
//                   child: Container(
//                     height: 150,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         if (controller.selectedFaq.value == i)
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                             margin: EdgeInsets.symmetric(vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Color(0xffF1F1F1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: kTextHeader(
//                               '${controller.faqResponse.value.data![i].question}',
//                               align: TextAlign.start,
//                               color: Color(0xff7FC902),
//                               bold: true,
//                             ),
//                           ),
//                         if (controller.selectedFaq.value != i)
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                             margin: EdgeInsets.symmetric(vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Color(0xffF1F1F1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: kTextHeader(
//                               '${controller.faqResponse.value.data![i].question}',
//                               align: TextAlign.start,
//                               color: Color(0xff7FC902),
//                               bold: true,
//                             ),
//                           ),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                           margin: EdgeInsets.symmetric(vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Color(0xffF1F1F1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: kTextHeader(
//                             '${controller.faqResponse.value.data![i].answer}',
//                             align: TextAlign.start,
//                             color: Color(0xff7FC902),
//                             bold: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//
//               // FaqResponse ress = controller.faqResponse.value;
//               //
//               // return ListView.builder(
//               //     shrinkWrap: true,
//               //     physics: NeverScrollableScrollPhysics(),
//               //     itemCount: ress.data!.length,
//               //     itemBuilder: (context, index) {
//               //       return questionRow(ress.data![index] , );
//               //     });
//             }
//             return Center(child: CircularLoadingWidget());
//           })
//         ],
//       ),
//     ));
//   }
//
//   Widget questionRow(Data? question, bool showAnswer) {
//     return InkWell(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         margin: EdgeInsets.symmetric(vertical: 4),
//         decoration: BoxDecoration(
//           color: Color(0xffF1F1F1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             kTextHeader(
//               '${question!.question}',
//               align: TextAlign.start,
//               color: Color(0xff7FC902),
//               bold: true,
//             ),
//             showAnswer == false
//                 ? SizedBox()
//                 : kTextHeader(
//                     '${question.answer}',
//                     align: TextAlign.center,
//                     color: Colors.black54,
//                     bold: true,
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:app/app/models/faq_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FaqView extends StatefulWidget {
  const FaqView({Key? key}) : super(key: key);

  @override
  _FaqViewState createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  FaqResponse ress = FaqResponse();
  bool isLoading = true;

  void getFaq() async {
    await ApiProvider().getFaqtData().then((value) {
      if (value.success == true) {
        setState(() {
          ress = value;
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "$value");
        print("error");
      }
    });
  }

  @override
  void initState() {
    getFaq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        HomeAppbar(type: null),
        SizedBox(height: 12),
        PageLable(name: "FAQ"),
        SizedBox(height: 12),
        isLoading == true
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Center(child: CircularLoadingWidget()),
              )

            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ress.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        // for (int i = 0; i < ress.data!.length; i++) {
                        //   setState(() {
                        //     ress.data![i].isSellected = false;
                        //   });
                        // }
                        if (ress.data![index].isSellected == false) {
                          setState(() {
                            ress.data![index].isSellected = true;
                          });
                        }else{
                          setState(() {
                            ress.data![index].isSellected = false;
                          });

                        }
                      },
                      child: questionRow(ress.data![index]));
                })
      ],
    ));
  }

  Widget questionRow(Data? question) {
    return InkWell(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xffF1F1F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                kTextHeader(
                  '${question!.question}',
                  align: TextAlign.start,
                  color: Color(0xff7FC902),
                  bold: true,
                ),
                Icon(question.isSellected == true
                    ? Icons.keyboard_arrow_up_outlined
                    : Icons.keyboard_arrow_down_outlined)
              ],
            ),
          ),
          question.isSellected == false
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${question.answer}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
        ],
      ),
    );
  }
}
