import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/price_widget.dart';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/package_data_model.dart';
import 'package:booking_system_flutter/product_module/provider/wish_list_provider.dart';

import 'package:booking_system_flutter/product_module/screens/product_details_screen.dart';
import 'package:booking_system_flutter/product_module/services/store_service.dart';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../product_module/models/product_data.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';

class ProductComponent extends StatefulWidget {
  final ProductData? productData;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;

  ProductComponent({
    this.productData,
    this.width,
    this.isBorderEnabled,
    this.isFavouriteService = false,
    this.onUpdate,
  });

  @override
  ProductComponentState createState() => ProductComponentState();
}

class ProductComponentState extends State<ProductComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.productData;
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ProductDetailsScreen(
          productId: product!.id!.toString(),
        ).launch(context);
        // ServiceDetailScreen(
        //         serviceId: widget.isFavouriteService
        //             ? widget.serviceData!.serviceId.validate().toInt()
        //             : widget.serviceData!.id.validate())
        //     .launch(context)
        //     .then((value) {
        //   setStatusBarColor(context.primaryColor);
        // });
      },
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(),
          backgroundColor: context.scaffoldBackgroundColor,
          border: widget.isBorderEnabled.validate(value: false)
              ? appStore.isDarkMode
                  ? Border.all(color: context.dividerColor)
                  : null
              : null,
        ),
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 110,
              width: context.width(),
              child: product?.productImages?.isEmpty ?? true
                  ? SizedBox()
                  : CachedImageWidget(
                      url: product!.productImages!.first.images!,
                      fit: BoxFit.cover,
                      height: 110,
                      width: context.width(),
                      circle: false,
                    ).cornerRadiusWithClipRRectOnly(
                      topRight: defaultRadius.toInt(),
                      topLeft: defaultRadius.toInt()),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product?.title ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: boldTextStyle(size: 10))
                              .paddingOnly(right: 16),
                        ],
                      ),
                    ),
                    8.width,
                    ValueListenableBuilder(
                        valueListenable: WishListProvider().wishList,
                        builder: (context, value, _) {
                          final isFav = value
                              .map(
                                (e) => e.productId ?? -1,
                              )
                              .contains(product?.id);
                          return GestureDetector(
                            onTap: () async {
                              appStore.setLoading(true);
                              await StoreService.toogleItem(
                                  product!.id.validate());
                              appStore.setLoading(false);
                            },
                            child: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              color: isFav ? Colors.pink : grey,
                              size: 16,
                            ),
                          );
                        }),
                  ],
                ).paddingSymmetric(
                  horizontal: 10.0,
                ),
                8.height,
                Text.rich(
                  TextSpan(children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.location_on,
                        color: grey,
                        size: 12,
                      ),
                    ),
                    WidgetSpan(
                      child: 4.width,
                    ),
                    TextSpan(
                        text: product?.address,
                        style: TextStyle(color: gray, fontSize: 8)),
                  ]),
                  maxLines: 1,
                ).paddingSymmetric(horizontal: 10.0),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Marquee(
                        child: PriceWidget(
                          price: double.parse(product!.price.validate()),
                          size: 14,
                          decimalPoint: 0,
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.yellow.shade700,
                          size: 10,
                        ),
                        4.width,
                        Text(
                          '3.4',
                          style: TextStyle(
                            color: gray,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                ).paddingSymmetric(horizontal: 10.0),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (product.user?.isVerifyProvider == 1)
                      Container(
                        height: 20,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/ic_verified.png',
                              height: 14,
                              width: 14,
                            ),
                            4.width,
                            Text(
                              language.verified,
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      timeAgoSinceDate(product?.createdAt).validate(),
                      style: TextStyle(
                        fontSize: 9,
                        color: context.primaryColor,
                      ),
                    )
                  ],
                ).paddingSymmetric(horizontal: 10.0),
                8.height,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
