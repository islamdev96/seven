import '../../all_export.dart';

class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const AppBarBase({Key? key, this.title = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      title: Text(title!,
          style: poppinsMedium.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color)),
      backgroundColor: Theme.of(context).cardColor,
      actions: [
        IconButton(
            icon: Stack(clipBehavior: Clip.none, children: [
              Image.asset(Images.cart_icon,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  width: 25),
              Positioned(
                top: -7,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor),
                  child: Text(
                      '${Provider.of<CartProvider>(context).cartList.length}',
                      style: TextStyle(
                          color: Theme.of(context).cardColor, fontSize: 10)),
                ),
              ),
            ]),
            onPressed: () {
              Navigator.pushNamed(context, RouteHelper.cart);
            }),
        IconButton(
            icon: Icon(Icons.search,
                size: 30, color: Theme.of(context).textTheme.bodyLarge!.color),
            onPressed: () {
              Navigator.pushNamed(context, RouteHelper.searchProduct);
              // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchScreen()));
            }),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.maxFinite, 50);
}
