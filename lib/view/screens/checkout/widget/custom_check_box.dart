import 'package:flutter/material.dart';
import 'package:seven/provider/order_provider.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/styles.dart';
import 'package:provider/provider.dart';

class CustomCheckBox extends StatelessWidget {
  final String? title;
  final int index;

  const CustomCheckBox({super.key, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setPaymentMethod(index),
          child: Row(children: [
            Checkbox(
              value: order.paymentMethodIndex == index,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool? isChecked) => order.setPaymentMethod(index),
            ),
            Expanded(
              child: Text(title!,
                  style: poppinsRegular.copyWith(
                    color: order.paymentMethodIndex == index
                        ? Theme.of(context).textTheme.bodyLarge!.color
                        : ColorResources.getHintColor(context),
                  )),
            ),
          ]),
        );
      },
    );
  }
}
