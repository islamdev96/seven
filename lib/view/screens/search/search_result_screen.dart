import 'package:flutter/material.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/search_provider.dart';
import 'package:seven/provider/theme_provider.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/base/footer_view.dart';
import 'package:seven/view/base/no_data_screen.dart';
import 'package:seven/view/base/product_shimmer.dart';
import 'package:seven/view/base/product_widget.dart';
import 'package:seven/view/base/web_app_bar/web_app_bar.dart';
import 'package:seven/view/base/web_product_shimmer.dart';
import 'package:seven/view/screens/search/widget/filter_widget.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  final String? searchString;

  const SearchResultScreen({super.key, this.searchString});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : null,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) => Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: ResponsiveHelper.isDesktop(context)
                                  ? MediaQuery.of(context).size.height - 400
                                  : MediaQuery.of(context).size.height),
                          child: SizedBox(
                            width: 1170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),
                                !ResponsiveHelper.isDesktop(context)
                                    ? Container(
                                        height: 48,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: ColorResources.getCardBgColor(
                                              context),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[
                                                  Provider.of<ThemeProvider>(
                                                              context)
                                                          .darkTheme
                                                      ? 700
                                                      : 200]!,
                                              spreadRadius: 0.5,
                                              blurRadius: 0.5,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              widget.searchString!,
                                              style: poppinsLight.copyWith(
                                                  color: ColorResources
                                                      .getTextColor(context),
                                                  fontSize: Dimensions
                                                      .PADDING_SIZE_LARGE),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Icon(Icons.close,
                                                  color: Colors.red, size: 22),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 13),
                                Container(
                                  height: 48,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_SMALL),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_SMALL),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color:
                                        ColorResources.getCardBgColor(context),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[
                                            Provider.of<ThemeProvider>(context)
                                                    .darkTheme
                                                ? 700
                                                : 200]!,
                                        spreadRadius: 0.5,
                                        blurRadius: 0.5,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          searchProvider.searchProductList !=
                                                  null
                                              ? Text(
                                                  "${searchProvider.searchProductList!.length ?? 0}",
                                                  style: poppinsMedium.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                )
                                              : const SizedBox.shrink(),
                                          Text(
                                            '${searchProvider.searchProductList != null ? "" : 0} ${getTranslated('items_found', context)}',
                                            style: poppinsMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context)),
                                          )
                                        ],
                                      ),
                                      searchProvider.searchProductList != null
                                          ? InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      List<double?> prices = [];
                                                      for (var product
                                                          in searchProvider
                                                              .filterProductList!) {
                                                        prices
                                                            .add(product.price);
                                                      }
                                                      prices.sort();
                                                      double? maxValue = prices
                                                              .isNotEmpty
                                                          ? prices[
                                                              prices.length - 1]
                                                          : 1000;

                                                      return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                        child: FilterWidget(
                                                            maxValue: maxValue),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    border: Border.all(
                                                        color: ColorResources
                                                                .getHintColor(
                                                                    context)
                                                            .withOpacity(.5))),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.filter_list,
                                                        color: ColorResources
                                                            .getTextColor(
                                                                context)),
                                                    Text(
                                                      '  ${getTranslated('filter', context)}',
                                                      style: poppinsMedium.copyWith(
                                                          color: ColorResources
                                                              .getTextColor(
                                                                  context),
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 22),
                                searchProvider.searchProductList != null
                                    ? searchProvider
                                            .searchProductList!.isNotEmpty
                                        ? GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 13
                                                            : 5,
                                                    mainAxisSpacing:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 13
                                                            : 5,
                                                    childAspectRatio:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? (1 / 1.4)
                                                            : 2.8,
                                                    crossAxisCount:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 5
                                                            : ResponsiveHelper
                                                                    .isTab(
                                                                        context)
                                                                ? 2
                                                                : 1),
                                            itemCount: searchProvider
                                                .searchProductList!.length,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL,
                                                vertical:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? Dimensions
                                                            .PADDING_SIZE_LARGE
                                                        : 0.0),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ProductWidget(
                                                  product: searchProvider
                                                          .searchProductList![
                                                      index]);
                                            },
                                          )
                                        : const NoDataScreen(isSearch: true)
                                    : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? 13
                                                        : 5,
                                                mainAxisSpacing:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? 13
                                                        : 5,
                                                childAspectRatio:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? (1 / 1.4)
                                                        : 4,
                                                crossAxisCount: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? 5
                                                    : ResponsiveHelper.isTab(
                                                            context)
                                                        ? 2
                                                        : 1),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: 10,
                                        itemBuilder: (context, index) =>
                                            ResponsiveHelper.isDesktop(context)
                                                ? WebProductShimmer(
                                                    isEnabled: searchProvider
                                                            .searchProductList ==
                                                        null)
                                                : ProductShimmer(
                                                    isEnabled: searchProvider
                                                            .searchProductList ==
                                                        null),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ResponsiveHelper.isDesktop(context)
                          ? const FooterView()
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
