import '../../all_export.dart';

class ProductRepo {
  final DioClient? dioClient;

  ProductRepo({required this.dioClient});

  Future<ApiResponse> getPopularProductList(
      String offset, String? languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.POPULAR_PRODUCT_URI}?limit=10&&offset=$offset',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLatestProductList(
      String offset, String? languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.LATEST_PRODUCT_URI}?limit=10&&offset=$offset',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDailyItemList(
      String offset, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.DAILY_ITEM_URI}?limit=10&&offset=$offset',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(
      String productID, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.PRODUCT_DETAILS_URI}$productID',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchProduct(
      String productId, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.SEARCH_PRODUCT_URI}$productId',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBrandOrCategoryProductList(
      String id, String languageCode) async {
    try {
      String uri = '${AppConstants.CATEGORY_PRODUCT_URI}$id';

      final response = await dioClient!.get(uri,
          options: Options(headers: {'X-localization': languageCode}));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
