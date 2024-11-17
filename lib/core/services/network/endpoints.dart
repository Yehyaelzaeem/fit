class EndPoints {


  static const String home = "/home";
  static const String getSessions = "/sessions";


  // Auth
  static const String register = "/register";
  static const String sendOtp = "/user/send-otp";
  static const String login = "/login";
  static const String deleteAccount = "/remove-account";
  static const String forgetPassword = "/forget-password";


  // Profile
  static const String getCurrentUser = "/profile";
  static const String updateProfile = "/update-profile";


  static const String setSleepTime = "/set_sleeping_time";
  static const String sleepingTimes = "/sleeping_times";
  static const String caloriesDayDetails = "/calories_day_details";




  // Home
  static const String getBanners = "/banners";
  static const String getAllCategories = "/all-categories";
  static const String getLatestEquipments = "/latest-equipment";
  static const String getMaintenanceEngineers = "/maintenance-engineers";

  static const String viewEquipment = "/equipment-show";
  static const String getAllEquipments = "/all-equipment";
  static const String getMainCategories = "/main-categories";
  static const String getAllMaintenanceEngineers = "/all-maintenance-engineers";

  static const String getSubCategory = "/sub-category";
  static const String getEquipmentByCategory = "/equipment-by-category";
  static const String getEquipmentNew = "/equipment-new";
  static const String getEquipmentUsed = "/equipment-used";
  static const String getMaintenanceRequests = "/all-maintenance-request";
  static const String viewMaintenance = "/maintenance-show";


  static const String searchEquipment = "/equipment-search";
  static const String searchEquipmentName = "/equipment-name-search";
  static const String searchEquipmentCity = "/equipment-city-search";

  // Settings
  static const String getPrivacyPolicy = "/policy-privacy";
  static const String getTermsConditions = "/terms-conditions";
  static const String getCountries = "/countries";
  static const String getCities = "/cities";
  static const String getAreas = "/areas";

  // Wishlist
  static const String addFavoriteCalorie = "/new_favourite_calorie";
  static const String deleteFavouriteCalorie = "/delete_favourite_calorie";

  // Ads
  static const String getUserAds = "/user-ads";
  static const String getMyAds = "/my-ads";

  // Notifications
  static const String getNotifications = "/notification";
  static const String getNotificationsNoAuth = "/notification-no-auth";
  static const String getNotificationDetails = "/single-notification";

  static const String sendReport = "/report";

}
