import 'package:flutter/material.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/core/vendor/constant/ps_constants.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/viewobject/default_photo.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/order_summary/widgets/subtotal_discount.dart';
import 'package:psxmpc/ui/vendor_ui/common/ps_ui_widget.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary(
      {Key? key,
      this.subtotal,
      this.subtotalValue,
      this.discount,
      this.discountValue,
      this.productDesciption,
      this.defaultPhoto,
      this.photoKey,
      this.stockQty,
      this.userQty,
      this.currentPrice,
      this.title,
      this.isOrderDetail,
      this.total,
      this.totalValue,
      this.onTap})
      : super(key: key);
  final String? subtotal;
  final String? subtotalValue;
  final String? discount;
  final String? discountValue;
  final String? currentPrice;
  final DefaultPhoto? defaultPhoto;
  final int? userQty;
  final int? stockQty;
  final String? photoKey;
  final String? productDesciption;
  final String? title;
  final bool? isOrderDetail;
  final String? total;
  final String? totalValue;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? '',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
        Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space16, bottom: PsDimens.space4),
          width: double.infinity,
          height: PsDimens.space100,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: PsDimens.space6),
                  child: PsNetworkImage(
                    photoKey: photoKey,
                    //  value.product.id,
                    defaultPhoto: defaultPhoto,
                    // value.product.defaultPhoto,
                    imageAspectRation: PsConst.Aspect_Ratio_3x,
                    width: PsDimens.space100,
                    height: PsDimens.space100,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (isOrderDetail == true)
                        Container()
                      else
                        stockQty! < 10
                            ? //
                            Text(
                                'Only $stockQty Items In Stock',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),
                              )
                            : Container(),
                      Expanded(
                        child: Text(
                          productDesciption ?? '',
                          // value.product.description.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: PsColors.text500),
                        ),
                      ),
                      Expanded(child: Text('Qty: $userQty X')),
                      if (isOrderDetail == true)
                        Container()
                      else
                        Flexible(
                          //
                          child: GestureDetector(
                            onTap: onTap,
                            child: Text(
                              // 'Edit',
                              'check_out_edit'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: PsColors.primary500),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text('${currentPrice?.toString() ?? ''}'),
                )
              ]),
        ),
        const Divider(),
        SubTotalDiscount(
          title: subtotal ?? '',
          values: subtotalValue ?? '',
          isDiscount: false,
        ),
        SubTotalDiscount(
          title: discount ?? '',
          values: discountValue ?? '',
          isDiscount: true,
        ),
        const Divider(),
        if (isOrderDetail == true)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                total ?? '',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: PsColors.text600),
              ),
              Text(
                totalValue ?? '',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: PsColors.text600),
              ),
            ],
          )
        // SubTotalDiscount(
        //   title: total ?? '',
        //   values: totalValue ?? '',
        //   isDiscount: false,
        // )
        else
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text:
                    // 'By clicking place order, I have read and agreed to',
                    'check_out_aggree'.tr,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: PsColors.text800),
              ),
              TextSpan(
                text:
                    //  ' terms and conditions, Privacy Policy.',
                    'check_out_policy'.tr,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: PsColors.primary500),
              )
            ]),
          )
      ],
    );
  }
}
