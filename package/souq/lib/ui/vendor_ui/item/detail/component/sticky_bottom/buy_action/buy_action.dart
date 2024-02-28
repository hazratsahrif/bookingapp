import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/config/route/route_paths.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/provider/product/product_provider.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/product_detail_and_address_intent_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/product_relation.dart';
import 'package:psxmpc/ui/vendor_ui/common/dialog/error_dialog.dart';
import 'widgets/buy_button_widget.dart';
import 'widgets/quantity_widget.dart';

class BuyAction extends StatefulWidget {
  const BuyAction({Key? key, this.productDetailAndAddress}) : super(key: key);
  final ProductDetailAndAddress? productDetailAndAddress;

  @override
  State<BuyAction> createState() => _BuyActionState();
}

class _BuyActionState extends State<BuyAction> {
  late ItemDetailProvider itemDetailProvider;
  @override
  void initState() {
    super.initState();
    itemDetailProvider =
        Provider.of<ItemDetailProvider>(context, listen: false);

    // Move the state modifications to initState or another appropriate method
    itemDetailProvider.count =
        widget.productDetailAndAddress?.productDetailIntentHolder?.userQty ??
            itemDetailProvider.count;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemDetailProvider>(builder: (BuildContext context,
        ItemDetailProvider itemDetailProvider, Widget? child) {
      // itemDetailProvider.count =
      //     widget.productDetailAndAddress?.productDetailIntentHolder?.userQty ??
      //         itemDetailProvider.count;

      itemDetailProvider.product.productRelation?.forEach(
        (ProductRelation element) {
          if (element.coreKeyId == 'ps-itm00010') {
            itemDetailProvider.quantity =
                int.tryParse(element.selectedValues![0].value.toString());
          }
        },
      );

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: PsDimens.space16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if ((itemDetailProvider.product.isSoldOutItem != true ||
                        itemDetailProvider.quantity != null) &&
                    (itemDetailProvider.quantity != null &&
                        itemDetailProvider.count.toDouble() > 1))
                  itemDetailProvider.decrement();
                widget.productDetailAndAddress?.productDetailIntentHolder
                    ?.userQty = itemDetailProvider.count;
              },
              child: QuantityWidget(
                  icon: Icons.remove,
                  color: (itemDetailProvider.product.isSoldOutItem == true ||
                              itemDetailProvider.quantity == null) ||
                          (itemDetailProvider.quantity != null &&
                              itemDetailProvider.count == 1)
                      ? PsColors.achromatic100
                      : PsColors.primary500),
            ),
            Text(
              itemDetailProvider.count.toString(),
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            GestureDetector(
              onTap: () {
                if ((itemDetailProvider.product.isSoldOutItem != true ||
                        itemDetailProvider.quantity != null) &&
                    (itemDetailProvider.quantity != null &&
                        itemDetailProvider.quantity!.toDouble() >
                            itemDetailProvider.count.toDouble()))
                  itemDetailProvider.increment();
                widget.productDetailAndAddress?.productDetailIntentHolder
                    ?.userQty = itemDetailProvider.count;
              },
              child: QuantityWidget(
                  icon: Icons.add,
                  color: (itemDetailProvider.product.isSoldOutItem == true ||
                              itemDetailProvider.quantity == null) ||
                          (itemDetailProvider.quantity != null &&
                              itemDetailProvider.count.toDouble() >=
                                  itemDetailProvider.quantity!.toDouble())
                      ? PsColors.achromatic100
                      : PsColors.primary500),
            ),
            BuyButtonWidget(
              onPressed: () {
                if (itemDetailProvider.product.isSoldOutItem == true) {
                  
                } else if(itemDetailProvider.quantity == null){
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message:
                              "you_are_unable_to_purchase_this_item".tr,
                        );
                      });
                } else {
                  Utils.navigateOnUserVerificationView(context, () {
                    final ProductDetailAndAddress holder =
                        ProductDetailAndAddress(
                            productDetailIntentHolder:
                                ProductDetailIntentHolder(
                                    currentPrice:
                                        itemDetailProvider.product.currentPrice,
                                    product: itemDetailProvider.product,
                                    productId: itemDetailProvider.product.id,
                                    userQty: itemDetailProvider.count,
                                    stockQty: itemDetailProvider.quantity),
                            shippingAddressHolder: widget
                                .productDetailAndAddress?.shippingAddressHolder,
                            billingAddressHolder: widget
                                .productDetailAndAddress?.billingAddressHolder);
                    Navigator.pushNamed(context, RoutePaths.checkout,
                        arguments: holder);
                  });
                }
              },
              colorData: itemDetailProvider.product.isSoldOutItem == true
                  ? PsColors.achromatic100
                  : PsColors.primary500,
            )
          ],
        ),
      );
    });
  }
}
