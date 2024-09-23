import 'dart:async';
import 'package:app/core/utils/globals.dart';
import 'package:app/modules/diary/repositories/diary_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/cheer_full_response.dart';
import '../../../core/models/home_page_response.dart';
import '../../../core/models/user_response.dart';
import '../../../core/models/version_response.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/services/error/failure.dart';
import '../../../core/utils/shared_helper.dart';
import '../../diary/cubits/diary_cubit.dart';
import '../repositories/home_repository.dart';
import '../view/screens/home_page_view.dart';
import '../view/screens/home_screen.dart';

part 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository _homeRepository;
  final DiaryRepository _diaryCubit;

  HomeCubit(this._homeRepository,this._diaryCubit) : super(HomeInitialState());

  final currentIndex = 0.obs;
  final selectedService = 0.obs;
  final currectMenuIdex = 1.obs;
  HomePageResponse? homeResponse;
  List<String> homeSliderList = [];

  final cheerfulResponse = CheerFullResponse().obs;
  late bool login = false;

  //bool cheerFullStatus = false;
  // bool faqStatus = false;
  bool? orientationStatus;
  bool? faqStatus;
  RxList<String> slider = RxList();
  RxList<Services> servicesList = RxList();
  // var name = "".obs;
  // var lastName = "".obs;
  // var phone = "".obs;
  // var avatar = "".obs;
  // var isLogggd = false.obs;
  // var id = "".obs;
  var isGuest = false.obs;
  late int newMessage = 0;
  final response =
      VersionResponse(success: false, code: 0, message: "", forceUpdate: false)
          .obs;
  final loading = false.obs;
  UserResponse ress = UserResponse();
  SharedPreferences? preferences;

  void onInit(DiaryCubit diaryCubit) async {
    emit(GetHomeLoadingState());
    await SharedHelper().removeData(CachingKey.INVOICE);

    // isLogggd.value = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    // name.value = await SharedHelper().readString(CachingKey.USER_NAME);
    // phone.value = await SharedHelper().readString(CachingKey.PHONE);
    // avatar.value = await SharedHelper().readString(CachingKey.AVATAR);
    // id.value = await SharedHelper().readString(CachingKey.USER_ID);
    // login = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    // lastName.value = await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    // isGuest.value=await SharedHelper().readBoolean(CachingKey.IS_GUEST_SAVED);
    cheerfulResponse.value = await ApiProvider().getCheerFullStatus();
    faqStatus = await ApiProvider().getFaqStatus();
    if(currentUser!=null)  orientationStatus = await ApiProvider().getOrientationVideosStatusStatus();
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {

      await _diaryCubit.sendSavedDiaryDataByDay();
      /// important
      // await _diaryCubit.sendSavedSleepTimes();

      diaryCubit.getDiaryData(
        diaryCubit.lastSelectedDate.value != '' ? diaryCubit.lastSelectedDate.value : DateTime
            .now().toString().substring(0, 10),true);

    }

    if (homeResponse?.success == false && (homeResponse?.code == 200 || homeResponse?.code == 401)) {
      // SharedHelper().logout();
      // NavigationService.pushReplacementAll(context,Routes.splashScreen);
    }
    //   Get.put(SessionsController(), tag: 'SessionsController');
    onInit(diaryCubit);


    emit(GetHomeSuccessState());

  }

  void refreshController(bool getNeworkData) async {
    emit(GetHomeLoadingState());
    // isLogggd.value = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    // name.value = await SharedHelper().readString(CachingKey.USER_NAME);
    // id.value = await SharedHelper().readString(CachingKey.USER_ID);
    // lastName.value = await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    // avatar.value = await SharedHelper().readString(CachingKey.AVATAR);
    // login = await SharedHelper().readBoolean(CachingKey.IS_LOGGED);
    emit(GetHomeSuccessState());
  }



  void updateCurrentIndex(int value) {
    currentIndex.value = value;
  }

  void getNetworkData() async {
    try {
      response.value = await ApiProvider().kAppVersion();
    } catch (e) {}
  }


  Future<void> loadHomePage({bool notLogged = false}) async {
    emit(HomePageLoadingState());
    final result = await _homeRepository.getHomePageData(notLogged: notLogged);
    result.fold(
          (failure) => emit(HomePageFailureState(failure)),
          (homePageData) {

            homeResponse = homePageData;
            globalIsIosInReview = (homeResponse?.data!.subscriptionStatus == false);
            homeResponse?.data?.slider?.forEach((v) {
              slider.add(v.image ??
                  "https://dev.matrixclouds.com/fitoverfat/public/uploads/choose_us/1627982041Cover.jpg");
            });
            homeResponse?.data?.services?.forEach((v) {
              servicesList.add(Services(id: v.id, title: v.title, items: v.items));
            });

            homeResponse?.data!.slider!.forEach((element) {
              homeSliderList.add(element.image!);
            });
            emit(HomePageSuccessState());
      },
    );
  }

}
