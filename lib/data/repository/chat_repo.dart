import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import '../../all_export.dart';

class ChatRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ChatRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getDeliveryManMessage(int? orderId, int offset) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.GET_DELIVERYMAN_MESSAGE_URI}?offset=$offset&limit=100&order_id=$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAdminMessage(int offset) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.GET_ADMIN_MESSAGE_URL}?offset=$offset&limit=100');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> sendMessageToDeliveryMan(
      String message, List<XFile> file, int? orderId, String token) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.SEND_MESSAGE_TO_DELIVERY_MAN_URL}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    for (int i = 0; i < file.length; i++) {
      Uint8List list = await file[i].readAsBytes();
      var part = http.MultipartFile(
          'image[]', file[i].readAsBytes().asStream(), list.length,
          filename: basename(file[i].path));
      request.files.add(part);
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'message': message,
      'order_id': orderId.toString(),
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> sendMessageToAdmin(
      String message, List<XFile> file, String token) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.SEND_MESSAGE_TO_ADMIN_URL}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    print('----------------->>>>  $message');
    for (int i = 0; i < file.length; i++) {
      Uint8List list = await file[i].readAsBytes();
      var part = http.MultipartFile(
          'image[]', file[i].readAsBytes().asStream(), list.length,
          filename: basename(file[i].path));
      request.files.add(part);
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'message': message,
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
}
