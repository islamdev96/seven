import '../../all_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool isCenter;
  final bool isElevation;
  final bool fromCategoryScreen;
  const CustomAppBar(
      {super.key,
      required this.title,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.isCenter = true,
      this.isElevation = false,
      this.fromCategoryScreen = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title!,
          style: poppinsMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Theme.of(context).textTheme.bodyLarge!.color)),
      centerTitle: isCenter ? true : false,
      leading: isBackButtonExist
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () => onBackPressed != null
                  ? onBackPressed!()
                  : Navigator.pop(context),
            )
          : const SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: isElevation ? 2 : 0,
      actions: [
        fromCategoryScreen
            ? PopupMenuButton(
                color: ColorResources.getWhiteColor(context),
                elevation: 20,
                enabled: true,
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                onSelected: (dynamic value) {
                  int index =
                      Provider.of<ProductProvider>(context, listen: false)
                          .allSortBy
                          .indexOf(value);
                  Provider.of<CategoryProvider>(context, listen: false)
                      .setFilterIndex(index);
                  Provider.of<ProductProvider>(context, listen: false)
                      .sortCategoryProduct(index);
                },
                itemBuilder: (context) {
                  return Provider.of<ProductProvider>(context, listen: false)
                      .allSortBy
                      .map((choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text("$choice"),
                    );
                  }).toList();
                })
            : const SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
