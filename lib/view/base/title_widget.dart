import '../../all_export.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final Function? onTap;
  const TitleWidget({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ResponsiveHelper.isDesktop(context)
          ? ColorResources.getAppBarHeaderColor(context)
          : Theme.of(context).canvasColor,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: ResponsiveHelper.isDesktop(context)
          ? const EdgeInsets.symmetric(horizontal: 5)
          : EdgeInsets.zero,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title!,
            style: ResponsiveHelper.isDesktop(context)
                ? poppinsSemiBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                    color: ColorResources.getTextColor(context))
                : poppinsMedium),
        onTap != null
            ? InkWell(
                onTap: onTap as void Function()?,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                  child: Text(
                    getTranslated('view_all', context)!,
                    style: ResponsiveHelper.isDesktop(context)
                        ? poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                            color: Theme.of(context).primaryColor)
                        : poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_SMALL,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.8)),
                  ),
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}
