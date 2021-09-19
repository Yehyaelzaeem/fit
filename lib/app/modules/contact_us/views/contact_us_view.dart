import 'package:app/app/models/contact_response.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  late String contactEmail;

  late String contactFirstName;

  late String contactPhone;

  late String subject;

  late String contactMessage;

  ContactResponse ress = ContactResponse();

  bool isLoading = true;

  void getData() async {
    await ApiProvider().getContactData().then((value) {
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
            SizedBox(height: 4),
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
                      align: TextAlign.start, color: Color(0xff7FC902), bold: true),
                  kTextbody('${ress.data!.contactInfo!.phone}',
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
                      align: TextAlign.start, color: Color(0xff7FC902), bold: true),
                  kTextbody("${ress.data!.contactInfo!.email}",
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
                      align: TextAlign.start, color: Color(0xff7FC902), bold: true),
                  kTextbody("${ress.data!.contactInfo!.address}",
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
                      align: TextAlign.start, color: Color(0xff7FC902), bold: true),
                  kTextbody("${ress.data!.contactInfo!.workingHours}",
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
              print("SENDING");
              print(contactFirstName);
              print(contactEmail);
              print(contactPhone);
              print(subject);
              print(contactPhone);
              await ApiProvider()
                  .sendContactData(
                      contactFirstName, contactEmail, contactPhone, subject, contactMessage)
                  .then((value) {
                if (value.success == true) {
                  Get.offAllNamed(Routes.HOME);
                  Fluttertoast.showToast(msg: "${value.message}");
                } else {
                  Fluttertoast.showToast(msg: "${value.message}");
                  print("error");
                }
              });
            }, shadow: true, paddingH: 50)),
            Center(child: kTextbody('Our Social media links', size: 14)),

            Container(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ress.data!.socialMedia!.length,
                  itemBuilder: (contaxt, index) {
                    return socoialItem(ress.data!.socialMedia![index]);
                  }),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 14),
          ]);
  }

  Widget socoialItem(SocialMedia data) {
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
