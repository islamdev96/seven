import 'package:flutter/material.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/helper/route_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/auth_provider.dart';
import 'package:seven/provider/splash_provider.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/images.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/base/custom_app_bar.dart';
import 'package:seven/view/base/custom_button.dart';
import 'package:seven/view/base/custom_snackbar.dart';
import 'package:seven/view/screens/auth/create_account_screen.dart';
import 'package:seven/view/screens/forgot_password/create_new_password_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../base/footer_view.dart';
import '../../base/web_app_bar/web_app_bar.dart';

class VerificationScreen extends StatelessWidget {
  final String? emailAddress;
  final bool fromSignUp;
  const VerificationScreen(
      {super.key, required this.emailAddress, this.fromSignUp = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.getCardBgColor(context),
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(120), child: WebAppBar())
              : CustomAppBar(title: getTranslated('verify_email', context)))
          as PreferredSizeWidget?,
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: ResponsiveHelper.isDesktop(context)
                            ? MediaQuery.of(context).size.height - 560
                            : MediaQuery.of(context).size.height),
                    child: SizedBox(
                      width: 1170,
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => Container(
                          margin: EdgeInsets.only(
                              top: width > 700 ? 55 : 0,
                              bottom: width > 700 ? 55 : 0),
                          decoration: width > 700
                              ? BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[300]!,
                                        blurRadius: 5,
                                        spreadRadius: 1)
                                  ],
                                )
                              : null,
                          child: Column(
                            children: [
                              const SizedBox(height: 55),
                              Image.asset(Images.email_with_background,
                                  width: 142,
                                  height: 142,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(height: 40),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Center(
                                    child: Text(
                                  '${getTranslated('please_enter_4_digit_code', context)}\n ${emailAddress!.trim()}',
                                  textAlign: TextAlign.center,
                                  style: poppinsRegular.copyWith(
                                      color:
                                          ColorResources.getHintColor(context)),
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width > 850 ? 300 : 39,
                                    vertical: 35),
                                child: PinCodeTextField(
                                  length: 4,
                                  appContext: context,
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    fieldHeight: 63,
                                    fieldWidth: 55,
                                    borderWidth: 1,
                                    borderRadius: BorderRadius.circular(10),
                                    selectedColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.2),
                                    selectedFillColor: Colors.white,
                                    inactiveFillColor:
                                        ColorResources.getCardBgColor(context),
                                    inactiveColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.2),
                                    activeColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.4),
                                    activeFillColor:
                                        ColorResources.getCardBgColor(context),
                                  ),
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  backgroundColor: Colors.transparent,
                                  enableActiveFill: true,
                                  onChanged:
                                      authProvider.updateVerificationCode,
                                  beforeTextPaste: (text) {
                                    return true;
                                  },
                                ),
                              ),
                              Center(
                                  child: Text(
                                getTranslated(
                                    'i_didnt_receive_the_code', context)!,
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.getHintColor(context),
                                ),
                              )),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    if (fromSignUp) {
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .checkEmail(emailAddress)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          showCustomSnackBar(
                                              'Resent code successful', context,
                                              isError: false);
                                        } else {
                                          showCustomSnackBar(
                                              value.message!, context);
                                        }
                                      });
                                    } else {
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .forgetPassword(emailAddress)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          showCustomSnackBar(
                                              'Resent code successful', context,
                                              isError: false);
                                        } else {
                                          showCustomSnackBar(
                                              value.message!, context);
                                        }
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    child: Text(
                                      getTranslated('resend_code', context)!,
                                      style: poppinsMedium.copyWith(
                                        color: ColorResources.getTextColor(
                                            context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 48),
                              authProvider.isEnableVerificationCode
                                  ? !authProvider
                                          .isPhoneNumberVerificationButtonLoading
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                          child: CustomButton(
                                            buttonText: getTranslated(
                                                'verify', context),
                                            onPressed: () {
                                              if (fromSignUp) {
                                                if (Provider.of<SplashProvider>(
                                                        context,
                                                        listen: false)
                                                    .configModel!
                                                    .phoneVerification!) {
                                                  Provider.of<AuthProvider>(
                                                          context,
                                                          listen: false)
                                                      .verifyPhone(
                                                          emailAddress!.trim())
                                                      .then((value) {
                                                    if (value.isSuccess) {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              RouteHelper
                                                                  .createAccount,
                                                              arguments:
                                                                  CreateAccountScreen());
                                                    } else {
                                                      showCustomSnackBar(
                                                          value.message!,
                                                          context);
                                                    }
                                                  });
                                                } else {
                                                  Provider.of<AuthProvider>(
                                                          context,
                                                          listen: false)
                                                      .verifyEmail(emailAddress)
                                                      .then((value) {
                                                    if (value.isSuccess) {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              RouteHelper
                                                                  .createAccount,
                                                              arguments:
                                                                  CreateAccountScreen());
                                                    } else {
                                                      showCustomSnackBar(
                                                          value.message!,
                                                          context);
                                                    }
                                                  });
                                                }
                                              } else {
                                                String? mail =
                                                    Provider.of<SplashProvider>(
                                                                context,
                                                                listen: false)
                                                            .configModel!
                                                            .phoneVerification!
                                                        ? emailAddress!.trim()
                                                        : emailAddress;
                                                Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false)
                                                    .verifyToken(mail)
                                                    .then((value) {
                                                  if (value.isSuccess) {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      RouteHelper.getNewPassRoute(
                                                          mail,
                                                          authProvider
                                                              .verificationCode),
                                                      arguments:
                                                          CreateNewPasswordScreen(
                                                              email: mail,
                                                              resetToken:
                                                                  authProvider
                                                                      .verificationCode),
                                                    );
                                                  } else {
                                                    showCustomSnackBar(
                                                        value.message!,
                                                        context);
                                                  }
                                                });
                                              }
                                            },
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Theme.of(context)
                                                          .primaryColor)))
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 48),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ResponsiveHelper.isDesktop(context)
                      ? const FooterView()
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
