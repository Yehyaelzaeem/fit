
import 'dart:async';
import 'dart:convert';

import 'package:app/modules/diary/cubits/diary_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';
import '../../../config/navigation/navigation_services.dart';
import '../../../core/database/shared_pref.dart';
import '../../../core/models/day_details_reposne.dart';


import '../../../config/navigation/routes.dart';
import '../../../core/models/sleeping_time_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/shared_helper.dart';
import '../repositories/shipping_details_repository.dart';

import '../../../core/models/mymeals_response.dart';
part 'shipping_details_states.dart';

class ShippingDetailsCubit extends Cubit<ShippingDetailsStates> {
  final ShippingDetailsRepository _shippingDetailsRepository;

  ShippingDetailsCubit(this._shippingDetailsRepository) : super(ShippingDetailsInitialState());

  GlobalKey<FormState> key = GlobalKey();
  List<SingleMyMeal> meals = [];
  final detailedAddress = ''.obs;
  final name = ''.obs;
  final lastName = ''.obs;
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
    lastName.value = Get.parameters['last_name'] ?? '';
    email.value = Get.parameters['email'] ?? '';
    phone.value = Get.parameters['phone'] ?? '';
    detailedAddress.value = Get.parameters['detailedAddress'] ?? '';
    // latitude.value = Get.parameters['latitude'] ?? '';
    // longitude.value = Get.parameters['longitude'] ?? '';
    // String address = Get.parameters['address'] ?? '';
    // textController = TextEditingController(text: address);
    meals = Get.arguments;

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


  void submit() {
    if (kDebugMode) {
      latitude.value = '0';
      longitude.value = '0';
    }
    if (latitude.value.toString().isEmpty) {
      Get.snackbar('Error', 'Please select location',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    YemenyPrefs yemenyPrefs = YemenyPrefs();
    yemenyPrefs.setShippingName(name.value);
    yemenyPrefs.setShippingLastName(lastName.value);
    yemenyPrefs.setShippingEmail(email.value);
    yemenyPrefs.setShippingPhone(phone.value);
    yemenyPrefs.setShippingAddress(detailedAddress.value);
    yemenyPrefs.setShippingLat(latitude.value.toString());
    yemenyPrefs.setShippingLng(longitude.value.toString());
    yemenyPrefs.setShippingCoordinatesAddress(textController.text);

    NavigationService.pushReplacement(NavigationService.navigationKey.currentState!.context,Routes.cart,


      arguments: {
        "meals" : meals,
        "name" : name.value,
        'last_name': lastName.value,
        'email': email.value,
        'phone': phone.value,
        'address': detailedAddress.value,
        'latitude': latitude.value.toString(),
        'longitude': longitude.value.toString(),
      },);
  }
}
