import 'package:flutter/material.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/view/base/custom_app_bar.dart';
import 'package:seven/view/base/main_app_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionScreen extends StatelessWidget {
  final String? description;
  DescriptionScreen({required this.description});

  @override
  Widget build(BuildContext context) {
    final String _viewID = 'description';

    // if(ResponsiveHelper.isWeb()) {
    //   try{
    //     ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
    //       html.IFrameElement _ife = html.IFrameElement();
    //       _ife.width = '1170';
    //       _ife.height = MediaQuery.of(context).size.height.toString();
    //       _ife.srcdoc = description;
    //       _ife.contentEditable = 'false';
    //       _ife.style.border = 'none';
    //       _ife.allowFullscreen = true;
    //       return _ife;
    //     });
    //   }catch(e) {}
    // }

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? MainAppBar()
          : CustomAppBar(
              title: getTranslated('description', context),
              isBackButtonExist: true)) as PreferredSizeWidget?,
      body: Center(
        child: Container(
          width: 1170,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: ResponsiveHelper.isWeb()
              ? Column(
                  children: [
                    Expanded(
                        child: IgnorePointer(
                            child: HtmlElementView(
                                viewType: _viewID, key: Key('description')))),
                  ],
                )
              : SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: HtmlWidget(
                        description!,
                        onTapUrl: (String url) {
                          return launchUrl(Uri.parse(url));
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ),

      //HtmlWidget(description),
      // body: Html(data: description),
    );
  }
}
