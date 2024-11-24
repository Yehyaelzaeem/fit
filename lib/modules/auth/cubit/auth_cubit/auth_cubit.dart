import 'package:app/modules/auth/view/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../config/navigation/routes.dart';
import '../../../../core/enums/http_request_state.dart';
import '../../../../core/models/general_response.dart';
import '../../../../core/models/user_response.dart';
import '../../../../core/services/api_provider.dart';
import '../../../../core/services/error/failure.dart';
import '../../../../core/utils/globals.dart';
import '../../../../core/utils/shared_helper.dart';
import '../../../diary/controllers/diary_controller.dart';
import '../../../diary/cubits/diary_cubit.dart';
import '../../../profile/models/responses/user_model.dart';
import '../../models/requests/login_body.dart';
import '../../models/requests/registration_body.dart';
import '../../repositories/auth_repository.dart';

part 'auth_state.dart';
bool iSLoggedNow = false;

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthState());

  bool get isAuthed => _authRepository.isAuthed;

  Future<void> clearCache() async => await _authRepository.clearCache();
  UserResponse loginResponse = UserResponse();

  void sendDataLogin(
  String pin,
   String password,
      BuildContext context
      ) async {
    if (kDebugMode) {
      pin = 'p30000';
      password = '123123';
    }
    emit(state.copyWith(authRequestType: AuthRequestType.login, httpRequestState: HttpRequestState.loading));

    await ApiProvider().login(pin, password).then((value) async {
      if (value.success == true) {
          loginResponse = value;
          emit(state.copyWith(user: loginResponse, httpRequestState: HttpRequestState.success));

          SharedHelper _shared = SharedHelper();
        await _shared.writeData(
            CachingKey.TOKEN, loginResponse.data!.accessToken);
        await _shared.writeData(CachingKey.USER_NAME, loginResponse.data!.name);
        await _shared.writeData(
            CachingKey.USER_ID, loginResponse.data!.patientId);
        await _shared.writeData(CachingKey.EMAIL, loginResponse.data!.email);
        await _shared.writeData(CachingKey.PHONE, loginResponse.data!.phone);
        await _shared.writeData(
            CachingKey.MOBILE_NUMBER, loginResponse.data!.phone);
        await _shared.writeData(CachingKey.AVATAR, loginResponse.data!.image);
        await _shared.writeData(CachingKey.IS_LOGGED, true);
        await _shared.writeData(
            CachingKey.USER_LAST_NAME, loginResponse.data!.lastName);
        await _shared.writeData(CachingKey.IS_GUEST_SAVED, false);
        await _shared.writeData(CachingKey.IS_GUEST, false);
        // bool isReggisterd = Get.isRegistered<DiaryController>(tag: 'diary');
        // if (isReggisterd) {
        //   DiaryController controller = Get.find<DiaryController>(tag: 'diary');
        //   print("objectDairy");
        //   // await ApiProvider().getDiaryView(DateTime.now().toString().substring(0, 10));
        //   controller.onInit();
        //   iSLoggedNow = true;
        //
        // }
          BlocProvider.of<DiaryCubit>(context).onInit();
          iSLoggedNow = true;
        /*
        bool isReggisterd2 = Get.isRegistered<HomeController>(tag: 'diary');
        if (isReggisterd2) {
          HomeController textEditController =
          Get.find<HomeController>(tag: 'home');
          textEditController.refreshController(true);
          textEditController.isLogggd.value = true;

        }
*/
        // bool isReggisterd = Get.isRegistered<HomeC>(tag: 'diary');
        // if (isReggisterd) {
        //   DiaryController controller = Get.find<DiaryController>(tag: 'diary');
        //   controller.onInit();
        // }
        // await Get.put(UsualController(), tag: "usual").getUserUsualMeals();
        // await Get.put(UsualController(), tag: "usual").usualMealsData();
        Get.offAndToNamed(Routes.homeScreen);
      } else {
        emit(state.copyWith(failure: Failure(value.code??0, value.message??''), httpRequestState: HttpRequestState.failure));


        Fluttertoast.showToast(msg: " ${value.message} ");
      }
    });

  }


  Future<bool> isDataSaved() async {
    SharedHelper _shared = SharedHelper();
    String? token = await _shared.readString(CachingKey.TOKEN);
    print('tokentoken$token');
    if(token.isNotEmpty){
      await _authRepository.saveAuth(token);
    }

    // Ensure essential data is saved
    return token.isNotEmpty;
  }




  Future<void> login( String pin,
      String password,
      BuildContext context) async {
    emit(state.copyWith(authRequestType: AuthRequestType.login, httpRequestState: HttpRequestState.loading));
    final result = await _authRepository.login(pin,password);
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
      (userModel) {

        if(userModel.success??false){
          currentUser = userModel;


          emit(state.copyWith(user: userModel, httpRequestState: HttpRequestState.success));

        }else{
          emit(state.copyWith(failure: Failure(userModel.code??0, userModel.message??'Error'), httpRequestState: HttpRequestState.failure));
        }
        },
    );
  }

  Future<void> register(String id,
      String password,
      String name,
      String lastName,
      String email,
      String date,
      String phone,
      String gender,
      String password_confirmation) async {
    emit(state.copyWith(authRequestType: AuthRequestType.registration, httpRequestState: HttpRequestState.loading));
    final result = await _authRepository.register(id, password, name, lastName, email, date, phone, gender,
        password_confirmation);
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
      (userModel) => emit(state.copyWith(generalResponse: userModel, httpRequestState: HttpRequestState.success)),
    );
  }

  Future<void> sendOtp(String phone) async {
    emit(state.copyWith(authRequestType: AuthRequestType.sendOtp, httpRequestState: HttpRequestState.loading));
    final result = await _authRepository.sendOtp(phone);
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
      (otp) => emit(state.copyWith(otp: otp, httpRequestState: HttpRequestState.success)),
    );
  }


  void sendDataForgetPassword(String pin,BuildContext context) async {
    emit(state.copyWith(authRequestType: AuthRequestType.forgetPassword, httpRequestState: HttpRequestState.loading));

    await ApiProvider().forgetPassword(pin).then((value) async {
      if (value.success == true) {
        emit(state.copyWith(message: value.message, httpRequestState: HttpRequestState.success));
        Fluttertoast.showToast(msg: "${value.message}");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
                (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(msg: "${value.message}");

        emit(state.copyWith(failure: Failure(value.code??0, value.message??''), httpRequestState: HttpRequestState.failure));

        print("error");
      }
    });
  }

  Future<void> forgetPassword(String email) async {
    emit(state.copyWith(authRequestType: AuthRequestType.forgetPassword, httpRequestState: HttpRequestState.loading));
    final result = await _authRepository.forgetPassword(email);
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
      (message) => emit(state.copyWith(message: message, httpRequestState: HttpRequestState.success)),
    );
  }

  // Future<void> verifyOtp(String phone, String otp) async {
  //   emit(state.copyWith(authRequestType: AuthRequestType.verifyOtp, httpRequestState: HttpRequestState.loading));
  //   final result = await _authRepository.verifyOtp(phone, otp);
  //   result.fold(
  //     (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
  //     (message) => emit(state.copyWith(httpRequestState: HttpRequestState.success)),
  //   );
  // }

  Future<void> logout() async {
    // emit(state.copyWith(httpRequestState: HttpRequestState.loading, authRequestType: AuthRequestType.logout));
    final result = await _authRepository.logout();
    result.fold(
      (failure) => emit(state.copyWith(failure: failure, httpRequestState: HttpRequestState.failure)),
      (message) {
        currentUser = null;
        emit(state.copyWith(message: message, httpRequestState: HttpRequestState.success));
      },
    );
  }


}
