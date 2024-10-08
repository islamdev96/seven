import '../../all_export.dart';

class SearchRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SearchRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getSearchProductList(
      String query, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.SEARCH_URI + query}&limit=50&&offset=1',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String?> getAllSortByList(BuildContext context) {
    List<String?> sortByList = [
      getTranslated('low_to_high', context),
      getTranslated('high_to_low', context),
      getTranslated('ascending', context),
      getTranslated('descending', context),
    ];
    return sortByList;
  }

  // for save home address
  Future<void> saveSearchAddress(String searchAddress) async {
    try {
      List<String> searchKeywordList =
          sharedPreferences!.getStringList(AppConstants.SEARCH_ADDRESS) ?? [];
      if (!searchKeywordList.contains(searchAddress)) {
        searchKeywordList.add(searchAddress);
        print(searchAddress);
      }
      await sharedPreferences!
          .setStringList(AppConstants.SEARCH_ADDRESS, searchKeywordList);
    } catch (e) {
      rethrow;
    }
  }

  List<String> getSearchAddress() {
    return sharedPreferences!.getStringList(AppConstants.SEARCH_ADDRESS) ?? [];
  }

  Future<bool> clearSearchAddress() async {
    return sharedPreferences!.setStringList(AppConstants.SEARCH_ADDRESS, []);
  }
}
