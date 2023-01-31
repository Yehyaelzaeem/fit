import 'package:get/get.dart';

class NotificationsController extends GetxController {
  RxList<NotificationModel> list = RxList();

  @override
  void onInit() {
    super.onInit();
    list.add(NotificationModel(
        'Lorem inpsum',
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text',
        '2021-01-01 03:49'));
    list.add(NotificationModel(
        'Lorem inpsum',
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text',
        '2021-01-01 03:49'));
    list.add(NotificationModel(
        'Lorem inpsum',
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text',
        '2021-01-01 03:49'));
    list.add(NotificationModel(
        'Lorem inpsum',
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text',
        '2021-01-01 03:49'));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

class NotificationModel {
  String title;
  String desc;
  String date;

  NotificationModel(this.title, this.desc, this.date);
}
