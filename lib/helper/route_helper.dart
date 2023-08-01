// ignore_for_file: constant_identifier_names

import '../all_export.dart';

class RouteHelper {
  static final FluroRouter router = FluroRouter();

  static String splash = '/splash';
  static String orderDetails = '/order-details';
  static String onBoarding = '/on-boarding';
  static String menu = '/';
  static String login = '/login';
  static String favorite = '/favorite';
  static String forgetPassword = '/forget-password';
  static String signUp = '/sign-up';
  static String verification = '/verification';
  static String createAccount = '/create-account';
  static String resetPassword = '/reset-password';
  static String updateAddress = '/update-address';
  static String selectLocation = '/select-location/';
  static String orderSuccessful = '/order-successful';
  static String payment = '/payment';
  static String checkout = '/checkout';
  static String notification = '/notification';
  static String trackOrder = '/track-order';
  static String categoryProductsNew = '/category-products-new';
  static String productDescription = '/product-description';
  static String productDetails = '/product-details';
  static String productImages = '/product-images';
  static String profile = '/profile';
  static String searchProduct = '/search-product';
  static String profileEdit = '/profile-edit';
  static String searchResult = '/search-result';
  static String cart = '/cart';
  static String categorys = '/categorys';
  static String profileMenus = '/menus';
  static String myOrder = '/my-order';
  static String address = '/address';
  static String coupon = '/coupon';
  static const String CHAT_SCREEN = '/chat_screen';
  static String settings = '/settings';
  static const String TERMS_SCREEN = '/terms';
  static const String POLICY_SCREEN = '/privacy-policy';
  static const String ABOUT_US_SCREEN = '/about-us';
  static const String HOME_ITEM = '/home-item';
  static const String MAINTENANCE = '/maintenance';
  static const String CONTACT_SCREEN = '/contact';
  static const String UPDATE = '/update';
  static const String ADD_ADDRESS_SCREEN = '/add-address';
  static const String ORDER_WEB_PAYMENT = '/order-web-payment';

  static String getMainRoute() => menu;
  static String getLoginRoute() => login;
  static String getTermsRoute() => TERMS_SCREEN;
  static String getPolicyRoute() => POLICY_SCREEN;
  static String getAboutUsRoute() => ABOUT_US_SCREEN;
  static String getUpdateRoute() => UPDATE;
  static String getSelectLocationRoute() => selectLocation;

  static String getOrderDetailsRoute(int? id) => '$orderDetails?id=$id';
  static String getVerifyRoute(String page, String email) =>
      '$verification?page=$page&email=$email';
  static String getNewPassRoute(String? email, String token) =>
      '$resetPassword?email=$email&token=$token';
  //static String getAddAddressRoute(String page) => '$addAddress?page=$page';
  static String getAddAddressRoute(
      String page, String action, AddressModel addressModel) {
    String data =
        base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$ADD_ADDRESS_SCREEN?page=$page&action=$action&address=$data';
  }

  static String getUpdateAddressRoute(String address, String? type, String? lat,
      String? long, String name, String? num, int? id, int? user) {
    List<int> encoded = utf8.encode(address);
    String address0 = base64Encode(encoded);
    encoded = utf8.encode(name);
    String name0 = base64Encode(encoded);
    return '$updateAddress?address=$address0&type=$type&lat=$lat&long=$long&name=$name0&number=$num&id=$id&user=$user';
  }

  static String getPaymentRoute(
      {required String page,
      String? id,
      int? user,
      String? selectAddress,
      PlaceOrderBody? placeOrderBody}) {
    String address = selectAddress != null
        ? base64Encode(utf8.encode(selectAddress))
        : 'null';
    String data = placeOrderBody != null
        ? base64Url.encode(utf8.encode(jsonEncode(placeOrderBody.toJson())))
        : 'null';
    return '$payment?page=$page&id=$id&user=$user&address=$address&place_order=$data';
  }

