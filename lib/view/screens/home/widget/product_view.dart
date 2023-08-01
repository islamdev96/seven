import 'package:flutter/material.dart';
import 'package:seven/data/model/response/product_model.dart';
import 'package:seven/helper/product_type.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/localization_provider.dart';
import 'package:seven/provider/product_provider.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/base/no_data_screen.dart';
import 'package:seven/view/base/product_shimmer.dart';
import 'package:seven/view/base/product_widget.dart';
import 'package:seven/view/base/web_product_shimmer.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  final ScrollController? scrollController;
  ProductView({this.scrollController});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int? pageSize;

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
      context,
      '1',
      true,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void seeMoreItems() {
      pageSize = (Provider.of<ProductProvider>(context, listen: false)
                  .latestPageSize! /
              10)
          .ceil();

      if (Provider.of<ProductProvider>(context, listen: false).offset <
          pageSize!) {
        Provider.of<ProductProvider>(context, listen: false).offset++;
        Provider.of<ProductProvider>(context, listen: false).showBottomLoader();
        Provider.of<ProductProvider>(context, listen: false)
            .getLatestProductList(
          context,
          Provider.of<ProductProvider>(context, listen: false)
              .offset
              .toString(),
          false,
          Provider.of<LocalizationProvider>(context, listen: false)
              .locale
              .languageCode,
        );
      }
    }

    if (!ResponsiveHelper.isDesktop(context)) {
      if (widget.scrollController!.hasClients) {
        widget.scrollController?.addListener(() {
          if (widget.scrollController!.position.maxScrollExtent ==
                  widget.scrollController!.position.pixels &&
              Provider.of<ProductProvider>(context, listen: false)
                      .latestProductList !=
                  null &&
              !Provider.of<ProductProvider>(context, listen: false).isLoading) {
            pageSize = (Provider.of<ProductProvider>(context, listen: false)
                        .latestPageSize! /
                    10)
                .ceil();
            if (Provider.of<ProductProvider>(context, listen: false).offset <
                pageSize!) {
              Provider.of<ProductProvider>(context, listen: false).offset++;
              Provider.of<ProductProvider>(context, listen: false)
                  .showBottomLoader();
              Provider.of<ProductProvider>(context, listen: false)
                  .getLatestProductList(
                context,
                Provider.of<ProductProvider>(context, listen: false)
                    .offset
                    .toString(),
                false,
                Provider.of<LocalizationProvider>(context, listen: false)
                    .locale
                    .languageCode,
              );
            }
          }
        });
      }
    }
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        productList = prodProvider.latestProductList;

        return Column(children: [
          productList != null
              ? productList.length > 0
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing:
                              ResponsiveHelper.isDesktop(context) ? 13 : 5,
                          mainAxisSpacing:
                              ResponsiveHelper.isDesktop(context) ? 13 : 5,
                          childAspectRatio: ResponsiveHelper.isDesktop(context)
                              ? (1 / 1.5)
                              : 3.0,
                          crossAxisCount: ResponsiveHelper.isDesktop(context)
                              ? 5
                              : ResponsiveHelper.isTab(context)
                                  ? 2
                                  : 1),
                      itemCount: productList.length,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                          vertical: Dimensions.PADDING_SIZE_LARGE),
                      // padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_DEFAULT),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductWidget(
                          product: productList![index],
                          productType: ProductType.LATEST_PRODUCT,
                        );
                      },
                    )
                  : NoDataScreen()
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing:
                          ResponsiveHelper.isDesktop(context) ? 13 : 5,
                      mainAxisSpacing:
                          ResponsiveHelper.isDesktop(context) ? 13 : 5,
                      childAspectRatio:
                          ResponsiveHelper.isDesktop(context) ? (1 / 1.4) : 4,
                      crossAxisCount: ResponsiveHelper.isDesktop(context)
                          ? 5
                          : ResponsiveHelper.isTab(context)
                              ? 2
                              : 1),
                  itemCount: 10,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ResponsiveHelper.isDesktop(context)
                        ? WebProductShimmer(isEnabled: productList == null)
                        : ProductShimmer(isEnabled: productList == null);
                  },
                ),
          Padding(
            padding: ResponsiveHelper.isDesktop(context)
                ? const EdgeInsets.only(top: 40, bottom: 70)
                : const EdgeInsets.all(0),
            child: ResponsiveHelper.isDesktop(context)
                ? prodProvider.isLoading
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      ))
                    : (Provider.of<ProductProvider>(context, listen: false)
                                .offset ==
                            pageSize)
                        ? SizedBox()
                        : SizedBox(
                            width: 500,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                seeMoreItems();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(getTranslated('see_more', context)!,
                                    style: poppinsRegular.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_OVER_LARGE)),
                              ),
                            ),
                          )
                : prodProvider.isLoading
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      ))
                    : SizedBox.shrink(),
          ),
        ]);
      },
    );
  }
}
