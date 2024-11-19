
import 'package:app/config/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../config/navigation/routes.dart';
import '../../../../core/models/message_details_response.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/services/api_provider.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../../core/view/widgets/fit_new_app_bar.dart';
import '../../../../core/view/widgets/page_lable.dart';
import '../../../home/cubits/home_cubit.dart';
import '../../../home/view/widgets/home_appbar.dart';
import '../../../pdf_viewr.dart';

class NotificationDetailsView extends StatefulWidget {
  final int? id;

  const NotificationDetailsView({Key? key, this.id}) : super(key: key);

  @override
  _NotificationDetailsViewState createState() =>
      _NotificationDetailsViewState();
}

class _NotificationDetailsViewState extends State<NotificationDetailsView> {

  // MessageDetailsResponse ressponse = MessageDetailsResponse();
  //
  // void getData() async {
  //   await ApiProvider()
  //       .getMessagesDetailsData(widget.id ?? 0)
  //       .then((value) async {
  //     if (value.success == true) {
  //       setState(() {
  //         ressponse = value;
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         ressponse = value;
  //       });
  //       Fluttertoast.showToast(msg: "Check Internet Connection");
  //       print("error");
  //     }
  //   });
  // }


  late final HomeCubit homeCubit;


  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.fetchMessageDetails(widget.id!);
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    NavigationService.pushReplacement(context, Routes.homeScreen);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => HomeView()));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {
            if (state is HomePageFailureState) {
              Alerts.showToast(state.failure.message);
            }

          },
          builder: (context, state) => ListView(
          children: [
            // HomeAppbar(
            //   type: null,
            //   removeNotificationsCount: true,
            //   onBack: () {
            //     Get.offAllNamed(Routes.homeScreen);
            //   },
            // ),
            // SizedBox(height: 10),
            FitNewAppBar(
              title: "Messages",
            ),
            state is MessageDetailsLoading
                ? CircularLoadingWidget()
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "${homeCubit.messageDetails.data!.subject}",
                        style: TextStyle(color: kColorPrimary, fontSize: 20),
                      ),
                    ),
                  ),
            state is MessageDetailsLoading
                ? SizedBox()
                : Center(
                    child: Html(
                      data: """${homeCubit.messageDetails.data!.message}""",
                    ),
                  ),
            homeCubit.messageDetails.data?.hasPlan == true
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PDFPreview(
                                      res: homeCubit.messageDetails.data?.planUrl??"",
                                      name: "Plan Details")));
                  /*    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NotificationPlan(
                                    link: ressponse.data?.planUrl ??
                                        "https://fofclinic.com/",
                                  )));*/
                    },
                    child: Image.asset(
                      "assets/messages_icon.png",
                      scale: 8,
                    ),
                  )
                : SizedBox()
          ],
        ),),
      ),
    );
  }
}
