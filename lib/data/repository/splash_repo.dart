import '../../all_export.dart';

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.CONFIG_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences!.containsKey(AppConstants.THEME)) {
      return sharedPreferences!.setBool(AppConstants.THEME, false);
    }
    if (!sharedPreferences!.containsKey(AppConstants.COUNTRY_CODE)) {
      return sharedPreferences!.setString(AppConstants.COUNTRY_CODE, 'US');
    }
    if (!sharedPreferences!.containsKey(AppConstants.LANGUAGE_CODE)) {
      return sharedPreferences!.setString(AppConstants.LANGUAGE_CODE, 'en');
    }
    if (!sharedPreferences!.containsKey(AppConstants.CART_LIST)) {
      return sharedPreferences!.setStringList(AppConstants.CART_LIST, []);
    }
    if (!sharedPreferences!.containsKey(AppConstants.ON_BOARDING_SKIP)) {
      return sharedPreferences!.setBool(AppConstants.ON_BOARDING_SKIP, false);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }

  void disableIntro() {
    sharedPreferences!.setBool(AppConstants.ON_BOARDING_SKIP, false);
  }

  bool showIntro() {
    return sharedPreferences!.getBool(AppConstants.ON_BOARDING_SKIP) ?? true;
  }
}
