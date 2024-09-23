import 'package:app/core/resources/app_values.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/navigation/navigation_services.dart';
import '../../../config/navigation/routes.dart';
import '../../../core/models/contact_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/app_buttons.dart';
import '../../../core/view/widgets/default/edit_text.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/view/widgets/home_appbar.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  String? contactEmail;

  String? contactFirstName;

  String? contactPhone;

  String? subject;

  String? contactMessage;

  ContactResponse? ress;

  bool isLoading = true;

  void getData() async {
    await ApiProvider().getContactData().then((value) {
      if (value.success == true) {
        setState(() {
          ress = value;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "$value");
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
      body: ViewDate(),
    );
  }

  Widget ViewDate() {
    return isLoading == true
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Center(child: CircularLoadingWidget()),
          )
        : ListView(children: [
            HomeAppbar(type: null),
            SizedBox(height: 8),
            PageLable(name: "Contact us"),
            //* phone
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: EdgeInsets.symmetric(vertical: 4),
              color: Color(0xffF1F1F1),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kTextHeader('Phone',
                      align: TextAlign.start,
                      color: Color(0xff7FC902),
                      bold: true),
                  kTextbody('${ress!.data!.contactInfo!.phone}',
                      align: TextAlign.start, color: Colors.black, bold: true),
                ],
              ),
            ),
            //* email
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: EdgeInsets.symmetric(vertical: 4),
              color: Color(0xffF1F1F1),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kTextHeader('Email Address',
                      align: TextAlign.start,
                      color: Color(0xff7FC902),
                      bold: true),
                  kTextbody("${ress!.data!.contactInfo!.email}",
                      align: TextAlign.start, color: Colors.black, bold: true),
                ],
              ),
            ),
            // * location
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: EdgeInsets.symmetric(vertical: 4),
              color: Color(0xffF1F1F1),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kTextHeader('Our Location',
                      align: TextAlign.start,
                      color: Color(0xff7FC902),
                      bold: true),
                  kTextbody("${ress!.data!.contactInfo!.address}",
                      align: TextAlign.start, color: Colors.black, bold: true),
                ],
              ),
            ),
            //* Working hours
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: EdgeInsets.symmetric(vertical: 4),
              color: Color(0xffF1F1F1),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kTextHeader('Working Hours',
                      align: TextAlign.start,
                      color: Color(0xff7FC902),
                      bold: true),
                  kTextbody("${ress!.data!.contactInfo!.workingHours}",
                      align: TextAlign.start, color: Colors.black, bold: true),
                ],
              ),
            ),
            //* title text
            SizedBox(height: 12),
            PageLable(name: "Kindly leave your message"), //* User name
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //First name
                        kTextbody('User name', size: 18, bold: true),
                        Container(
                          color: Color(0xffeeeeee),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: EditText(
                            value: '',
                            hint: '',
                            radius: 4,
                            noBorder: true,
                            background: Color(0xffeeeeee),
                            updateFunc: (String text) {
                              setState(() {
                                contactFirstName = text;
                              });
                              print(contactFirstName);
                            },
                            validateFunc: (text) {},
                            type: TextInputType.name,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //* Email
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //First name
                        kTextbody('Email', size: 18, bold: true),
                        Container(
                          color: Color(0xffeeeeee),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: EditText(
                            value: '',
                            hint: '',
                            radius: 4,
                            noBorder: true,
                            background: Color(0xffeeeeee),
                            updateFunc: (text) {
                              setState(() {
                                contactEmail = text;
                              });
                              print(contactEmail);
                            },
                            validateFunc: (text) {},
                            type: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //* Mobile Number
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //First name
                        kTextbody('Mobile Number', size: 18, bold: true),
                        Container(
                          color: Color(0xffeeeeee),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: EditText(
                            value: '',
                            hint: '',
                            radius: 4,
                            noBorder: true,
                            background: Color(0xffeeeeee),
                            updateFunc: (text) {
                              setState(() {
                                contactPhone = text;
                              });
                              print(contactPhone);
                            },
                            validateFunc: (text) {},
                            type: TextInputType.number,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //* Subhect
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //First name
                        kTextbody('Subject', size: 18, bold: true),
                        Container(
                          color: Color(0xffeeeeee),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: EditText(
                            value: '',
                            hint: '',
                            radius: 4,
                            noBorder: true,
                            background: Color(0xffeeeeee),
                            updateFunc: (text) {
                              setState(() {
                                subject = text;
                              });
                              print(subject);
                            },
                            validateFunc: (text) {},
                            type: TextInputType.name,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //* Description
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(width: double.infinity, child: kTextHeader(Strings().login, size: 24, align: TextAlign.start)),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //First name
                        kTextbody('Description', size: 18, bold: true),
                        Container(
                          color: Color(0xffeeeeee),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: EditText(
                            value: '',
                            hint: '',
                            radius: 4,
                            lines: 3,
                            noBorder: true,
                            background: Color(0xffeeeeee),
                            updateFunc: (text) {
                              setState(() {
                                contactMessage = text;
                              });
                              print(contactMessage);
                            },
                            validateFunc: (text) {},
                            type: TextInputType.name,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //* Send Button
            Center(
                child: kButtonDefault('Send', paddingV: 0, func: () async {
              if (contactEmail == null) {
                Fluttertoast.showToast(msg: "enter valid Email");
                return;
              }
              if (contactPhone == null) {
                Fluttertoast.showToast(msg: "enter valid Phone");
                return;
              }
              if (contactFirstName == null) {
                Fluttertoast.showToast(msg: "enter valid Name");
                return;
              }
              if (subject == null) {
                Fluttertoast.showToast(msg: "enter valid subject");
                return;
              }
              if (contactMessage == null) {
                Fluttertoast.showToast(msg: "enter valid Message");
                return;
              }
              setState(() {
                isLoading = true;
              });
              print("SENDING");
              print(contactFirstName);
              print(contactEmail);
              print(contactPhone);
              print(subject);
              print(contactPhone);
              await ApiProvider()
                  .sendContactData(contactFirstName!, contactEmail!,
                      contactPhone!, subject!, contactMessage!)
                  .then((value) {
                if (value.success == true) {
                  NavigationService.pushReplacementAll(context,Routes.homeScreen);
                  Fluttertoast.showToast(msg: "${value.message}");
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  Fluttertoast.showToast(msg: "${value.message}");
                  print("error");
                  setState(() {
                    isLoading = false;
                  });
                }
              });
            }, shadow: true, paddingH: 50)),
            Center(child: kTextbody('Our Social media links', size: 14)),

            Container(
              height: deviceHeight * 0.12,
              child: Center(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: ress!.data!.socialMedia!.length,
                    itemBuilder: (contaxt, index) {
                      return socialItem(ress!.data!.socialMedia![index]);
                    }),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 14),
          ]);
  }

  Widget socialItem(SocialMedia data) {
    return InkWell(
      onTap: () async {
        String fallbackUrl = '${data.link}';

        try {
          bool launched = await launch(fallbackUrl, forceSafariVC: false);

          if (!launched) {
            await launch(fallbackUrl, forceSafariVC: false);
          }
        } catch (e) {
          await launch(fallbackUrl, forceSafariVC: false);
        }
      },
      child: buildImage("${data.image}"),
    );
  }

  Widget buildImage(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Image.network(
        "$path",
        width: 50,
        height: 50,
      ),
    );
  }
}
