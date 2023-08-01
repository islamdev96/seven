import '../../all_export.dart';

class NoDataScreen extends StatelessWidget {
  final bool isOrder;
  final bool isCart;
  final bool isNothing;
  final bool isProfile;
  final bool isWeb;
  final bool isSearch;
  const NoDataScreen(
      {super.key,
      this.isCart = false,
      this.isNothing = false,
      this.isOrder = false,
      this.isProfile = false,
      this.isWeb = false,
      this.isSearch = false});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ResponsiveHelper.isDesktop(context)
        ? SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: height * 0.7,
                    width: double.infinity,
                    child: view(context, height)),
                !isSearch ? const FooterView() : const SizedBox(),
              ],
            ),
          )
        : view(context, height);
  }

  Widget view(BuildContext context, double height) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            isOrder
                ? Images.box
                : isCart
                    ? Images.shopping_cart
                    : Images.not_found,
            width: height * 0.17,
            height: height * 0.17,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: height * 0.03),
          Text(
            getTranslated(
                isOrder
                    ? 'no_order_history'
                    : isCart
                        ? 'empty_shopping_bag'
                        : isProfile
                            ? 'no_address_found'
                            : 'no_result_found',
                context)!,
            style: poppinsMedium.copyWith(
                color: Theme.of(context).primaryColor, fontSize: height * 0.02),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: height * 0.01),
          Text(
            isOrder
                ? getTranslated('buy_something_to_see', context)!
                : isCart
                    ? getTranslated('look_like_you_have_not_added', context)!
                    : '',
            style: poppinsRegular.copyWith(fontSize: height * 0.02),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: height * 0.01),
          SizedBox(
            height: 40,
            width: 150,
            child: CustomButton(
              buttonText: getTranslated('lets_shop', context),
              onPressed: () {
                Provider.of<SplashProvider>(context, listen: false)
                    .setPageIndex(0);
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MenuScreen()), (route) => false);
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteHelper.menu, (route) => false);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
