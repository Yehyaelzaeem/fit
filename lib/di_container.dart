import 'package:app/modules/about/repositories/about_repository.dart';
import 'package:app/modules/makeMeals/cubits/make_meals_cubit.dart';
import 'package:app/modules/makeMeals/repositories/make_meals_repository.dart';
import 'package:app/modules/myMeals/repositories/my_meals_repository.dart';
import 'package:app/modules/orders/repositories/order_repository.dart';
import 'package:app/modules/other_calories/cubits/other_calories_cubit.dart';
import 'package:app/modules/other_calories/repositories/other_calories_repository.dart';
import 'package:app/modules/packages/repositories/packages_repository.dart';
import 'package:app/modules/subscribe/repositories/subscribe_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'config/localization/cubit/l10n_cubit.dart';
import 'core/services/local/cache_client.dart';
import 'core/services/network/api_client.dart';
import 'core/services/network/network_info.dart';
import 'modules/about/cubits/about_cubit.dart';
import 'modules/auth/cubit/auth_cubit/auth_cubit.dart';
import 'modules/auth/repositories/auth_repository.dart';
import 'modules/cheerful/cubits/cheerfull_cubit.dart';
import 'modules/cheerful/repositories/cheerfull_repository.dart';
import 'modules/diary/cubits/diary_cubit.dart';
import 'modules/diary/repositories/diary_repository.dart';
import 'modules/general/cubits/general_data_cubit.dart';
import 'modules/general/repositories/general_data_repository.dart';
import 'modules/home/cubits/home_cubit.dart';
import 'modules/home/repositories/home_repository.dart';
import 'modules/myMeals/cubits/my_meals_cubit.dart';
import 'modules/orders/cubits/order_cubit.dart';
import 'modules/packages/cubits/packages_cubit.dart';
import 'modules/profile/cubits/profile_cubit.dart';
import 'modules/profile/repositories/profile_repository.dart';
import 'modules/sessions/cubits/session_cubit.dart';
import 'modules/sessions/repositories/session_repository.dart';
import 'modules/subscribe/cubits/subscribe_cubit.dart';
import 'modules/timeSleep/cubits/time_sleep_cubit.dart';
import 'modules/timeSleep/repositories/time_sleep_repository.dart';
import 'modules/usuals/cubits/usual_cubit.dart';
import 'modules/usuals/repositories/usual_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // external
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true,)));
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<PrettyDioLogger>(
    () => PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true),
  );

  // core
  sl.registerLazySingleton<CacheClient>(() => CacheClient(sl<SharedPreferences>(), sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl<Connectivity>()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>(), sl<CacheClient>(), sl<PrettyDioLogger>()));

  // Repositories
  sl.registerLazySingleton<GeneralDataRepository>(() => GeneralDataRepository(sl<ApiClient>(), sl<CacheClient>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<ApiClient>(), sl<CacheClient>(), sl<NetworkInfo>()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository(sl<ApiClient>(), sl<CacheClient>(), sl<NetworkInfo>()));
 sl.registerLazySingleton<HomeRepository>(() => HomeRepository(sl<ApiClient>(), sl<CacheClient>(),  sl<NetworkInfo>()));
  sl.registerLazySingleton<UsualRepository>(() => UsualRepository(sl<ApiClient>(), sl<CacheClient>(),  sl<NetworkInfo>()));
  sl.registerLazySingleton<TimeSleepRepository>(() => TimeSleepRepository(sl<ApiClient>(), sl<CacheClient>(),  sl<NetworkInfo>()));
  sl.registerLazySingleton<DiaryRepository>(() => DiaryRepository(sl<ApiClient>(), sl<CacheClient>(),  sl<NetworkInfo>()));
  sl.registerLazySingleton<MyMealsRepository>(() => MyMealsRepository(sl<ApiClient>(), sl<CacheClient>(),  sl<NetworkInfo>()));
  sl.registerLazySingleton<MakeMealsRepository>(() => MakeMealsRepository(sl<ApiClient>(), sl<CacheClient>(),  sl<NetworkInfo>()));
  sl.registerLazySingleton<SessionRepository>(() => SessionRepository(sl<ApiClient>(), sl<CacheClient>(),  sl<NetworkInfo>()));
  sl.registerLazySingleton<OtherCaloriesRepository>(() => OtherCaloriesRepository(sl<ApiClient>(), sl<CacheClient>(),  sl<NetworkInfo>()));
  sl.registerLazySingleton<AboutRepository>(() => AboutRepository(apiClient:sl<ApiClient>(), cacheClient:sl<CacheClient>()));
  sl.registerLazySingleton<CheerFullRepository>(() => CheerFullRepository(sl<ApiClient>(),sl<CacheClient>(),  sl<NetworkInfo>()));
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepository(sl<ApiClient>(),));
  sl.registerLazySingleton<PackagesRepository>(() => PackagesRepository(sl<ApiClient>(),));
  sl.registerLazySingleton<SubscribeRepository>(() => SubscribeRepository(sl<ApiClient>(),));

  // Cubits
  sl.registerFactory<L10nCubit>(() => L10nCubit(sl<CacheClient>())..initLocale());
  sl.registerFactory<GeneralDataCubit>(() => GeneralDataCubit(sl<GeneralDataRepository>()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<ProfileRepository>()));

  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepository>(),sl<DiaryRepository>()));
  sl.registerFactory<UsualCubit>(() => UsualCubit(sl<UsualRepository>()));
  sl.registerFactory<DiaryCubit>(() => DiaryCubit(sl<DiaryRepository>(),sl<TimeSleepCubit>(),sl<OtherCaloriesRepository>(),sl<UsualRepository>(),));
  sl.registerFactory<TimeSleepCubit>(() => TimeSleepCubit(sl<TimeSleepRepository>(),));
  sl.registerFactory<MyMealsCubit>(() => MyMealsCubit(sl<MyMealsRepository>()));
  sl.registerFactory<MakeMealsCubit>(() => MakeMealsCubit(sl<MakeMealsRepository>()));
  sl.registerFactory<SessionCubit>(() => SessionCubit(sl<SessionRepository>()));
  sl.registerFactory<OtherCaloriesCubit>(() => OtherCaloriesCubit(sl<OtherCaloriesRepository>()));
  sl.registerFactory<AboutCubit>(() => AboutCubit( aboutRepository: sl<AboutRepository>()));
  sl.registerFactory<CheerFullCubit>(() => CheerFullCubit( sl<CheerFullRepository>()));
  sl.registerFactory<OrdersCubit>(() => OrdersCubit( sl<OrdersRepository>()));
  sl.registerFactory<PackagesCubit>(() => PackagesCubit( sl<PackagesRepository>()));
  sl.registerFactory<SubscribeCubit>(() => SubscribeCubit( sl<SubscribeRepository>()));

}
