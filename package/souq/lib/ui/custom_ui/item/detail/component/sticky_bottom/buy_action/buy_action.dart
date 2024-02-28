import 'package:flutter/material.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/product_detail_and_address_intent_holder.dart';
import 'package:psxmpc/ui/vendor_ui/item/detail/component/sticky_bottom/buy_action/buy_action.dart';

class CustomBuyAction extends StatelessWidget {
  const CustomBuyAction({Key? key, this.productDetailAndAddress})
      : super(key: key);
  final ProductDetailAndAddress? productDetailAndAddress;
  @override
  Widget build(BuildContext context) {
    return BuyAction(
      productDetailAndAddress: productDetailAndAddress,
    );
  }
}
