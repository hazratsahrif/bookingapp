import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/component/shimmer_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/orders_module/screens/order_details_screen.dart';
import 'package:booking_system_flutter/orders_module/service/order_service.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class OrdersMainScreen extends StatefulWidget {
  const OrdersMainScreen({super.key, this.showBack = true});

  @override
  _OrdersMainScreenState createState() => _OrdersMainScreenState();
  final bool showBack;
}

class _OrdersMainScreenState extends State<OrdersMainScreen> {
  // int page = 0;
  // bool isLastPage = false;
  // bool isApiCalled = false;

  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {}

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    controller.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  ValueNotifier<int> selectedPage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedPage,
        builder: (context, val, _) {
          return AppScaffold(
            // appBarTitle:
            //     val == 0 ? language.lblMyOrders : language.lblOrdersReceived,
            // showBack: widget.showBack,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      val == 0 ? primaryColor : null),
                              child: Text(
                                language.lblMyOrders,
                                style: boldTextStyle(
                                  color: val == 0 ? white : null,
                                ),
                              ),
                              onPressed: () {
                                controller.jumpToPage(0);
                                selectedPage.value = 0;
                              },
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      val == 1 ? primaryColor : null),
                              child: Text(
                                language.lblOrdersReceived,
                                style: boldTextStyle(
                                  color: val == 1 ? white : null,
                                ),
                              ),
                              onPressed: () {
                                selectedPage.value = 1;

                                controller.jumpToPage(1);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        onPageChanged: (value) => selectedPage.value = value,
                        controller: controller,
                        children: [
                          MyProducts(
                            myOrders: true,
                          ),
                          MyProducts(
                            myOrders: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Observer(
                    builder: (context) =>
                        LoaderWidget().visible(appStore.isLoading))
              ],
            ),
          );
        });
  }
}

class MyProducts extends StatefulWidget {
  const MyProducts({
    super.key,
    required this.myOrders,
  });
  final bool myOrders;

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  @override
  Widget build(BuildContext context) {
    return SnapHelperWidget(
        future: widget.myOrders
            ? OrderService.getUserOwnOrders()
            : OrderService.getUserProductsOrders(),
        loadingWidget: ShimmerWidget(),
        onSuccess: (orders) {
          return orders.isEmpty
              ? Center(
                  child: Text(language.noDataAvailable),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final status = order.orderStatus ?? 'Pending';

                    return InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () {
                        OrderDetailsScreen(
                          isMyOrders: widget.myOrders,
                          orderModel: order,
                        ).launch(context).then((value) => setState(() {}));
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4),
                            decoration: boxDecorationDefault(boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: grey.withOpacity(0.3)),
                            ], color: context.cardColor),
                            child: Row(
                              children: [
                                Builder(builder: (context) {
                                  final listOfList = order.orderProducts
                                          ?.map((e) => e.product?.productImages
                                              ?.map((e) => e.images)
                                              .toList())
                                          .toList() ??
                                      [];
                                  List<String> images = [];
                                  for (final e in listOfList) {
                                    if (e != null)
                                      images = [
                                        ...(e ?? [])
                                            .where((element) => element != null)
                                            .map((e) => e ?? '')
                                            .toList(),
                                        ...images
                                      ];
                                  }
                                  return Container(
                                    height: 125,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color:
                                          context.primaryColor.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            (images.isNotEmpty)
                                                ? images
                                                    .where((element) =>
                                                        element.isNotEmpty)
                                                    .first
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
                                  );
                                }),
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
                                        "# ${(order.id ?? "")}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: boldTextStyle(),
                                      ),
                                      PriceWidget(
                                        decimalPoint: 0,
                                        price: double.tryParse(
                                                order.totalPrice ?? '0') ??
                                            0,
                                      ),
                                      Text(
                                        formatDate(order.createdAt,
                                            isLocal: true),
                                        style: secondaryTextStyle(),
                                      ),
                                      Row(
                                        children: [
                                          if (order.user?.socialImage != null)
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: context.primaryColor
                                                    .withOpacity(0.3),
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          order.user
                                                                  ?.socialImage ??
                                                              ''),
                                                ),
                                              ),
                                            ),
                                          8.width,
                                          Text(
                                            order.user?.displayName ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: boldTextStyle(size: 12),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15, right: 15),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 26),
                            decoration: boxDecorationWithRoundedCorners(
                                backgroundColor: status == 'Cancelled'
                                    ? redColor.withOpacity(0.2)
                                    : greenColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(100)),
                            child: Text(
                              order.orderStatus ?? 'N/A',
                              style: boldTextStyle(
                                color: status == 'Cancelled'
                                    ? redColor
                                    : greenColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 10.height,
                  itemCount: orders.length);
        });
  }
}
