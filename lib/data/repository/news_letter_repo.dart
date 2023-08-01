import '../../all_export.dart';

class NewsLetterRepo {
  final DioClient? dioClient;

  NewsLetterRepo({required this.dioClient});

  Future<ApiResponse> addToNewsLetter(String email) async {
    try {
      final response = await dioClient!
          .post(AppConstants.EMAIL_SUBSCRIBE_URI, data: {'email': email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
