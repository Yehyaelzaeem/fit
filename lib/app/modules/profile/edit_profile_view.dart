import 'dart:async';
import 'dart:io';

import 'package:app/app/models/user_response.dart';
import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/modules/home/home_appbar.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:app/app/widgets/default/app_buttons.dart';
import 'package:app/app/widgets/default/edit_text.dart';
import 'package:app/app/widgets/default/password_edit_text.dart';
import 'package:app/app/widgets/default/text.dart';
import 'package:app/app/widgets/page_lable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  String password = '';
  String? name;
  String? email;
  String? date;
  String? phone;
  String password_confirmation = '';
  String gender = "Male";
  GlobalKey<FormState> key = GlobalKey();
  GlobalKey<FormState> key2 = GlobalKey();
  bool showLoader = false;
  bool passwordSaveLoading = false;
  UserResponse loginResponse = UserResponse();
  UserResponse ress = UserResponse();
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;

  XFile? _imageFile;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(1950, 8), lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date = picked.toString().substring(0, 10);
      });
  }

  void SendData() async {
    setState(() {
      showLoader = true;
    });
    await ApiProvider()
        .editProfileApi(
            // image: File(_imageFile!.path),
            password: password,
            name: name ?? ress.data!.name,
            email: email ?? ress.data!.email,
            date: date ?? ress.data!.dateOfBirth,
            phone: phone ?? ress.data!.phone,
            password_confirmation: password_confirmation,
            gender: gender)
        .then((value) async {
      if (value.success == true) {
        setState(() {
          loginResponse = value;
          showLoader = false;
        });
        final controller = Get.find<HomeController>(tag: 'home');
        controller.avatar.value = loginResponse.data!.image!;
        controller.name.value = loginResponse.data!.name!;
        controller.id.value = loginResponse.data!.patientId!;

        Fluttertoast.showToast(msg: "${value.message}");
        // SharedHelper _shared = SharedHelper();
        // await _shared.writeData(CachingKey.USER_NAME, loginResponse.data!.name);
        // await _shared.writeData(CachingKey.EMAIL, loginResponse.data!.email);
        // await _shared.writeData(CachingKey.USER_ID, loginResponse.data!.id);
        // await _shared.writeData(CachingKey.MOBILE_NUMBER, loginResponse.data!.phone);
        // await _shared.writeData(CachingKey.AVATAR, loginResponse.data!.image);
        // await _shared.writeData(CachingKey.IS_LOGGED, true);
        Get.offAllNamed(Routes.HOME);
      } else {
        setState(() {
          loginResponse = value;
          showLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  void savePassword() async {
    if (passwordSaveLoading) return;
    passwordSaveLoading = true;
    setState(() {});
    await ApiProvider().changePassword(password: password, confirmPassword: password_confirmation).then((value) async {
      if (value.success == true) {
        setState(() {
          loginResponse = value;
          passwordSaveLoading = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
      } else {
        setState(() {
          loginResponse = value;
          passwordSaveLoading = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  void updatePhoto() async {
    setState(() {
      showLoader = true;
    });
    await ApiProvider().editProfileApi(image: File(_imageFile!.path), name: name ?? ress.data!.name, email: email ?? ress.data!.email, date: date ?? ress.data!.dateOfBirth, phone: phone ?? ress.data!.phone, gender: gender).then((value) async {
      if (value.success == true) {
        setState(() {
          loginResponse = value;
          showLoader = false;
        });
        final controller = Get.find<HomeController>(tag: 'home');
        controller.avatar.value = loginResponse.data!.image!;
        controller.name.value = loginResponse.data!.name!;
        controller.id.value = loginResponse.data!.patientId!;
        controller.isLogggd.value = true;
        Fluttertoast.showToast(msg: "${value.message}");
        Get.offAllNamed(Routes.HOME);
      } else {
        setState(() {
          loginResponse = value;
          showLoader = false;
        });
        Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  void getHomeData() async {
    await ApiProvider().getProfile().then((value) {
      if (value.success == true) {
        setState(() {
          ress = value;
          date = ress.data!.dateOfBirth!.toUpperCase();
          isLoading = false;
          gender = ress.data!.gender!;
        });
      } else {
        Fluttertoast.showToast(msg: "Check Internet Connection");
        print("error");
      }
    });
  }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 50,
      );
      setState(() {
        _imageFile = pickedFile;
      });
      if (_imageFile == null) {
      } else {
        updatePhoto();
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getHomeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppbar(
            type: null,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              PageLable(name: "Edit Profile"),
            ],
          ),
          isLoading == true
              ? CircularLoadingWidget()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 18,
                            ),
                            InkWell(
                              onTap: getImage,
                              child: Center(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(250),
                                    child: _imageFile == null
                                        ? CachedNetworkImage(
                                            imageUrl: "${ress.data!.image}",
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: 100,
                                            placeholder: (ctx, url) {
                                              return profileImageHolder();
                                            },
                                            errorWidget: (context, url, error) {
                                              return profileImageHolder();
                                            },
                                          )
                                        : Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(shape: BoxShape.circle),
                                            child: Image.file(
                                              File(_imageFile!.path),
                                              fit: BoxFit.cover,
                                            ))),
                              ),
                            ),
                            //id
                            kTextbody('ID', size: 18),
                            EditText(
                              value: '${ress.data!.patientId!.toUpperCase()}',
                              updateFunc: (text) {},
                              validateFunc: (text) {},
                              enable: false,
                              type: TextInputType.name,
                            ),
                            SizedBox(height: 12),
                            //User name
                            kTextbody('User name', size: 18),
                            EditText(
                              value: '${ress.data!.name!}',
                              updateFunc: (text) {
                                setState(() {
                                  name = text;
                                });
                                print(text);
                              },
                              validateFunc: (text) {
                                if (text != null && text.toString().length < 3) {
                                  return "Enter Valid Name";
                                }
                              },
                              type: TextInputType.text,
                            ),
                            SizedBox(height: 12),

                            //User name
                            kTextbody('Email', size: 18),
                            EditText(
                              value: '${ress.data!.email}',
                              updateFunc: (text) {
                                setState(() {
                                  email = text;
                                });
                                print(text);
                              },
                              validateFunc: (text) {
                                if (text != null && !text.toString().contains("@")) {
                                  return "Enter Valid Email";
                                }
                              },
                              type: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 12),
                            //Mobile Number
                            kTextbody('Mobile Number', size: 18),
                            EditText(
                              value: '${ress.data!.phone!.toUpperCase()}',
                              updateFunc: (text) {
                                setState(() {
                                  phone = text;
                                });
                                print(text);
                              },
                              validateFunc: (text) {
                                if (text != null && text.toString().length < 10) {
                                  return "Enter Valid Mobile Number";
                                }
                              },
                              type: TextInputType.phone,
                            ),
                            SizedBox(height: 12),
                            //Birth date
                            kTextbody('Birth date', size: 18),
                            InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: EditText(
                                value: "",
                                suffixIconData: Icons.date_range,
                                hint: '${date}',
                                type: TextInputType.text,
                                enable: false,
                              ),
                            ),
                            SizedBox(height: 12),
                            //Gender
                            kTextbody('Gender', size: 18),
                            Row(
                              children: [
                                SizedBox(width: 4),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      gender = "Female";
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(64),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          gender == "Female"
                                              ? Icon(
                                                  Icons.radio_button_checked,
                                                  color: kColorPrimary,
                                                )
                                              : Icon(
                                                  Icons.radio_button_off,
                                                  color: kColorPrimary,
                                                ),
                                          kTextbody('Female', size: 16),
                                          SizedBox(
                                            width: 16,
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      gender = "Male";
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(64),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          gender == "Male"
                                              ? Icon(
                                                  Icons.radio_button_checked,
                                                  color: kColorPrimary,
                                                )
                                              : Icon(
                                                  Icons.radio_button_off,
                                                  color: kColorPrimary,
                                                ),
                                          kTextbody('Male', size: 16),
                                          SizedBox(
                                            width: 16,
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  kButtonDefault(
                                    'Save',
                                    marginH: MediaQuery.of(context).size.width / 4,
                                    paddingV: 0,
                                    func: () {
                                      SendData();
                                    },
                                    shadow: true,
                                    paddingH: 16,
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.width / 14),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: key2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 18),
                            kTextbody('Change password', size: 18),
                            EditTextPassword(
                              value: '',
                              hint: '',
                              updateFunc: (text) {
                                setState(() {
                                  password = text;
                                });
                                print(text);
                              },
                              validateFunc: (text) {
                                if (text.toString().isEmpty || text.toString().length < 6) {
                                  return "Enter Valid Password";
                                }
                              },
                            ),
                            SizedBox(height: 12),
                            kTextbody('Confirm password', size: 18),
                            EditTextPassword(
                              value: '',
                              hint: '',
                              updateFunc: (text) {
                                setState(() {
                                  password_confirmation = text;
                                });
                                print(text);
                              },
                              validateFunc: (text) {
                                if (text.toString().isEmpty || text.toString().length < 6) {
                                  return "Enter Valid Password";
                                }
                              },
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 8,
                            ),

                            SizedBox(height: 12),
                            //Password
                            SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  kButtonDefault(
                                    'Change password',
                                    marginH: MediaQuery.of(context).size.width / 4,
                                    paddingV: 0,
                                    func: () {
                                      savePassword();
                                    },
                                    shadow: true,
                                    paddingH: 16,
                                    loading: passwordSaveLoading,
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.width / 14),
                                  SizedBox(height: MediaQuery.of(context).size.width / 14),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  Widget profileImageHolder() {
    return Container(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.person, size: 40, color: Colors.grey[200]),
      ),
    );
  }

  Widget ChangePasswordForm() {
    return Column(
      children: [
        kTextbody('Password', size: 18),
        EditTextPassword(
          value: '',
          hint: '',
          updateFunc: (text) {
            setState(() {
              password_confirmation = text;
            });
            print(text);
          },
          validateFunc: (text) {
            if (text != null && text.toString().length < 6) {
              return "Enter Valid Password";
            }
          },
        ),
        SizedBox(height: 12),
        kTextbody('Confirm password', size: 18),
        EditTextPassword(
          value: '',
          hint: '',
          updateFunc: (text) {
            setState(() {
              password_confirmation = text;
            });
            print(text);
          },
          validateFunc: (text) {
            if (text != null && text.toString().length < 6) {
              return "Enter Valid Password";
            }
          },
        ),
      ],
    );
  }
}
