import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/auth_provider.dart';
import 'package:seven/provider/cart_provider.dart';
import 'package:seven/provider/splash_provider.dart';
import 'package:seven/helper/route_helper.dart';
import 'package:seven/utill/app_constants.dart';
import 'package:seven/utill/images.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/screens/menu/menu_screen.dart';
import 'package:seven/view/screens/onboarding/on_boarding_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        print('-----------------${isNotConnected ? 'Not' : 'Yes'}');
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', context)!
                : getTranslated('connected', context)!,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    _route();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        if (Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .maintenanceMode!) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteHelper.getMaintenanceRoute(), (route) => false);
        } else {
          Timer(const Duration(seconds: 1), () async {
            double minimumVersion = 0.0;
            if (Platform.isAndroid) {
              if (Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .playStoreConfig!
                      .minVersion !=
                  null) {
                minimumVersion =
                    Provider.of<SplashProvider>(context, listen: false)
                            .configModel!
                            .playStoreConfig!
                            .minVersion ??
                        6.0;
              }
            } else if (Platform.isIOS) {
              if (Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .appStoreConfig!
                      .minVersion !=
                  null) {
                minimumVersion =
                    Provider.of<SplashProvider>(context, listen: false)
                            .configModel!
                            .appStoreConfig!
                            .minVersion ??
                        6.0;
              }
            }
            if (AppConstants.APP_VERSION < minimumVersion &&
                !ResponsiveHelper.isWeb()) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteHelper.getUpdateRoute(), (route) => false);
            } else {
              if (Provider.of<AuthProvider>(context, listen: false)
                  .isLoggedIn()) {
                Provider.of<AuthProvider>(context, listen: false).updateToken();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteHelper.menu, (route) => false,
                    arguments: MenuScreen());
              } else {
                print(
                    '===intro=>${Provider.of<SplashProvider>(context, listen: false).showIntro()}');
                if (Provider.of<SplashProvider>(context, listen: false)
                    .showIntro()) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteHelper.onBoarding, (route) => false,
                      arguments: OnBoardingScreen());
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteHelper.menu, (route) => false,
                      arguments: MenuScreen());
                }
                // Navigator.pushNamedAndRemoveUntil(context, RouteHelper.onBoarding, (route) => false, arguments: OnBoardingScreen());
              }
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _globalKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            Images.app_logo,
            width: 170,
            height: 170,
          ),
          const SizedBox(height: 30),
          Text(AppConstants.APP_NAME,
              textAlign: TextAlign.center,
              style: poppinsMedium.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 50,
              )),
        ],
      ),
    );
  }
}
