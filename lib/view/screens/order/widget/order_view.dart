import 'package:flutter/material.dart';
import 'package:seven/data/model/response/order_model.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/provider/order_provider.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/view/base/footer_view.dart';
import 'package:seven/view/base/no_data_screen.dart';
import 'package:provider/provider.dart';

import 'order_card.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  OrderView({required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrderProvider>(
        builder: (context, order, index) {
          List<OrderModel>? orderList;
          if (order.runningOrderList != null) {
            orderList = isRunning
                ? order.runningOrderList!.reversed.toList()
                : order.historyOrderList!.reversed.toList();
          }

          return orderList != null
              ? orderList.length > 0
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<OrderProvider>(context, listen: false)
                            .getOrderList(context);
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      child: ListView(
                        children: [
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: ResponsiveHelper.isDesktop(context)
                                      ? MediaQuery.of(context).size.height - 400
                                      : MediaQuery.of(context).size.height),
                              child: SizedBox(
                                width: 1170,
                                child: ResponsiveHelper.isDesktop(context)
                                    ? GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 13,
                                                mainAxisSpacing: 13,
                                                childAspectRatio: 3,
                                                crossAxisCount: 2),
                                        itemCount: orderList.length,
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                            vertical: Dimensions
                                                .PADDING_SIZE_DEFAULT),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return OrderCard(
                                              orderList: orderList,
                                              index: index);
                                        },
                                      )
                                    : ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_SMALL),
                                        itemCount: orderList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return OrderCard(
                                              orderList: orderList,
                                              index: index);
                                        },
                                      ),
                              ),
                            ),
                          ),
                          ResponsiveHelper.isDesktop(context)
                              ? FooterView()
                              : SizedBox(),
                        ],
                      ),
                    )
                  : NoDataScreen(isOrder: true)
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
