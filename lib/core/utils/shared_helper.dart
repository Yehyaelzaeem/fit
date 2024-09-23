import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

abstract class Enum<T> {
  final T _value;

  const Enum(this._value);

  T get value => _value;
}

class CachingKey extends Enum<String> {
  const CachingKey(String val) : super(val);
  static const CachingKey CART_NUM = const CachingKey('CART_NUM');
  static const CachingKey IS_LOGGED = const CachingKey('IS_LOGGED');
  static const CachingKey USER_NAME = const CachingKey('USER_NAME');
  static const CachingKey USER_LAST_NAME = const CachingKey('USER_LAST_NAME');
  static const CachingKey USER = const CachingKey('USER');
  static const CachingKey DAIRY = const CachingKey('DAIRY');
  static const CachingKey DAIRY_TO_SEND = const CachingKey('DAIRY_TO_SEND');
  static const CachingKey DAIRY_TEMPLATE = const CachingKey('DAIRY_TEMPLATE');
  static const CachingKey MY_USUAL_MEALS = const CachingKey('MY_USUAL_MEALS');
  static const CachingKey USUAL_MEALS = const CachingKey('USUAL_MEALS');
  static const CachingKey HOME = const CachingKey('Home');
  static const CachingKey Transformation = const CachingKey('Transformation');
  static const CachingKey MESSAGES = const CachingKey('MESSAGES');
  static const CachingKey ABOUT = const CachingKey('ABOUT');
  static const CachingKey CONTACT = const CachingKey('CONTACT');
  static const CachingKey SLEEPING_TIMES = const CachingKey('SLEEPING_TIMES');
  static const CachingKey ORIENTATION_VIDEOS = const CachingKey('ORIENTATION_VIDEOS');
  static const CachingKey SERVICES = const CachingKey('SERVICES');
  static const CachingKey SESSIONS = const CachingKey('SESSIONS');
  static const CachingKey SESSIONS_DETAILS = const CachingKey('SESSIONS_DETAILS');
  static const CachingKey MY_OTHER_CALORIES = const CachingKey('MY_OTHER_CALORIES');
  static const CachingKey OTHER_CALORIES_UNITS = const CachingKey('OTHER_CALORIES_UNITS');
  static const CachingKey SESSION_DETAIL = const CachingKey('OTHER_CALORIES_UNITS');
  static const CachingKey CHEER_FULL = const CachingKey('CHEER_FULL');
  static const CachingKey FAQ_STATUS = const CachingKey('FAQ_STATUS');
  static const CachingKey ORIENTATION_VIDEOS_STATUS = const CachingKey('ORIENTATION_VIDEOS_STATUS');
  static const CachingKey USER_ID = const CachingKey('USER_ID');
  static const CachingKey TOKEN = const CachingKey('TOKEN');
  static const CachingKey FORGET_TOKEN = const CachingKey('FORGET_TOKEN');
  static const CachingKey EMAIL = const CachingKey('EMAIL');
  static const CachingKey USER_IMAGE = const CachingKey('USER_IMAGE');
  static const CachingKey MOBILE_NUMBER = const CachingKey('MOBILE_NUMBER');
  static const CachingKey AVATAR = const CachingKey('AVATAR');
  static const CachingKey PHONE = const CachingKey('PHONE');
  static const CachingKey INVOICE = const CachingKey('INVOICE');
  static const CachingKey IS_GUEST_SAVED = const CachingKey('IS_GUEST_LOGGED');
  static const CachingKey IS_GUEST = const CachingKey('IS_GUEST');
  static const CachingKey SLEEP_TIMES = const CachingKey('SleepTimes');
  static const CachingKey DAIRY_DATA_LIST = const CachingKey('DAIRY_DATA_LIST');
  static const CachingKey DELETE_CALORIE = const CachingKey('DELETE_CALORIE');
  static const CachingKey DELETE_OTHER_CALORIE = const CachingKey('DELETE_OTHER_CALORIE');
  static const CachingKey DELETE_USUAL_MEAL = const CachingKey('DELETE_USUAL_MEAL');
  static const CachingKey Meals_Creation_LIST = const CachingKey('Meals_Creation_LIST');
  static const CachingKey OTHER_CALORIES_CREATION = const CachingKey('OTHER_CALORIES_CREATION');
  static const CachingKey LAST_LOADING_TIME = const CachingKey('LAST_LOADING_TIME');
  static const CachingKey DAIRY_TEMP = const CachingKey('DAIRY_TEMP');
}

class A {
  A() {
    print('default constructor');
  }

  A.named() {
    print('named constructor');
  }
}

class SharedHelper {
  late SharedPreferences _shared;

  removeData(CachingKey key) async {
    _shared = await SharedPreferences.getInstance();
    _shared.remove(key.value);
  }

  clear(CachingKey key) async {
    _shared = await SharedPreferences.getInstance();
    _shared.clear();
  }

  // logout() async {
  //   _shared = await SharedPreferences.getInstance();
  //   _shared.clear();
  //   // Get.offAllNamed(Routes.SPLASH);
  // }

  writeData(CachingKey key, value) async {
    _shared = await SharedPreferences.getInstance();
    print("saving >>> $value into local >>> with key ${key.value}");
    if (value is String) {
      _shared.setString(key.value, value);
    } else if (value is int) {
      _shared.setInt(key.value, value);
    } else if (value is bool) {
      _shared.setBool(key.value, value);
    } else if (value is double) {
      _shared.setDouble(key.value, value);
    } else if (value is List<String>) {
      _shared.setStringList(key.value, value);
    } else {
      print('abf');
      return null;
    }
  }

  Future<bool> readBoolean(CachingKey key) async {
    _shared = await SharedPreferences.getInstance();
    return Future.value(_shared.getBool(key.value) ?? false);
  }

  Future<double> readDouble(CachingKey key) async {
    _shared = await SharedPreferences.getInstance();
    return Future.value(_shared.getDouble(key.value) ?? 0.0);
  }

  Future<int> readInteger(CachingKey key) async {
    _shared = await SharedPreferences.getInstance();
    return Future.value(_shared.getInt(key.value) ?? 0);
  }

  Future<String> readString(CachingKey key) async {
    _shared = await SharedPreferences.getInstance();
    return Future.value(_shared.getString(key.value) ?? "");
  }

  Future<List<String>> readStringList(CachingKey key) async {
    _shared = await SharedPreferences.getInstance();
    return Future.value(_shared.getStringList(key.value) ?? []);
  }
}
