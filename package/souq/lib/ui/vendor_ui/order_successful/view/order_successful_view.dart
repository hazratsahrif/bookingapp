import 'package:flutter/material.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/intent_holder/product_detail_intent_holder.dart';

import 'package:psxmpc/ui/vendor_ui/order_successful/component/widgets/order_successful_widget.dart';

class OrderSuccessfulView extends StatelessWidget {
  const OrderSuccessfulView({Key? key, this.productDetailIntentHolder})
      : super(key: key);
  final ProductDetailIntentHolder? productDetailIntentHolder;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OrderSuccessfulWidget(
      productDetailIntentHolder: productDetailIntentHolder,
    ));
  }
}
