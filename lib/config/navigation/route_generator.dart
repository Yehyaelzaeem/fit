import 'package:app/modules/about/views/about_view.dart';
import 'package:app/modules/auth/view/screens/auth_view.dart';
import 'package:app/modules/auth/view/screens/login_screen.dart';
import 'package:app/modules/auth/view/screens/signup_screen.dart';
import 'package:app/modules/cheerful/views/cheer_full_view.dart';
import 'package:app/modules/contact_us/views/contact_us_view.dart';
import 'package:app/modules/home/view/screens/home_screen.dart';
import 'package:app/modules/notifications/view/screens/notification_screen.dart';
import 'package:app/modules/orders/views/orders_view.dart';
import 'package:app/modules/orientation/views/orientation_view.dart';
import 'package:app/modules/profile/view/screens/edit_profile_screen.dart';
import 'package:app/modules/profile/view/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../core/view/screens/undefined_route_screen.dart';
import '../../modules/auth/view/screens/forget_password.dart';
import '../../modules/cart/views/cart_view.dart';
import '../../modules/faq/views/faq_view.dart';
import '../../modules/home/view/widgets/home_drawer.dart';
import '../../modules/layout/view/screens/layout_screen.dart';
import '../../modules/makeMeals/views/make_meals_view.dart';
import '../../modules/myMeals/views/my_meals_view.dart';
import '../../modules/packages/view/my_packages_view.dart';
import '../../modules/profile/view/screens/edit_profile_view.dart';
import '../../modules/shippingDetails/views/shipping_details_view.dart';
import '../../modules/splash/view/screens/splash_screen.dart';
import '../../modules/subscribe/views/subscribe_view.dart';
import '../../modules/timeSleep/views/time_sleep_view.dart';
import '../../modules/transform/views/transform_view.dart';
import '../../modules/usuals/views/usual_view.dart';
import 'navigation.dart';

class RouteGenerator {
  static Route onGenerateRoute(RouteSettings settings) {
    final Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case Routes.splashScreen:
        return platformPageRoute(const SplashScreen());
      case Routes.layoutScreen:
        return platformPageRoute(const LayoutScreen());
      case Routes.loginScreen:
        return platformPageRoute(const LoginScreen());
      case Routes.forgetPasswordScreen:
        return platformPageRoute(const ForgetPasswordScreen());
      case Routes.homeDrawer:
        return platformPageRoute(const HomeDrawer());
      case Routes.profile:
        return platformPageRoute(const ProfileScreen());
      case Routes.editProfileScreen:
        return platformPageRoute(const EditProfileView());
      case Routes.signupScreen:
        return platformPageRoute(const SignupScreen());
      case Routes.homeScreen:
        return platformPageRoute(const HomeScreen());
      case Routes.transformView:
        return platformPageRoute(const TransformView());
      case Routes.myPackagesView:
        return platformPageRoute( MyPackagesView());
      case Routes.about:
        return platformPageRoute( AboutView());
      case Routes.contactUs:
        return platformPageRoute( ContactUsView());
      case Routes.faqs:
        return platformPageRoute( FaqView());
      case Routes.orientation:
        return platformPageRoute( OrientationView());
      case Routes.cheerful:
        return platformPageRoute( CheerFullView());
      case Routes.orders:
        return platformPageRoute( OrdersView());
      case Routes.subscribeView:
        return platformPageRoute( SubscribeView());
      case Routes.shippingDetailsView:
        return platformPageRoute( ShippingDetailsView(
          meals: arguments?["meals"],
          name: arguments?["name"],
          lastName: arguments?["lastName"],
          phone: arguments?["phone"],
          email: arguments?["email"],
          detailedAddress: arguments?["detailedAddress"],
        ));
      case Routes.makeMeals:
        return platformPageRoute( MakeMealsView());
      case Routes.myMeals:
        return platformPageRoute( MyMealsView());
      case Routes.cart:
        return platformPageRoute( CartView(
            meals: arguments?["meals"],
            name: arguments?["name"],
            lastName: arguments?["lastName"],
            phone: arguments?["phone"],
            email: arguments?["email"],
            address: arguments?["address"],
            latitude: arguments?["latitude"],
            longitude: arguments?["longitude"],

        ));
      case Routes.usual:
        return platformPageRoute( UsualView());
      case Routes.timeSleep:
        return platformPageRoute(
            TimeSleepView(
              isToday: arguments?["isToday"],
            ));
      case Routes.notificationScreen:
        return platformPageRoute( NotificationScreen());
      case Routes.authScreen:
        return platformPageRoute(const AuthScreen());

      default:
        return platformPageRoute(const UndefinedRouteScreen());
    }
  }
}
