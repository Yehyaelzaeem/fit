import 'package:app/app/models/orientation_videos_response.dart';
import 'package:app/app/network_util/api_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class OrientationController extends GetxController {
  final loading = true.obs;
  final response = OrientationVideosResponse().obs;
  final error = ''.obs;
  OrientationVideosResponse orientationVideosResponse = OrientationVideosResponse();

  @override
  void onInit() {
    getData();
    super.onInit();
  }
  void getData() async {
    await ApiProvider().getOrientationVideos().then((value) {
      if (value.success == true) {
        orientationVideosResponse = value;
        loading.value = false;
      } else {
        Fluttertoast.showToast(msg: "$value");
        print("error");
      }
    });
  }
  getNetworkData() async {
    error.value = '';
    loading.value = true;
    try {
      response.value = await ApiProvider().getOrientationVideos();
    } catch (e) {
      error.value = '$e';
    }
    loading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
