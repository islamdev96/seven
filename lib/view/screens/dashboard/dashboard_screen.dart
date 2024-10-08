import 'package:flutter/material.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/utill/images.dart';
import 'package:seven/view/screens/address/address_screen.dart';
import 'package:seven/view/screens/cart/cart_screen.dart';
import 'package:seven/view/screens/category/all_category_screen.dart';
import 'package:seven/view/screens/chat/chat_screen.dart';
import 'package:seven/view/screens/coupon/coupon_screen.dart';
import 'package:seven/view/screens/home/home_screens.dart';
import 'package:seven/view/screens/order/my_order_screen.dart';
import 'package:seven/view/screens/settings/setting_screen.dart';
import 'package:seven/view/screens/wishlist/wishlist_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(),
      AllCategoryScreen(),
      CartScreen(),
      WishListScreen(),
      MyOrderScreen(),
      AddressScreen(),
      CouponScreen(),
      ChatScreen(orderModel: null),
      SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            _barItem(Images.home, getTranslated('home', context), 0),
            _barItem(Images.list, getTranslated('all_categories', context), 1),
            _barItem(
                Images.order_bag, getTranslated('shopping_bag', context), 2),
            _barItem(Images.order_bag, getTranslated('favourite', context), 3),
            _barItem(Images.order_list, getTranslated('my_order', context), 4),
            _barItem(Images.location, getTranslated('address', context), 5),
            _barItem(Images.coupon, getTranslated('coupon', context), 6),
            _barItem(Images.chat, getTranslated('live_chat', context), 7),
            _barItem(Images.settings, getTranslated('settings', context), 8),
          ],
          onTap: (int index) {
            _setPage(index);
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Image.asset(icon,
          color: index == _pageIndex
              ? Theme.of(context).primaryColor
              : Colors.grey,
          width: 25),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
