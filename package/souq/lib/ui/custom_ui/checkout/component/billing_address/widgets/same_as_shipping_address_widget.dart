import 'package:flutter/material.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/billing_address/widgets/same_as_shipping_address_widget.dart';

class CustomSameAsShippingWidget extends StatelessWidget {
  const CustomSameAsShippingWidget({Key? key, required this.onCheckboxChanged})
      : super(key: key);
  final Function(bool) onCheckboxChanged;
  @override
  Widget build(BuildContext context) {
    return SameAsShippingAddressWidget(onCheckboxChanged: onCheckboxChanged);
  }
}
