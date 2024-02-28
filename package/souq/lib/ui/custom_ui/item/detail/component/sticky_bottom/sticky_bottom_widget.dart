import 'package:flutter/material.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/product_detail_and_address_intent_holder.dart';

import '../../../../../vendor_ui/item/detail/component/sticky_bottom/sticky_bottom_widget.dart';

class CustomStickyBottomWidget extends StatelessWidget {
  const CustomStickyBottomWidget({Key? key, this.productDetailAndAddress})
      : super(key: key);
  final ProductDetailAndAddress? productDetailAndAddress;
  @override
  Widget build(BuildContext context) {
    return StickyBottomWidget(
      productDetailAndAddress: productDetailAndAddress,
    );
  }
}
// class CustomStickyBottomWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StickyBottomWidget();
//   }
// }
