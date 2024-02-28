import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:psxmpc/config/route/route_paths.dart';
import 'package:psxmpc/core/vendor/api/common/ps_resource.dart';
import 'package:psxmpc/core/vendor/api/ps_api_service.dart';
import 'package:psxmpc/core/vendor/constant/ps_constants.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/app_info/app_info_provider.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/provider/order_id/order_id_provider.dart';
import 'package:psxmpc/core/vendor/provider/product/product_provider.dart';
import 'package:psxmpc/core/vendor/provider/user/user_provider.dart';
import 'package:psxmpc/core/vendor/provider/vendor_item_bought/vendor_item_bought_provider.dart';
import 'package:psxmpc/core/vendor/provider/vendor_paypal_token/vendor_paypal_token_provider.dart';
import 'package:psxmpc/core/vendor/repository/app_info_repository.dart';
import 'package:psxmpc/core/vendor/repository/order_id_repository.dart';
import 'package:psxmpc/core/vendor/repository/product_repository.dart';
import 'package:psxmpc/core/vendor/repository/user_repository.dart';
import 'package:psxmpc/core/vendor/repository/vendor_item_bought_repository.dart';
import 'package:psxmpc/core/vendor/repository/vendor_paypal_token_repository.dart';
import 'package:psxmpc/core/vendor/utils/ps_progress_dialog.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/viewobject/common/ps_value_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/app_info_parameter_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/billing_address_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/order_and_billing_parameter_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/product_detail_and_address_intent_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/request_path_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/shipping_address_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/vendor_item_bought_parameter_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/item_info.dart';
import 'package:psxmpc/core/vendor/viewobject/order_id.dart';
import 'package:psxmpc/core/vendor/viewobject/product.dart';
import 'package:psxmpc/core/vendor/viewobject/product_relation.dart';
import 'package:psxmpc/core/vendor/viewobject/vendor_item_bought_status.dart';
import 'package:psxmpc/core/vendor/viewobject/vendor_paypal_token.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/billing_address/widgets/address_tile_widget.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/order_place/widgets/order_place_button.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/order_summary/order_summary.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/payment/widgets/payment_role_widget.dart';
import 'package:psxmpc/ui/vendor_ui/common/dialog/check_item_dialog.dart';

import 'package:psxmpc/ui/vendor_ui/common/dialog/warning_dialog_view.dart';

// ignore: must_be_immutable
class CheckoutView extends StatelessWidget {
  CheckoutView({Key? key, this.productDetailAndAddress}) : super(key: key);

  final ProductDetailAndAddress? productDetailAndAddress;

  OrderIdRepository? orderIdRepository;
  VendorPaypalTokenRepository? vendorPaypalTokenRepository;
  VendorItemBoughtRepository? vendorItemBoughtRepository;
  AppInfoRepository? appInfoRepository;
  VendorPayPalTokenProvider? vendorPayPalTokenProvider;
  VendorItemBoughtProvider? vendorItemBoughtProvider;
  ItemDetailProvider? itemDetailProvider;
  ProductRepository? productRepository;
  UserRepository? userRepository;
  OrderIdProvider? orderIdProvider;
  AppInfoProvider? appInfoProvider;
  UserProvider? userProvider;
  int? quan;
  PsValueHolder? psValueHolder;
  PsApiService? psApiService;

