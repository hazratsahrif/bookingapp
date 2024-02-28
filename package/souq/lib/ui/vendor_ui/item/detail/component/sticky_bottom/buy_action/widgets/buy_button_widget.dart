import 'package:flutter/material.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/ui/vendor_ui/common/ps_button_widget_with_round_corner.dart';

class BuyButtonWidget extends StatelessWidget {
  const BuyButtonWidget({Key? key, this.onPressed, this.colorData})
      : super(key: key);
  final void Function()? onPressed;
  final Color? colorData;

  @override
  Widget build(BuildContext context) {
    return PSButtonWidgetRoundCorner(
      width: PsDimens.space200,
      height: PsDimens.space40,
      colorData: colorData,
      titleText:
          //  'Buy Now',
          'product_buy_now'.tr,
      titleTextColor: PsColors.text300,
      titleTextAlign: TextAlign.center,
      onPressed: onPressed,
    );
  }
}
