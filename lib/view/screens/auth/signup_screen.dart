import '../../../all_export.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController? _emailController;
  final FocusNode _emailFocus = FocusNode();
  bool email = true;
  bool phone = false;
  String? _countryDialCode = '+880';
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    // Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
    _countryDialCode = CountryCode.fromCountryCode(
            Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .country!)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : null,
      body: SafeArea(
        child: Scrollbar(
          child: Center(
            child: SingleChildScrollView(
              padding: ResponsiveHelper.isDesktop(context)
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: ResponsiveHelper.isDesktop(context)
                        ? MediaQuery.of(context).size.height - 560
                        : MediaQuery.of(context).size.height),
                child: Center(
                  child: Column(
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? const SizedBox(
                              height: 50,
                            )
                          : const SizedBox(),
                      Container(
                        width: size.width > 700 ? 700 : size.width,
                        padding: ResponsiveHelper.isDesktop(context)
                            ? const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 50)
                            : size.width > 700
                                ? const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT)
                                : null,
                        decoration: size.width > 700
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
                          builder: (context, authProvider, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 30),
                              FadeInDownBig(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      Images.app_logo,
                                      height: ResponsiveHelper.isDesktop(
                                              context)
                                          ? MediaQuery.of(context).size.height *
                                              0.15
                                          : MediaQuery.of(context).size.height /
                                              4.5,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              FadeInDownBig(
                                child: Center(
                                    child: Text(
                                  getTranslated('signup', context)!,
                                  style: poppinsMedium.copyWith(
                                      fontSize: 24,
                                      color:
                                          ColorResources.getTextColor(context)),
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
                                            color: ColorResources.getHintColor(
                                                context)),
                                      ),
                                    )
                                  : Text(
                                      getTranslated('mobile_number', context)!,
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
                                        inputAction: TextInputAction.done,
                                        inputType: TextInputType.emailAddress,
                                        controller: _emailController,
                                        focusNode: _emailFocus,
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
                                                .headline1!
                                                .color),
                                      ),
                                      Expanded(
                                          child: CustomTextField(
                                        hintText: getTranslated(
                                            'number_hint', context),
                                        isShowBorder: true,
                                        controller: _emailController,
                                        inputType: TextInputType.phone,
                                        inputAction: TextInputAction.done,
                                      )),
                                    ]),
                              const SizedBox(height: 6),
                              const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL),

                              const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_LARGE),
                                  child: Divider(height: 1)),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.verificationMessage!.isNotEmpty
                                      ? CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          radius: 5)
                                      : const SizedBox.shrink(),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.verificationMessage ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  )
                                ],
                              ),

                              // for continue button
                              const SizedBox(height: 12),
                              !authProvider
                                      .isPhoneNumberVerificationButtonLoading
                                  ? FadeInUpBig(
                                      child: CustomButton(
                                        buttonText:
                                            getTranslated('continue', context),
                                        onPressed: () {
                                          String email =
                                              _emailController!.text.trim();
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
                                              EmailChecker.isNotValid(email)) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'enter_valid_email',
                                                    context)!,
                                                context);
                                          } else {
                                            if (Provider.of<SplashProvider>(
                                                    context,
                                                    listen: false)
                                                .configModel!
                                                .emailVerification!) {
                                              authProvider
                                                  .checkEmail(email)
                                                  .then((value) async {
                                                if (value.isSuccess) {
                                                  authProvider
                                                      .updateEmail(email);
                                                  if (value.message ==
                                                      'active') {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      RouteHelper
                                                          .getVerifyRoute(
                                                              'sign-up', email),
                                                      arguments:
                                                          VerificationScreen(
                                                              emailAddress:
                                                                  email,
                                                              fromSignUp: true),
                                                    );
                                                  } else {
                                                    Navigator.of(context).pushNamed(
                                                        RouteHelper
                                                            .createAccount,
                                                        arguments:
                                                            CreateAccountScreen());
                                                  }
                                                }
                                              });
                                            } else {
                                              authProvider
                                                  .checkPhone(
                                                      _countryDialCode! + email)
                                                  .then((value) async {
                                                if (value.isSuccess) {
                                                  authProvider.updateEmail(
                                                      _countryDialCode! +
                                                          email);
                                                  if (value.message ==
                                                      'active') {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      RouteHelper.getVerifyRoute(
                                                          'sign-up',
                                                          _countryDialCode! +
                                                              email),
                                                      arguments: VerificationScreen(
                                                          emailAddress:
                                                              _countryDialCode! +
                                                                  email,
                                                          fromSignUp: true),
                                                    );
                                                  } else {
                                                    Navigator.of(context).pushNamed(
                                                        RouteHelper
                                                            .createAccount,
                                                        arguments:
                                                            CreateAccountScreen());
                                                  }
                                                }
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor))),

                              // for create an account
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FadeInUpBig(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated(
                                              'already_have_account', context)!,
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                        ),
                                        const SizedBox(
                                            width:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        Text(
                                          getTranslated('login', context)!,
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
                            ],
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
      ),
    );
  }
}
