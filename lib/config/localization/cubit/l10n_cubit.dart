import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/network/api_client.dart';
import '../../../di_container.dart';
import 'l10n_states.dart';
import '../l10n/l10n.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/local/storage_keys.dart';

class L10nCubit extends Cubit<L10nStates> {
  final CacheClient _cacheConsumer;

  L10nCubit(this._cacheConsumer) : super(L10nInitialState());

  Locale? appLocale;

  void initLocale() {
    dynamic storedLocale = _cacheConsumer.get(StorageKeys.appLocale);
    appLocale = storedLocale != null ? Locale(storedLocale.toString()) : const Locale("ar");
  }

  Future<void> setAppLocale(bool isArabic) async {
    if (isArabic) {
      appLocale = L10n.supportedLocales[1];
      sl<ApiClient>().changeLocale("ar");
      await _cacheConsumer.save(StorageKeys.appLocale, "ar");
    } else {
      appLocale = L10n.supportedLocales[0];
      sl<ApiClient>().changeLocale("en");
      await _cacheConsumer.save(StorageKeys.appLocale, "en");
    }
    emit(L10nSetLangState());
  }
}
