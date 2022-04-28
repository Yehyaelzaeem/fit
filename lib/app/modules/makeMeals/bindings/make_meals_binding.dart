import 'package:get/get.dart';

import '../controllers/make_meals_controller.dart';

class MakeMealsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MakeMealsController>(
      () => MakeMealsController(),
    );
  }
}
