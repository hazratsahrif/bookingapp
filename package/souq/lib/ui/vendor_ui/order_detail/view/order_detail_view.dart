import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';

import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/provider/order_detail/order_detail_provider.dart';
import 'package:psxmpc/core/vendor/repository/order_detail_repository.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/viewobject/common/ps_value_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/request_path_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/order_summary_detail.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/order_summary/order_summary.dart';
import 'package:psxmpc/ui/vendor_ui/common/base/ps_widget_with_appbar.dart';
import 'package:psxmpc/ui/vendor_ui/order_detail/component/user_info/widgets/order_id_date_widget.dart';
import 'package:psxmpc/ui/vendor_ui/order_detail/component/user_info/widgets/user_info_widget.dart';

class OrderDetailView extends StatelessWidget {
  OrderDetailView({Key? key, this.productDetailIntentHolder}) : super(key: key);
  late OrderDetailRepository repo1;
  final ProductDetailIntentHolder? productDetailIntentHolder;
  PsValueHolder? valueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  late AppLocalization langProvider;

  late OrderDetailProvider _orderDetailProvider;
  @override
  Widget build(BuildContext context) {
    langProvider = Provider.of<AppLocalization>(context);
    repo1 = Provider.of<OrderDetailRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    // ignore: always_specify_types
    return PsWidgetWithAppBar(
        initProvider: () {
          return OrderDetailProvider(repo: repo1);
        },
        appBarTitle:
            //  'Order Details',
            'order_details'.tr,
        onProviderReady: (OrderDetailProvider provider) {
          provider.loadData(
              requestPathHolder: RequestPathHolder(
                  loginUserId: Utils.checkUserLoginId(valueHolder),
                  languageCode: langProvider.currentLocale.languageCode,
                  orderId: productDetailIntentHolder!.orderId));
          _orderDetailProvider = provider;
        },
        builder: (BuildContext context, OrderDetailProvider provider,
            Widget? child) {
          // Scaffold(
          //     appBar: AppBar(
          //       title: const Text('Order Detail'),
          //     ),
          final OrderSummaryDetail? orderSummaryDetail =
              provider.orderSummaryModel.data?.orderSummaryDetail;

          if (provider.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: <Widget>[
                  OrderIdAndDateWidget(
                    date: orderSummaryDetail?.paymentDate,
                    id: orderSummaryDetail?.orderCode,
                  ),
                  UserInfoWidget(
                    title: 'home_search__product_name_hint'.tr,
                    values:
                        '${orderSummaryDetail?.shippingFirstName.toString()} ${orderSummaryDetail?.shippingLastName}',
                  ),
                  const Divider(),
                  UserInfoWidget(
                    title: 'edit_profile__email'.tr,
                    values: orderSummaryDetail?.shippingEmail,
                  ),
                  const Divider(),
                  UserInfoWidget(
                    isPayment: true,
                    title:
                        //  'Payment Method',
                        'check_out_payment_method'.tr,
                    values: orderSummaryDetail?.paymentMethod,
                    paid: orderSummaryDetail?.paymentStatus,
                  ),
                  const Divider(),
                  UserInfoWidget(
                      title: 'transaction_detail__shipping_address'.tr,
                      values:
                          '${orderSummaryDetail?.shippingFirstName.toString()} ${orderSummaryDetail?.shippingLastName}, ${orderSummaryDetail?.shippingPhoneNo} , ${orderSummaryDetail?.shippingEmail}, ${orderSummaryDetail?.shippingAddress}, ${orderSummaryDetail?.shippingCountry}, ${orderSummaryDetail?.shippingState}, ${orderSummaryDetail?.shippingCity}, ${orderSummaryDetail?.shippingPostalCode}'
                      // 'Guy HawKins, (+33)6 55 51 3035, guy.hawkins@example.com, 2972 Westheimer Rd,Country, State, City, 10004',
                      ),
                  const Divider(),
                  UserInfoWidget(
                      title: 'transaction_detail__billing_address'.tr,
                      values:
                          '${orderSummaryDetail?.billingFirstName.toString()} ${orderSummaryDetail?.billingLastName}, ${orderSummaryDetail?.billingPhoneNo} , ${orderSummaryDetail?.billingEmail}, ${orderSummaryDetail?.billingAddress}, ${orderSummaryDetail?.billingCountry}, ${orderSummaryDetail?.billingState}, ${orderSummaryDetail?.billingCity}, ${orderSummaryDetail?.billingPostalCode}'

                      // 'Guy HawKins, (+33)6 55 51 3035, guy.hawkins@example.com, 2972 Westheimer Rd,Country, State, City, 10004',
                      ),
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  OrderSummary(
                      userQty: int.tryParse(
                        orderSummaryDetail?.itemInfo?[0].quantity.toString() ??
                            '',
                      ),
                      isOrderDetail: true,
                      total: 'transaction_detail__total'.tr,
                      totalValue: orderSummaryDetail?.total ?? '',
                      defaultPhoto:
                          productDetailIntentHolder?.product?.defaultPhoto,
                      photoKey: productDetailIntentHolder?.product?.id,
                      currentPrice: orderSummaryDetail
                              ?.itemInfo?[0].originalPrice
                              .toString() ??
                          '',
                      subtotal: 'basket_list__sub_total'.tr,
                      subtotalValue: orderSummaryDetail?.itemInfo?[0].subTotal
                              .toString() ??
                          '',
                      discount: 'transaction_detail__discount'.tr,
                      discountValue: orderSummaryDetail
                              ?.itemInfo?[0].discountPrice
                              .toString() ??
                          '',
                      productDesciption: orderSummaryDetail
                              ?.itemInfo?[0].itemName
                              .toString() ??
                          '',
                      // product!.description.toString(),
                      // orderSummaryDetail?.iteminfo?[0].itemName ?? '',
                      title: orderSummaryDetail?.vendorName ?? ''),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
