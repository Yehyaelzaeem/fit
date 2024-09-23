import 'dart:async';
import 'dart:io';

import 'package:app/config/navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/cheer_full_response.dart';
import '../../../core/models/cheerful_response.dart';
import '../../../core/models/home_page_response.dart';
import '../../../core/models/meal_features_status_response.dart';
import '../../../core/models/user_response.dart';
import '../../../core/models/version_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/globals.dart';
import '../../../core/utils/shared_helper.dart';
import '../repositories/cheerfull_repository.dart';

part 'cheerfull_states.dart';

class CheerFullCubit extends Cubit<CheerFullStates> {
  final CheerFullRepository _cheerFullRepository;

  CheerFullCubit(this._cheerFullRepository) : super(CheerFullInitialState());
  final response = MealFeatureHomeResponse().obs;
  final error = ''.obs;
  final loading = false.obs;
  final isLoading = true.obs;
  bool isGuest = false;
  bool isGuestSaved = false;
  String userId = "";
  CheerfulSocialsResponse cheerfulSocialsResponse = CheerfulSocialsResponse();

  void getData() async {
    await ApiProvider().getCheerfulSocialsResponse().then((value) {
      if (value.success == true) {
        cheerfulSocialsResponse = value;
        isLoading.value = false;
      } else {
        Fluttertoast.showToast(msg: "Something went wrong!");
        print("error");
      }
    });
  }

  void onInit() async {
    getNetworkData();
    getData();
    userId = await SharedHelper().readString(CachingKey.USER_ID);
    isGuest = await SharedHelper().readBoolean(CachingKey.IS_GUEST);
    isGuestSaved = await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
  }


  getNetworkData() async {
    error.value = '';
    loading.value = true;
    try {
      response.value = await ApiProvider().getMealFeaturesHome();
      mealFeatureHomeResponse = response.value;
    } catch (e) {
      Echo('error response $e');
      error.value = '$e';
    }
    loading.value = false;
  }
}
