import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_provider.dart';

class YemenyPrefs {
  final box = GetStorage();

  /// **********    ShippingName     ****************/
  setShippingName(String? val) {
    box.write('ShippingName', val);
  }

  String? getShippingName() {
    return box.read('ShippingName');
  }

  /// **********    ShippingName     ****************/
  setShippingLastName(String? val) {
    box.write('ShippingLastName', val);
  }

  String? getShippingLastName() {
    return box.read('ShippingLastName');
  }

  /// **********    ShippingEmail     ****************/
  setShippingEmail(String? val) {
    box.write('ShippingEmail', val);
  }

  String? getShippingEmail() {
    return box.read('ShippingEmail');
  }

  /// **********    ShippingPhone     ****************/
  setShippingPhone(String? val) {
    box.write('ShippingPhone', val);
  }

  String? getShippingPhone() {
    return box.read('ShippingPhone');
  }

  /// **********    ShippingAddress     ****************/
  setShippingAddress(String? val) {
    box.write('ShippingAddress', val);
  }

  String? getShippingAddress() {
    return box.read('ShippingAddress');
  }

  /// **********    ShippingAddress     ****************/
  setShippingLat(String? val) {
    box.write('ShippingLat', val);
  }

  String? getShippingLat() {
    return box.read('ShippingLat');
  }

  /// **********    ShippingAddress     ****************/
  setShippingLng(String? val) {
    box.write('ShippingLng', val);
  }

  String? getShippingLng() {
    return box.read('ShippingLng');
  }

  /// **********    ShippingCoordinatesAddress     ****************/
  setShippingCoordinatesAddress(String? val) {
    box.write('ShippingCoordinatesAddress', val);
  }

  String? getShippingCoordinatesAddress() {
    return box.read('ShippingCoordinatesAddress');
  }

  /// **********    UserLang     ****************/
  setLanguage(String? language) {
    box.write('language', language);
  }

  String? getLanguage() {
    return box.read('language');
  }

  /// **********    FirstTimeVisit     ****************/
  setFirstTimeVisit(bool? firstTimeVisit) {
    Echo('setFirstTimeVisit $firstTimeVisit');
    box.write('firstTimeVisit', firstTimeVisit);
  }

  bool? getFirstTimeVisit() {
    return box.read('firstTimeVisit') == null
        ? true
        : box.read('firstTimeVisit');
  }

  /// **********    Skip     ****************/
  setSkipAuth(bool? skipAuth) {
    box.write('skipAuth', skipAuth);
  }

  bool? getSkipAuth() {
    return box.read('skipAuth') == null ? false : box.read('skipAuth');
  }

  /// **********   User Id     ****************/
  setUserId(int? userId) {
    box.write('userId', userId);
  }

  int? getUserId() {
    return box.read('userId');
  }

  /// **********   User Phone     ****************/
  setPhone(String? phone) {
    box.write('phone', phone);
  }

  String? getPhone() {
    return box.read('phone');
  }

  /// **********   User token     ****************/
  setToken(String? token) {
    box.write('token', token);
  }

  String? getToken() {
    return box.read('token');
  }

  /// **********   User Bearer token     ****************/
  setBearerToken(String? token) {
    box.write('bearerToken', token);
  }

  String? getBearerToken() {
    return box.read('bearerToken');
  }

  /// **********   User name     ****************/
  setName(String? name) {
    box.write('name', name);
  }

  String? getName() {
    return box.read('name');
  }

  /// **********   User image     ****************/
  setImage(String? name) {
    box.write('image', name);
  }

  String? getImage() {
    return box.read('image');
  }

  /// **********   User Email     ****************/
  setEmail(String? email) {
    box.write('email', email);
  }

  String? getEmail() {
    return box.read('email');
  }

  /// **********   City Name     ****************/
  setCityName(String? email) {
    box.write('cityName', email);
  }

  String? getCityName() {
    return box.read('cityName');
  }

  /// **********   City ID     ****************/
  setCityId(String? email) {
    box.write('cityId', email);
  }

  String? getCityId() {
    return box.read('cityId');
  }

  /// **********   Gender     ****************/
  setGender(String? gender) {
    box.write('gender', gender);
  }

  String? getGender() {
    return box.read('gender');
  }

  /// **********   Plan ID     ****************/
  setPlanId(String? id) {
    box.write('planId', id);
  }

  String? getPlanId() {
    return box.read('planId');
  }

  /// **********   Plan      ****************/
  setPlan(String? id) {
    box.write('plan', id);
  }

  String? getPlan() {
    return box.read('plan');
  }

  /// **********   Subject ID     ****************/
  setSubjectId(String? id) {
    box.write('SubjectId', id);
  }

  String? getSubjectId() {
    return box.read('SubjectId');
  }

  /// **********   Subject      ****************/
  setSubject(String? id) {
    box.write('Subject', id);
  }

  String? getSubject() {
    return box.read('Subject');
  }

  /// **********    already send phone data     ****************/
  setAlreadySendPhoneData(bool AlreadySendPhoneData) async {
    box.write('AlreadySendPhoneData', AlreadySendPhoneData);
  }

  Future<bool> getAlreadySendPhoneData() async {
    return box.read('AlreadySendPhoneData') == null
        ? false
        : box.read('AlreadySendPhoneData');
  }

  void logout() async {
//    MainProviderModel mainProviderModel = Provider.of<MainProviderModel>(context, listen: false);
//    mainProviderModel = null;
    setSkipAuth(false);
    setFirstTimeVisit(false);
    setUserId(0);
    setPhone('');
    setToken('');
    setEmail('');
    setImage('');
    SharedPreferences _shared = await SharedPreferences.getInstance();
    _shared.clear();
//    Navigator.of(context).pushNamedAndRemoveUntil(SplashController.id, (Route<dynamic> route) => false);
  }
}
