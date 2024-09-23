
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/localization/l10n/l10n.dart';
import '../../config/navigation/navigation_services.dart';
import '../../config/navigation/routes.dart';
import '../../modules/auth/cubit/auth_cubit/auth_cubit.dart';
import '../../modules/profile/models/responses/user_model.dart';
import '../models/meal_features_status_response.dart';
import '../models/meal_food_list_response.dart';
import '../models/user_response.dart';
import '../view/components/confirmation_dialog.dart';

UserResponse? currentUser;
int? selectedCountry = 1;
String currentCurrency = "L.E";

MealFoodListResponse response = MealFoodListResponse(data: []);
MealFeatureHomeResponse mealFeatureHomeResponse = MealFeatureHomeResponse();
bool delivery_option = false;
bool pickup_option = false;
bool shoNewMessage = true;
bool canDismissNewMessageDialog = false;
bool removeNotificationsCount = false;
bool iosInReview = false;
String avatar = '';
String? lastSelectedDate;


invokeIfAuthenticated(BuildContext context, {required Function callback, Function? beforeAuthCallback}) {
  if (BlocProvider.of<AuthCubit>(context).isAuthed) {
    callback();
  } else {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: L10n.tr(context).loginFirst,
        hasNoButton: false,
        confirmText: L10n.tr(context).ok,
        onConfirm: () {
          if (beforeAuthCallback != null) beforeAuthCallback();
          NavigationService.push(context, Routes.loginScreen);
        },
      ),
    );
  }
}

String getDelivertMethod(String deliveryMethod) {
  switch (deliveryMethod) {
    case 'delivery':
      return 'Delivery';
    case 'pick_up':
      return 'Pick up';
    default:
      return deliveryMethod;
  }
}
