import '../../../all_export.dart';

class WebAppBar extends StatefulWidget implements PreferredSizeWidget {
  const WebAppBar({super.key});

  @override
  State<WebAppBar> createState() => _WebAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _WebAppBarState extends State<WebAppBar> {
  String? chooseLanguage;

  List<PopupMenuEntry<Object>> popUpMenuList(BuildContext context) {
    List<PopupMenuEntry<Object>> list = <PopupMenuEntry<Object>>[];
    List<CategoryModel>? categoryList =
        Provider.of<CategoryProvider>(context, listen: false).categoryList;
    list.add(PopupMenuItem(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      value: categoryList,
      child: MouseRegion(
        onExit: (_) => Navigator.of(context).pop(),
        child: CategoryHoverWidget(categoryList: categoryList),
      ),
    ));
    return list;
  }

  List<PopupMenuEntry<Object>> popUpLanguageList(BuildContext context) {
    List<PopupMenuEntry<Object>> languagePopupMenuEntryList =
        <PopupMenuEntry<Object>>[];
    List<LanguageModel> languageList = AppConstants.languages;
    languagePopupMenuEntryList.add(PopupMenuItem(
      padding: EdgeInsets.zero,
      value: languageList,
      child: MouseRegion(
        onExit: (_) => Navigator.of(context).pop(),
        child: LanguageHoverWidget(languageList: languageList),
      ),
    ));
    return languagePopupMenuEntryList;
  }

  _showPopupMenu(Offset offset, BuildContext context, bool isCategory) async {
    double left = offset.dx;
    double top = offset.dy;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          left, top, overlay.size.width, overlay.size.height),
      items: isCategory ? popUpMenuList(context) : popUpLanguageList(context),
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  @override
  void initState() {
    // _loadData(context, true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    Provider.of<LanguageProvider>(context, listen: false)
        .initializeAllLanguages(context);
    LanguageModel currentLanguage = AppConstants.languages.firstWhere(
        (language) =>
            language.languageCode ==
            Provider.of<LocalizationProvider>(context, listen: false)
                .locale
                .languageCode);
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: ColorResources.Black_COLOR.withOpacity(0.10),
          blurRadius: 20,
          offset: const Offset(0, 10),
        )
      ]),
      child: Column(
        children: [
          Container(
            color: ColorResources.getAppBarHeaderColor(context),
            height: 45,
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Text(getTranslated('dark_mode', context)!,
                            style: poppinsRegular.copyWith(
                                color: ColorResources.getTextColor(context),
                                fontSize: Dimensions.PADDING_SIZE_DEFAULT)),
                      ),
                      // StatusWidget(),
                      Transform.scale(
                        scale: 1,
                        child: Switch(
                          onChanged: (bool isActive) =>
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme(),
                          value: Provider.of<ThemeProvider>(context).darkTheme,
                          activeColor: Colors.black26,
                          activeTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      SizedBox(
                        height: Dimensions.PADDING_SIZE_LARGE,
                        child: MouseRegion(
                          onHover: (details) {
                            _showPopupMenu(details.position, context, false);
                          },
                          child: InkWell(
                            onTap: () =>
                                showAnimatedDialog(context, CurrencyDialog()),
                            // onTap: () => Navigator.pushNamed(context, RouteHelper.getLanguageRoute('menu')),
                            child: Row(
                              children: [
                                Image.asset(currentLanguage.imageUrl!,
                                    height: Dimensions.PADDING_SIZE_LARGE,
                                    width: Dimensions.PADDING_SIZE_LARGE),
                                const SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text('${currentLanguage.languageName}',
                                    style: poppinsRegular.copyWith(
                                        color: ColorResources.getTextColor(
                                            context))),
                                const SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Icon(Icons.expand_more,
                                    color: ColorResources.getTextColor(context))
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                          width: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                      isLoggedIn
                          ? InkWell(
                              onTap: () => showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) =>
                                      SignOutConfirmationDialog()),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    child: Image.asset(Images.lock,
                                        height: 16,
                                        fit: BoxFit.contain,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    child: Text(
                                        getTranslated('log_out', context)!,
                                        style: poppinsRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT,
                                            color: ColorResources.getTextColor(
                                                context))),
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, RouteHelper.login);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    child: Image.asset(Images.lock,
                                        height: 16,
                                        fit: BoxFit.contain,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    child: Text(
                                        getTranslated('login', context)!,
                                        style: poppinsRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT,
                                            color: ColorResources.getTextColor(
                                                context))),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).cardColor,
              child: Center(
                child: SizedBox(
                    width: 1170,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Provider.of<ProductProvider>(context,
                                        listen: false)
                                    .offset = 1;
                                Navigator.pushNamed(context, RouteHelper.menu);
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                      height: 50,
                                      child: Consumer<SplashProvider>(
                                        builder: (context, splash, child) =>
                                            FadeInImage.assetNetwork(
                                          placeholder: Images.app_logo,
                                          image: splash.baseUrls != null
                                              ? '${splash.baseUrls!.ecommerceImageUrl}/${splash.configModel!.ecommerceLogo}'
                                              : '',
                                          fit: BoxFit.contain,
                                          imageErrorBuilder: (c, b, v) =>
                                              Image.asset(Images.app_logo),
                                        ),
                                      )),
                                  const SizedBox(
                                      width: Dimensions.PADDING_SIZE_SMALL),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                            TextHover(builder: (isHovered) {
                              return InkWell(
                                  onTap: () {
                                    Provider.of<ProductProvider>(context,
                                            listen: false)
                                        .offset = 1;
                                    Navigator.pushNamed(
                                        context, RouteHelper.menu);
                                  },
                                  child: Text(getTranslated('home', context)!,
                                      style: isHovered
                                          ? poppinsSemiBold.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)
                                          : poppinsMedium.copyWith(
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)));
                            }),
                            const SizedBox(width: 40),
                            TextHover(builder: (isHovered) {
                              return MouseRegion(
                                  onHover: (details) {
                                    if (Provider.of<CategoryProvider>(context,
                                                listen: false)
                                            .categoryList !=
                                        null) {
                                      _showPopupMenu(
                                          details.position, context, true);
                                    }
                                  },
                                  child: Text(
                                      getTranslated('categories', context)!,
                                      style: isHovered
                                          ? poppinsSemiBold.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)
                                          : poppinsMedium.copyWith(
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)));
                            }),
                            const SizedBox(width: 40),
                            TextHover(builder: (isHovered) {
                              return InkWell(
                                  onTap: () => Navigator.pushNamed(
                                      context, RouteHelper.favorite),
                                  child: SizedBox(
                                    width: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                      child: Text(
                                          getTranslated('favourite', context)!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: isHovered
                                              ? poppinsSemiBold.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)
                                              : poppinsMedium.copyWith(
                                                  color: ColorResources
                                                      .getTextColor(context),
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                    ),
                                  ));
                            }),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 400,
                              decoration: BoxDecoration(
                                color: ColorResources.getGreyColor(context),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.RADIUS_SIZE_DEFAULT),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 2),
                              child: Consumer<SearchProvider>(
                                  builder: (context, search, _) {
                                return CustomTextField(
                                  hintText: getTranslated(
                                      'search_items_here', context),
                                  isShowBorder: false,
                                  fillColor: Colors.transparent,
                                  isElevation: false,
                                  isShowSuffixIcon: true,
                                  suffixAssetUrl: !search.isSearch
                                      ? Images.close
                                      : Images.search,
                                  onChanged: (str) {
                                    str.length = 0;
                                    search.getSearchText(str);
                                    print(
                                        '===>${search.searchController.text.toString()}');
                                  },
                                  onSuffixTap: () {
                                    if (search
                                            .searchController.text.isNotEmpty &&
                                        search.isSearch == true) {
                                      Provider.of<SearchProvider>(context,
                                              listen: false)
                                          .saveSearchAddress(
                                              search.searchController.text);
                                      Provider.of<SearchProvider>(context,
                                              listen: false)
                                          .searchProduct(
                                              search.searchController.text,
                                              context);
                                      Navigator.pushNamed(
                                          context,
                                          RouteHelper.getSearchResultRoute(
                                              search.searchController.text),
                                          arguments: SearchResultScreen(
                                              searchString: search
                                                  .searchController.text));
                                      search.searchDone();
                                    } else if (search
                                            .searchController.text.isNotEmpty &&
                                        search.isSearch == false) {
                                      search.searchController.clear();
                                      search.getSearchText('');
                                      search.searchDone();
                                    }
                                  },
                                  controller: search.searchController,
                                  inputAction: TextInputAction.search,
                                  isIcon: true,
                                  onSubmit: (text) {
                                    if (search
                                        .searchController.text.isNotEmpty) {
                                      Provider.of<SearchProvider>(context,
                                              listen: false)
                                          .saveSearchAddress(
                                              search.searchController.text);
                                      Provider.of<SearchProvider>(context,
                                              listen: false)
                                          .searchProduct(
                                              search.searchController.text,
                                              context);
                                      Navigator.pushNamed(
                                          context,
                                          RouteHelper.getSearchResultRoute(
                                              search.searchController.text),
                                          arguments: SearchResultScreen(
                                              searchString: search
                                                  .searchController.text));

                                      search.searchDone();
                                    }
                                  },
                                );
                              }),
                            ),
                            const SizedBox(width: 40),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, RouteHelper.cart);
                              },
                              child: SizedBox(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Image.asset(
                                            Images.shopping_cart_bold,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    Positioned(
                                        top: -10,
                                        right: -10,
                                        child: int.parse(
                                                    Provider.of<CartProvider>(
                                                            context)
                                                        .cartList
                                                        .length
                                                        .toString()) <=
                                                0
                                            ? const SizedBox()
                                            : Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      ColorResources.RED_COLOR,
                                                ),
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                child: Text(
                                                    '${Provider.of<CartProvider>(context).cartList.length}',
                                                    style: poppinsRegular.copyWith(
                                                        color: Colors.white,
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_SMALL)),
                                              )),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                            IconButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, RouteHelper.profileMenus),
                                icon: Icon(Icons.menu,
                                    size: Dimensions.FONT_SIZE_OVER_LARGE,
                                    color: Theme.of(context).primaryColor)),
                            const SizedBox(width: Dimensions.PADDING_SIZE_SMALL)
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Size get preferredSize => const Size(double.maxFinite, 160);
}
