import 'package:flutter/material.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';

class SaveAddressNextTimeWidget extends StatelessWidget {
  const SaveAddressNextTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              value: true,
              //  provider.isAggreTermsAndPolicy,
              onChanged: (bool? value) {
                // updateCheckBox(context);
              },
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: () {
                // Navigator.pushNamed(context, RoutePaths.privacyPolicy);
              },
              child: Container(
                padding: const EdgeInsets.only(left: PsDimens.space4),
                height: PsDimens.space24,
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    // 'Save this address for next time',
                    'save_address_next_time'.tr,
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
  }
}
