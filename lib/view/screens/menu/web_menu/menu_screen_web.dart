import 'package:flutter/material.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/helper/route_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/auth_provider.dart';
import 'package:seven/provider/profile_provider.dart';
import 'package:seven/provider/splash_provider.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/images.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/base/footer_view.dart';
import 'package:seven/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:seven/view/screens/notification/notification_screen.dart';
import 'package:provider/provider.dart';

import '../../../base/custom_dialog.dart';
import '../widget/acount_delete_dialog.dart';
import 'menu_item_web.dart';

class MenuScreenWeb extends StatelessWidget {
  final bool isLoggedIn;
  const MenuScreenWeb({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: ResponsiveHelper.isDesktop(context)
                        ? MediaQuery.of(context).size.height - 400
                        : MediaQuery.of(context).size.height),
                child: SizedBox(
                  width: 1170,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 150,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 240.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isLoggedIn
                                    ? profileProvider.userInfoModel != null
                                        ? Text(
                                            '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                                            style: poppinsRegular.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_EXTRA_LARGE,
                                                color:
                                                    ColorResources.getTextColor(
                                                        context)),
                                          )
                                        : SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                            width: 150)
                                    : Text(
                                        getTranslated('guest', context)!,
                                        style: poppinsRegular.copyWith(
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_LARGE,
                                            color: ColorResources.getTextColor(
                                                context)),
                                      ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                isLoggedIn
                                    ? profileProvider.userInfoModel != null
                                        ? Text(
                                            '${profileProvider.userInfoModel!.email ?? ''}',
                                            style: poppinsRegular.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context)),
                                          )
                                        : SizedBox(height: 15, width: 100)
                                    : Text(
                                        'demo@demo.com',
                                        style: poppinsRegular.copyWith(
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_LARGE,
                                            color: ColorResources.getTextColor(
                                                context)),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(height: 100),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  MenuItemWeb(
                                      image: Images.order_list,
                                      title: getTranslated('my_order', context),
                                      onTap: () => Navigator.pushNamed(
                                          context, RouteHelper.myOrder)),
                                  MenuItemWeb(
                                    image: Images.profile,
                                    title: getTranslated('profile', context),
                                    onTap: () {
                                      isLoggedIn
                                          ? Navigator.pushNamed(
                                              context,
                                              RouteHelper.getProfileEditRoute(
                                                  profileProvider
                                                      .userInfoModel!.fName!,
                                                  profileProvider
                                                      .userInfoModel!.lName!,
                                                  profileProvider
                                                      .userInfoModel!.email!,
                                                  profileProvider
                                                      .userInfoModel!.phone!,
                                                  profileProvider.userInfoModel!
                                                          .image ??
                                                      ''),
                                              // arguments: ProfileEditScreen(userInfoModel: profileProvider.userInfoModel),
                                            )
                                          : Navigator.pushNamed(context,
                                              RouteHelper.getLoginRoute());
                                    },
                                  ),
                                  MenuItemWeb(
                                      image: Images.location,
                                      title: getTranslated('address', context),
                                      onTap: () => Navigator.pushNamed(
                                          context, RouteHelper.address)),
                                  MenuItemWeb(
                                      image: Images.chat,
                                      title:
                                          getTranslated('live_chat', context),
                                      onTap: () => Navigator.pushNamed(
                                          context,
                                          RouteHelper.getChatRoute(
                                              orderModel: null))),
                                  MenuItemWeb(
                                      image: Images.coupon,
                                      title: getTranslated('coupon', context),
                                      onTap: () => Navigator.pushNamed(
                                          context, RouteHelper.coupon)),
                                  MenuItemWeb(
                                      image: Images.notification,
                                      title: getTranslated(
                                          'notifications', context),
                                      onTap: () => Navigator.pushNamed(
                                          context, RouteHelper.notification,
                                          arguments: NotificationScreen())),
                                ],
                              ),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  MenuItemWeb(
                                      image: Images.language,
                                      title:
                                          getTranslated('contact_us', context),
                                      onTap: () => Navigator.pushNamed(context,
                                          RouteHelper.getContactRoute())),
                                  MenuItemWeb(
                                      image: Images.order_bag,
                                      title: getTranslated(
                                          'shopping_bag', context),
                                      onTap: () => Navigator.pushNamed(
                                          context, RouteHelper.cart)),
                                  MenuItemWeb(
                                      image: Images.privacy_policy,
                                      title: getTranslated(
                                          'privacy_policy', context),
                                      onTap: () => Navigator.pushNamed(context,
                                          RouteHelper.getPolicyRoute())),
                                  MenuItemWeb(
                                      image: Images.terms_and_conditions,
                                      title: getTranslated(
                                          'terms_and_condition', context),
                                      onTap: () => Navigator.pushNamed(context,
                                          RouteHelper.getTermsRoute())),
                                  MenuItemWeb(
                                      image: Images.about_us,
                                      title: getTranslated('about_us', context),
                                      onTap: () => Navigator.pushNamed(context,
                                          RouteHelper.getAboutUsRoute())),
                                  MenuItemWeb(
                                    image: Images.login,
                                    title: getTranslated(
                                        isLoggedIn ? 'log_out' : 'login',
                                        context),
                                    onTap: () {
                                      if (isLoggedIn) {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                SignOutConfirmationDialog());
                                      } else {
                                        Provider.of<SplashProvider>(context,
                                                listen: false)
                                            .setPageIndex(0);
                                        Navigator.pushNamed(context,
                                            RouteHelper.getLoginRoute());
                                      }
                                    },
                                    /* onTap: () => isLoggedIn ? showDialog(context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog()) : Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
                                            Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getLoginRoute(), (route) => false);,*/
                                  ),
                                ],
                              ),
                              SizedBox(height: 50.0)
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        left: 30,
                        top: 45,
                        child: Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 22,
                                    offset: Offset(0, 8.8))
                              ]),
                          child: ClipOval(
                            child: isLoggedIn
                                ? FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder(context),
                                    height: 170,
                                    width: 170,
                                    fit: BoxFit.cover,
                                    image:
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/'
                                        '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                                    imageErrorBuilder: (c, o, s) => Image.asset(
                                        Images.placeholder(context),
                                        height: 170,
                                        width: 170,
                                        fit: BoxFit.cover),
                                  )
                                : Image.asset(Images.placeholder(context),
                                    height: 170, width: 170, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 140,
                        child: _isLoggedIn
                            ? Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT),
                                child: InkWell(
                                  onTap: () {
                                    showAnimatedDialog(
                                        context,
                                        AccountDeleteDialog(
                                          icon: Icons.question_mark_sharp,
                                          title: getTranslated(
                                              'are_you_sure_to_delete_account',
                                              context),
                                          description: getTranslated(
                                              'it_will_remove_your_all_information',
                                              context),
                                          onTapFalseText:
                                              getTranslated('no', context),
                                          onTapTrueText:
                                              getTranslated('yes', context),
                                          isFailed: true,
                                          onTapFalse: () =>
                                              Navigator.of(context).pop(),
                                          onTapTrue: () =>
                                              Provider.of<AuthProvider>(context,
                                                      listen: false)
                                                  .deleteUser(context),
                                        ),
                                        dismissible: false,
                                        isFlip: true);
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        child: Icon(Icons.delete,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 16),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        child: Text(getTranslated(
                                            'delete_account', context)!),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
          FooterView(),
        ],
      ),
    );
  }
}
