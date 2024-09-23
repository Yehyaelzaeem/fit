//
// import '../../config/localization/l10n/l10n.dart';
// import '../../config/navigation/navigation_services.dart';
// import '../resources/resources.dart';
//
//
// class Validators {
//   static String? passwordValidator(String? input) {
//     return input.orEmpty.length < 8 ? L10n.tr(NavigationService.navigationKey.currentContext!).passwordValidator : null;
//   }
//
//   static String? phoneNumberValidator(String? input) {
//     return input.orEmpty.isEmpty ? L10n.tr(NavigationService.navigationKey.currentContext!).phoneValidator : null;
//   }
//
//   static String? notEmptyValidator(String? input) {
//     return input.orEmpty.isEmpty ? L10n.tr(NavigationService.navigationKey.currentContext!).requiredValidator : null;
//   }
//
//
//   static String? notEmptyIntValidator(int? input) {
//     return input.orZero == 0 ? L10n.tr(NavigationService.navigationKey.currentContext!).requiredValidator : null;
//   }
//
//   static String? emailValidator(String? input) {
//     return !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input.orEmpty)
//         ? L10n.tr(NavigationService.navigationKey.currentContext!).emailValidator
//         : null;
//   }
// }
