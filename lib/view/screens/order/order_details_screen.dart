import 'package:flutter/material.dart';
import 'package:seven/data/model/response/order_details_model.dart';
import 'package:seven/data/model/response/order_model.dart';
import 'package:seven/data/model/response/timeslote_model.dart';
import 'package:seven/helper/date_converter.dart';
import 'package:seven/helper/price_converter.dart';
import 'package:seven/helper/responsive_helper.dart';
import 'package:seven/helper/route_helper.dart';
import 'package:seven/localization/language_constrants.dart';
import 'package:seven/provider/localization_provider.dart';
import 'package:seven/provider/location_provider.dart';
import 'package:seven/provider/order_provider.dart';
import 'package:seven/provider/product_provider.dart';
import 'package:seven/provider/profile_provider.dart';
import 'package:seven/provider/splash_provider.dart';
import 'package:seven/provider/theme_provider.dart';
import 'package:seven/utill/app_constants.dart';
import 'package:seven/utill/color_resources.dart';
import 'package:seven/utill/dimensions.dart';
import 'package:seven/utill/images.dart';
import 'package:seven/utill/styles.dart';
import 'package:seven/view/base/custom_app_bar.dart';
import 'package:seven/view/base/custom_button.dart';
import 'package:seven/view/base/custom_divider.dart';
import 'package:seven/view/base/custom_snackbar.dart';
import 'package:seven/view/base/footer_view.dart';
import 'package:seven/view/screens/address/widget/map_widget.dart';
import 'package:seven/view/base/web_app_bar/web_app_bar.dart';
import 'package:universal_html/html.dart' as html;
import 'package:seven/view/screens/order/widget/cancel_dialog.dart';
import 'package:seven/view/screens/order/widget/change_method_dialog.dart';
import 'package:seven/view/screens/review/rate_review_screen.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;
  const OrderDetailsScreen(
      {super.key, required this.orderModel, required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();
  late bool _isCashOnDeliveryActive;

  void _loadData(BuildContext context) async {
    await Provider.of<OrderProvider>(context, listen: false).trackOrder(
        widget.orderId.toString(), widget.orderModel, context, false);
    if (widget.orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false)
          .initConfig(context);
    }
    await Provider.of<LocationProvider>(context, listen: false)
        .initAddressList(context);
    await Provider.of<OrderProvider>(context, listen: false)
        .initializeTimeSlot(context);
    Provider.of<OrderProvider>(context, listen: false)
        .getOrderDetails(widget.orderId.toString(), context);
  }

  @override
  void initState() {
    super.initState();
    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : CustomAppBar(
              title: getTranslated('order_details', context),
            )) as PreferredSizeWidget?,
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          double? deliveryCharge = 0;
          double itemsPrice = 0;
          double discount = 0;
          double extraDiscount = 0;
          double tax = 0;
          TimeSlotModel? timeSlot;
          if (order.orderDetails != null) {
            deliveryCharge = order.trackModel!.deliveryCharge;
            for (OrderDetailsModel orderDetails in order.orderDetails!) {
              itemsPrice =
                  itemsPrice + (orderDetails.price! * orderDetails.quantity!);
              discount = discount +
                  (orderDetails.discountOnProduct! * orderDetails.quantity!);
              tax = tax + (orderDetails.taxAmount! * orderDetails.quantity!);
            }
            try {
              TimeSlotModel timeSlotModel = order.allTimeSlots!.firstWhere(
                  (timeSlot) => timeSlot.id == order.trackModel!.timeSlotId);
              timeSlot = timeSlotModel;
            } catch (c) {
              timeSlot = null;
            }
          }
          if (order.trackModel != null &&
              order.trackModel!.extraDiscount != null) {
            extraDiscount = order.trackModel!.extraDiscount ?? 0.0;
          }
          double subTotal = itemsPrice + tax;
          double total = subTotal -
              discount -
              extraDiscount +
              deliveryCharge! -
              (order.trackModel != null
                  ? order.trackModel!.couponDiscountAmount!
                  : 0);
          _isCashOnDeliveryActive =
              Provider.of<SplashProvider>(context, listen: false)
                      .configModel!
                      .cashOnDelivery ==
                  'true';

          return order.orderDetails != null
              ? ResponsiveHelper.isDesktop(context)
                  ? ListView(
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: ResponsiveHelper.isDesktop(context)
                                    ? MediaQuery.of(context).size.height - 400
                                    : MediaQuery.of(context).size.height),
                            child: Container(
                              width: 1170,
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_LARGE),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_LARGE),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                            vertical: Dimensions
                                                .PADDING_SIZE_DEFAULT),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Theme.of(context).cardColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[
                                                    Provider.of<ThemeProvider>(
                                                                context)
                                                            .darkTheme
                                                        ? 700
                                                        : 300]!,
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                              )
                                            ]),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(children: [
                                              Text(
                                                  '${getTranslated('order_id', context)}:',
                                                  style: poppinsRegular),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              Text(
                                                  order.trackModel!.id
                                                      .toString(),
                                                  style: poppinsMedium),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              const Expanded(child: SizedBox()),
                                              const Icon(Icons.watch_later,
                                                  size: 17),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              Text(
                                                  DateConverter
                                                      .isoStringToLocalDateOnly(
                                                          order.trackModel!
                                                              .createdAt!),
                                                  style: poppinsMedium),
                                            ]),
                                            const SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_SMALL),

                                            if (timeSlot != null)
                                              Row(children: [
                                                Text(
                                                    '${getTranslated('delivered_time', context)}:',
                                                    style: poppinsRegular),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                Text(
                                                    DateConverter
                                                        .convertTimeRange(
                                                            timeSlot.startTime!,
                                                            timeSlot.endTime!,
                                                            context),
                                                    style: poppinsMedium),
                                              ]),
                                            const SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_LARGE),

                                            Row(children: [
                                              Text(
                                                  '${getTranslated('item', context)}:',
                                                  style: poppinsRegular),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              Text(
                                                  order.orderDetails!.length
                                                      .toString(),
                                                  style: poppinsMedium.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              const Expanded(child: SizedBox()),
                                              order.trackModel!.orderType ==
                                                      'delivery'
                                                  ? TextButton.icon(
                                                      onPressed: () {
                                                        if (order.trackModel!
                                                                .deliveryAddress !=
                                                            null) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) => MapWidget(
                                                                      address: order
                                                                          .trackModel!
                                                                          .deliveryAddress)));
                                                        } else {
                                                          showCustomSnackBar(
                                                              getTranslated(
                                                                  'address_not_found',
                                                                  context)!,
                                                              context);
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.map,
                                                        size: 18,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      label: Text(
                                                          getTranslated(
                                                              'delivery_address',
                                                              context)!,
                                                          style: poppinsRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: Dimensions
                                                                  .FONT_SIZE_SMALL)),
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              side:
                                                                  const BorderSide(
                                                                      width:
                                                                          1)),
                                                          padding: const EdgeInsets
                                                                  .all(
                                                              Dimensions
                                                                  .PADDING_SIZE_EXTRA_SMALL),
                                                          minimumSize:
                                                              const Size(
                                                                  1, 30)),
                                                    )
                                                  : order.trackModel!
                                                              .orderType ==
                                                          'pos'
                                                      ? Text(
                                                          getTranslated(
                                                              'pos_order',
                                                              context)!,
                                                          style: poppinsRegular)
                                                      : Text(
                                                          getTranslated(
                                                              'self_pickup',
                                                              context)!,
                                                          style:
                                                              poppinsRegular),
                                            ]),
                                            const Divider(height: 20),

                                            // Payment info
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  getTranslated(
                                                      'payment_info', context)!,
                                                  style: poppinsRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                            ),
                                            const SizedBox(height: 10),

                                            Row(children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                      '${getTranslated('status', context)}:',
                                                      style: poppinsRegular)),
                                              Expanded(
                                                  flex: 8,
                                                  child: Text(
                                                    getTranslated(
                                                        order.trackModel!
                                                            .paymentStatus,
                                                        context)!,
                                                    style:
                                                        poppinsRegular.copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                  )),
                                            ]),
                                            const SizedBox(height: 5),

                                            Row(children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                      getTranslated(
                                                          'method', context)!,
                                                      style: poppinsRegular)),
                                              Builder(
                                                builder: (context) => Expanded(
                                                    flex: 8,
                                                    child: Row(children: [
                                                      (order.trackModel!.paymentMethod !=
                                                                      null &&
                                                                  order
                                                                      .trackModel!
                                                                      .paymentMethod!
                                                                      .isNotEmpty) &&
                                                              order.trackModel!
                                                                      .paymentMethod ==
                                                                  'cash_on_delivery'
                                                          ? Text(
                                                              getTranslated(
                                                                  'cash_on_delivery',
                                                                  context)!,
                                                              style: poppinsRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            )
                                                          : Text(
                                                              (order.trackModel!
                                                                              .paymentMethod !=
                                                                          null &&
                                                                      order
                                                                          .trackModel!
                                                                          .paymentMethod!
                                                                          .isNotEmpty)
                                                                  ? '${order.trackModel!.paymentMethod![0].toUpperCase()}${order.trackModel!.paymentMethod!.substring(1).replaceAll('_', ' ')}'
                                                                  : 'Digital Payment',
                                                              style: poppinsRegular.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                      (order.trackModel!.paymentStatus !=
                                                                  'paid' &&
                                                              order.trackModel!
                                                                      .paymentMethod !=
                                                                  'cash_on_delivery' &&
                                                              order.trackModel!
                                                                      .orderStatus !=
                                                                  'delivered')
                                                          ? InkWell(
                                                              onTap: () {
                                                                if (!_isCashOnDeliveryActive) {
                                                                  showCustomSnackBar(
                                                                      getTranslated(
                                                                          'cash_on_delivery_is_not_activated',
                                                                          context)!,
                                                                      context,
                                                                      isError:
                                                                          true);
                                                                } else {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        false,
                                                                    builder: (context) => ChangeMethodDialog(
                                                                        orderID: order.trackModel!.id.toString(),
                                                                        fromOrder: widget.orderModel != null,
                                                                        callback: (String message, bool isSuccess) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: Text(message),
                                                                              duration: const Duration(milliseconds: 600),
                                                                              backgroundColor: isSuccess ? Colors.green : Colors.red));
                                                                        }),
                                                                  );
                                                                }
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        Dimensions
                                                                            .PADDING_SIZE_SMALL,
                                                                    vertical:
                                                                        Dimensions
                                                                            .PADDING_SIZE_EXTRA_SMALL),
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        Dimensions
                                                                            .PADDING_SIZE_EXTRA_SMALL,
                                                                    vertical:
                                                                        2),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                        .withOpacity(
                                                                            0.3)),
                                                                child: Text(
                                                                    getTranslated(
                                                                        'change',
                                                                        context)!,
                                                                    style: poppinsRegular
                                                                        .copyWith(
                                                                      fontSize:
                                                                          10,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .color,
                                                                    )),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ])),
                                              ),
                                            ]),
                                            const Divider(height: 40),

                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  order.orderDetails!.length,
                                              itemBuilder: (context, index) {
                                                return order
                                                            .orderDetails![
                                                                index]
                                                            .productDetails !=
                                                        null
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                            Row(children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: FadeInImage
                                                                    .assetNetwork(
                                                                  placeholder: Images
                                                                      .placeholder(
                                                                          context),
                                                                  image:
                                                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/'
                                                                      '${order.orderDetails![index].productDetails!.image!.isNotEmpty ? order.orderDetails![index].productDetails!.image![0] : ''}',
                                                                  height: 70,
                                                                  width: 80,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageErrorBuilder: (c,
                                                                          o,
                                                                          s) =>
                                                                      Image.asset(
                                                                          Images.placeholder(
                                                                              context),
                                                                          height:
                                                                              70,
                                                                          width:
                                                                              80,
                                                                          fit: BoxFit
                                                                              .cover),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: Dimensions
                                                                      .PADDING_SIZE_SMALL),
                                                              Expanded(
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              order.orderDetails![index].productDetails!.name!,
                                                                              style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                              '${getTranslated('quantity', context)}:',
                                                                              style: poppinsRegular),
                                                                          const SizedBox(
                                                                            width:
                                                                                5.0,
                                                                          ),
                                                                          Text(
                                                                              order.orderDetails![index].quantity.toString(),
                                                                              style: poppinsRegular.copyWith(color: Theme.of(context).primaryColor)),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                      Row(
                                                                          children: [
                                                                            Text(
                                                                              PriceConverter.convertPrice(context, order.orderDetails![index].price! - order.orderDetails![index].discountOnProduct!.toDouble()),
                                                                              style: poppinsRegular,
                                                                            ),
                                                                            const SizedBox(width: 5),
                                                                            order.orderDetails![index].discountOnProduct! > 0
                                                                                ? Expanded(
                                                                                    child: Text(
                                                                                    PriceConverter.convertPrice(context, order.orderDetails![index].price!.toDouble()),
                                                                                    style: poppinsRegular.copyWith(
                                                                                      decoration: TextDecoration.lineThrough,
                                                                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                                                                      color: ColorResources.getHintColor(context),
                                                                                    ),
                                                                                  ))
                                                                                : const SizedBox(),
                                                                          ]),
                                                                      const SizedBox(
                                                                          height:
                                                                              Dimensions.PADDING_SIZE_SMALL),
                                                                      order.orderDetails![index].variation!
                                                                              .isNotEmpty
                                                                          ? Row(children: [
                                                                              order.orderDetails![index].variation != '' && order.orderDetails![index].variation != null
                                                                                  ? Container(
                                                                                      height: 10,
                                                                                      width: 10,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                                                                      ))
                                                                                  : const SizedBox.shrink(),
                                                                              const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                              Text(
                                                                                order.orderDetails![index].variation ?? '',
                                                                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                                              ),
                                                                            ])
                                                                          : const SizedBox(),
                                                                    ]),
                                                              ),
                                                            ]),
                                                            const Divider(
                                                                height: 40),
                                                          ])
                                                    : const SizedBox.shrink();
                                              },
                                            ),

                                            (order.trackModel!.orderNote !=
                                                        null &&
                                                    order.trackModel!.orderNote!
                                                        .isNotEmpty)
                                                ? Container(
                                                    padding: const EdgeInsets
                                                            .all(
                                                        Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    margin: const EdgeInsets
                                                            .only(
                                                        bottom: Dimensions
                                                            .PADDING_SIZE_LARGE),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                        '${getTranslated('order_note', context)} : ${order.trackModel!
                                                                .orderNote!}',
                                                        style: poppinsRegular.copyWith(
                                                            color: ColorResources
                                                                .getTextColor(
                                                                    context))),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                            vertical: Dimensions
                                                .PADDING_SIZE_DEFAULT),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Theme.of(context).cardColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[
                                                    Provider.of<ThemeProvider>(
                                                                context)
                                                            .darkTheme
                                                        ? 700
                                                        : 300]!,
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                              )
                                            ]),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'items_price',
                                                          context)!,
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                      PriceConverter
                                                          .convertPrice(context,
                                                              itemsPrice),
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                ]),
                                            const SizedBox(height: 10),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'tax', context)!,
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                      '(+) ${PriceConverter.convertPrice(context, tax)}',
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                ]),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                              child: CustomDivider(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'subtotal', context)!,
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                      PriceConverter
                                                          .convertPrice(
                                                              context, subTotal),
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                ]),
                                            const SizedBox(height: 10),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'discount', context)!,
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                      '(-) ${PriceConverter.convertPrice(context, discount)}',
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                ]),
                                            const SizedBox(height: 10),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'coupon_discount',
                                                          context)!,
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                    '(-) ${PriceConverter.convertPrice(context, order.trackModel!.couponDiscountAmount)}',
                                                    style:
                                                        poppinsRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_LARGE),
                                                  ),
                                                ]),
                                            const SizedBox(height: 10),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'delivery_fee',
                                                          context)!,
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                      '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                ]),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              child: CustomDivider(),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'total_amount',
                                                          context)!,
                                                      style: poppinsRegular
                                                          .copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_EXTRA_LARGE,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )),
                                                  Text(
                                                    PriceConverter.convertPrice(
                                                        context, total),
                                                    style: poppinsRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_EXTRA_LARGE,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ]),
                                            !order.showCancelled
                                                ? Center(
                                                    child: SizedBox(
                                                      width: 1170,
                                                      child: Row(children: [
                                                        order.trackModel!
                                                                    .orderStatus ==
                                                                'pending'
                                                            ? Expanded(
                                                                child: Padding(
                                                                padding: const EdgeInsets
                                                                        .all(
                                                                    Dimensions
                                                                        .PADDING_SIZE_SMALL),
                                                                child:
                                                                    TextButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    minimumSize:
                                                                        const Size(
                                                                            1,
                                                                            50),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        side: BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                ColorResources.getGreyColor(context))),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder: (context) =>
                                                                            OrderCancelDialog(
                                                                              orderID: order.trackModel!.id.toString(),
                                                                              fromOrder: widget.orderModel != null,
                                                                              callback: (String message, bool isSuccess, String orderID) {
                                                                                if (isSuccess) {
                                                                                  Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
                                                                                    context,
                                                                                    '1',
                                                                                    true,
                                                                                    Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                                                                  );

                                                                                  showCustomSnackBar('$message. ${getTranslated('order_id', context)}: $orderID', context, isError: false);
                                                                                } else {
                                                                                  showCustomSnackBar(message, context, isError: false);
                                                                                }
                                                                              },
                                                                            ));
                                                                  },
                                                                  child: Text(
                                                                      getTranslated(
                                                                          'cancel_order',
                                                                          context)!,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .displaySmall!
                                                                          .copyWith(
                                                                            color:
                                                                                ColorResources.getTextColor(context),
                                                                            fontSize:
                                                                                Dimensions.FONT_SIZE_LARGE,
                                                                          )),
                                                                ),
                                                              ))
                                                            : const SizedBox(),
                                                        (order.trackModel!
                                                                        .paymentStatus ==
                                                                    'unpaid' &&
                                                                order.trackModel!
                                                                        .paymentMethod !=
                                                                    'cash_on_delivery' &&
                                                                order.trackModel!
                                                                        .orderStatus !=
                                                                    'delivered')
                                                            ? Expanded(
                                                                child:
                                                                    Container(
                                                                height: 50,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        Dimensions
                                                                            .PADDING_SIZE_SMALL),
                                                                child:
                                                                    CustomButton(
                                                                  buttonText:
                                                                      getTranslated(
                                                                          'pay_now',
                                                                          context),
                                                                  onPressed:
                                                                      () async {
                                                                    if (ResponsiveHelper
                                                                        .isWeb()) {
                                                                      String? hostname = html
                                                                          .window
                                                                          .location
                                                                          .hostname;
                                                                      String
                                                                          selectedUrl =
                                                                          '${AppConstants.BASE_URL}/payment-mobile?order_id=${order.trackModel!.id}&&customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id}'
                                                                          '&&callback=http://$hostname${RouteHelper.orderSuccessful}${order.trackModel!.id}';
                                                                      html.window.open(
                                                                          selectedUrl,
                                                                          "_self");
                                                                    } else {
                                                                      Navigator.pushReplacementNamed(
                                                                          context,
                                                                          RouteHelper.getPaymentRoute(
                                                                              page: 'order',
                                                                              id: order.trackModel!.id.toString(),
                                                                              user: order.trackModel!.userId));
                                                                    }
                                                                  },
                                                                ),
                                                              ))
                                                            : const SizedBox(),
                                                      ]),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 1170,
                                                    height: 50,
                                                    margin: const EdgeInsets
                                                            .all(
                                                        Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                        getTranslated(
                                                            'order_cancelled',
                                                            context)!,
                                                        style: poppinsRegular
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor)),
                                                  ),
                                            (order.trackModel!.orderStatus ==
                                                        'confirmed' ||
                                                    order.trackModel!
                                                            .orderStatus ==
                                                        'processing' ||
                                                    order.trackModel!
                                                            .orderStatus ==
                                                        'out_for_delivery')
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .all(
                                                        Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    child: CustomButton(
                                                      buttonText: getTranslated(
                                                          'track_order',
                                                          context),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            RouteHelper
                                                                .getOrderTrackingRoute(
                                                                    order
                                                                        .trackModel!
                                                                        .id));
                                                      },
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            order.trackModel!.orderStatus ==
                                                        'delivered' &&
                                                    order.trackModel!
                                                            .orderType !=
                                                        'pos'
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .all(
                                                        Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    child: CustomButton(
                                                      buttonText: getTranslated(
                                                          'review', context),
                                                      onPressed: () {
                                                        List<OrderDetailsModel>
                                                            orderDetailsList =
                                                            [];
                                                        List<int?> orderIdList =
                                                            [];
                                                        for (var orderDetails
                                                            in order
                                                                .orderDetails!) {
                                                          if (!orderIdList.contains(
                                                              orderDetails
                                                                  .productDetails!
                                                                  .id)) {
                                                            orderDetailsList.add(
                                                                orderDetails);
                                                            orderIdList.add(
                                                                orderDetails
                                                                    .productDetails!
                                                                    .id);
                                                          }
                                                        }
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    RateReviewScreen(
                                                                      orderDetailsList:
                                                                          orderDetailsList,
                                                                      deliveryMan: order
                                                                          .trackModel!
                                                                          .deliveryMan,
                                                                    )));
                                                      },
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            if (order.trackModel!.deliveryMan !=
                                                    null &&
                                                (order.trackModel!
                                                        .orderStatus !=
                                                    'delivered'))
                                              Center(
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(
                                                      Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  child: CustomButton(
                                                      buttonText: getTranslated(
                                                          'chat_with_delivery_man',
                                                          context),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            RouteHelper.getChatRoute(
                                                                orderModel: order
                                                                    .trackModel));
                                                      }),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        ResponsiveHelper.isDesktop(context)
                            ? const FooterView()
                            : const SizedBox(),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                            child: Scrollbar(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(
                                Dimensions.PADDING_SIZE_SMALL),
                            child: Center(
                              child: SizedBox(
                                width: 1170,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(
                                          '${getTranslated('order_id', context)}:',
                                          style: poppinsRegular),
                                      const SizedBox(
                                          width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Text(order.trackModel!.id.toString(),
                                          style: poppinsMedium),
                                      const SizedBox(
                                          width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      const Expanded(child: SizedBox()),
                                      const Icon(Icons.watch_later, size: 17),
                                      const SizedBox(
                                          width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                          DateConverter
                                              .isoStringToLocalDateOnly(
                                                  order.trackModel!.createdAt!),
                                          style: poppinsMedium),
                                    ]),
                                    const SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),

                                    if (timeSlot != null)
                                      Row(children: [
                                        Text(
                                            '${getTranslated('delivered_time', context)}:',
                                            style: poppinsRegular),
                                        const SizedBox(
                                            width: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        Text(
                                            DateConverter.convertTimeRange(
                                                timeSlot.startTime!,
                                                timeSlot.endTime!,
                                                context),
                                            style: poppinsMedium),
                                      ]),
                                    const SizedBox(
                                        height: Dimensions.PADDING_SIZE_LARGE),

                                    Row(children: [
                                      Text('${getTranslated('item', context)}:',
                                          style: poppinsRegular),
                                      const SizedBox(
                                          width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                          order.orderDetails!.length.toString(),
                                          style: poppinsMedium.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      const Expanded(child: SizedBox()),
                                      order.trackModel!.orderType == 'delivery'
                                          ? TextButton.icon(
                                              onPressed: () {
                                                if (order.trackModel!
                                                        .deliveryAddress !=
                                                    null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) => MapWidget(
                                                              address: order
                                                                  .trackModel!
                                                                  .deliveryAddress)));
                                                } else {
                                                  showCustomSnackBar(
                                                      getTranslated(
                                                          'address_not_found',
                                                          context)!,
                                                      context,
                                                      isError: true);
                                                }
                                              },
                                              icon: Icon(
                                                Icons.map,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              label: Text(
                                                  getTranslated(
                                                      'delivery_address',
                                                      context)!,
                                                  style: poppinsRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_SMALL)),
                                              style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      side: const BorderSide(
                                                          width: 1)),
                                                  padding: const EdgeInsets.all(
                                                      Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  minimumSize:
                                                      const Size(1, 30)),
                                            )
                                          : order.trackModel!.orderType == 'pos'
                                              ? Text(
                                                  getTranslated(
                                                      'pos_order', context)!,
                                                  style: poppinsRegular)
                                              : Text(
                                                  getTranslated(
                                                      'self_pickup', context)!,
                                                  style: poppinsRegular),
                                    ]),
                                    const Divider(height: 20),

                                    // Payment info
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          getTranslated(
                                              'payment_info', context)!,
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                              '${getTranslated('status', context)}:',
                                              style: poppinsRegular)),
                                      Expanded(
                                          flex: 8,
                                          child: Text(
                                            getTranslated(
                                                order.trackModel!.paymentStatus,
                                                context)!,
                                            style: poppinsRegular.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )),
                                    ]),
                                    const SizedBox(height: 5),
                                    Row(children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                              getTranslated('method', context)!,
                                              style: poppinsRegular)),
                                      Builder(
                                        builder: (context) => Expanded(
                                            flex: 8,
                                            child: Row(children: [
                                              (order.trackModel!.paymentMethod !=
                                                              null &&
                                                          order
                                                              .trackModel!
                                                              .paymentMethod!
                                                              .isNotEmpty) &&
                                                      order.trackModel!
                                                              .paymentMethod ==
                                                          'cash_on_delivery'
                                                  ? Text(
                                                      getTranslated(
                                                          'cash_on_delivery',
                                                          context)!,
                                                      style: poppinsRegular
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    )
                                                  : Text(
                                                      (order.trackModel!
                                                                      .paymentMethod !=
                                                                  null &&
                                                              order
                                                                  .trackModel!
                                                                  .paymentMethod!
                                                                  .isNotEmpty)
                                                          ? '${order.trackModel!.paymentMethod![0].toUpperCase()}${order.trackModel!.paymentMethod!.substring(1).replaceAll('_', ' ')}'
                                                          : 'Digital Payment',
                                                      style: poppinsRegular
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    ),
                                              (order.trackModel!
                                                              .paymentStatus !=
                                                          'paid' &&
                                                      order.trackModel!
                                                              .paymentMethod !=
                                                          'cash_on_delivery' &&
                                                      order.trackModel!
                                                              .orderStatus !=
                                                          'delivered')
                                                  ? InkWell(
                                                      onTap: () {
                                                        if (!_isCashOnDeliveryActive) {
                                                          showCustomSnackBar(
                                                              getTranslated(
                                                                  'cash_on_delivery_is_not_activated',
                                                                  context)!,
                                                              context,
                                                              isError: true);
                                                        } else {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (context) =>
                                                                ChangeMethodDialog(
                                                                    orderID: order
                                                                        .trackModel!
                                                                        .id
                                                                        .toString(),
                                                                    fromOrder:
                                                                        widget.orderModel !=
                                                                            null,
                                                                    callback: (String
                                                                            message,
                                                                        bool
                                                                            isSuccess) {
                                                                      showCustomSnackBar(
                                                                          message,
                                                                          context,
                                                                          isError:
                                                                              isSuccess);
                                                                    }),
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: Dimensions
                                                                .PADDING_SIZE_SMALL,
                                                            vertical: Dimensions
                                                                .PADDING_SIZE_EXTRA_SMALL),
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: Dimensions
                                                                .PADDING_SIZE_EXTRA_SMALL,
                                                            vertical: 2),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.3)),
                                                        child: Text(
                                                            getTranslated(
                                                                'change',
                                                                context)!,
                                                            style:
                                                                poppinsRegular
                                                                    .copyWith(
                                                              fontSize: 10,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color,
                                                            )),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ])),
                                      ),
                                    ]),
                                    const Divider(height: 40),

                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: order.orderDetails!.length,
                                      itemBuilder: (context, index) {
                                        return order.orderDetails![index]
                                                    .productDetails !=
                                                null
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    Row(children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder: Images
                                                              .placeholder(
                                                                  context),
                                                          image:
                                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/'
                                                              '${order.orderDetails![index].productDetails!.image!.isNotEmpty ? order.orderDetails![index].productDetails!.image![0] : ''}',
                                                          height: 70,
                                                          width: 80,
                                                          fit: BoxFit.cover,
                                                          imageErrorBuilder: (c,
                                                                  o, s) =>
                                                              Image.asset(
                                                                  Images.placeholder(
                                                                      context),
                                                                  height: 70,
                                                                  width: 80,
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .PADDING_SIZE_SMALL),
                                                      Expanded(
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      order
                                                                          .orderDetails![
                                                                              index]
                                                                          .productDetails!
                                                                          .name!,
                                                                      style: poppinsRegular.copyWith(
                                                                          fontSize:
                                                                              Dimensions.FONT_SIZE_SMALL),
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      '${getTranslated('quantity', context)}:',
                                                                      style:
                                                                          poppinsRegular),
                                                                  const SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  Text(
                                                                      order
                                                                          .orderDetails![
                                                                              index]
                                                                          .quantity
                                                                          .toString(),
                                                                      style: poppinsRegular.copyWith(
                                                                          color:
                                                                              Theme.of(context).primaryColor)),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: Dimensions
                                                                      .PADDING_SIZE_EXTRA_SMALL),
                                                              Row(children: [
                                                                Text(
                                                                  PriceConverter.convertPrice(
                                                                      context,
                                                                      order.orderDetails![index].price! -
                                                                          order
                                                                              .orderDetails![index]
                                                                              .discountOnProduct!
                                                                              .toDouble()),
                                                                  style:
                                                                      poppinsRegular,
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                order.orderDetails![index]
                                                                            .discountOnProduct! >
                                                                        0
                                                                    ? Expanded(
                                                                        child: Text(
                                                                        PriceConverter.convertPrice(
                                                                            context,
                                                                            order.orderDetails![index].price!.toDouble()),
                                                                        style: poppinsRegular
                                                                            .copyWith(
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
                                                                          fontSize:
                                                                              Dimensions.FONT_SIZE_SMALL,
                                                                          color:
                                                                              ColorResources.getHintColor(context),
                                                                        ),
                                                                      ))
                                                                    : const SizedBox(),
                                                              ]),
                                                              const SizedBox(
                                                                  height: Dimensions
                                                                      .PADDING_SIZE_SMALL),
                                                              order.orderDetails![index].variation !=
                                                                          '' &&
                                                                      order.orderDetails![index].variation !=
                                                                          null
                                                                  ? Row(
                                                                      children: [
                                                                          Container(
                                                                              height: 10,
                                                                              width: 10,
                                                                              decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                color: Theme.of(context).textTheme.bodyLarge!.color,
                                                                              )),
                                                                          const SizedBox(
                                                                              width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                          Text(
                                                                            order.orderDetails![index].variation ??
                                                                                '',
                                                                            style:
                                                                                poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                                          ),
                                                                        ])
                                                                  : const SizedBox(),
                                                            ]),
                                                      ),
                                                    ]),
                                                    const Divider(height: 40),
                                                  ])
                                            : const SizedBox
                                                .shrink(); /*Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text('product was deleted or product not found',style: TextStyle(color: Colors.red),),
                                );*/
                                      },
                                    ),

                                    (order.trackModel!.orderNote != null &&
                                            order.trackModel!.orderNote!
                                                .isNotEmpty)
                                        ? Container(
                                            padding: const EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_SMALL),
                                            margin: const EdgeInsets.only(
                                                bottom: Dimensions
                                                    .PADDING_SIZE_LARGE),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1,
                                                  color: ColorResources
                                                      .getTextColor(context)),
                                            ),
                                            child: Text(
                                                order.trackModel!.orderNote!,
                                                style: poppinsRegular.copyWith(
                                                    color: ColorResources
                                                        .getTextColor(
                                                            context))),
                                          )
                                        : const SizedBox(),

                                    // Total
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              getTranslated(
                                                  'items_price', context)!,
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  context, itemsPrice),
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                        ]),
                                    const SizedBox(height: 10),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(getTranslated('tax', context)!,
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                          Text(
                                              '(+) ${PriceConverter.convertPrice(context, tax)}',
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                        ]),
                                    const SizedBox(height: 10),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: CustomDivider(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color),
                                    ),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              getTranslated(
                                                  'subtotal', context)!,
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  context, subTotal),
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                        ]),
                                    const SizedBox(height: 10),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              getTranslated(
                                                  'discount', context)!,
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                          Text(
                                              '(-) ${PriceConverter.convertPrice(context, discount)}',
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                        ]),
                                    const SizedBox(height: 10),

                                    order.trackModel!.orderType == "pos"
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'extra_discount',
                                                          context)!,
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                      '(-) ${PriceConverter.convertPrice(context, extraDiscount ?? 0.0)}',
                                                      style: poppinsRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                ]),
                                          )
                                        : const SizedBox(),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              getTranslated(
                                                  'coupon_discount', context)!,
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                          Text(
                                            '(-) ${PriceConverter.convertPrice(context, order.trackModel!.couponDiscountAmount)}',
                                            style: poppinsRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE),
                                          ),
                                        ]),
                                    const SizedBox(height: 10),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              getTranslated(
                                                  'delivery_fee', context)!,
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                          Text(
                                              '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                        ]),

                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: CustomDivider(),
                                    ),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              getTranslated(
                                                  'total_amount', context)!,
                                              style: poppinsRegular.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_EXTRA_LARGE,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )),
                                          Text(
                                            PriceConverter.convertPrice(
                                                context, total),
                                            style: poppinsRegular.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_EXTRA_LARGE,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                        !order.showCancelled
                            ? Center(
                                child: SizedBox(
                                  width: 1170,
                                  child: Row(children: [
                                    order.trackModel!.orderStatus == 'pending'
                                        ? Expanded(
                                            child: Padding(
                                            padding: const EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_SMALL),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  minimumSize:
                                                      const Size(1, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: BorderSide(
                                                        width: 2,
                                                        color: ColorResources
                                                            .getGreyColor(
                                                                context)),
                                                  )),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (context) =>
                                                            OrderCancelDialog(
                                                              orderID: order
                                                                  .trackModel!
                                                                  .id
                                                                  .toString(),
                                                              fromOrder: widget
                                                                      .orderModel !=
                                                                  null,
                                                              callback: (String
                                                                      message,
                                                                  bool
                                                                      isSuccess,
                                                                  String
                                                                      orderID) {
                                                                if (isSuccess) {
                                                                  Provider.of<ProductProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getPopularProductList(
                                                                    context,
                                                                    '1',
                                                                    true,
                                                                    Provider.of<LocalizationProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .locale
                                                                        .languageCode,
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        '$message. ${getTranslated('order_id', context)}: $orderID'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                  ));
                                                                } else {
                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                      content: Text(
                                                                          message),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red));
                                                                }
                                                              },
                                                            ));
                                              },
                                              child: Text(
                                                  getTranslated(
                                                      'cancel_order', context)!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall!
                                                      .copyWith(
                                                        color: ColorResources
                                                            .getTextColor(
                                                                context),
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE,
                                                      )),
                                            ),
                                          ))
                                        : const SizedBox(),
                                    (order.trackModel!.paymentStatus ==
                                                'unpaid' &&
                                            order.trackModel!.paymentMethod !=
                                                'cash_on_delivery' &&
                                            order.trackModel!.orderStatus !=
                                                'delivered')
                                        ? Expanded(
                                            child: Container(
                                            height: 50,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            child: CustomButton(
                                              buttonText: getTranslated(
                                                  'pay_now', context),
                                              onPressed: () async {
                                                if (ResponsiveHelper.isWeb()) {
                                                  String? hostname = html
                                                      .window.location.hostname;
                                                  String selectedUrl =
                                                      '${AppConstants.BASE_URL}/payment-mobile?order_id=${order.trackModel!.id}&&customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id}'
                                                      '&&callback=http://$hostname${RouteHelper.orderSuccessful}${order.trackModel!.id}';
                                                  html.window.open(
                                                      selectedUrl, "_self");
                                                } else {
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      RouteHelper
                                                          .getPaymentRoute(
                                                              page: 'order',
                                                              id: order
                                                                  .trackModel!
                                                                  .id
                                                                  .toString(),
                                                              user: order
                                                                  .trackModel!
                                                                  .userId));
                                                }
                                              },
                                            ),
                                          ))
                                        : const SizedBox(),
                                  ]),
                                ),
                              )
                            : Container(
                                width: 1170,
                                height: 50,
                                margin: const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                    getTranslated('order_cancelled', context)!,
                                    style: poppinsRegular.copyWith(
                                        color: Theme.of(context).primaryColor)),
                              ),
                        (order.trackModel!.orderStatus == 'confirmed' ||
                                order.trackModel!.orderStatus == 'processing' ||
                                order.trackModel!.orderStatus ==
                                        'out_for_delivery' &&
                                    order.trackModel!.orderType != 'pos')
                            ? Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: CustomButton(
                                  buttonText:
                                      getTranslated('track_order', context),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context,
                                        RouteHelper.getOrderTrackingRoute(
                                            order.trackModel!.id));
                                  },
                                ),
                              )
                            : const SizedBox(),
                        order.trackModel!.orderStatus == 'delivered' &&
                                order.trackModel!.orderType != 'pos'
                            ? Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: CustomButton(
                                  buttonText: getTranslated('review', context),
                                  onPressed: () {
                                    List<OrderDetailsModel> orderDetailsList =
                                        [];
                                    List<int?> orderIdList = [];
                                    for (var orderDetails
                                        in order.orderDetails!) {
                                      if (!orderIdList.contains(
                                          orderDetails.productDetails!.id)) {
                                        orderDetailsList.add(orderDetails);
                                        orderIdList.add(
                                            orderDetails.productDetails!.id);
                                      }
                                    }
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => RateReviewScreen(
                                                  orderDetailsList:
                                                      orderDetailsList,
                                                  deliveryMan: order
                                                      .trackModel!.deliveryMan,
                                                )));
                                  },
                                ),
                              )
                            : const SizedBox(),
                        if (order.trackModel!.deliveryMan != null &&
                            (order.trackModel!.orderStatus != 'delivered'))
                          Center(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                  Dimensions.PADDING_SIZE_SMALL),
                              child: CustomButton(
                                  buttonText: getTranslated(
                                      'chat_with_delivery_man', context),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context,
                                        RouteHelper.getChatRoute(
                                            orderModel: order.trackModel));
                                  }),
                            ),
                          ),
                      ],
                    )
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
