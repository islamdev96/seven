import '../all_export.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo? bannerRepo;

  BannerProvider({required this.bannerRepo});

  List<BannerModel>? _bannerList;
  final List<Product> _productList = [];
  int _currentIndex = 0;

  List<BannerModel>? get bannerList => _bannerList;
  List<Product> get productList => _productList;
  int get currentIndex => _currentIndex;

  Future<void> getBannerList(BuildContext context, bool reload) async {
    if (bannerList == null || reload) {
      ApiResponse apiResponse = await bannerRepo!.getBannerList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bannerList = [];
        apiResponse.response!.data.forEach((category) {
          BannerModel bannerModel = BannerModel.fromJson(category);
          if (bannerModel.productId != null) {
            getProductDetails(context, bannerModel.productId.toString());
          }
          _bannerList!.add(bannerModel);
        });
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void getProductDetails(BuildContext context, String productID) async {
    ApiResponse apiResponse = await bannerRepo!.getProductDetails(productID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _productList.add(Product.fromJson(apiResponse.response!.data));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }
}
