import 'package:flutter/material.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';

class TotalPriceRowWidget extends StatelessWidget {
  const TotalPriceRowWidget({Key? key, this.totalPrice}) : super(key: key);
  final String? totalPrice;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'transaction_detail__total'.tr,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(
          '\$ $totalPrice',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PsColors.text800),
        )
      ],
    );
  }
}
