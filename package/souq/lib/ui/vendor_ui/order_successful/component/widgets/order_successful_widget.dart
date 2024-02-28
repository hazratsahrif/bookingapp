import 'package:flutter/material.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/config/route/route_paths.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/intent_holder/product_detail_intent_holder.dart';

import 'package:psxmpc/ui/vendor_ui/common/ps_button_widget_with_round_corner.dart';
import 'package:psxmpc/ui/vendor_ui/order_successful/component/widgets/order_success_photo_widget.dart';

class OrderSuccessfulWidget extends StatelessWidget {
  const OrderSuccessfulWidget({Key? key, this.productDetailIntentHolder})
      : super(key: key);
  final ProductDetailIntentHolder? productDetailIntentHolder;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.close,
                      color: Utils.isLightMode(context)
                          ? PsColors.text800
                          : PsColors.text50,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(RoutePaths.home);
                    }
                    // onClose,
                    ),
              ],
            ),
            const SizedBox(
              height: PsDimens.space104,
            ),

            OrderSuccessfulPhotoWidget(),
            const SizedBox(
              height: PsDimens.space10,
            ),
            Text(
                // 'Order Successfully Completed',
                'order_successfully_completed'.tr,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Utils.isLightMode(context)
                        ? PsColors.text800
                        : PsColors.achromatic50)),
            const SizedBox(
              height: PsDimens.space20,
            ),
            Text(
                // 'Your order has been successfully completed. An order confirmation email will be sent to you shortly. We hope you enjoy your purchase.',
                'order_successfully_completed_message'.tr,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: PsColors.text400)),
            const SizedBox(
              height: PsDimens.space20,
            ),
            PSButtonWidgetRoundCorner(
              titleTextColor: Utils.isLightMode(context)
                  ? PsColors.text50
                  : PsColors.text50,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(RoutePaths.home);
              },
              titleText:
                  //  'Continue Shopping'
                  'order_successful_continue_shopping'.tr,
            ),
            const SizedBox(
              height: PsDimens.space20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(RoutePaths.orderDetail,
                    arguments: productDetailIntentHolder);
              },
              child: Text(
                // 'View Order Details',
                'order_successful_order_detail'.tr,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: PsColors.primary500),
              ),
            )
            // CustomSelectCityWidget(
            //     searchCityNameController: searchCityNameController,
            //     searchTownshipNameController: searchTownshipNameController),
            // if (valueHolder.isSubLocation == PsConst.ONE)
            //   CustomSelectTownshipWidget(
            //       searchTownshipNameController:
            //           searchTownshipNameController),
            // CustomExploreWidget(),
          ],
        ),
      ),
    );
  }
}