  @override
  Widget build(BuildContext context) {
    
    final String? discountTotal = (
      (double.parse(productDetailAndAddress
                ?.productDetailIntentHolder?.product?.originalPrice
                .toString() ??
            '0') -
      double.parse(productDetailAndAddress
                ?.productDetailIntentHolder?.currentPrice
                .toString() ??
            '0')) *
        int.parse(productDetailAndAddress?.productDetailIntentHolder?.userQty
                .toString() ??
            '0')
            ).toStringAsFixed(2).toString();

    final String? subTotal =
        (double.parse(productDetailAndAddress
                ?.productDetailIntentHolder?.currentPrice
                .toString() ??
            '0') *
        int.parse(productDetailAndAddress?.productDetailIntentHolder?.userQty
                .toString() ??
            '0')).toStringAsFixed(2).toString();

    final String? totalPrice =
        (double.parse(productDetailAndAddress
                ?.productDetailIntentHolder?.currentPrice
                .toString() ??
            '0') *
        int.parse(productDetailAndAddress?.productDetailIntentHolder?.userQty
                .toString() ??
            '0')).toStringAsFixed(2).toString();

    final ShippingAddressHolder? shippingAddressHolder = ShippingAddressHolder(
      address: productDetailAndAddress?.shippingAddressHolder?.address,
      city: productDetailAndAddress?.shippingAddressHolder?.city,
      country: productDetailAndAddress?.shippingAddressHolder?.country,
      lastName: productDetailAndAddress?.shippingAddressHolder?.lastName,
      email: productDetailAndAddress?.shippingAddressHolder?.email,
      firstName: productDetailAndAddress?.shippingAddressHolder?.firstName,
      postalCode: productDetailAndAddress?.shippingAddressHolder?.postalCode,
      code: productDetailAndAddress?.shippingAddressHolder?.code,
      state: productDetailAndAddress?.shippingAddressHolder?.state,
      phone: productDetailAndAddress?.shippingAddressHolder?.phone,
    );
    final BillingAddressHolder? billingAddressHolder = BillingAddressHolder(
      address: productDetailAndAddress?.billingAddressHolder?.address,
      city: productDetailAndAddress?.billingAddressHolder?.city,
      country: productDetailAndAddress?.billingAddressHolder?.country,
      lastName: productDetailAndAddress?.billingAddressHolder?.lastName,
      email: productDetailAndAddress?.billingAddressHolder?.email,
      firstName: productDetailAndAddress?.billingAddressHolder?.firstName,
      postalCode: productDetailAndAddress?.billingAddressHolder?.postalCode,
      code: productDetailAndAddress?.billingAddressHolder?.code,
      state: productDetailAndAddress?.billingAddressHolder?.state,
      phone: productDetailAndAddress?.billingAddressHolder?.phone,
    );
    final ProductDetailIntentHolder? productDetailIntentHolder =
        ProductDetailIntentHolder(
      productId: productDetailAndAddress?.productDetailIntentHolder?.productId,
      stockQty: productDetailAndAddress?.productDetailIntentHolder?.stockQty,
      product: productDetailAndAddress?.productDetailIntentHolder?.product,
      currentPrice:
          productDetailAndAddress?.productDetailIntentHolder?.currentPrice,
      userQty: productDetailAndAddress?.productDetailIntentHolder?.userQty,
    );

    orderIdRepository = Provider.of<OrderIdRepository>(context);
    vendorItemBoughtRepository =
        Provider.of<VendorItemBoughtRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    psValueHolder = Provider.of<PsValueHolder>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);
    psApiService = Provider.of<PsApiService>(context);
    userRepository = Provider.of<UserRepository>(context);
    vendorPaypalTokenRepository =
        Provider.of<VendorPaypalTokenRepository>(context);
    final ProductRepository productRepository =
        Provider.of<ProductRepository>(context);

