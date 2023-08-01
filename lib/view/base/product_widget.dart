import 'package:seven/view/base/wish_button.dart';

import '../../all_export.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final ProductType productType;
  final bool isGrid;
  ProductWidget(
      {super.key,
      required this.product,
      this.productType = ProductType.DAILY_ITEM,
      this.isGrid = false});

  final oneSideShadow = Padding(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
    child: Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: ColorResources.Black_COLOR.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        double? price = 0;
        int? stock = 0;
        bool isExistInCart = false;
        int? cardIndex;
        CartModel? cartModel;
        if (product.variations!.isNotEmpty) {
          for (int index = 0; index < product.variations!.length; index++) {
            price = product.variations!.isNotEmpty
                ? product.variations![index].price
                : product.price;
            stock = product.variations!.isNotEmpty
                ? product.variations![index].stock
                : product.totalStock;
            cartModel = CartModel(
                product.id,
                product.image!.isNotEmpty ? product.image![0] : '',
                product.name,
                price,
                PriceConverter.convertWithDiscount(
                    context, price, product.discount, product.discountType),
                1,
                product.variations!.isNotEmpty
                    ? product.variations![index]
                    : null,
                (price! -
                    PriceConverter.convertWithDiscount(context, price,
                        product.discount, product.discountType)!),
                (price -
                    PriceConverter.convertWithDiscount(
                        context, price, product.tax, product.taxType)!),
                product.capacity,
                product.unit,
                stock,
                product);
            isExistInCart = Provider.of<CartProvider>(context, listen: false)
                    .isExistInCart(cartModel) !=
                null;
            cardIndex = Provider.of<CartProvider>(context, listen: false)
                .isExistInCart(cartModel);
            if (isExistInCart) {
              break;
            }
          }
        } else {
          price = product.variations!.isNotEmpty
              ? product.variations![0].price!
              : product.price!;
          stock = product.variations!.isNotEmpty
              ? product.variations![0].stock!
              : product.totalStock!;
          cartModel = CartModel(
              product.id,
              product.image!.isNotEmpty ? product.image![0] : '',
              product.name,
              price,
              PriceConverter.convertWithDiscount(
                  context, price, product.discount, product.discountType),
              1,
              product.variations!.isNotEmpty ? product.variations![0] : null,
              (price -
                  PriceConverter.convertWithDiscount(
                      context, price, product.discount, product.discountType)!),
              (price -
                  PriceConverter.convertWithDiscount(
                      context, price, product.tax, product.taxType)!),
              product.capacity,
              product.unit,
              stock,
              product);
          isExistInCart = Provider.of<CartProvider>(context, listen: false)
                  .isExistInCart(cartModel) !=
              null;
          cardIndex = Provider.of<CartProvider>(context, listen: false)
              .isExistInCart(cartModel);
        }

        return ResponsiveHelper.isDesktop(context)
            ? OnHover(
                isItem: true,
                child: _productGridView(
                    context, isExistInCart, stock, cartModel, cardIndex),
              )
            : isGrid
                ? _productGridView(
                    context, isExistInCart, stock, cartModel, cardIndex)
                : Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.PADDING_SIZE_SMALL),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RouteHelper.getProductDetailsRoute(product: product),
                        );
                      },
                      child: Container(
                        height: 85,
                        padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorResources.getCardBgColor(context),
                        ),
                        child: Row(children: [
                          Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: ColorResources.getGreyColor(context)),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder(context),
                                image:
                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
                                fit: BoxFit.cover,
                                width: 85,
                                imageErrorBuilder: (c, o, s) => Image.asset(
                                    Images.placeholder(context),
                                    width: 85,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.name!,
                                      style: poppinsMedium.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    product.rating != null
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: RatingBar(
                                                rating:
                                                    product.rating!.isNotEmpty
                                                        ? double.parse(product
                                                            .rating![0]
                                                            .average!)
                                                        : 0.0,
                                                size: 10),
                                          )
                                        : const SizedBox(),
                                    Text('${product.capacity} ${product.unit}',
                                        style: poppinsRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.getTextColor(
                                                context))),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          product.discount! > 0
                                              ? Text(
                                                  PriceConverter.convertPrice(
                                                      context, product.price),
                                                  style: poppinsRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_EXTRA_SMALL,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                )
                                              : const SizedBox(),
                                          product.discount! > 0
                                              ? const SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL)
                                              : const SizedBox(),
                                          Text(
                                            PriceConverter.convertPrice(
                                              context,
                                              product.price,
                                              discount: product.discount,
                                              discountType:
                                                  product.discountType,
                                            ),
                                            style: poppinsBold.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: WishButton(
                                      product: product,
                                      edgeInset: const EdgeInsets.all(5)),
                                ),
                                const Expanded(child: SizedBox()),
                                !isExistInCart
                                    ? InkWell(
                                        onTap: () {
                                          if (product.variations == null ||
                                              product.variations!.isEmpty) {
                                            if (isExistInCart) {
                                              showCustomSnackBar(
                                                  getTranslated('already_added',
                                                      context)!,
                                                  context);
                                            } else if (stock! < 1) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'out_of_stock', context)!,
                                                  context);
                                            } else {
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .addToCart(cartModel!);
                                              showCustomSnackBar(
                                                  getTranslated('added_to_cart',
                                                      context)!,
                                                  context,
                                                  isError: false);
                                            }
                                          } else {
                                            Navigator.of(context).pushNamed(
                                              RouteHelper
                                                  .getProductDetailsRoute(
                                                      product: product),
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          margin: const EdgeInsets.all(2),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color:
                                                    ColorResources.getHintColor(
                                                            context)
                                                        .withOpacity(0.2)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(Icons.add,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ))
                                    : Consumer<CartProvider>(
                                        builder: (context, cart, child) =>
                                            Row(children: [
                                          InkWell(
                                            onTap: () {
                                              if (cart.cartList[cardIndex!]
                                                      .quantity! >
                                                  1) {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .setQuantity(
                                                        false, cardIndex,
                                                        context: context,
                                                        showMessage: true);
                                              } else {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeFromCart(
                                                        cardIndex, context);
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets
                                                      .symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                  vertical: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              child: Icon(Icons.remove,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                          Text(
                                              cart.cartList[cardIndex!].quantity
                                                  .toString(),
                                              style: poppinsSemiBold.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_EXTRA_LARGE,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                          InkWell(
                                            onTap: () {
                                              if (cart.cartList[cardIndex!]
                                                      .quantity! <
                                                  cart.cartList[cardIndex]
                                                      .stock!) {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .setQuantity(
                                                        true, cardIndex,
                                                        context: context,
                                                        showMessage: true);
                                              } else {
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'out_of_stock',
                                                        context)!,
                                                    context);
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets
                                                      .symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                  vertical: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              child: Icon(Icons.add,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        ]),
                                      ),
                              ]),
                        ]),
                      ),
                    ),
                  );
      },
    );
  }

  InkWell _productGridView(BuildContext context, bool isExistInCart, int? stock,
      CartModel? cartModel, int? cardIndex) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_TEN),
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteHelper.getProductDetailsRoute(product: product),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: ColorResources.getCardBgColor(context),
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_TEN),
            boxShadow: [
              BoxShadow(
                color: ColorResources.Black_COLOR.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 7,
                spreadRadius: 0.1,
              ),
            ]),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: width < 425 ? 4 : 6,
                  child: Stack(
                    children: [
                      oneSideShadow,
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorResources.getCardBgColor(context),
                          borderRadius: const BorderRadius.only(
                            topLeft:
                                Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                            topRight:
                                Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft:
                                Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                            topRight:
                                Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                          ),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder(context),
                            height: 155,
                            fit: BoxFit.cover,
                            image:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image!.isNotEmpty ? product.image![0] : ''}',
                            imageErrorBuilder: (c, o, s) => Image.asset(
                                Images.placeholder(context),
                                width: 80,
                                height: 155,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: width < 425 ? 6 : 4,
                  child: Container(
                    //padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          product.name!,
                          style: poppinsMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),

                        product.rating != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: RatingBar(
                                    rating: product.rating!.isNotEmpty
                                        ? double.parse(
                                            product.rating![0].average!)
                                        : 0.0,
                                    size: 10),
                              )
                            : const SizedBox(),

                        Text(
                          '${product.capacity} ${product.unit}',
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Text(
                          PriceConverter.convertPrice(context, product.price,
                              discount: product.discount,
                              discountType: product.discountType),
                          style: poppinsBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                        ),

                        product.discount! > 0
                            ? Text(
                                PriceConverter.convertPrice(
                                    context, product.price),
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                  color: ColorResources.RED_COLOR,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              )
                            : const SizedBox(),

                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //
                        //   ],
                        // ),
                        const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        if (productType == ProductType.LATEST_PRODUCT)
                          Column(
                            children: [
                              !isExistInCart
                                  ? InkWell(
                                      onTap: () {
                                        if (product.variations == null ||
                                            product.variations!.isEmpty) {
                                          if (isExistInCart) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'already_added', context)!,
                                                context);
                                          } else if (stock! < 1) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'out_of_stock', context)!,
                                                context);
                                          } else {
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .addToCart(cartModel!);
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'added_to_cart', context)!,
                                                context,
                                                isError: false);
                                          }
                                        } else {
                                          Navigator.of(context).pushNamed(
                                            RouteHelper.getProductDetailsRoute(
                                                product: product),
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getTranslated(
                                                'add_to_cart', context)!,
                                            style: poppinsRegular.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_DEFAULT,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: Image.asset(
                                                Images.shopping_cart_bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Consumer<CartProvider>(
                                      builder: (context, cart, child) => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (cart.cartList[cardIndex!]
                                                      .quantity! >
                                                  1) {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .setQuantity(
                                                        false, cardIndex);
                                              } else {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeFromCart(
                                                        cardIndex, context);
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL,
                                                vertical: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            cart.cartList[cardIndex!].quantity
                                                .toString(),
                                            style: poppinsSemiBold.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_LARGE,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (cart.cartList[cardIndex]
                                                      .quantity! <
                                                  cart.cartList[cardIndex]
                                                      .stock!) {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .setQuantity(
                                                        true, cardIndex);
                                              } else {
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'out_of_stock',
                                                        context)!,
                                                    context);
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL,
                                                vertical: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              child: Icon(Icons.add,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.topRight,
              child: WishButton(
                product: product,
                edgeInset: const EdgeInsets.all(8.0),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
