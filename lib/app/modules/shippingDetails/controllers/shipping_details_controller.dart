import 'dart:async';

import 'package:app/app/data/database/shared_pref.dart';
import 'package:app/app/models/mymeals_response.dart';
import 'package:app/app/routes/app_pages.dart';
import 'package:app/globale_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';

class ShippingDetailsController extends GetxController {
  final GlobalController globalController = Get.find<GlobalController>(tag: 'global');
  GlobalKey<FormState> key = GlobalKey();
  List<SingleMyMeal> meals = [];
  final detailedAddress = ''.obs;
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;

  final googleMapController = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  final permissionGranted = false.obs;
  final mapLoading = false.obs;

  var textController = TextEditingController();
  final latitude = ''.obs;
  final longitude = ''.obs;
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 15,
  );

  @override
  void onInit() async {
    name.value = Get.parameters['name'] ?? '';
    email.value = Get.parameters['email'] ?? '';
    phone.value = Get.parameters['phone'] ?? '';
    detailedAddress.value = Get.parameters['detailedAddress'] ?? '';
    latitude.value = Get.parameters['latitude'] ?? '';
    longitude.value = Get.parameters['longitude'] ?? '';
    String address = Get.parameters['address'] ?? '';
    textController = TextEditingController(text: address);
    meals = Get.arguments;

    super.onInit();
  }

  Future<bool> requestPermission() async {
    LocationPermission per = await Geolocator.checkPermission();
    if (per == LocationPermission.deniedForever) {
      permissionGranted.value = false;
      return false;
    }
    if (per == LocationPermission.denied) {
      LocationPermission per = await Geolocator.requestPermission();
      if (per == LocationPermission.denied) {
        return false;
      } else if (per == LocationPermission.deniedForever) {
        permissionGranted.value = false;
        return false;
      }
    }
    Position position = await Geolocator.getCurrentPosition();

    cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );
    permissionGranted.value = true;
    return true;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void submit() {
    if (kDebugMode) {
      latitude.value = '0';
      longitude.value = '0';
    }
    if (latitude.value.toString().isEmpty) {
      Get.snackbar('Error', 'Please select location', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    YemenyPrefs yemenyPrefs = YemenyPrefs();
    yemenyPrefs.setShippingName(name.value);
    yemenyPrefs.setShippingEmail(email.value);
    yemenyPrefs.setShippingPhone(phone.value);
    yemenyPrefs.setShippingAddress(detailedAddress.value);
    yemenyPrefs.setShippingLat(latitude.value.toString());
    yemenyPrefs.setShippingLng(longitude.value.toString());
    yemenyPrefs.setShippingCoordinatesAddress(textController.text);

    Get.toNamed(Routes.CART, arguments: meals, parameters: {
      'name': name.value,
      'email': email.value,
      'phone': phone.value,
      'address': detailedAddress.value,
      'latitude': latitude.value.toString(),
      'longitude': longitude.value.toString(),
    });
  }
}