  static String getCheckoutRoute(
          double amount, double? discount, String? type, String? code) =>
      '$checkout?amount=$amount&discount=$discount&type=$type&code=$code';
  static String getOrderTrackingRoute(int? id) => '$trackOrder?id=$id';
  // static String getCategoryProductsRoute(int id) => '$categoryProducts?id=$id';
  static String getCategoryProductsRouteNew(
          {int? id, String? subcategoryName}) =>
      '$categoryProductsNew?id=$id&subcategory=$subcategoryName';
  static String getProductDescriptionRoute(String description) =>
      '$productDescription?description=$description';

  ///..........................
  static String getProductDetailsRoute({required Product product}) {
    String product1 = Uri.encodeComponent(jsonEncode(product.toJson()));
    return '$productDetails?product=$product1';
  }

  static String getProductImagesRoute(String? name, String images) =>
      '$productImages?name=$name&images=$images';
  static String getProfileEditRoute(
      String fname, String lname, String email, String phone, String images) {
    List<int> encoded = utf8.encode(fname);
    String fname0 = base64Encode(encoded);
    encoded = utf8.encode(lname);
    String lname0 = base64Encode(encoded);
    encoded = utf8.encode(email);
    String email0 = base64Encode(encoded);
    encoded = utf8.encode(phone);
    String phone0 = base64Encode(encoded);
    encoded = utf8.encode(images);
    String image = base64Encode(encoded);
    return '$profileEdit?fname=$fname0&lname=$lname0&email=$email0&phone=$phone0&images=$image';
  }

  static String getHomeItemRoute(String item) {
    List<int> encoded = utf8.encode(item);
    String data = base64Encode(encoded);
    return '$HOME_ITEM?item=$data';
  }

  static String getMaintenanceRoute() => MAINTENANCE;
  static String getSearchResultRoute(String text) {
    List<int> encoded = utf8.encode(text);
    String data = base64Encode(encoded);
    return '$searchResult?text=$data';
  }

  static String getChatRoute({OrderModel? orderModel}) {
    String orderModel0 = base64Encode(utf8.encode(jsonEncode(orderModel)));
    return '$CHAT_SCREEN?order=$orderModel0';
  }

  static String getContactRoute() => CONTACT_SCREEN;
  static String getFavoriteRoute() => favorite;

  static final Handler _splashHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const SplashScreen());

  static final Handler _orderDetailsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    OrderDetailsScreen? orderDetailsScreen =
        ModalRoute.of(context!)!.settings.arguments as OrderDetailsScreen?;
    return orderDetailsScreen ??
        OrderDetailsScreen(
            orderId: int.parse(params['id'][0]), orderModel: null);
  });

  static final Handler _onBoardingHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          OnBoardingScreen());

  static final Handler _menuHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          MenuScreen());

  static final Handler _loginHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const LoginScreen());

  static final Handler _forgetPassHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          ForgotPasswordScreen());

  static final Handler _signUpHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const SignUpScreen());

  static final Handler _verificationHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    VerificationScreen? verificationScreen =
        ModalRoute.of(context!)!.settings.arguments as VerificationScreen?;
    return verificationScreen ??
        VerificationScreen(
          fromSignUp: params['page'][0] == 'sign-up',
          emailAddress: params['email'][0],
        );
  });

  static final Handler _createAccountHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          CreateAccountScreen());

  static final Handler _resetPassHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    CreateNewPasswordScreen? createPassScreen =
        ModalRoute.of(context!)!.settings.arguments as CreateNewPasswordScreen?;
    return createPassScreen ??
        CreateNewPasswordScreen(
          email: params['email'][0],
          resetToken: params['token'][0],
        );
  });

  static final Handler _updateAddressHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    AddNewAddressScreen? addNewAddressScreen =
        ModalRoute.of(context!)!.settings.arguments as AddNewAddressScreen?;
    List<int> decode = base64Decode(params['address'][0].replaceAll(' ', '+'));
    String address = utf8.decode(decode);
    decode = base64Decode(params['name'][0].replaceAll(' ', '+'));
    String name = utf8.decode(decode);
    return addNewAddressScreen ??
        AddNewAddressScreen(
          isEnableUpdate: true,
          fromCheckout: false,
          address: AddressModel(
            id: int.parse(params['id'][0]),
            userId: int.parse(params['user'][0]),
            address: address,
            addressType: params['type'][0],
            latitude: params['lat'][0],
            longitude: params['long'][0],
            contactPersonName: name,
            contactPersonNumber: params['number'][0],
          ),
        );
  });

  static final Handler _selectLocationHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    SelectLocationScreen? locationScreen =
        ModalRoute.of(context!)!.settings.arguments as SelectLocationScreen?;
    return locationScreen ??
        Center(child: Container(child: const Text('Not Found')));
  });

