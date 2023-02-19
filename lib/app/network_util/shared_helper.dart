import 'package:shared_preferences/shared_preferences.dart';

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
  static const CachingKey USER_ID = const CachingKey('USER_ID');
  static const CachingKey TOKEN = const CachingKey('TOKEN');
  static const CachingKey FORGET_TOKEN = const CachingKey('FORGET_TOKEN');
  static const CachingKey EMAIL = const CachingKey('EMAIL');
  static const CachingKey USER_IMAGE = const CachingKey('USER_IMAGE');
  static const CachingKey MOBILE_NUMBER = const CachingKey('MOBILE_NUMBER');
  static const CachingKey AVATAR = const CachingKey('AVATAR');
  static const CachingKey PHONE = const CachingKey('PHONE');
  static const CachingKey INVOICE = const CachingKey('INVOICE');
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

  logout() async {
    _shared = await SharedPreferences.getInstance();
    _shared.clear();
    // Get.offAllNamed(Routes.SPLASH);
  }

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
    } else {
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
}
