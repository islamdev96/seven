import 'package:flutter/material.dart';
import 'package:seven/helper/route_helper.dart';
import 'package:seven/utill/app_constants.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/images.dart';
import 'package:seven/utill/styles.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: Theme.of(context).cardColor,
          width: 1170.0,
          height: 45.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () => Navigator.pushNamed(context, RouteHelper.menu),
                    child: Row(
                      children: [
                        Image.asset(Images.app_logo,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(AppConstants.APP_NAME,
                            style: poppinsMedium.copyWith(
                                color: Theme.of(context).primaryColor)),
                      ],
                    )),
              ),
              const MenuBar(
                children: [],
              ),
            ],
          )),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
