import 'package:app/app/modules/my_other_calories/my_other_calories.dart';
import 'package:get/get.dart';
import 'package:app/app/modules/about/bindings/about_binding.dart';
import 'package:app/app/modules/about/views/about_view.dart';
import 'package:app/app/modules/auth/bindings/auth_binding.dart';
import 'package:app/app/modules/auth/views/auth_view.dart';
import 'package:app/app/modules/contact_us/bindings/contact_us_binding.dart';
import 'package:app/app/modules/contact_us/views/contact_us_view.dart';
import 'package:app/app/modules/diary/bindings/diary_binding.dart';
import 'package:app/app/modules/diary/views/diary_view.dart';
import 'package:app/app/modules/faq/bindings/faq_binding.dart';
import 'package:app/app/modules/faq/views/faq_view.dart';
import 'package:app/app/modules/forget_password/bindings/forget_password_binding.dart';
import 'package:app/app/modules/forget_password/views/forget_password_view.dart';
import 'package:app/app/modules/home/bindings/home_binding.dart';
import 'package:app/app/modules/home/views/home_view.dart';
import 'package:app/app/modules/introduction_screen/bindings/introduction_screen_binding.dart';
import 'package:app/app/modules/introduction_screen/views/introduction_screen_view.dart';
import 'package:app/app/modules/login/bindings/login_binding.dart';
import 'package:app/app/modules/login/views/login_view.dart';
import 'package:app/app/modules/notifications/bindings/notifications_binding.dart';
import 'package:app/app/modules/notifications/views/notifications_view.dart';
import 'package:app/app/modules/otp/bindings/otp_binding.dart';
import 'package:app/app/modules/otp/views/otp_view.dart';
import 'package:app/app/modules/profile/bindings/profile_binding.dart';
import 'package:app/app/modules/profile/views/profile_view.dart';
import 'package:app/app/modules/register/bindings/register_binding.dart';
import 'package:app/app/modules/register/views/register_view.dart';
import 'package:app/app/modules/sessions/bindings/sessions_binding.dart';
import 'package:app/app/modules/sessions/views/sessions_view.dart';
import 'package:app/app/modules/show_pages/bindings/show_pages_binding.dart';
import 'package:app/app/modules/show_pages/views/show_pages_view.dart';
import 'package:app/app/modules/splash/bindings/splash_binding.dart';
import 'package:app/app/modules/splash/views/splash_view.dart';
import 'package:app/app/modules/transform/bindings/transform_binding.dart';
import 'package:app/app/modules/transform/views/transform_view.dart';

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
      name: _Paths.FAQ,
      page: () => FaqView(),
      binding: FaqBinding(),
    ),

    GetPage(
      name: _Paths.TRANSFORM,
      page: () => TransformView(),
      binding: TransformBinding(),
    ),
  ];
}
