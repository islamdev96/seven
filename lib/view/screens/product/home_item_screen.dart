import 'package:flutter/material.dart';
import 'package:seven/data/model/response/product_model.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/localization_provider.dart';
import 'package:seven/provider/product_provider.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/view/base/custom_app_bar.dart';
import 'package:seven/view/base/footer_view.dart';
import 'package:seven/view/base/no_data_screen.dart';
import 'package:seven/view/base/product_widget.dart';
import 'package:seven/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';

import '../../base/title_widget.dart';

class HomeItemScreen extends StatefulWidget {
  final bool? dailyItem;

  const HomeItemScreen({Key? key, this.dailyItem}) : super(key: key);

  @override
  State<HomeItemScreen> createState() => _HomeItemScreenState();
}

class _HomeItemScreenState extends State<HomeItemScreen> {
  late int pageSize;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).popularOffset = 1;

    if (widget.dailyItem!) {
      Provider.of<ProductProvider>(context, listen: false).getDailyNeeds(
        context,
        '1',
        false,
        Provider.of<LocalizationProvider>(context, listen: false)
            .locale
            .languageCode,
      );
    } else {
      Provider.of<ProductProvider>(context, listen: false)
          .getPopularProductList(
        context,
        '1',
        true,
        Provider.of<LocalizationProvider>(context, listen: false)
            .locale
            .languageCode,
      );
    }

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.position.pixels &&
          (productProvider.popularProductList != null ||
              productProvider.dailyItemList != null) &&
          !productProvider.isLoading) {
        pageSize = (productProvider.popularPageSize! / 10).ceil();
        if (productProvider.popularOffset < pageSize) {
          productProvider.popularOffset++;
          productProvider.showBottomLoader();
          if (widget.dailyItem!) {
            productProvider.getDailyNeeds(
              context,
              productProvider.popularOffset.toString(),
              false,
              Provider.of<LocalizationProvider>(context, listen: false)
                  .locale
                  .languageCode,
            );
          } else {
            productProvider.getPopularProductList(
              context,
              productProvider.popularOffset.toString(),
              false,
              Provider.of<LocalizationProvider>(context, listen: false)
                  .locale
                  .languageCode,
            );
          }
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : CustomAppBar(
              title: widget.dailyItem!
                  ? getTranslated('daily_needs', context)
                  : getTranslated('popular_item', context),
            )) as PreferredSizeWidget?,
      body: Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
              controller: scrollController,
              child: Center(
                  child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: ResponsiveHelper.isDesktop(context)
                            ? MediaQuery.of(context).size.height - 400
                            : MediaQuery.of(context).size.height),
                    child: Column(children: [
                      ResponsiveHelper.isDesktop(context)
                          ? const SizedBox(height: 20)
                          : const SizedBox.shrink(),
                      SizedBox(
                          width: 1170,
                          child: TitleWidget(
                            title: widget.dailyItem!
                                ? getTranslated('daily_needs', context)
                                : getTranslated('popular_item', context),
                          )),
                      SizedBox(
                        width: 1170,
                        child: Consumer<ProductProvider>(
                          builder: (context, productProvider, child) {
                            List<Product>? productList;
                            if (widget.dailyItem!) {
                              productList = productProvider.dailyItemList;
                            } else {
                              productList = productProvider.popularProductList;
                            }

                            return productList != null
                                ? productList.isNotEmpty
                                    ? Column(
                                        children: [
                                          GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: ResponsiveHelper
                                                      .isDesktop(context)
                                                  ? 5
                                                  : ResponsiveHelper.isMobile(
                                                          context)
                                                      ? 2
                                                      : 4,
                                              mainAxisSpacing:
                                                  ResponsiveHelper.isDesktop(
                                                          context)
                                                      ? 13
                                                      : 10,
                                              crossAxisSpacing:
                                                  ResponsiveHelper.isDesktop(
                                                          context)
                                                      ? 13
                                                      : 10,
                                              childAspectRatio: (1 / 1.3),
                                            ),
                                            padding: const EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_SMALL),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: productList.length,
                                            itemBuilder: (context, index) {
                                              return ProductWidget(
                                                  product: productList![index],
                                                  isGrid: true);
                                            },
                                          ),
                                          if (productProvider.isLoading)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Theme.of(context)
                                                            .primaryColor),
                                              )),
                                            )
                                        ],
                                      )
                                    : const NoDataScreen()
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor))));
                          },
                        ),
                      ),
                    ]),
                  ),
                  ResponsiveHelper.isDesktop(context)
                      ? const FooterView()
                      : const SizedBox(),
                ],
              )))),
    );
  }
}
