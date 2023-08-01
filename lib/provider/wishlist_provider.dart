import '../all_export.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo? wishListRepo;

  WishListProvider({required this.wishListRepo});

  List<Product>? _wishList;
  List<Product>? get wishList => _wishList;
  Product? _product;
  Product? get product => _product;
  List<int?> _wishIdList = [];
  List<int?> get wishIdList => _wishIdList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void addToWishList(Product product, BuildContext context) async {
    _wishList!.add(product);
    _wishIdList.add(product.id);
    notifyListeners();
    ApiResponse apiResponse = await wishListRepo!.addWishList([product.id]);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map<String, dynamic> map = apiResponse.response!.data;
      String message = map['message'];
      showCustomSnackBar(message, context, isError: false);
    } else {
      _wishList!.remove(product);
      _wishIdList.remove(product.id);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void removeFromWishList(Product product, BuildContext context) async {
    _wishList!.remove(product);
    _wishIdList.remove(product.id);
    notifyListeners();
    ApiResponse apiResponse = await wishListRepo!.removeWishList([product.id]);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map<String, dynamic> map = apiResponse.response!.data;
      String message = map['message'];
      showCustomSnackBar(message, context, isError: false);
    } else {
      _wishList!.add(product);
      _wishIdList.add(product.id);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getWishList(BuildContext context) async {
    _isLoading = true;
    _wishList = [];
    _wishIdList = [];
    ApiResponse apiResponse = await wishListRepo!.getWishList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map<String, dynamic> responseData = apiResponse.response!.data;
      WishListModel wishListModel = WishListModel.fromJson(responseData);
      if (wishListModel.products != null) {
        _wishList!.addAll(wishListModel.products!);
        for (int i = 0; i < _wishList!.length; i++) {
          _wishIdList.add(_wishList![i].id);
        }
      }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }
}
