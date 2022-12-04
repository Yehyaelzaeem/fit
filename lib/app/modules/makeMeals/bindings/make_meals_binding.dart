import 'package:app/app/modules/makeMeals/controllers/make_meals_controller.dart';
import 'package:get/get.dart';


class MakeMealsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MakeMealsController>(
      () => MakeMealsController(),
    );
  }
}
