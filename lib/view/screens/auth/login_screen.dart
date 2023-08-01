import 'package:animate_do/animate_do.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:seven/helper/email_checker.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/helper/route_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/auth_provider.dart';
import 'package:seven/provider/splash_provider.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/images.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/base/custom_button.dart';
import 'package:seven/view/base/custom_snackbar.dart';
import 'package:seven/view/base/custom_text_field.dart';
import 'package:seven/view/base/footer_view.dart';
import 'package:seven/view/screens/auth/signup_screen.dart';
import 'package:seven/view/screens/auth/widget/code_picker_widget.dart';
import 'package:seven/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:seven/view/base/web_app_bar/web_app_bar.dart';
import 'package:seven/view/screens/menu/menu_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  bool email = true;
  bool phone = false;
  String? _countryDialCode = '+880';

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController!.text =
        Provider.of<AuthProvider>(context, listen: false).getUserNumber();
    _passwordController!.text =
        Provider.of<AuthProvider>(context, listen: false).getUserPassword();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .country!)
        .dialCode;
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : null,
      body: SafeArea(
        child: Scrollbar(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: ResponsiveHelper.isDesktop(context)
                      ? MediaQuery.of(context).size.height - 560
                      : MediaQuery.of(context).size.height),
              child: SingleChildScrollView(
                padding: ResponsiveHelper.isDesktop(context)
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ResponsiveHelper.isDesktop(context)
                        ? const SizedBox(
                            height: 30,
                          )
                        : const SizedBox(),
                    Center(
                      child: Container(
                        width: width > 700 ? 700 : width,
                        padding: ResponsiveHelper.isDesktop(context)
                            ? const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 50)
                            : width > 700
                                ? const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT)
                                : null,
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
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) => Form(
                            key: _formKeyLogin,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeInDownBig(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Image.asset(
                                        Images.app_logo,
                                        height:
                                            ResponsiveHelper.isDesktop(context)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4.5,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                                //SizedBox(height: 20),
                                FadeInDownBig(
                                  child: Center(
                                      child: Text(
                                    getTranslated('login', context)!,
                                    style: poppinsMedium.copyWith(
                                        fontSize: 24,
                                        color: ColorResources.getTextColor(
                                            context)),
                                  )),
                                ),
                                const SizedBox(height: 35),
                                Provider.of<SplashProvider>(context,
                                            listen: false)
                                        .configModel!
                                        .emailVerification!
                                    ? FadeInLeftBig(
                                        child: Text(
                                          getTranslated('email', context)!,
                                          style: poppinsRegular.copyWith(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                        ),
                                      )
                                    : Text(
                                        getTranslated(
                                            'mobile_number', context)!,
                                        style: poppinsRegular.copyWith(
                                            color: ColorResources.getHintColor(
                                                context)),
                                      ),
                                const SizedBox(
                                    height: Dimensions.PADDING_SIZE_SMALL),
                                Provider.of<SplashProvider>(context,
                                            listen: false)
                                        .configModel!
                                        .emailVerification!
                                    ? FadeInLeftBig(
                                        child: CustomTextField(
                                          hintText: getTranslated(
                                              'demo_gmail', context),
                                          isShowBorder: true,
                                          focusNode: _emailFocus,
                                          nextFocus: _passwordFocus,
                                          controller: _emailController,
                                          inputType: TextInputType.emailAddress,
                                        ),
                                      )
                                    : Row(children: [
                                        CodePickerWidget(
                                          onChanged: (CountryCode countryCode) {
                                            _countryDialCode =
                                                countryCode.dialCode;
                                          },
                                          initialSelection: _countryDialCode,
                                          favorite: [_countryDialCode],
                                          showDropDownButton: true,
                                          padding: EdgeInsets.zero,
                                          showFlagMain: true,
                                          textStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .color),
                                        ),
                                        Expanded(
                                            child: CustomTextField(
                                          hintText: getTranslated(
                                              'number_hint', context),
                                          isShowBorder: true,
                                          focusNode: _numberFocus,
                                          nextFocus: _passwordFocus,
                                          controller: _emailController,
                                          inputType: TextInputType.phone,
                                        )),
                                      ]),

                                const SizedBox(
                                    height: Dimensions.PADDING_SIZE_LARGE),
                                FadeInLeftBig(
                                  child: Text(
                                    getTranslated('password', context)!,
                                    style: poppinsRegular.copyWith(
                                        color: ColorResources.getHintColor(
                                            context)),
                                  ),
                                ),
                                const SizedBox(
                                    height: Dimensions.PADDING_SIZE_SMALL),
                                FadeInLeftBig(
                                  child: CustomTextField(
                                    hintText:
                                        getTranslated('password_hint', context),
                                    isShowBorder: true,
                                    isPassword: true,
                                    isShowSuffixIcon: true,
                                    focusNode: _passwordFocus,
                                    controller: _passwordController,
                                    inputAction: TextInputAction.done,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // for remember me section
                                FadeInRightBig(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          authProvider.toggleRememberMe();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 18,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                  color: authProvider
                                                          .isActiveRememberMe
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : ColorResources
                                                          .getCardBgColor(
                                                              context),
                                                  border: Border.all(
                                                      color: authProvider
                                                              .isActiveRememberMe
                                                          ? Colors.transparent
                                                          : Theme.of(context)
                                                              .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: authProvider
                                                        .isActiveRememberMe
                                                    ? const Icon(Icons.done,
                                                        color: Colors.white,
                                                        size: 17)
                                                    : const SizedBox.shrink(),
                                              ),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              Text(
                                                getTranslated(
                                                    'remember_me', context)!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_EXTRA_SMALL,
                                                        color: ColorResources
                                                            .getHintColor(
                                                                context)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              RouteHelper.forgetPassword,
                                              arguments:
                                                  ForgotPasswordScreen());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            getTranslated(
                                                'forgot_password', context)!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_SMALL,
                                                    color: ColorResources
                                                        .getHintColor(context)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    authProvider.loginErrorMessage!.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            radius: 5)
                                        : const SizedBox.shrink(),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authProvider.loginErrorMessage ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                      ),
                                    )
                                  ],
                                ),

                                // for login button
                                const SizedBox(height: 10),
                                !authProvider.isLoading
                                    ? FadeInUpBig(
                                        child: CustomButton(
                                          buttonText:
                                              getTranslated('login', context),
                                          onPressed: () async {
                                            String email =
                                                _emailController!.text.trim();
                                            if (!Provider.of<SplashProvider>(
                                                    context,
                                                    listen: false)
                                                .configModel!
                                                .emailVerification!) {
                                              email = _countryDialCode! +
                                                  _emailController!.text.trim();
                                            }
                                            String password =
                                                _passwordController!.text
                                                    .trim();
                                            if (email.isEmpty) {
                                              if (Provider.of<SplashProvider>(
                                                      context,
                                                      listen: false)
                                                  .configModel!
                                                  .emailVerification!) {
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'enter_email_address',
                                                        context)!,
                                                    context);
                                              } else {
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'enter_phone_number',
                                                        context)!,
                                                    context);
                                              }
                                            } else if (Provider.of<
                                                            SplashProvider>(
                                                        context,
                                                        listen: false)
                                                    .configModel!
                                                    .emailVerification! &&
                                                EmailChecker.isNotValid(
                                                    email)) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_valid_email',
                                                      context)!,
                                                  context);
                                            } else if (password.isEmpty) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_password',
                                                      context)!,
                                                  context);
                                            } else if (password.length < 6) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'password_should_be',
                                                      context)!,
                                                  context);
                                            } else {
                                              authProvider
                                                  .login(email, password)
                                                  .then((status) async {
                                                if (status.isSuccess) {
                                                  if (authProvider
                                                      .isActiveRememberMe) {
                                                    authProvider
                                                        .saveUserNumberAndPassword(
                                                            _emailController!
                                                                .text,
                                                            password);
                                                  } else {
                                                    authProvider
                                                        .clearUserNumberAndPassword();
                                                  }
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          RouteHelper.menu,
                                                          (route) => false,
                                                          arguments:
                                                              MenuScreen());
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
                                                Theme.of(context).primaryColor),
                                      )),

                                // for create an account
                                const SizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        RouteHelper.signUp,
                                        arguments: SignUpScreen());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FadeInUpBig(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getTranslated(
                                                'create_an_account', context)!,
                                            style: poppinsRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL,
                                                color:
                                                    ColorResources.getHintColor(
                                                        context)),
                                          ),
                                          const SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          Text(
                                            getTranslated('signup', context)!,
                                            style: poppinsMedium.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL,
                                                color:
                                                    ColorResources.getTextColor(
                                                        context)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                FadeInUpBig(
                                    child: Center(
                                        child: Text(
                                            getTranslated('OR', context)!,
                                            style: poppinsRegular.copyWith(
                                                fontSize: 12)))),

                                FadeInUpBig(
                                  child: Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        minimumSize: const Size(1, 40),
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, RouteHelper.menu,
                                            arguments: MenuScreen());
                                      },
                                      child: RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                '${getTranslated('login_as_a', context)} ',
                                            style: poppinsRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL,
                                                color:
                                                    ColorResources.getHintColor(
                                                        context))),
                                        TextSpan(
                                            text:
                                                getTranslated('guest', context),
                                            style: poppinsRegular.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color)),
                                      ])),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ResponsiveHelper.isDesktop(context)
                        ? const SizedBox(
                            height: 50,
                          )
                        : const SizedBox(),
                    ResponsiveHelper.isDesktop(context)
                        ? const FooterView()
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
