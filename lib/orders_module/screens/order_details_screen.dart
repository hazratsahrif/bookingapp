import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/orders_module/models/order_model.dart';
import 'package:booking_system_flutter/orders_module/models/order_status.dart';
import 'package:booking_system_flutter/orders_module/service/order_service.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen(
      {super.key, required this.orderModel, required this.isMyOrders});
  final OrderModel orderModel;
  final bool isMyOrders;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final isMyOrders = widget.isMyOrders;
    return SnapHelperWidget(
      initialData: widget.orderModel,
      future: OrderService.getOrderDetails(widget.orderModel.id ?? 0),
      onSuccess: (order) {
        final status = order?.orderStatus ?? OrderStatus.Pending.toString();
        if (order == null)
          return AppScaffold(
            child: Center(
              child: Text(language.noDataAvailable),
            ),
          );
        print(OrderStatus.Pending.toString());
        return AppScaffold(
          appBarTitle: '# ${order.id}',
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 26),
                  decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: status == 'Cancelled'
                          ? redColor.withOpacity(0.2)
                          : greenColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    order.orderStatus ?? 'N/A',
                    style: boldTextStyle(
                      color: status == 'Cancelled' ? redColor : greenColor,
                    ),
                  ),
                ),
              ],
            )
          ],
          child: Stack(
            alignment: Alignment.center,
            children: [
              ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Text(
                    language.lblProducts,
                    style: boldTextStyle(size: 22),
                  ),
                  10.height,
                  ...order.orderProducts?.map((orderProduct) {
                        final product = orderProduct.product;
                        if (product == null) return SizedBox();
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4),
                              decoration: boxDecorationDefault(boxShadow: [
                                BoxShadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: grey.withOpacity(0.3))
                              ], color: context.cardColor),
                              child: Row(
                                children: [
                                  Container(
                                    height: 125,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color:
                                          context.primaryColor.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            (product.productImages
                                                        ?.isNotEmpty ??
                                                    false)
                                                ? product.productImages?.first
                                                        .images ??
                                                    ''
                                                : ''),
                                      ),
                                    ),
                                    // child: CachedImageWidget(
                                    //   url: (product.productImages?.isNotEmpty ?? false)
                                    //       ? product.productImages?.first.images ?? ''
                                    //       : '',
                                    //   radius: 8,
                                    //   height: 125,
                                    //   usePlaceholderIfUrlEmpty: true,
                                    //   fit: BoxFit.cover,
                                    //   width: 100,
                                    //   color: context.primaryColor.withOpacity(0.3),
                                    // ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: 125,
                                    width: 100,
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: boldTextStyle(),
                                        ),
                                        PriceWidget(
                                            price: double.tryParse(
                                                    product.price ?? '0') ??
                                                0),
                                        Text(
                                          formatDate(product.createdAt,
                                              isLocal: true),
                                          style: secondaryTextStyle(),
                                        ),
                                        Text(
                                          language.lblQuantity +
                                              ":" +
                                              (orderProduct.quantity ?? ""),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: secondaryTextStyle(
                                              color: context.primaryColor),
                                        ),
                                        Row(
                                          children: [
                                            if (product.user?.socialImage !=
                                                null)
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: context.primaryColor
                                                      .withOpacity(0.3),
                                                  image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        product.user
                                                                ?.socialImage ??
                                                            ''),
                                                  ),
                                                ),
                                              ),
                                            8.width,
                                            Text(
                                              product.user?.displayName ?? "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: boldTextStyle(size: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ],
                        );
                      }) ??
                      [],
                  if (order.user != null)
                    ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithShadow(
                                boxShape: BoxShape.circle,
                                backgroundColor: context.cardColor),
                            child: Icon(
                              Icons.phone,
                              size: 20,
                              color: context.primaryColor,
                            ).onTap(() async {
                              String phoneNumber = "";
                              if (order.user?.contactNumber
                                      .validate()
                                      .contains('+') ??
                                  false) {
                                phoneNumber =
                                    "${order.user!.contactNumber.validate().replaceAll('-', '')}";
                              } else {
                                phoneNumber =
                                    "+${order.user!.contactNumber.validate().replaceAll('-', '')}";
                              }
                              launchUrl(Uri.parse('tel:$phoneNumber'),
                                  mode: LaunchMode.externalApplication);
                            }),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithShadow(
                                boxShape: BoxShape.circle,
                                backgroundColor: context.cardColor),
                            child: Image.asset(
                              ic_whatsapp,
                              height: 20,
                              width: 20,
                            ).onTap(() async {
                              String phoneNumber = "";
                              if (order.user?.contactNumber
                                      .validate()
                                      .contains('+') ??
                                  false) {
                                phoneNumber =
                                    "${order.user!.contactNumber.validate().replaceAll('-', '')}";
                              } else {
                                phoneNumber =
                                    "+${order.user!.contactNumber.validate().replaceAll('-', '')}";
                              }
                              launchUrl(
                                  Uri.parse(
                                      '${getSocialMediaLink(LinkProvider.WHATSAPP)}$phoneNumber'),
                                  mode: LaunchMode.externalApplication);
                            }),
                          ),
                        ],
                      ),
                      tileColor: gray.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      leading: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              colorFilter: order.user?.profileImage != null
                                  ? null
                                  : ColorFilter.mode(
                                      primaryColor, BlendMode.dstIn),
                              image: order.user?.profileImage != null
                                  ? CachedNetworkImageProvider(
                                      order.user!.profileImage!)
                                  : AssetImage(ic_profile2) as ImageProvider),
                          shape: BoxShape.circle,
                          // color: context.primaryColor,
                        ),
                      ),
                      title: Text(
                        order.user?.displayName ?? '',
                        style: primaryTextStyle(),
                      ),
                      subtitle: Text.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: language.hintAddress + ": ",
                            style: boldTextStyle(),
                          ),
                          TextSpan(
                            text: (order.deliveryAddress ?? ''),
                            style: primaryTextStyle(),
                          )
                        ],
                      )),
                      // subtitle: RatingBarWidget(
                      //   onRatingChanged: (_) {},
                      //   rating: product.user?.,
                      //   size: 15,
                      // ),
                    ),
                  TextButton(
                    child: Text(language.getLocation),
                    onPressed: () async {
                      commonLaunchUrl(
                          '$GOOGLE_MAP_PREFIX${Uri.encodeFull(order.deliveryAddress.validate())}',
                          launchMode: LaunchMode.externalApplication);
                    },
                  ),
                  16.height,
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: language.paymentMethod + ": ",
                        style: boldTextStyle()),
                    TextSpan(
                        text: order.paymentMethod, style: primaryTextStyle()),
                  ])),
                ],
              ),
              Observer(
                  builder: (context) =>
                      LoaderWidget().visible(appStore.isLoading))
            ],
          ),
          bottomNavigationBar: status == OrderStatus.Pending.toString()
              ? isMyOrders
                  ? _buildButton(
                      context,
                      language.lblCancelOrder,
                      onTap: () async {
                        await _changeStatus(order, OrderStatus.Cancelled);
                      },
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildButton(context, language.lblCancelOrder,
                              onTap: () async {
                            await _changeStatus(order, OrderStatus.Cancelled);
                          }, color: Colors.red),
                        ),
                        Expanded(
                          child: _buildButton(
                            context,
                            language.lblOrderShipped,
                            onTap: () async {
                              await _changeStatus(order, OrderStatus.Shipping);
                            },
                          ),
                        ),
                      ],
                    )
              : status == OrderStatus.Shipping.toString()
                  ? isMyOrders
                      ? _buildButton(
                          context,
                          language.lblOrderReceived,
                          onTap: () async {
                            await _changeStatus(order, OrderStatus.Delivered);
                          },
                        )
                      : _buildButton(
                          context,
                          language.lblOrderDelivered,
                          onTap: () async {
                            await _changeStatus(order, OrderStatus.Delivered);
                          },
                        )
                  : status == OrderStatus.Delivered.toString()
                      ? isMyOrders
                          ? SizedBox()
                          : _buildButton(
                              context,
                              language.lblCompleteOrder,
                              onTap: () async {
                                await _changeStatus(
                                    order, OrderStatus.Completed);
                              },
                            )
                      : SizedBox(),
        );
      },
    );
  }

  Future<void> _changeStatus(OrderModel order, String status) async {
    await OrderService.changeStatus(
            orderId: order.id.toString(), status: status)
        .then((value) => value ? setState(() {}) : null);
  }

  AppButton _buildButton(BuildContext context, final String lbl,
      {required VoidCallback onTap, Color? color}) {
    return AppButton(
      text: lbl,
      width: context.width(),
      margin: EdgeInsets.all(16),
      color: color ?? (appStore.isDarkMode ? primaryColorDark : primaryColor),
      textColor: Colors.white,
      onTap: onTap,
    );
  }
}
