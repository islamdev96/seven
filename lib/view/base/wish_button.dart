import '../../all_export.dart';

class WishButton extends StatelessWidget {
  final Product? product;
  final EdgeInsetsGeometry edgeInset;
  const WishButton(
      {Key? key, required this.product, this.edgeInset = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishListProvider>(builder: (context, wishList, child) {
      return InkWell(
        onTap: () {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            List<int?> productIdList = [];
            productIdList.add(product!.id);

            wishList.wishIdList.contains(product!.id)
                ? wishList.removeFromWishList(product!, context)
                : wishList.addToWishList(product!, context);
          } else {
            showCustomSnackBar(
                getTranslated('now_you_are_in_guest_mode', context)!, context);
          }
        },
        child: Padding(
          padding: edgeInset,
          child: Icon(
              wishList.wishIdList.contains(product!.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: wishList.wishIdList.contains(product!.id)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor),
        ),
      );
    });
  }
}
