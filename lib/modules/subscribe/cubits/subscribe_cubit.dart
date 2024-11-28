import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/payment_package_response.dart';
import '../../../core/models/services_response.dart';
import '../../../core/utils/globals.dart';
import '../repositories/subscribe_repository.dart';

part 'subscribe_states.dart';

class SubscribeCubit extends Cubit<SubscribeState> {
  final SubscribeRepository _subscribeRepository;

  SubscribeCubit(this._subscribeRepository)
      : super(SubscribeInitial());

  int serviceIndex = 0;
  int currentPageIndex = 0;
  ServicesResponse servicesResponse = ServicesResponse();
  PackagePaymentResponse packagePaymentResponse = PackagePaymentResponse();
  // PageController pc = new PageController(viewportFraction: 0.75);
  bool isPaymentAppleClicked = false;
  bool isPaymentVisaClicked = false;

  Future<void> fetchServices() async {
    emit(ServicesLoading());

    try {
      final servicesRes = await _subscribeRepository.getServices();
      servicesResponse = servicesRes;
      emit(ServicesLoaded(servicesResponse: servicesRes));
    } catch (error) {
      emit(ServicesError(message: error.toString()));
    }
  }

  Future<void> makePackagePayment({
    required String name,
    required String lastName,
    required String phone,
    required String email,
    required int packageId,
    required String payMethod,
    required bool isGuest,
  }) async {
    emit(PaymentLoading());

    try {
      final paymentRes = await _subscribeRepository.packagePayment(
        name: name,
        lastName: lastName,
        phone: phone,
        email: email,
        packageId: packageId,
        payMethod: payMethod,
        isGuest: isGuest,
      );
      packagePaymentResponse = paymentRes;
      emit(PaymentSuccess(paymentResponse: paymentRes));
    } catch (error) {
      emit(PaymentError(message: error.toString()));
    }
  }


  int selectedIndex(int index) {
    serviceIndex = index;
    emit(state);
    return serviceIndex;
  }

  Future<String> getFromCash() async {
    // userPhone.value = await SharedHelper().readString(CachingKey.PHONE);
    // userEmail.value = await SharedHelper().readString(CachingKey.EMAIL);
    // userName.value = await SharedHelper().readString(CachingKey.USER_NAME);
    // userLastName.value =
    // await SharedHelper().readString(CachingKey.USER_LAST_NAME);
    if (currentUser?.data==null) {
      // Fluttertoast.showToast(msg: "Kindly enter your all data!");
      return await "noPhone";
    } else if (currentUser!.data!.phone!.isEmpty &&
        (currentUser!.data!.email??'').isEmpty &&
        (currentUser!.data!.name??'').isEmpty) {
      // Fluttertoast.showToast(msg: "Kindly enter your all data!");
      return await "noPhone";
    } else if ((currentUser!.data!.lastName??'').isEmpty) {
      //  Fluttertoast.showToast(msg: "Kindly enter your all data!");
      return await "noLastName";
    } else {
      return await "haveAllData";
    }
    ;
  }

}