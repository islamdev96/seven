// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:seven/data/model/response/response_model.dart';
import 'package:seven/data/model/response/userinfo_model.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/auth_provider.dart';
import 'package:seven/provider/profile_provider.dart';
import 'package:seven/provider/splash_provider.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/images.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/base/custom_snackbar.dart';
import 'package:seven/view/base/custom_text_field.dart';
import 'package:seven/view/base/web_app_bar/web_app_bar.dart';
import 'package:seven/view/screens/profile/web/profile_screen_web.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserInfoModel? userInfoModel;

  const ProfileEditScreen({super.key, this.userInfoModel});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;

  FocusNode? firstNameFocus;
  FocusNode? lastNameFocus;
  FocusNode? emailFocus;
  FocusNode? phoneFocus;
  FocusNode? passwordFocus;
  FocusNode? confirmPasswordFocus;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    firstNameFocus = FocusNode();
    lastNameFocus = FocusNode();
    emailFocus = FocusNode();
    phoneFocus = FocusNode();
    passwordFocus = FocusNode();
    confirmPasswordFocus = FocusNode();

    _firstNameController!.text = widget.userInfoModel!.fName ?? '';
    _lastNameController!.text = widget.userInfoModel!.lName ?? '';
    _emailController!.text = widget.userInfoModel!.email ?? '';
    _phoneController!.text = widget.userInfoModel!.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : AppBar(
              backgroundColor: Theme.of(context).cardColor,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Provider.of<SplashProvider>(context, listen: false)
                        .setPageIndex(0);
                    Navigator.of(context).pop();
                  }),
              title: Text(getTranslated('update_profile', context) ?? '',
                  style: poppinsMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  )),
            ),
      body: ResponsiveHelper.isDesktop(context)
          ? Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
              return ProfileScreenWeb(
                file: profileProvider.data,
                pickImage: profileProvider.pickImage,
                confirmPasswordController: _confirmPasswordController,
                confirmPasswordFocus: confirmPasswordFocus,
                emailController: _emailController,
                firstNameController: _firstNameController,
                firstNameFocus: firstNameFocus,
                lastNameController: _lastNameController,
                lastNameFocus: lastNameFocus,
                emailFocus: emailFocus,
                passwordController: _passwordController,
                passwordFocus: passwordFocus,
                phoneNumberController: _phoneController,
                phoneNumberFocus: phoneFocus,
                image: widget.userInfoModel!.image,
              );
            })
          : SafeArea(
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) => Scrollbar(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // for profile image
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 25, bottom: 24),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorResources.getGreyColor(context),
                                    width: 3),
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (ResponsiveHelper.isMobilePhone()) {
                                    profileProvider.choosePhoto();
                                  } else {
                                    profileProvider.pickImage();
                                  }
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: profileProvider.file != null
                                          ? Image.file(profileProvider.file!,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.fill)
                                          : profileProvider.data != null
                                              ? Image.network(
                                                  profileProvider.data!.path,
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.fill)
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        Images.placeholder(
                                                            context),
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                    image:
                                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}'
                                                        '/${profileProvider.userInfoModel!.image}',
                                                    imageErrorBuilder: (c, o,
                                                            s) =>
                                                        Image.asset(
                                                            Images.placeholder(
                                                                context),
                                                            height: 80,
                                                            width: 80,
                                                            fit: BoxFit.cover),
                                                  ),
                                                ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      right: 0,
                                      child: Image.asset(
                                        Images.camera,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            //mobileNumber,email,gender
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // for first name section
                                Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            getTranslated(
                                                'first_name', context)!,
                                            style: poppinsRegular.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'enter_first_name', context),
                                          isElevation: false,
                                          isPadding: false,
                                          controller: _firstNameController,
                                          focusNode: firstNameFocus,
                                          nextFocus: lastNameFocus,
                                        ),
                                      ],
                                    ),
                                    const Positioned(
                                        bottom: 0,
                                        left: 20,
                                        right: 20,
                                        child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // for Last name section
                                Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            getTranslated(
                                                'last_name', context)!,
                                            style: poppinsRegular.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'enter_last_name', context),
                                          isElevation: false,
                                          isPadding: false,
                                          controller: _lastNameController,
                                          focusNode: lastNameFocus,
                                          nextFocus: emailFocus,
                                        ),
                                      ],
                                    ),
                                    const Positioned(
                                        bottom: 0,
                                        left: 20,
                                        right: 20,
                                        child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                // for email section
                                Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            getTranslated('email', context)!,
                                            style: poppinsRegular.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'enter_email_address', context),
                                          isElevation: false,
                                          isPadding: false,
                                          isEnabled: false,
                                          controller: _emailController,
                                          focusNode: emailFocus,
                                          nextFocus: phoneFocus,
                                          inputType: TextInputType.emailAddress,
                                        ),
                                      ],
                                    ),
                                    const Positioned(
                                        bottom: 0,
                                        left: 20,
                                        right: 20,
                                        child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                // for Phone Number section
                                Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            getTranslated(
                                                    'phone_number', context) ??
                                                '',
                                            style: poppinsRegular.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'enter_phone_number', context),
                                          isElevation: false,
                                          isPadding: false,
                                          controller: _phoneController,
                                          focusNode: phoneFocus,
                                          nextFocus: passwordFocus,
                                          inputType: TextInputType.phone,
                                        ),
                                      ],
                                    ),
                                    const Positioned(
                                        bottom: 0,
                                        left: 20,
                                        right: 20,
                                        child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            getTranslated(
                                                    'password', context) ??
                                                '',
                                            style: poppinsRegular.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'password_hint', context),
                                          isElevation: false,
                                          isPadding: false,
                                          isPassword: true,
                                          isShowSuffixIcon: true,
                                          controller: _passwordController,
                                          focusNode: passwordFocus,
                                          nextFocus: confirmPasswordFocus,
                                        ),
                                      ],
                                    ),
                                    const Positioned(
                                        bottom: 0,
                                        left: 20,
                                        right: 20,
                                        child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            getTranslated('confirm_password',
                                                    context) ??
                                                '',
                                            style: poppinsRegular.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'password_hint', context),
                                          isElevation: false,
                                          isPadding: false,
                                          isPassword: true,
                                          isShowSuffixIcon: true,
                                          controller:
                                              _confirmPasswordController,
                                          focusNode: confirmPasswordFocus,
                                          inputAction: TextInputAction.done,
                                        ),
                                      ],
                                    ),
                                    const Positioned(
                                        bottom: 0,
                                        left: 20,
                                        right: 20,
                                        child: Divider()),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 50),
                            !profileProvider.isLoading
                                ? TextButton(
                                    onPressed: () async {
                                      String firstName =
                                          _firstNameController!.text.trim();
                                      String lastName =
                                          _lastNameController!.text.trim();
                                      String phoneNumber =
                                          _phoneController!.text.trim();
                                      String password =
                                          _passwordController!.text.trim();
                                      String confirmPassword =
                                          _confirmPasswordController!.text
                                              .trim();
                                      if (profileProvider
                                                  .userInfoModel!.fName ==
                                              firstName &&
                                          profileProvider
                                                  .userInfoModel!.lName ==
                                              lastName &&
                                          profileProvider
                                                  .userInfoModel!.phone ==
                                              phoneNumber &&
                                          profileProvider
                                                  .userInfoModel!.email ==
                                              _emailController!.text &&
                                          profileProvider.file == null &&
                                          profileProvider.data == null &&
                                          password.isEmpty &&
                                          confirmPassword.isEmpty) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'change_something_to_update',
                                                context)!,
                                            context);
                                      } else if (firstName.isEmpty) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'enter_first_name', context)!,
                                            context);
                                      } else if (lastName.isEmpty) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'enter_last_name', context)!,
                                            context);
                                      } else if (phoneNumber.isEmpty) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'enter_phone_number', context)!,
                                            context);
                                      } else if ((password.isNotEmpty &&
                                              password.length < 6) ||
                                          (confirmPassword.isNotEmpty &&
                                              confirmPassword.length < 6)) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'password_should_be', context)!,
                                            context);
                                      } else if (password != confirmPassword) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'password_did_not_match',
                                                context)!,
                                            context);
                                      } else {
                                        UserInfoModel updateUserInfoModel =
                                            profileProvider.userInfoModel!;
                                        updateUserInfoModel.fName =
                                            _firstNameController!.text ?? "";
                                        updateUserInfoModel.lName =
                                            _lastNameController!.text ?? "";
                                        updateUserInfoModel.phone =
                                            _phoneController!.text ?? '';

                                        ResponseModel responseModel =
                                            await profileProvider
                                                .updateUserInfo(
                                          updateUserInfoModel,
                                          password,
                                          profileProvider.file,
                                          profileProvider.data,
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .getUserToken(),
                                        );
                                        if (responseModel.isSuccess) {
                                          profileProvider.getUserInfo(context);
                                          _passwordController!.text = '';
                                          _confirmPasswordController!.text = '';
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'updated_successfully',
                                                  context)!,
                                              context,
                                              isError: false);
                                        } else {
                                          showCustomSnackBar(
                                              responseModel.message!, context,
                                              isError: true);
                                        }
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          getTranslated('save', context)!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Theme.of(context).primaryColor))),
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
