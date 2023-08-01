import '../../all_export.dart';

class MenuBar extends StatelessWidget {
  const MenuBar({super.key});

  List<MenuItems> getMenus(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return [
      MenuItems(
          title: getTranslated('home', context),
          icon: Icons.home_filled,
          onTap: () => Navigator.pushNamed(context, RouteHelper.menu)),
      MenuItems(
        title: getTranslated('all_categories', context),
        icon: Icons.category,
        onTap: () => Navigator.pushNamed(context, RouteHelper.categorys),
      ),
      MenuItems(
        title: getTranslated('useful_links', context),
        icon: Icons.settings,
        children: [
          MenuItems(
            title: getTranslated('privacy_policy', context),
            onTap: () =>
                Navigator.pushNamed(context, RouteHelper.getPolicyRoute()),
          ),
          MenuItems(
            title: getTranslated('terms_and_condition', context),
            onTap: () =>
                Navigator.pushNamed(context, RouteHelper.getTermsRoute()),
          ),
          MenuItems(
            title: getTranslated('about_us', context),
            onTap: () =>
                Navigator.pushNamed(context, RouteHelper.getAboutUsRoute()),
          ),
        ],
      ),
      MenuItems(
        title: getTranslated('search', context),
        icon: Icons.search,
        onTap: () => Navigator.pushNamed(context, RouteHelper.searchProduct),
      ),
      MenuItems(
        title: getTranslated('menu', context),
        icon: Icons.menu,
        onTap: () => Navigator.pushNamed(context, RouteHelper.profileMenus),
      ),
      isLoggedIn
          ? MenuItems(
              title: getTranslated('profile', context),
              icon: Icons.person,
              onTap: () => Navigator.pushNamed(context, RouteHelper.profile),
            )
          : MenuItems(
              title: getTranslated('login', context),
              icon: Icons.lock,
              onTap: () => Navigator.pushNamed(context, RouteHelper.login),
            ),
      MenuItems(
        title: '',
        icon: Icons.shopping_cart,
        onTap: () => Navigator.pushNamed(context, RouteHelper.cart),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: PlutoMenuBar(
        backgroundColor: Theme.of(context).cardColor,
        gradient: false,
        goBackButtonText: 'Back',
        textStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        moreIconColor: Theme.of(context).textTheme.bodyLarge!.color,
        menuIconColor: Theme.of(context).textTheme.bodyLarge!.color,
        menus: getMenus(context),
      ),
    );
  }
}
