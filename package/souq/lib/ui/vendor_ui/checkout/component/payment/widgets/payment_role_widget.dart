import 'package:flutter/material.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';

class PaymentRoleWidget extends StatelessWidget {
  const PaymentRoleWidget(
      {Key? key,
      required this.image,
      required this.paymentName,
      this.groupValue,
      this.isSelected,
      this.onChanged,
      this.value})
      : super(key: key);
  final Image image;
  final String paymentName;
  final int? value;
  final int? groupValue;
  final bool? isSelected;
  final void Function(int?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: PsDimens.space10),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 0, left: PsDimens.space16),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1,
              color: isSelected == true
                  ? PsColors.primary500
                  : PsColors.achromatic100),
          borderRadius: BorderRadius.circular(PsDimens.space4),
        ),
        leading: Container(
            width: PsDimens.space40, height: PsDimens.space40, child: image),
        title: Text(
          paymentName,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: Radio<int?>(
          activeColor: PsColors.primary500,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
