import 'package:flutter/material.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/order_place/widgets/total_price_row.dart';
import 'package:psxmpc/ui/vendor_ui/common/ps_button_widget_with_round_corner.dart';

class OrderPlaceButtonWidget extends StatelessWidget {
  const OrderPlaceButtonWidget({Key? key, this.totalPrice, this.onPressed})
      : super(key: key);
  final String? totalPrice;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: double.infinity,
          height: PsDimens.space84,
          decoration: BoxDecoration(
            color: Utils.isLightMode(context)
                ? PsColors.achromatic50
                : PsColors.achromatic800,
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? PsColors.achromatic50
                    : PsColors.achromatic800),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(PsDimens.space12),
                topRight: Radius.circular(PsDimens.space12)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Utils.isLightMode(context)
                    ? PsColors.achromatic100
                    : PsColors.achromatic700,
                blurRadius: 10.0, // has the effect of softening the shadow
                spreadRadius: 0, // has the effect of extending the shadow
                offset: const Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                TotalPriceRowWidget(
                  totalPrice: totalPrice ?? '',
                ),
                PSButtonWidgetRoundCorner(
                  onPressed: onPressed,
                  titleText:
                      'check_out_place_order'.tr,
                  titleTextColor: PsColors.achromatic50,
                )
              ],
            ),
          )
          // CustomOtherUserActionsWidget(),
          ),
    );
  }
}
