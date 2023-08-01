// ignore_for_file: avoid_print

import '../../all_export.dart';

class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> registration(SignUpModel signUpModel) async {
    try {
      print(signUpModel.toJson());
      Response response = await dioClient!.post(
        AppConstants.REGISTER_URI,
        data: signUpModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login({String? email, String? password}) async {
    try {
      print({"email": email, "email_or_phone": email, "password": password});
      Response response = await dioClient!.post(
        AppConstants.LOGIN_URI,
        data: {"email": email, "email_or_phone": email, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteUser() async {
    try {
      Response response = await dioClient!.delete(AppConstants.CUSTOMER_REMOVE);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for forgot password
  Future<ApiResponse> forgetPassword(String? email) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.FORGET_PASSWORD_URI,
          data: {"email": email, "email_or_phone": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(String? mail, String? resetToken,
      String password, String confirmPassword) async {
    try {
      print({
        "_method": "put",
        "reset_token": resetToken,
        "password": password,
        "confirm_password": confirmPassword,
        "email_or_phone": mail,
        "email": mail
      });
      Response response = await dioClient!.post(
        AppConstants.RESET_PASSWORD_URI,
        data: {
          "_method": "put",
          "reset_token": resetToken,
          "password": password,
          "confirm_password": confirmPassword,
          "email_or_phone": mail,
          "email": mail
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify phone number
  Future<ApiResponse> checkEmail(String? email) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.CHECK_EMAIL_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String? email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.VERIFY_EMAIL_URI,
          data: {"email": email, "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // phone
  //verify phone number

  Future<ApiResponse> checkPhone(String phone) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.CHECK_PHONE_URI + phone, data: {"phone": phone});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyPhone(String phone, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.VERIFY_PHONE_URI,
          data: {"phone": phone.trim(), "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyToken(String? email, String token) async {
    try {
      print({"email": email, "reset_token": token});
      Response response = await dioClient!.post(AppConstants.VERIFY_TOKEN_URI,
          data: {
            "email": email,
            "email_or_phone": email,
            "reset_token": token
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.token = token;
    dioClient!.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences!.setString(AppConstants.TOKEN, token);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> updateToken() async {
    try {
      String? deviceToken = '';
      if (ResponsiveHelper.isMobilePhone()) {
        deviceToken = await (_saveDeviceToken() as FutureOr<String>);
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
      }
      Response response = await dioClient!.post(
        AppConstants.TOKEN_URI,
        data: {"_method": "put", "cm_firebase_token": deviceToken},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '';
    if (Platform.isAndroid) {
      deviceToken =
          await (FirebaseMessaging.instance.getToken() as FutureOr<String>);
    } else if (Platform.isIOS) {
      deviceToken =
          await (FirebaseMessaging.instance.getAPNSToken() as FutureOr<String>);
    }
    print('--------Device Token---------- $deviceToken');
    return deviceToken;
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.TOKEN);
  }

  Future<bool> clearSharedData() async {
    if (!kIsWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
    }
    await sharedPreferences!.remove(AppConstants.TOKEN);
    await sharedPreferences!.remove(AppConstants.CART_LIST);
    await sharedPreferences!.remove(AppConstants.USER_ADDRESS);
    await sharedPreferences!.remove(AppConstants.SEARCH_ADDRESS);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences!.setString(AppConstants.USER_NUMBER, number);
    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences!.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences!.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences!.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences!.remove(AppConstants.USER_NUMBER);
  }
}
