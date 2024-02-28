import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/product_module/models/cart_item_model.dart';
import 'package:booking_system_flutter/product_module/models/order_product_model.dart';
import 'package:booking_system_flutter/product_module/screens/place_order.dart';
import 'package:booking_system_flutter/product_module/screens/view_all_products_screen.dart';
import 'package:booking_system_flutter/product_module/services/store_service.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/widgets/horizontal_calender/date_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';
import '../../utils/configs.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemModel> cartItems = [];
  Future _init() async {
    appStore.setLoading(true);

    await StoreService.getCart().then((value) {
      appStore.setLoading(false);
      setState(() {
        cartItems = value;
      });
    });
  }

  @override
  void initState() {
    _init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblCart,
      child: appStore.isLoading
          ? SizedBox()
          : cartItems.isEmpty
              ? Center(
                  child: Text(language.noDataAvailable),
                )
              : Column(
                  children: [
                    ListTile(
                      title: Text(language.lblSelectItemList),
                      trailing: TextButton(
                        child: Text(language.lblAddMoreItems),
                        onPressed: () {
                          ViewAllProductsScreen()
                              .launch(context)
                              .then((value) => _init());
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(16.0),
                        children: [
                          ...cartItems.map((item) {
                            return CartItemWidget(
                              item: item,
                              onDelete: () async {
                                final success =
                                    await StoreService.deleteItemInCart(
                                        productId: item.productId!.toString());
                                if (success) _init();
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         language.lblSubTotal,
                //         style: TextStyle(
                //             color: Theme.of(context).primaryColor,
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold),
                //       ),
                //       PriceWidget(
                //         price: cartItems.isEmpty
                //             ? 0
                //             : cartItems
                //                 .map((e) =>
                //                     (double.tryParse(e.price ?? '') ?? 0) *
                //                     (int.tryParse(e.quantity ?? '') ?? 0).toDouble())
                //                 .reduce((value, element) => value + element),
                //         color: context.primaryColor,
                //       ),
                //     ],
                //   ),
                // ),
                // 8.width,

                AppButton(
                  text: language.lblPlaceOrderButton,
                  width: context.width(),
                  margin: EdgeInsets.all(16),
                  color: appStore.isDarkMode ? primaryColorDark : primaryColor,
                  textColor: Colors.white,
                  onTap: () async {
                    await _init();
                    final success = await PlaceOrderScreen(
                                orderProducts: cartItems
                                    .map((e) => OrderProductModel(
                                        e.productId!.toString(),
                                        e.price!,
                                        e.quantity!))
                                    .toList())
                            .launch<bool>(context) ??
                        false;
                    if (success) {
                      appStore.setLoading(true);
                      for (final item in cartItems) {
                        await StoreService.deleteItemInCart(
                            productId: item.productId!.toString());
                      }
                      appStore.setLoading(false);

                      finish(context, success);
                    }
                    ;
                  },
                ),
              ],
            )
          : null,
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final CartItemModel item;
  final VoidCallback? onDelete;
  const CartItemWidget({
    super.key,
    required this.item,
    this.onDelete,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late int quantity;
  @override
  void initState() {
    quantity = int.parse(widget.item.quantity ?? '0');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.item.products;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: CachedImageWidget(
                  url: (product?.productImages?.isNotEmpty ?? false)
                      ? product!.productImages!.first.images!
                      : '',
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40,
                  color: Colors.amber.shade50,
                ),
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.item.products?.title ?? '',
                    maxLines: 1,
                    style: boldTextStyle(),
                  ),
                  8.height,
                  PriceWidget(
                    price: double.parse(widget.item.products?.price ?? '0'),
                    size: 14,
                  )
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber.shade50,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        if (quantity >= 1) {
                          final success =
                              await StoreService.decrementItemInCart(
                                  productId: product?.id?.toString() ?? '',
                                  quantity: quantity);
                          if (success) {
                            quantity--;
                            setState(() {});
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(500),
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: white, shape: BoxShape.circle),
                        child: Icon(
                          Icons.remove,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    12.width,
                    Text(
                      quantity.toString(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24,
                      ),
                    ),
                    12.width,
                    InkWell(
                      onTap: () async {
                        if (quantity < int.parse(product?.quantity ?? '0')) {
                          final success =
                              await StoreService.incrementItemInCart(
                                  productId: product?.id?.toString() ?? '',
                                  quantity: quantity);
                          if (success) {
                            quantity++;
                            setState(() {});
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(500),
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.add,
                          color: white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 0.0),
            child: Divider(
              color: Colors.grey.shade100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(widget.item.createdAt, isLocal: true),
                  style: secondaryTextStyle(),
                ),
                IconButton(
                    onPressed: widget.onDelete,
                    style: IconButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                        elevation: 0,
                        fixedSize: Size(16, 16),
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4)),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.grey,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
