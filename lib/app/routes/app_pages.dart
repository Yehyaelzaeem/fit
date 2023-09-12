import 'package:app/app/modules/invoice/bindings/invoice_binding.dart';
import 'package:app/app/modules/invoice/views/invoice_view.dart';
import 'package:app/app/modules/orientation/bindings/orientation_binding.dart';
import 'package:app/app/modules/orientation/views/orientation_view.dart';
import 'package:get/get.dart';

import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/cheerFull/bindings/cheer_full_binding.dart';
import '../modules/cheerFull/views/cheer_full_view.dart';
import '../modules/contact_us/bindings/contact_us_binding.dart';
import '../modules/contact_us/views/contact_us_view.dart';
import '../modules/diary/bindings/diary_binding.dart';
import '../modules/diary/views/diary_view.dart';
import '../modules/faq/bindings/faq_binding.dart';
import '../modules/faq/views/faq_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/introduction_screen/bindings/introduction_screen_binding.dart';
import '../modules/introduction_screen/views/introduction_screen_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/makeMeals/bindings/make_meals_binding.dart';
import '../modules/makeMeals/views/make_meals_view.dart';
import '../modules/myMeals/bindings/my_meals_binding.dart';
import '../modules/myMeals/views/my_meals_view.dart';
import '../modules/myOrders/bindings/my_orders_binding.dart';
import '../modules/myOrders/views/my_orders_view.dart';
import '../modules/myPackages/bindings/my_packages_binding.dart';
import '../modules/myPackages/views/my_packages_view.dart';
import '../modules/my_other_calories/my_other_calories.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/sessions/bindings/sessions_binding.dart';
import '../modules/sessions/views/sessions_view.dart';
import '../modules/shippingDetails/bindings/shipping_details_binding.dart';
import '../modules/shippingDetails/views/shipping_details_view.dart';
import '../modules/show_pages/bindings/show_pages_binding.dart';
import '../modules/show_pages/views/show_pages_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/subscribe/bindings/subscribe_binding.dart';
import '../modules/subscribe/views/subscribe_view.dart';
import '../modules/timeSleep/bindings/time_sleep_binding.dart';
import '../modules/timeSleep/views/time_sleep_view.dart';
import '../modules/transform/bindings/transform_binding.dart';
import '../modules/transform/views/transform_view.dart';
import '../modules/usuals/bindings/usual_binding.dart';
import '../modules/usuals/views/make_a_meal_view.dart';
import '../modules/usuals/views/usual_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH;

  // static const INITIAL = Routes.SHOW_PAGES;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.MY_OTHER_CALORIES,
      page: () => MyOtherCalories(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => ForgetPassword(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => AboutView(),
      binding: AboutBinding(),
    ),
    // GetPage(
    //   name: _Paths.POLICY,
    //   page: () => PolicyView(),
    //   binding: PolicyBinding(),
    // ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => ContactUsView(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_PAGES,
      page: () => ShowPagesView(),
      binding: ShowPagesBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION_SCREEN,
      page: () => IntroductionScreenView(),
      binding: IntroductionScreenBinding(),
    ),
    // GetPage(
    //   name: _Paths.ORIENTATION_REGISTER,
    //   page: () => OrientationRegisterView(),
    //   binding: OrientationRegisterBinding(),
    // ),
    GetPage(
      name: _Paths.SESSIONS,
      page: () => SessionsView(),
      binding: SessionsBinding(),
    ),
    GetPage(
      name: _Paths.DIARY,
      page: () => DiaryView(),
      binding: DiaryBinding(),
    ),
    GetPage(
      name: _Paths.USUAL,
      page: () => UsualView(),
      binding: UsualBinding(),
    ),
    GetPage(
      name: _Paths.MALEAMEAL,
      page: () => MakeAMealView(),
      binding: UsualBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => FaqView(),
      binding: FaqBinding(),
    ),

    GetPage(
      name: _Paths.TRANSFORM,
      page: () => TransformView(),
      binding: TransformBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.MY_MEALS,

      page: () => MyMealsView(),
      binding: MyMealsBinding(),
    ),
    GetPage(
      name: _Paths.MAKE_MEALS,
      page: () => MakeMealsView(),
      binding: MakeMealsBinding(),
    ),
    GetPage(
      name: _Paths.SHIPPING_DETAILS,
      page: () => ShippingDetailsView(),
      binding: ShippingDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CHEER_FULL,
      page: () => CheerFullView(),
      binding: CheerFullBinding(),
    ),
    GetPage(
      name: _Paths.MY_ORDERS,
      page: () => MyOrdersView(),
      binding: MyOrdersBinding(),
    ),
    GetPage(
      name: _Paths.TIME_SLEEP,
      page: () => TimeSleepView(),
      binding: TimeSleepBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIBE,
      page: () => SubscribeView(),
      binding: SubscribeBinding(),
    ),
    GetPage(
      name: _Paths.MY_PACKAGES,
      page: () => MyPackagesView(),
      binding: MyPackagesBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.INVOICE,
      page: () => InvoiceView(),
      binding: InvoiceBinding(),
    ),
    GetPage(
      name: _Paths.Orientation,
      page: () => OrientationView(),
      binding: OrientationBinding(),
    ),
  ];
}
