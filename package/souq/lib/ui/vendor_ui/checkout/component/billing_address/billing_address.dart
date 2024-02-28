import 'package:flutter/material.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/product_detail_and_address_intent_holder.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/billing_address/widgets/billing_address_widget.dart';

class BillingAddressView extends StatelessWidget {
  const BillingAddressView({Key? key, this.productDetailAndAddress})
      : super(key: key);
  final ProductDetailAndAddress? productDetailAndAddress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            // const Text('Billing Address')
            Text('billing_address'.tr),
      ),
      body: BillingAddressWidget(
        productDetailAndAddress: productDetailAndAddress,
      ),
    );
  }
}
