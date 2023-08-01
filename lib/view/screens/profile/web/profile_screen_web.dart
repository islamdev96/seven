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
import 'package:seven/view/base/custom_button.dart';
import 'package:seven/view/base/custom_snackbar.dart';
import 'package:seven/view/base/custom_text_field.dart';
import 'package:seven/view/base/footer_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreenWeb extends StatefulWidget {
  final FocusNode? firstNameFocus;
  final FocusNode? lastNameFocus;
  final FocusNode? emailFocus;
  final FocusNode? phoneNumberFocus;
  final FocusNode? passwordFocus;
  final FocusNode? confirmPasswordFocus;
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneNumberController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;

  final Function pickImage;
  final PickedFile? file;
  final String? image;
  const ProfileScreenWeb(
      {Key? key,
      required this.firstNameFocus,
      required this.lastNameFocus,
      required this.emailFocus,
      required this.phoneNumberFocus,
      required this.passwordFocus,
      required this.confirmPasswordFocus,
      required this.firstNameController,
      required this.lastNameController,
      required this.emailController,
      required this.phoneNumberController,
      required this.passwordController,
      required this.confirmPasswordController,
      //function
      required this.pickImage,
      //file
      required this.file,
      required this.image})
      : super(key: key);

  @override
  State<ProfileScreenWeb> createState() => _ProfileScreenWebState();
}

