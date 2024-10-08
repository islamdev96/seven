import 'package:flutter/material.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/helper/route_helper.dart';
import 'package:seven/provider/auth_provider.dart';
import 'package:seven/provider/splash_provider.dart';
import 'package:seven/provider/theme_provider.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/screens/menu/widget/custom_drawer.dart';
import 'package:provider/provider.dart';

class MenuButton extends StatelessWidget {
  final CustomDrawerController? drawerController;
  final int index;
  final String? icon;
  final String? title;
  final IconData? iconData;
  MenuButton(
      {required this.drawerController,
      required this.index,
      required this.icon,
      required this.title,
      this.iconData = null});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        return ListTile(
          onTap: () {
            ResponsiveHelper.isMobilePhone()
                ? splash.setPageIndex(index)
                : SizedBox();
            if (ResponsiveHelper.isWeb() && index == 0) {
              Navigator.pushNamed(context, RouteHelper.menu);
            } else if (ResponsiveHelper.isWeb() && index == 1) {
              Navigator.pushNamed(context, RouteHelper.categorys);
            } else if (ResponsiveHelper.isWeb() && index == 2) {
              Navigator.pushNamed(context, RouteHelper.cart);
            } else if (ResponsiveHelper.isWeb() && index == 3) {
              Navigator.pushNamed(context, RouteHelper.favorite);
            } else if (ResponsiveHelper.isWeb() && index == 4) {
              Navigator.pushNamed(context, RouteHelper.myOrder);
            } else if (ResponsiveHelper.isWeb() && index == 5) {
              Navigator.pushNamed(context, RouteHelper.address);
            } else if (ResponsiveHelper.isWeb() && index == 6) {
              Navigator.pushNamed(context, RouteHelper.coupon);
            } else if (ResponsiveHelper.isWeb() && index == 7) {
              Navigator.pushNamed(
                  context, RouteHelper.getChatRoute(orderModel: null));
            } else if (ResponsiveHelper.isWeb() && index == 8) {
              Navigator.pushNamed(context, RouteHelper.settings);
            } else if (ResponsiveHelper.isWeb() && index == 9) {
              Navigator.pushNamed(context, RouteHelper.getTermsRoute());
            } else if (ResponsiveHelper.isWeb() && index == 10) {
              Navigator.pushNamed(context, RouteHelper.getPolicyRoute());
            } else if (ResponsiveHelper.isWeb() && index == 11) {
              Navigator.pushNamed(context, RouteHelper.getAboutUsRoute());
            } else if (ResponsiveHelper.isWeb() && index == 12) {
              Provider.of<AuthProvider>(context, listen: false)
                  .deleteUser(context);
            }
            drawerController!.toggle();
          },
          selected: splash.pageIndex == index,
          selectedTileColor: Colors.black.withAlpha(30),
          leading: iconData != null
              ? Icon(iconData, size: 25, color: Theme.of(context).cardColor)
              : Image.asset(
                  icon!,
                  color: Provider.of<ThemeProvider>(context).darkTheme
                      ? ColorResources.getTextColor(context)
                      : ResponsiveHelper.isDesktop(context)
                          ? ColorResources.getDarkColor(context)
                          : ColorResources.getBackgroundColor(context),
                  width: 25,
                  height: 25,
                ),
          title: Text(title!,
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE,
                color: Provider.of<ThemeProvider>(context).darkTheme
                    ? ColorResources.getTextColor(context)
                    : ResponsiveHelper.isDesktop(context)
                        ? ColorResources.getDarkColor(context)
                        : ColorResources.getBackgroundColor(context),
              )),
        );
      },
    );
  }
}
