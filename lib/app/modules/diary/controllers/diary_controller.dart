import 'package:get/get.dart';

class DiaryController extends GetxController {
  RxList<SingleImageItem> list = RxList();
  final listKey = 200.obs;
  @override
  void onInit() {
    super.onInit();
    list.add(SingleImageItem(id: 1, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 2, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 3, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 4, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 5, imagePath: 'assets/img/im_holder1.png', selected: false));
    list.add(SingleImageItem(id: 6, imagePath: 'assets/img/im_holder1.png', selected: false));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

class SingleImageItem {
  int id;
  String imagePath;
  bool selected;
  SingleImageItem({required this.id, required this.imagePath, required this.selected});
}