class _ProfileScreenWebState extends State<ProfileScreenWeb> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
            return Center(
              child: ConstrainedBox(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 240.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                profileProvider.userInfoModel != null
                                    ? Text(
                                        '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                                        style: poppinsRegular.copyWith(
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_LARGE,
                                            color: ColorResources.getTextColor(
                                                context)),
                                      )
                                    : const SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                        width: 150),
                                const SizedBox(
                                    height: Dimensions.PADDING_SIZE_SMALL),
                                profileProvider.userInfoModel != null
                                    ? Text(
                                        profileProvider.userInfoModel!.email ??
                                            '',
                                        style: poppinsRegular.copyWith(
                                            color: ColorResources.getTextColor(
                                                context)),
                                      )
                                    : const SizedBox(height: 15, width: 100),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                          SizedBox(
                            width:
                                1170 /*MediaQuery.of(context).size.width * 0.45*/,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTranslated('first_name', context)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  color: ColorResources
                                                      .getHintColor(context),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        SizedBox(
                                          width: 400,
                                          child: CustomTextField(
                                            hintText: 'John',
                                            isShowBorder: true,
                                            controller:
                                                widget.firstNameController,
                                            focusNode: widget.firstNameFocus,
                                            nextFocus: widget.lastNameFocus,
                                            inputType: TextInputType.name,
                                            capitalization:
                                                TextCapitalization.words,
                                          ),
                                        ),

                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        // for email section
                                        Text(
                                          getTranslated('email', context)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  color: ColorResources
                                                      .getHintColor(context),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        SizedBox(
                                          width: 400,
                                          child: CustomTextField(
                                            hintText: getTranslated(
                                                'demo_gmail', context),
                                            isShowBorder: true,
                                            controller: widget.emailController,
                                            isEnabled: false,
                                            focusNode: widget.emailFocus,
                                            nextFocus: widget.phoneNumberFocus,
                                            inputType:
                                                TextInputType.emailAddress,
                                          ),
                                        ),

                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        Text(
                                          getTranslated('password', context)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  color: ColorResources
                                                      .getHintColor(context),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        SizedBox(
                                          width: 400,
                                          child: CustomTextField(
                                            hintText: getTranslated(
                                                'password_hint', context),
                                            isShowBorder: true,
                                            controller:
                                                widget.passwordController,
                                            focusNode: widget.passwordFocus,
                                            nextFocus:
                                                widget.confirmPasswordFocus,
                                            isPassword: true,
                                            isShowSuffixIcon: true,
                                          ),
                                        ),

                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),
                                      ],
                                    ),
                                    const SizedBox(
                                        width: Dimensions.PADDING_SIZE_LARGE),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTranslated('last_name', context)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  color: ColorResources
                                                      .getHintColor(context),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        SizedBox(
                                          width: 400,
                                          child: CustomTextField(
                                            hintText: 'Doe',
                                            isShowBorder: true,
                                            controller:
                                                widget.lastNameController,
                                            focusNode: widget.lastNameFocus,
                                            nextFocus: widget.phoneNumberFocus,
                                            inputType: TextInputType.name,
                                            capitalization:
                                                TextCapitalization.words,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        // for phone Number section
                                        Text(
                                          getTranslated(
                                              'mobile_number', context)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  color: ColorResources
                                                      .getHintColor(context),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),

                                        SizedBox(
                                          width: 400,
                                          child: CustomTextField(
                                            hintText: getTranslated(
                                                'number_hint', context),
                                            isShowBorder: true,
                                            controller:
                                                widget.phoneNumberController,
                                            focusNode: widget.phoneNumberFocus,
                                            nextFocus: widget.passwordFocus,
                                            inputType: TextInputType.phone,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        Text(
                                          getTranslated(
                                              'confirm_password', context)!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  color: ColorResources
                                                      .getHintColor(context),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        SizedBox(
                                          width: 400,
                                          child: CustomTextField(
                                            hintText: getTranslated(
                                                'password_hint', context),
                                            isShowBorder: true,
                                            controller: widget
                                                .confirmPasswordController,
                                            focusNode:
                                                widget.confirmPasswordFocus,
                                            isPassword: true,
                                            isShowSuffixIcon: true,
                                            inputAction: TextInputAction.done,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),
                                      ],
                                    ),
                                    const SizedBox(height: 55.0)
                                  ],
                                ),
                                !profileProvider.isLoading
                                    ? SizedBox(
                                        width: 180.0,
                                        child: CustomButton(
                                          buttonText: getTranslated(
                                              'update_profile', context),
                                          onPressed: () async {
                                            String firstName = widget
                                                .firstNameController!.text
                                                .trim();
                                            String lastName = widget
                                                .lastNameController!.text
                                                .trim();
                                            String phoneNumber = widget
                                                .phoneNumberController!.text
                                                .trim();
                                            String password = widget
                                                .passwordController!.text
                                                .trim();
                                            String confirmPassword = widget
                                                .confirmPasswordController!.text
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
                                                    widget.emailController!
                                                        .text &&
                                                widget.file == null &&
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
                                                      'enter_first_name',
                                                      context)!,
                                                  context);
                                            } else if (lastName.isEmpty) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_last_name',
                                                      context)!,
                                                  context);
                                            } else if (phoneNumber.isEmpty) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_phone_number',
                                                      context)!,
                                                  context);
                                            } else if ((password.isNotEmpty &&
                                                    password.length < 6) ||
                                                (confirmPassword.isNotEmpty &&
                                                    confirmPassword.length <
                                                        6)) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'password_should_be',
                                                      context)!,
                                                  context);
                                            } else if (password !=
                                                confirmPassword) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'password_did_not_match',
                                                      context)!,
                                                  context);
                                            } else {
                                              UserInfoModel
                                                  updateUserInfoModel =
                                                  UserInfoModel();
                                              updateUserInfoModel.fName =
                                                  firstName ?? "";
                                              updateUserInfoModel.lName =
                                                  lastName ?? "";
                                              updateUserInfoModel.phone =
                                                  phoneNumber ?? '';
                                              String pass = password ?? '';

                                              ResponseModel responseModel =
                                                  await profileProvider
                                                      .updateUserInfo(
                                                updateUserInfoModel,
                                                pass,
                                                profileProvider.file,
                                                profileProvider.data,
                                                Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false)
                                                    .getUserToken(),
                                              );

                                              if (responseModel.isSuccess) {
                                                profileProvider
                                                    .getUserInfo(context);
                                                widget.passwordController!
                                                    .text = '';
                                                widget
                                                    .confirmPasswordController!
                                                    .text = '';
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'updated_successfully',
                                                        context)!,
                                                    context,
                                                    isError: false);
                                              } else {
                                                showCustomSnackBar(
                                                    responseModel.message!,
                                                    context,
                                                    isError: true);
                                              }
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: 30,
                        top: 45,
                        child: Stack(
                          children: [
                            Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white.withOpacity(0.1),
                                        blurRadius: 22,
                                        offset: const Offset(0, 8.8))
                                  ],
                                  color: ColorResources.getWhiteColor(context)),
                              child: ClipOval(
                                child: profileProvider.file != null
                                    ? Image.file(profileProvider.file!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain)
                                    : profileProvider.data != null
                                        ? Image.network(
                                            profileProvider.data!.path,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.fill)
                                        : FadeInImage.assetNetwork(
                                            placeholder:
                                                Images.placeholder(context),
                                            height: 170,
                                            width: 170,
                                            fit: BoxFit.cover,
                                            image:
                                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/'
                                                '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : widget.image}',
                                            imageErrorBuilder: (c, o, s) =>
                                                Image.asset(
                                                    Images.placeholder(context),
                                                    height: 170,
                                                    width: 170,
                                                    fit: BoxFit.cover),
                                          ),
                              ),
                            ),
                            Positioned(
                                bottom: 10,
                                right: 10,
                                child: InkWell(
                                  onTap: widget.pickImage as void Function()?,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt,
                                        color: Colors.white60),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 55),
          const FooterView(),
        ],
      ),
    );
  }
}
