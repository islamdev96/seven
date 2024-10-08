import 'package:flutter/material.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/styles.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDescription extends StatelessWidget {
  final String? productDescription;
  final String id;
  ProductDescription({required this.productDescription, required this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        productDescription!.isNotEmpty
            ? Center(
                child: Container(
                  width: 1170,
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: HtmlWidget(
                        productDescription!,
                        textStyle: poppinsRegular.copyWith(
                            color: ColorResources.getBlackColor(
                                context) /*ResponsiveHelper.isDesktop(context) ? ColorResources.getProductDescriptionColor(context) : Colors.black*/),
                        onTapUrl: (String url) {
                          return launchUrl(Uri.parse(url));
                        },
                      ),
                    ),
                  ),
                ),
              )
            : Center(child: Text(getTranslated('no_description', context)!)),
      ],
    );
  }
}
