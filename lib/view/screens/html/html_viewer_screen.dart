import 'package:flutter/material.dart';
import 'package:seven/helper/html_type.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/splash_provider.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/base/app_bar_base.dart';
import 'package:seven/view/base/footer_view.dart';
import 'package:seven/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({super.key, required this.htmlType});

  @override
  Widget build(BuildContext context) {
    String? data = htmlType == HtmlType.TERMS_AND_CONDITION
        ? Provider.of<SplashProvider>(context, listen: false)
            .configModel!
            .termsAndConditions
        : htmlType == HtmlType.ABOUT_US
            ? Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .aboutUs
            : htmlType == HtmlType.PRIVACY_POLICY
                ? Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .privacyPolicy
                : null;

    if (data != null && data.isNotEmpty) {
      data = data.replaceAll('href=', 'target="_blank" href=');
    }

    String viewID = htmlType.toString();
    // if(ResponsiveHelper.isWeb()) {
    //   try{
    //     ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
    //       html.IFrameElement _ife = html.IFrameElement();
    //       _ife.width = '1170';
    //       _ife.height = MediaQuery.of(context).size.height.toString();
    //       _ife.srcdoc = _data;
    //       _ife.contentEditable = 'false';
    //       _ife.style.border = 'none';
    //       _ife.allowFullscreen = true;
    //       return _ife;
    //     });
    //   }catch(e) {}
    // }
    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : ResponsiveHelper.isMobilePhone()
              ? null
              : AppBarBase(
                  title: getTranslated(
                    htmlType == HtmlType.TERMS_AND_CONDITION
                        ? 'terms_and_condition'
                        : htmlType == HtmlType.ABOUT_US
                            ? 'about_us'
                            : htmlType == HtmlType.PRIVACY_POLICY
                                ? 'privacy_policy'
                                : 'terms_and_condition',
                    context,
                  ),
                )) as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: ResponsiveHelper.isDesktop(context)
                      ? MediaQuery.of(context).size.height - 400
                      : MediaQuery.of(context).size.height),
              child: Container(
                width: 1170,
                color: Theme.of(context).canvasColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Text(htmlType.name.replaceAll('_', ' '),
                              style: poppinsBold.copyWith(
                                  fontSize: 28,
                                  color: ColorResources.getTextColor(context)))
                          : const SizedBox.shrink(),
                      Padding(
                        padding: ResponsiveHelper.isDesktop(context)
                            ? const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                                vertical: Dimensions.PADDING_SIZE_SMALL)
                            : const EdgeInsets.all(0.0),
                        child: HtmlWidget(
                          data ?? '',
                          key: Key(htmlType.toString()),
                          textStyle: poppinsRegular.copyWith(
                              color: ColorResources.getTextColor(context)),
                          onTapUrl: (String url) {
                            return launchUrlString(url);
                          },
                        ),
                      ),
                    ],
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
    );
  }
}
