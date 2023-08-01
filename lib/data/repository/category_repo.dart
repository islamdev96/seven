import '../../all_export.dart';

class CategoryRepo {
  final DioClient? dioClient;
  CategoryRepo({required this.dioClient});

  Future<ApiResponse> getCategoryList(String? languageCode) async {
    try {
      final response = await dioClient!.get(
        AppConstants.CATEGORY_URI,
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategoryList(
      String parentID, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.SUB_CATEGORY_URI}$parentID',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryProductList(
      String categoryID, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.CATEGORY_PRODUCT_URI}$categoryID',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
