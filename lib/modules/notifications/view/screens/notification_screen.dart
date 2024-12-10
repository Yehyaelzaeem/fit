import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/models/general_response.dart';
import '../../../../core/models/messages_response.dart';
import '../../../../core/resources/resources.dart';
import '../../../../core/services/api_provider.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../../core/view/widgets/default/text.dart';
import '../../../../core/view/widgets/fit_new_app_bar.dart';
import '../../../../core/view/widgets/page_lable.dart';
import '../../../home/cubits/home_cubit.dart';
import '../../../home/view/widgets/home_appbar.dart';
import 'notification_details_view.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;
  bool showLoader = false;

  late final HomeCubit homeCubit;


  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.fetchMessages();
    // getHomeData();
    super.initState();
  }



  GeneralResponse deleteRessponse = GeneralResponse();

  void deleteMessage(int? id, int? index) async {
    print(id);
    await homeCubit.deleteMessage(id!).then((value) async {
      if ( homeCubit.deleteRessponse.success == true) {
        setState(() {
          deleteRessponse = homeCubit.deleteRessponse;
          isLoading = false;
          homeCubit.messagesResponse.data!.removeAt(index ?? 0);
        });
      } else {
        setState(() {
          deleteRessponse =  homeCubit.deleteRessponse;
        });
        Fluttertoast.showToast(msg: "${deleteRessponse.message}");
        print("error");
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                FitNewAppBar(
                  title: "Messages",
                ),

      BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is HomePageFailureState) {
            Alerts.showToast(state.failure.message);
          }

        },
        builder: (context, state) => state is MessagesLoading
             ? CircularLoadingWidget(

             )
                    : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: homeCubit.messagesResponse.data?.length??0,
                    itemBuilder: (context, index) {
                      return messageRow(homeCubit.messagesResponse.data![index], index);
                    })),
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
        )
    );
  }

  Widget messageRow(Data element, int index) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
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
                        kTextHeader('Subject:',
                            paddingV: 12,
                            color: kColorPrimary,
                            align: TextAlign.start),
                        Expanded(
                          child: kTextHeader('${element.subject}',
                              paddingV: 12,
                              color: Colors.black,
                              align: TextAlign.start),
                        ),
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
                color: element.viewStatus == false
                    ? kColorPrimary
                    : Colors.grey[300],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  kTextbody(
                      element.viewStatus == false
                          ? "Click To See Info"
                          : "Seen",
                      paddingH: 12,
                      paddingV: 12,
                      align: TextAlign.start,
                      color: element.viewStatus == true
                          ? Colors.black
                          : Colors.white),
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
              child: kTextfooter(element.date ?? "",
                  paddingH: 0,
                  paddingV: 0,
                  align: TextAlign.end,
                  color: kColorPrimary),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