/*  static Handler _orderSuccessfulHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    OrderSuccessfulScreen _orderSuccessfulScreen = ModalRoute.of(context).settings.arguments;
    return _orderSuccessfulScreen != null ? _orderSuccessfulScreen : OrderSuccessfulScreen(
      orderID: params['id'][0], addressID: int.parse(params['address'][0]), status: int.parse(params['status'][0]),
    );
  });*/
  static final Handler _orderSuccessHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    int status = (params['status'][0] == 'success' ||
            params['status'][0] == 'payment-success')
        ? 0
        : (params['status'][0] == 'fail' ||
                params['status'][0] == 'payment-fail')
            ? 1
            : 2;
    return OrderSuccessfulScreen(orderID: params['id'][0], status: status);
  });

  static final Handler _orderWebPaymentHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return OrderWebPayment(
      token: params['token'][0],
    );
  });

  static final Handler _paymentHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    bool fromCheckOut = params['page'][0] == 'checkout';
    String decoded = fromCheckOut
        ? utf8.decode(
            base64Url.decode(params['place_order'][0].replaceAll(' ', '+')))
        : 'null';

    return PaymentScreen(
        fromCheckout: fromCheckOut,
        orderModel: fromCheckOut
            ? OrderModel()
            : OrderModel(
                userId: int.parse(params['user'][0]),
                id: int.parse(params['id'][0])),
        url:
            fromCheckOut ? utf8.decode(base64Decode(params['address'][0])) : '',
        placeOrderBody: decoded != 'null'
            ? PlaceOrderBody.fromJson(jsonDecode(decoded))
            : null);
  });

  static final Handler _checkoutHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    CheckoutScreen? checkoutScreen =
        ModalRoute.of(context!)!.settings.arguments as CheckoutScreen?;
    return checkoutScreen ??
        CheckoutScreen(
          orderType: params['type'][0],
          discount: double.parse(params['discount'][0]),
          amount: double.parse(params['amount'][0]),
          couponCode: params['code'][0],
        );
  });

  static final Handler _notificationHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          NotificationScreen());

  static final Handler _trackOrderHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    TrackOrderScreen? trackOrderScreen =
        ModalRoute.of(context!)!.settings.arguments as TrackOrderScreen?;
    return trackOrderScreen ?? TrackOrderScreen(orderID: params['id'][0]);
  });

  /*static Handler _categoryProductsHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    CategoryProductScreen _categoryProductScreen = ModalRoute.of(context).settings.arguments;
    return _categoryProductScreen != null ? _categoryProductScreen : CategoryProductScreen(categoryModel: CategoryModel(
      id: int.parse(params['id'][0]),
    ));
  });*/
  static final Handler _categoryProductsHandlerNew = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    CategoryProductScreenNew? categoryProductScreen = ModalRoute.of(context!)!
        .settings
        .arguments as CategoryProductScreenNew?;
    return categoryProductScreen ??
        CategoryProductScreenNew(
          categoryModel: CategoryModel(
            id: int.parse(params['id'][0]),
          ),
          subCategory: params['subcategory'][0],
        );
  });

  static final Handler _productDescriptionHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    DescriptionScreen? descriptionScreen =
        ModalRoute.of(context!)!.settings.arguments as DescriptionScreen?;
    List<int> decode =
        base64Decode(params['description'][0].replaceAll('-', '+'));
    String data = utf8.decode(decode);
    return descriptionScreen ?? DescriptionScreen(description: data);
  });

  static final Handler _productDetailsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    Product product = Product.fromJson(jsonDecode(params['product'][0]));
    return ProductDetailsScreen(product: product);
  });

  ///...............
  static final Handler _productImagesHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    ProductImageScreen? productImageScreen =
        ModalRoute.of(context!)!.settings.arguments as ProductImageScreen?;
    return productImageScreen ??
        ProductImageScreen(
          title: params['name'][0],
          imageList: jsonDecode(params['images'][0]),
        );
  });

  static final Handler _profileHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          ProfileScreen());

  static final Handler _searchProductHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          SearchScreen());

  ///.................
  static final Handler _profileEditHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    ProfileEditScreen? profileEditScreen =
        ModalRoute.of(context!)!.settings.arguments as ProfileEditScreen?;
    List<int> decode = base64Decode(params['fname'][0].replaceAll(' ', '+'));
    String fname = utf8.decode(decode);
    decode = base64Decode(params['lname'][0].replaceAll(' ', '+'));
    String lname = utf8.decode(decode);
    decode = base64Decode(params['email'][0].replaceAll(' ', '+'));
    String email = utf8.decode(decode);
    decode = base64Decode(params['phone'][0].replaceAll(' ', '+'));
    String phone = utf8.decode(decode);
    decode = base64Decode(params['images'][0].replaceAll(' ', '+'));
    String image = utf8.decode(decode);
    return profileEditScreen ??
        ProfileEditScreen(
          userInfoModel: UserInfoModel(
              fName: fname,
              lName: lname,
              email: email,
              phone: phone,
              image: image),
        );
  });
  static final Handler _searchResultHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    List<int> decode = base64Decode(params['text'][0]);
    String data = utf8.decode(decode);
    return SearchResultScreen(searchString: data);
  });
  static final Handler _cartHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          CartScreen());
  static final Handler _categorysHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return AllCategoryScreen();
  });
  static final Handler _profileMenusHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          MenuWidget());
  static final Handler _myOrderHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          MyOrderScreen());
  static final Handler _addressHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const AddressScreen());
  static final Handler _couponHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          CouponScreen());
  static final Handler _chatHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    final orderModel = jsonDecode(
        utf8.decode(base64Url.decode(params['order'][0].replaceAll(' ', '+'))));
    return ChatScreen(
        orderModel:
            orderModel != null ? OrderModel.fromJson(orderModel) : null);
  });
  static final Handler _settingsHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          SettingsScreen());
  static final Handler _termsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const HtmlViewerScreen(htmlType: HtmlType.TERMS_AND_CONDITION));

  static final Handler _policyHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const HtmlViewerScreen(htmlType: HtmlType.PRIVACY_POLICY));

  static final Handler _aboutUsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const HtmlViewerScreen(htmlType: HtmlType.ABOUT_US));

  static final Handler _homeItemHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    List<int> decode = base64Decode(params['item'][0]);
    String data = utf8.decode(decode);
    return HomeItemScreen(
      dailyItem: data == 'daily_needs',
    );
  });
  static final Handler _maintenanceHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          MaintenanceScreen());
  static final Handler _contactHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => ContactScreen());

  static final Handler _updateHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => UpdateScreen());
  static final Handler _newAddressHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool isUpdate = params['action'][0] == 'update';
    print('this add is call $isUpdate');
    AddressModel? addressModel;
    if (isUpdate) {
      String decoded = utf8
          .decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
      addressModel = AddressModel.fromJson(jsonDecode(decoded));
    }
    return AddNewAddressScreen(
        fromCheckout: params['page'][0] == 'checkout',
        isEnableUpdate: isUpdate,
        address: isUpdate ? addressModel : null);
  });
  static final Handler _favoriteHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => WishListScreen());

  //static Handler _routeHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => ModalRoute.of(context).settings.arguments);

  static void setupRouter() {
    router.define(splash,
        handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(orderDetails,
        handler: _orderDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(onBoarding,
        handler: _onBoardingHandler, transitionType: TransitionType.fadeIn);
    router.define(menu,
        handler: _menuHandler, transitionType: TransitionType.fadeIn);
    router.define(login,
        handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(forgetPassword,
        handler: _forgetPassHandler, transitionType: TransitionType.fadeIn);
    router.define(signUp,
        handler: _signUpHandler, transitionType: TransitionType.fadeIn);
    router.define(verification,
        handler: _verificationHandler, transitionType: TransitionType.fadeIn);
    router.define(createAccount,
        handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
    router.define(resetPassword,
        handler: _resetPassHandler, transitionType: TransitionType.fadeIn);
    //router.define(addAddress, handler: _addAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(updateAddress,
        handler: _updateAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(selectLocation,
        handler: _selectLocationHandler, transitionType: TransitionType.fadeIn);
    // router.define('$orderSuccessful:id/:status', handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    // router.define('$ORDER_WEB_PAYMENT/:status?:token', handler: _orderWebPaymentHandler, transitionType: TransitionType.fadeIn);
    router.define('$orderSuccessful/:id/:status',
        handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    router.define('$ORDER_WEB_PAYMENT/:status?:token',
        handler: _orderWebPaymentHandler,
        transitionType: TransitionType.fadeIn);
    router.define(payment,
        handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    router.define(checkout,
        handler: _checkoutHandler, transitionType: TransitionType.fadeIn);
    router.define(notification,
        handler: _notificationHandler, transitionType: TransitionType.fadeIn);
    router.define(trackOrder,
        handler: _trackOrderHandler, transitionType: TransitionType.fadeIn);
    // router.define(categoryProducts, handler: _categoryProductsHandler, transitionType: TransitionType.fadeIn);
    router.define(categoryProductsNew,
        handler: _categoryProductsHandlerNew,
        transitionType: TransitionType.fadeIn);
    router.define(productDescription,
        handler: _productDescriptionHandler,
        transitionType: TransitionType.fadeIn);
    router.define(productDetails,
        handler: _productDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(productImages,
        handler: _productImagesHandler, transitionType: TransitionType.fadeIn);
    router.define(profile,
        handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define(searchProduct,
        handler: _searchProductHandler, transitionType: TransitionType.fadeIn);
    router.define(profileEdit,
        handler: _profileEditHandler, transitionType: TransitionType.fadeIn);
    router.define(searchResult,
        handler: _searchResultHandler, transitionType: TransitionType.fadeIn);
    router.define(cart,
        handler: _cartHandler, transitionType: TransitionType.fadeIn);
    router.define(categorys,
        handler: _categorysHandler, transitionType: TransitionType.fadeIn);
    router.define(profileMenus,
        handler: _profileMenusHandler, transitionType: TransitionType.fadeIn);
    router.define(myOrder,
        handler: _myOrderHandler, transitionType: TransitionType.fadeIn);
    router.define(address,
        handler: _addressHandler, transitionType: TransitionType.fadeIn);
    router.define(coupon,
        handler: _couponHandler, transitionType: TransitionType.fadeIn);
    router.define(CHAT_SCREEN,
        handler: _chatHandler, transitionType: TransitionType.fadeIn);
    router.define(settings,
        handler: _settingsHandler, transitionType: TransitionType.fadeIn);
    router.define(TERMS_SCREEN,
        handler: _termsHandler, transitionType: TransitionType.fadeIn);
    router.define(POLICY_SCREEN,
        handler: _policyHandler, transitionType: TransitionType.fadeIn);
    router.define(ABOUT_US_SCREEN,
        handler: _aboutUsHandler, transitionType: TransitionType.fadeIn);
    router.define(HOME_ITEM,
        handler: _homeItemHandler, transitionType: TransitionType.fadeIn);
    router.define(MAINTENANCE,
        handler: _maintenanceHandler, transitionType: TransitionType.fadeIn);
    router.define(CONTACT_SCREEN,
        handler: _contactHandler, transitionType: TransitionType.fadeIn);
    router.define(UPDATE,
        handler: _updateHandler, transitionType: TransitionType.fadeIn);
    router.define(ADD_ADDRESS_SCREEN,
        handler: _newAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(favorite,
        handler: _favoriteHandler, transitionType: TransitionType.fadeIn);
  }
}
