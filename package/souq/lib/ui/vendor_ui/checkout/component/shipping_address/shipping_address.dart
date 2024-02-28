import 'package:flutter/material.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/product_detail_and_address_intent_holder.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/shipping_address/widgets/shipping_address_widget.dart';

class ShippingAddressView extends StatelessWidget {
  const ShippingAddressView({Key? key, this.productDetailAndAddress})
      : super(key: key);
  // final ShippingAddressHolder? shippingAddressHolder;
  // final String? productId;
  final ProductDetailAndAddress? productDetailAndAddress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            // const Text('Shipping Address')
            Text('shipping_address'.tr),
      ),
      body: ShippingAddressWidget(
        productDetailAndAddress: productDetailAndAddress,
        // productId: productId,
        // shippingAddressHolder: shippingAddressHolder,
      ),
    );
  }
}