    final AppLocalization langProvider =
        Provider.of<AppLocalization>(context, listen: false);
    final AppInfoParameterHolder appInfoParameterHolder =
        AppInfoParameterHolder(
            languageCode: langProvider.currentLocale.languageCode,
            countryCode: langProvider.currentLocale.countryCode);
    // final AppInfoProvider appInfoProvider =
    //     Provider.of<AppInfoProvider>(context);
    // final UserProvider? userProvider = Provider.of<UserProvider>(context);
    bool isShippingDataNull(dynamic shippingOrBillingholder){
        if(
          shippingOrBillingholder.firstName == null ||shippingOrBillingholder.lastName==null||
          shippingOrBillingholder.address == null ||shippingOrBillingholder.city==null||
          shippingOrBillingholder.code == null ||shippingOrBillingholder.country==null||
          shippingOrBillingholder.email == null ||shippingOrBillingholder.phone==null||
          shippingOrBillingholder.postalCode == null ||shippingOrBillingholder.state==null
        ){
            return true;
        }
      return false;
    }
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<OrderIdProvider?>(
            lazy: false,
            create: (BuildContext context) {
              orderIdProvider = OrderIdProvider(repo: orderIdRepository);

              return orderIdProvider;
            }),
        ChangeNotifierProvider<UserProvider?>(
          lazy: false,
          create: (BuildContext context) {
            userProvider = UserProvider(
                repo: userRepository, psValueHolder: psValueHolder);

            userProvider!.getUser(psValueHolder!.loginUserId,
                langProvider.currentLocale.languageCode);

            return userProvider;
          },
        ),
        ChangeNotifierProvider<AppInfoProvider?>(
            lazy: false,
            create: (BuildContext context) {
              appInfoProvider = AppInfoProvider(
                  repo: appInfoRepository, psValueHolder: psValueHolder);

              appInfoProvider!
                  .loadDeleteHistorywithNotifier(appInfoParameterHolder);

              return appInfoProvider;
            }),
        ChangeNotifierProvider<VendorPayPalTokenProvider?>(
            lazy: false,
            create: (BuildContext context) {
              vendorPayPalTokenProvider =
                  VendorPayPalTokenProvider(repo: vendorPaypalTokenRepository);

              return vendorPayPalTokenProvider;
            }),
        ChangeNotifierProvider<VendorItemBoughtProvider?>(
            lazy: false,
            create: (BuildContext context) {
              vendorItemBoughtProvider = VendorItemBoughtProvider(
                  vendorItemBoughtRepository: vendorItemBoughtRepository);

              return vendorItemBoughtProvider;
            }),
        ChangeNotifierProvider<ItemDetailProvider?>(
            lazy: false,
            create: (BuildContext context) {
              itemDetailProvider = ItemDetailProvider(
                  repo: productRepository, psValueHolder: psValueHolder);

              return itemDetailProvider;
            }),
      ],
      child: Consumer5<OrderIdProvider, UserProvider, AppInfoProvider,
          VendorPayPalTokenProvider, ItemDetailProvider>(
        builder: (BuildContext context,
                OrderIdProvider value,
                UserProvider userProvider,
                AppInfoProvider appInfoProvider,
                VendorPayPalTokenProvider vendorPayPalTokenProvider,
                ItemDetailProvider itemDetailProvider,
                Widget? child) {
                          return Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  title:
                      // Text('Checkout'),
                      Text('check_out'.tr),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RoutePaths.productDetail,
                            (Route<dynamic> route) => false,
                            arguments: productDetailAndAddress);
                      },
                      icon: const Icon(Icons.arrow_back)),
                ),
                body: Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: PsDimens.space16),
                    child: ListView(
                      children: <Widget>[
                        Text(
                            // 'Delivery Information',
                            'check_out_deli_info'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                        AddressTileWidget(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  RoutePaths.shippingAddress,
                                  arguments: ProductDetailAndAddress(
                                      productDetailIntentHolder:
                                          productDetailIntentHolder,
                                      shippingAddressHolder:
                                          productDetailAndAddress
                                              ?.shippingAddressHolder,
                                      billingAddressHolder:
                                          productDetailAndAddress
                                              ?.billingAddressHolder));
                            },
                            titleAddress:
                                // 'Shipping Address',
                                'shipping_address'.tr,
                            subtitleAddress: productDetailAndAddress
                                        ?.shippingAddressHolder ==
                                    null
                                ? ''
                                : '${productDetailAndAddress?.shippingAddressHolder?.firstName} ${productDetailAndAddress?.shippingAddressHolder?.lastName},(${productDetailAndAddress?.shippingAddressHolder?.code})${productDetailAndAddress?.shippingAddressHolder?.phone},${productDetailAndAddress?.shippingAddressHolder?.email},${productDetailAndAddress?.shippingAddressHolder?.address},${productDetailAndAddress?.shippingAddressHolder?.country},${productDetailAndAddress?.shippingAddressHolder?.state},${productDetailAndAddress?.shippingAddressHolder?.city},${productDetailAndAddress?.shippingAddressHolder?.postalCode}, '
                
                            // productDetailAndAddress
                            //         ?.shippingAddressHolder?.code ??
                            //     ''
                            ),
                        const Divider(),
                        AddressTileWidget(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  RoutePaths.billingAddress,
                                  arguments: ProductDetailAndAddress(
                                      productDetailIntentHolder:
                                          productDetailIntentHolder,
                                      shippingAddressHolder:
                                          shippingAddressHolder,
                                      billingAddressHolder:
                                          billingAddressHolder));
                            },
                            titleAddress:
                                // 'Billing Address',
                                'billing_address'.tr,
                            subtitleAddress: productDetailAndAddress
                                        ?.billingAddressHolder ==
                                    null
                                ? ''
                                : '${productDetailAndAddress?.billingAddressHolder?.firstName} ${productDetailAndAddress?.billingAddressHolder?.lastName},(${productDetailAndAddress?.billingAddressHolder?.code})${productDetailAndAddress?.billingAddressHolder?.phone},${productDetailAndAddress?.billingAddressHolder?.email},${productDetailAndAddress?.billingAddressHolder?.address},${productDetailAndAddress?.billingAddressHolder?.country},${productDetailAndAddress?.billingAddressHolder?.state},${productDetailAndAddress?.billingAddressHolder?.city},${productDetailAndAddress?.billingAddressHolder?.postalCode}, '
                            // productDetailAndAddress
                            //         ?.billingAddressHolder?.code ??
                            //     ''
                            ),
                        Text(
                            // 'Payment Method',
                            'check_out_payment_method'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                        PaymentRoleWidget(
                            // ignore: avoid_bool_literals_in_conditional_expressions
                            isSelected: value.selectedValue == 1 ? true : false,
                            value: 1,
                            groupValue: value.selectedValue,
                            onChanged: (int? a) {
                              value.updateSelectedValue(a!);
                            },
                            image:
                                Image.asset('assets/images/payment/paypal.png'),
                            paymentName: 'item_promote__paypal'.tr),
                        // PaymentRoleWidget(
                        //     isSelected: value.selectedValue == 2 ? true : false,
                        //     value: 2,
                        //     groupValue: value.selectedValue,
                        //     onChanged: (int? a) {
                        //       value.updateSelectedValue(a!);
                        //     },
                        //     image:
                        //         Image.asset('assets/images/payment/stripe.png'),
                        //     paymentName: 'item_promote__stripe'.tr),
                        // PaymentRoleWidget(
                        //     value: 3,
                        //     isSelected: value.selectedValue == 3 ? true : false,
                        //     groupValue: value.selectedValue,
                        //     onChanged: (int? a) {
                        //       value.updateSelectedValue(a!);
                        //     },
                        //     image:
                        //         Image.asset('assets/images/payment/razor.png'),
                        //     paymentName: 'item_promote__razor'.tr),
                        // PaymentRoleWidget(
                        //     value: 4,
                        //     isSelected: value.selectedValue == 4 ? true : false,
                        //     groupValue: value.selectedValue,
                        //     onChanged: (int? a) {
                        //       value.updateSelectedValue(a!);
                        //     },
                        //     image: Image.asset(
                        //         'assets/images/payment/paystack.png'),
                        //     paymentName: 'Paystack'),
                        const SizedBox(
                          height: PsDimens.space20,
                        ),
                        OrderSummary(
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RoutePaths.productDetail,
                                (Route<dynamic> route) => false,
                                arguments: productDetailAndAddress);
                          },
                          title:
                              // 'Order Summary',
                              'check_out_order_summary'.tr,
                          currentPrice:
                              '\$ ${productDetailAndAddress?.productDetailIntentHolder?.currentPrice}',
                          stockQty: productDetailAndAddress
                              ?.productDetailIntentHolder?.stockQty,
                          defaultPhoto: productDetailAndAddress
                              ?.productDetailIntentHolder
                              ?.product
                              ?.defaultPhoto,
                          photoKey: productDetailAndAddress
                              ?.productDetailIntentHolder?.product?.id,
                          subtotal: 'basket_list__sub_total'.tr,
                          discount: 'transaction_detail__discount'.tr,
                          subtotalValue: subTotal,
                          discountValue: discountTotal,
                          productDesciption: productDetailAndAddress
                                  ?.productDetailIntentHolder?.product?.title ??
                              '',
                          userQty: productDetailAndAddress
                              ?.productDetailIntentHolder?.userQty,
                        ),
                        const SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                  ),
                  OrderPlaceButtonWidget(
                      onPressed: () async {
                
                        if (value.selectedValue != 1) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return WarningDialog(
                                  message:
                                      // 'Please select payment method'
                                      'check_out_need_payment_method'.tr,
                                );
                              });
                        }else if(isShippingDataNull(shippingAddressHolder)== true) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return   WarningDialog(
                                  message:
                                       'shipping_need_address'.tr
                                     // 'check_out_need_payment_method'.tr,
                                );
                              });
                        }else if(isShippingDataNull(billingAddressHolder)== true) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return  WarningDialog(
                                  message:
                                       'shipping_need_address'.tr
                                     // 'check_out_need_payment_method'.tr,
                                );
                              });
                        }
                        
                        else {
                          final PsResource<Product> pro =
                              await itemDetailProvider.onlyCheckItemBought(
                                  requestPathHolder: RequestPathHolder(
                            loginUserId: psValueHolder?.loginUserId,
                            itemId: productDetailAndAddress
                                ?.productDetailIntentHolder?.productId,
                            languageCode: psValueHolder?.languageCode ?? 'en',
                          ));
                
                          ///
                
                          pro.data?.productRelation
                              ?.forEach((ProductRelation element) {
                            if (element.coreKeyId == 'ps-itm00010') {
                              quan = int.parse(
                                  element.selectedValues![0].value.toString());
                            }
                          });
                          final int? userQty = productDetailAndAddress
                              ?.productDetailIntentHolder?.userQty;
                
                          if (pro.data?.isSoldOutItem == true) {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return CheckOutDialog(
                                    title:
                                        //  'Sold Out',
                                        'dashboard__sold_out'.tr,
                                    message:
                                        // "The item you're trying to purchase is sold out. Please pick another available item for your order."
                                        'check_out_sold_out_message'.tr,
                                  );
                                });
                          } else if (userQty != null && userQty > quan!) {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return CheckOutDialog(
                                    title:
                                        'check_out_limt_item'.tr,
                                    message:
                                        // 'There is not enough stock to fulfill your requested quantity. Please adjust your order quantity.'
                                        'check_out_limit_item_message'.tr,
                                  );
                                });
                          } else {
                            final PsResource<OrderId> data =
                                await value.postData(
                              requestBodyHolder: OrderAndBillingParameterHolder(
                                  vendorId: productDetailAndAddress
                                      ?.productDetailIntentHolder
                                      ?.product
                                      ?.vendorId,
                                  billingAddress: productDetailAndAddress
                                      ?.billingAddressHolder?.address,
                                  shippingAddress: productDetailAndAddress
                                      ?.shippingAddressHolder?.address,
                                  billingCity: productDetailAndAddress
                                      ?.billingAddressHolder?.city,
                                  billingCountry: productDetailAndAddress
                                      ?.billingAddressHolder?.country,
                                  billingEmail: productDetailAndAddress
                                      ?.billingAddressHolder?.email,
                                  billingFirstName: productDetailAndAddress
                                      ?.billingAddressHolder?.firstName,
                                  billingLastName: productDetailAndAddress
                                      ?.billingAddressHolder?.lastName,
                                  billingPhoneNo:
                                      '${productDetailAndAddress?.billingAddressHolder?.code}${productDetailAndAddress?.billingAddressHolder?.phone} ',
                                  billingPostalCode: productDetailAndAddress
                                      ?.billingAddressHolder?.postalCode,
                                  billingState: productDetailAndAddress?.billingAddressHolder?.state,
                                  isSaveBillingInfoForNextTime: '0',
                                  isSaveShippingInfoForNextTime: '0',
                                  shippingCity: productDetailAndAddress?.shippingAddressHolder?.city,
                                  shippingCountry: productDetailAndAddress?.shippingAddressHolder?.country,
                                  shippingEmail: productDetailAndAddress?.shippingAddressHolder?.email,
                                  shippingFirstName: productDetailAndAddress?.shippingAddressHolder?.firstName,
                                  shippingLastName: productDetailAndAddress?.shippingAddressHolder?.lastName,
                                  shippingPhoneNo: '${productDetailAndAddress?.shippingAddressHolder?.code}${productDetailAndAddress?.shippingAddressHolder?.phone}',
                                  shippingPostalCode: productDetailAndAddress?.shippingAddressHolder?.postalCode,
                                  shippingState: productDetailAndAddress?.shippingAddressHolder?.state,
                                  totalPrice: subTotal,
                                  itemInfo: <ItemInfo>[
                                    ItemInfo(
                                        itemId: productDetailIntentHolder
                                            ?.product?.id,
                                        //  productDetailAndAddress
                                        //     ?.productDetailIntentHolder?.productId,
                                        quantity: productDetailAndAddress
                                            ?.productDetailIntentHolder?.userQty
                                            .toString(),
                                        originalPrice: productDetailAndAddress
                                            ?.productDetailIntentHolder
                                            ?.product
                                            ?.originalPrice,
                                        // itemName: '',
                                        salePrice: productDetailAndAddress
                                            ?.productDetailIntentHolder
                                            ?.product
                                            ?.currentPrice,
                                        subTotal: subTotal,
                                        discountPrice: discountTotal)
                                  ]),
                              requestPathHolder: RequestPathHolder(
                                  loginUserId: psValueHolder!.loginUserId,
                                  languageCode: psValueHolder!.languageCode,
                                  headerToken: psValueHolder!.headerToken),
                            );
                
                            if (data.data?.orderId != null) {
                              productDetailAndAddress?.productDetailIntentHolder
                                  ?.orderId = data.data?.orderId;
                              final PsResource<VendorPaypalToken>?
                                  tokenResource =
                                  await vendorPayPalTokenProvider.loadToken(
                                      psValueHolder!.loginUserId!,
                                      productDetailAndAddress!
                                          .productDetailIntentHolder!
                                          .product!
                                          .vendorId,
                                      psValueHolder!.headerToken!);
                              final String? message =
                                  tokenResource?.data?.message;
                              final BraintreeDropInRequest request =
                                  BraintreeDropInRequest(
                                clientToken: message,
                                collectDeviceData: true,
                                googlePaymentRequest:
                                    BraintreeGooglePaymentRequest(
                                  totalPrice: totalPrice ?? '',
                                  currencyCode: appInfoProvider
                                      .appInfo.data!.currencyShortForm!,
                                  billingAddressRequired: false,
                                ),
                                paypalRequest: BraintreePayPalRequest(
                                  amount: totalPrice,
                                  displayName: userProvider.user.data?.name,
                                ),
                              );
                              final BraintreeDropInResult? result =
                                  await BraintreeDropIn.start(request);
                              if (result != null) {
                                print(
                                    'Nonce: ${result.paymentMethodNonce.nonce}');
                              } else {
                                print('Selection was canceled.');
                              }
                              Utils.psPrint(message);
                
                              // final int reultStartTimeStamp =
                              //     Utils.getTimeStampDividedByOneThousand(time!);
                
                              // ignore: unnecessary_null_comparison
                              // if (vendorItemBoughtProvider != null) {
                              // final ItemPaidHistoryParameterHolder
                              //     itemPaidHistoryParameterHolder = ItemPaidHistoryParameterHolder(
                              //         itemId: product.id,
                              //         amount: amount,
                              //         howManyDay: chooseDay,
                              // paymentMethod: PsConst.PAYMENT_PAYPAL_METHOD,
                              //         paymentMethodNounce: result!.paymentMethodNonce.nonce,
                              //         startDate: startDate,
                              //         startTimeStamp: reultStartTimeStamp.toString(),
                              //         razorId: '',
                              //         purchasedId: '',
                              //         isPaystack: PsConst.ZERO);
                              final VendorItemBoughtParameterHolder
                                  vendorItemBoughtParameterHolder =
                                  VendorItemBoughtParameterHolder(
                                      currencyId: productDetailAndAddress
                                          ?.productDetailIntentHolder
                                          ?.product
                                          ?.itemCurrencyId,
                                      //  appInfoProvider
                                      //     .appInfo.data!.currencyShortForm!,
                                      isPaystack: null,
                                      orderId: data.data?.orderId,
                                      paymentAmount: totalPrice,
                                      paymentMethod:
                                          PsConst.PAYMENT_PAYPAL_METHOD,
                                      paymentMethodNonce:
                                          result!.paymentMethodNonce.nonce,
                                      razorId: '',
                                      userId: psValueHolder!.loginUserId,
                                      vendorId: productDetailAndAddress
                                          ?.productDetailIntentHolder
                                          ?.product
                                          ?.vendorId);
                
                              await PsProgressDialog.showDialog(context);
                              // final PsValueHolder psValueHolder =
                              //     Provider.of<PsValueHolder>(context, listen: false);
                              final PsResource<VendorItemBoughtApiStatus>?
                                  paidHistoryData =
                                  await vendorItemBoughtProvider!
                                      .vendorItemBought(
                                requestBodyHolder:
                                    vendorItemBoughtParameterHolder,
                                requestPathHolder: RequestPathHolder(
                                    loginUserId:
                                        Utils.checkUserLoginId(psValueHolder)),
                              );
                
                              PsProgressDialog.dismissDialog();
                
                              if (paidHistoryData?.data?.status == 'success') {
                                Navigator.of(context).pushNamed(
                                    RoutePaths.orderSuccessful,
                                    arguments: productDetailAndAddress
                                        ?.productDetailIntentHolder);
                                // showDialog<dynamic>(
                                //     context: context,
                                //     builder: (BuildContext contet) {
                                //       return SuccessDialog(
                                //         message: 'item_promote__success'.tr,
                                //         onPressed: () {
                                //           Navigator.of(context).pop(true);
                                //           Navigator.of(context).pop(true);
                                //         },
                                //       );
                                //     });
                              } else {
                                showDialog<dynamic>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CheckOutDialog(
                                        title:
                                            // 'Payment Failed',
                                            'checkout__payment_fail'.tr,
                                        message:
                                            // "There's an issue with processing your payment. Please try again to successfully complete the transaction."
                                            'check_out_payment_fail_message'.tr,
                                      );
                                    });
                              }
                              // } else {
                              //   Utils.psPrint(
                              //       'Item paid history provider is null , please check!!!');
                              // }
                            }
                          }
                        }
                      },
                      totalPrice: totalPrice ?? ''
                
                      //  (int.parse(productDetailAndAddress!
                      //             .productDetailIntentHolder!
                      //             .product!
                      //             .currentPrice!
                      //             .toString())! *
                      //         productDetailAndAddress!
                      //             .productDetailIntentHolder!.userQty!)
                      //     .toString(),
                      )
                ]));
                        },
      ),
    );
  }
  
}
