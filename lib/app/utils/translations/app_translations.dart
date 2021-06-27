import 'package:app/app/utils/translations/ar/ar_translations.dart';
import 'package:app/app/utils/translations/en/en_translations.dart';
import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': arTranslation,
        'en': enTranslation,
      };
}
