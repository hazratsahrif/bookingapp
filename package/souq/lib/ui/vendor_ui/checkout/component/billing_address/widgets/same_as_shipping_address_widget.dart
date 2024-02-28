import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/provider/order_id/order_id_provider.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';

class SameAsShippingAddressWidget extends StatelessWidget {
  const SameAsShippingAddressWidget({Key? key, required this.onCheckboxChanged})
      : super(key: key);
  final Function(bool) onCheckboxChanged;
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderIdProvider>(
      builder: (BuildContext context, OrderIdProvider provider, Widget? child) {
        return Container(
          margin: const EdgeInsets.only(left: PsDimens.space1),
          child: Row(
            children: <Widget>[
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: PsColors.achromatic500,
                ),
                child: Checkbox(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(1)),
                  // side: BorderSide(color: PsColors.primary500),
                  checkColor: Utils.isLightMode(context)
                      ? PsColors.achromatic50
                      : PsColors.achromatic800,
                  activeColor: Theme.of(context).primaryColor,
                  value: provider.isSameAsShippingAddress,
                  onChanged: (bool? value) {
                    print(provider.isSameAsShippingAddress);
                    onCheckboxChanged(
                        provider.checkisSameAsShippingAddress(value ?? false));
                  },
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(left: PsDimens.space4),
                    height: PsDimens.space24,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Directionality.of(context) == TextDirection.ltr
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        // 'Same as shipping address',
                        'billing_address_same_shipping'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
