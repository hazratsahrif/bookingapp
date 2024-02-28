import 'package:flutter/material.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import '../../../../../../../../core/vendor/utils/utils.dart';
import '../../../../../../config/ps_colors.dart';

class VendorExpiredWidget extends StatelessWidget {
  const VendorExpiredWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Utils.isLightMode(context)
              ? PsColors.warning50
              : PsColors.warning800,
          borderRadius: BorderRadius.circular(PsDimens.space8),
          border: Border.all(
              color: Utils.isLightMode(context)
                  ? PsColors.warning400
                  : PsColors.warning600)),
      padding: const EdgeInsets.all(20),
      child: Text('vendor_expired_text'.tr),
    );
  }
}
