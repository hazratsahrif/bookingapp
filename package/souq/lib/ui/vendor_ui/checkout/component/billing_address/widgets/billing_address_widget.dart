import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/config/route/route_paths.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/entry/item_entry_provider.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/provider/order_id/order_id_provider.dart';
import 'package:psxmpc/core/vendor/repository/product_repository.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/viewobject/common/ps_value_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/billing_address_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/product_detail_and_address_intent_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/shipping_address_holder.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/billing_address/widgets/same_as_shipping_address_widget.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/shipping_address/widgets/save_address_next_time.dart';
import 'package:psxmpc/ui/vendor_ui/common/ps_button_widget_with_round_corner.dart';
import 'package:psxmpc/ui/vendor_ui/common/ps_textfield_widget.dart';

import '../../../../common/dialog/warning_dialog_view.dart';

class BillingAddressWidget extends StatefulWidget {
  const BillingAddressWidget({
    Key? key,
    this.productDetailAndAddress,
  }) : super(key: key);

  final ProductDetailAndAddress? productDetailAndAddress;

  @override
  State<BillingAddressWidget> createState() => _BillingAddressWidgetState();
}

class _BillingAddressWidgetState extends State<BillingAddressWidget> {
  late ItemEntryProvider _itemEntryProvider;

  PsValueHolder? valueHolder;

  ProductRepository? repo1;
  final TextEditingController phone = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BillingAddressHolder? billingAddressHolder = BillingAddressHolder(
      address: widget.productDetailAndAddress?.billingAddressHolder?.address,
      city: widget.productDetailAndAddress?.billingAddressHolder?.city,
      country: widget.productDetailAndAddress?.billingAddressHolder?.country,
      lastName: widget.productDetailAndAddress?.billingAddressHolder?.lastName,
      email: widget.productDetailAndAddress?.billingAddressHolder?.email,
      firstName:
          widget.productDetailAndAddress?.billingAddressHolder?.firstName,
      postalCode:
          widget.productDetailAndAddress?.billingAddressHolder?.postalCode,
      code: widget.productDetailAndAddress?.billingAddressHolder?.code,
      state: widget.productDetailAndAddress?.billingAddressHolder?.state,
      phone: widget.productDetailAndAddress?.billingAddressHolder?.phone,
    );
    final ShippingAddressHolder? shippingAddressHolder = ShippingAddressHolder(
      address: widget.productDetailAndAddress?.shippingAddressHolder?.address,
      city: widget.productDetailAndAddress?.shippingAddressHolder?.city,
      country: widget.productDetailAndAddress?.shippingAddressHolder?.country,
      lastName: widget.productDetailAndAddress?.shippingAddressHolder?.lastName,
      email: widget.productDetailAndAddress?.shippingAddressHolder?.email,
      firstName:
          widget.productDetailAndAddress?.shippingAddressHolder?.firstName,
      postalCode:
          widget.productDetailAndAddress?.shippingAddressHolder?.postalCode,
      code: widget.productDetailAndAddress?.shippingAddressHolder?.code,
      state: widget.productDetailAndAddress?.shippingAddressHolder?.state,
      phone: widget.productDetailAndAddress?.shippingAddressHolder?.phone,
    );
    phone.text = billingAddressHolder?.phone ?? '';
    state.text = billingAddressHolder?.state ?? '';
    postalCode.text = billingAddressHolder?.postalCode ?? '';
    firstName.text = billingAddressHolder?.firstName ?? '';
    lastName.text = billingAddressHolder?.lastName ?? '';
    email.text = billingAddressHolder?.email ?? '';
    address.text = billingAddressHolder?.address ?? '';
    city.text = billingAddressHolder?.city ?? '';
    country.text = billingAddressHolder?.country ?? '';

    void checkedSameAsShippingAddress(bool value) {
      if (value) {
        phone.text = shippingAddressHolder?.phone ?? '';
        state.text = shippingAddressHolder?.state ?? '';
        postalCode.text = shippingAddressHolder?.postalCode ?? '';
        firstName.text = shippingAddressHolder?.firstName ?? '';
        lastName.text = shippingAddressHolder?.lastName ?? '';
        email.text = shippingAddressHolder?.email ?? '';
        address.text = shippingAddressHolder?.address ?? '';
        city.text = shippingAddressHolder?.city ?? '';
        country.text = shippingAddressHolder?.country ?? '';
      } else {
        phone.text = billingAddressHolder?.phone ?? '';
        state.text = billingAddressHolder?.state ?? '';
        postalCode.text = billingAddressHolder?.postalCode ?? '';
        firstName.text = billingAddressHolder?.firstName ?? '';
        lastName.text = billingAddressHolder?.lastName ?? '';
        email.text = billingAddressHolder?.email ?? '';
        address.text = billingAddressHolder?.address ?? '';
        city.text = billingAddressHolder?.city ?? '';
        country.text = billingAddressHolder?.country ?? '';
      }
    }

    void showMandatoryAlert(String message) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: message,
              onPressed: () {},
            );
          });
    }

    bool billingValidate() {
      const bool isValid = true;
      if (firstName.text.isEmpty) {
        showMandatoryAlert('shipping_need_first_name'.tr);
        // showMandatoryAlert('First name is required');
        return false;
      }
      if (lastName.text.isEmpty) {
        showMandatoryAlert('shipping_need_last_name'.tr);
        // showMandatoryAlert('Last name is required');

        return false;
      }
      if (email.text.isEmpty) {
        // showMandatoryAlert('Email is required');

        showMandatoryAlert('shipping_need_email'.tr);
        return false;
      }
      if (phone.text.isEmpty) {
        showMandatoryAlert('shipping_need_phone_number'.tr);
        // showMandatoryAlert('Phone Number is required');

        return false;
      }
      if (widget
              .productDetailAndAddress?.shippingAddressHolder?.code?.isEmpty ==
          true) {
        showMandatoryAlert('shipping_need_country_code'.tr);
        // showMandatoryAlert('CountryCode code is required');

        return false;
      }
      if (address.text.isEmpty) {
        showMandatoryAlert('shipping_need_address'.tr);
        // showMandatoryAlert('Address is required');

        return false;
      }
      if (country.text.isEmpty) {
        showMandatoryAlert('shipping_need_country'.tr);
        // showMandatoryAlert('Country is required');

        return false;
      }
      if (state.text.isEmpty) {
        showMandatoryAlert('shipping_need_state'.tr);
        // showMandatoryAlert('State is required');

        return false;
      }

      if (city.text.isEmpty) {
        // showMandatoryAlert('City is required');

        showMandatoryAlert('shipping_need_city'.tr);
        return false;
      }
      if (postalCode.text.isEmpty) {
        showMandatoryAlert('shipping_need_postal'.tr);
        // showMandatoryAlert('PostalCode is required');

        return false;
      }

      return isValid;
    }

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ItemEntryProvider?>(
              lazy: false,
              create: (BuildContext context) {
                _itemEntryProvider =
                    ItemEntryProvider(repo: repo1, psValueHolder: valueHolder);
                return _itemEntryProvider;
              }),
          ChangeNotifierProvider<OrderIdProvider?>(
              lazy: false,
              create: (BuildContext context) {
                return OrderIdProvider();
              })
        ],
        builder: (BuildContext context, Widget? child) {
          return Consumer2<ItemEntryProvider, OrderIdProvider>(builder:
              (BuildContext context, ItemEntryProvider itemEntryProvider,
                  OrderIdProvider orderIdProvider, Widget? child) {
            return ListView(
              children: <Widget>[
                SameAsShippingAddressWidget(
                    onCheckboxChanged: checkedSameAsShippingAddress),
                PsTextFieldWidget(
                  textEditingController: firstName,
                  isStar: true,
                  titleText: 'edit_profile__first_name'.tr,
                  hintText:
                      // 'Input Name'
                      'shipping_address_input_name'.tr,
                ),
                PsTextFieldWidget(
                  textEditingController: lastName,
                  isStar: true,
                  titleText: 'edit_profile__last_name'.tr,
                  hintText:
                      // 'Input Name'
                      'shipping_address_input_name'.tr,
                ),
                PsTextFieldWidget(
                  textEditingController: email,
                  isStar: true,
                  titleText: 'edit_profile__email'.tr,
                  hintText: 'edit_profile__email'.tr,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space16,
                      top: PsDimens.space12,
                      bottom: PsDimens.space12,
                      right: PsDimens.space16),
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                              // 'Phone Number',
                              'shipping_address_phone'.tr,
                              style: Theme.of(context).textTheme.titleMedium!),
                          Text('*',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: PsDimens.space44,
                  margin:
                      const EdgeInsets.symmetric(horizontal: PsDimens.space16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    border: Border.all(color: PsColors.text400),
                  ),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          // FocusScope.of(context).requestFocus(FocusNode());
                          final dynamic result = await Navigator.pushNamed(
                              context, RoutePaths.shippingPhoneCountryCode);
                          itemEntryProvider
                                  .phoneNumList[0].countryCodeController.text =
                              result.countryCode
                                  .toString()
                                  .replaceAll(RegExp(r'\s+'), '');
                          setState(() {
                            // itemEntryProvider
                            //     .shippingPhoneController
                            //     .countryCodeController
                            //     .text = result.countryCode;

                            widget.productDetailAndAddress?.billingAddressHolder
                                    ?.code =
                                result.countryCode
                                    .toString()
                                    .replaceAll(RegExp(r'\s+'), '');
                          });
                        },
                        child: Container(
                          width: PsDimens.space50,
                          height: PsDimens.space44,
                          margin: const EdgeInsets.symmetric(
                              horizontal: PsDimens.space12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                (orderIdProvider.isSameAsShippingAddress ==
                                        true)
                                    ? shippingAddressHolder?.code ?? ''
                                    : (widget.productDetailAndAddress
                                                ?.billingAddressHolder?.code !=
                                            null)
                                        ? widget.productDetailAndAddress
                                                ?.billingAddressHolder?.code ??
                                            ''
                                        : (itemEntryProvider
                                                .phoneNumList[0]
                                                .countryCodeController
                                                .text
                                                .isEmpty)
                                            ? '+95'
                                            : itemEntryProvider.phoneNumList[0]
                                                .countryCodeController.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Utils.isLightMode(context)
                            ? PsColors.text400
                            : PsColors.text300,
                        width: PsDimens.space1,
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            controller: phone,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                              hintText:
                                  // 'Phone Number',
                                  'shipping_address_phone'.tr,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: PsColors.text400),
                              contentPadding: const EdgeInsets.only(
                                  right: PsDimens.space12,
                                  left: PsDimens.space12,
                                  bottom: PsDimens.space4),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                PsTextFieldWidget(
                  textEditingController: address,
                  isStar: true,
                  titleText: 'edit_profile__address'.tr,
                  hintText: 'contact_us__contact_message_hint'.tr,
                  height: 124,
                ),
                PsTextFieldWidget(
                  textEditingController: country,
                  isStar: true,
                  titleText: 'edit_profile__country_name'.tr,
                  hintText: 'edit_profile__country_name'.tr,
                ),
                PsTextFieldWidget(
                  textEditingController: state,
                  isStar: true,
                  titleText: 'edit_profile__state_name'.tr,
                  hintText: 'edit_profile__state_name'.tr,
                ),
                PsTextFieldWidget(
                  textEditingController: city,
                  isStar: true,
                  titleText: 'edit_profile__city_name'.tr,
                  hintText: 'edit_profile__city_name'.tr,
                ),
                PsTextFieldWidget(
                  textEditingController: postalCode,
                  isStar: true,
                  titleText: 'edit_profile__postal_code'.tr,
                  hintText: 'edit_profile__postal_code'.tr,
                ),
                const SaveAddressNextTimeWidget(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: PSButtonWidgetRoundCorner(
                    onPressed: () {
                      final bool isValid = billingValidate();
                      if (isValid) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            // ignore: always_specify_types
                            RoutePaths.checkout,
                            (Route route) => false,
                            arguments: ProductDetailAndAddress(
                              productDetailIntentHolder: widget
                                  .productDetailAndAddress
                                  ?.productDetailIntentHolder,
                              shippingAddressHolder: widget
                                  .productDetailAndAddress
                                  ?.shippingAddressHolder,
                              billingAddressHolder: BillingAddressHolder(
                                  city: city.text,
                                  address: address.text,
                                  firstName: firstName.text,
                                  lastName: lastName.text,
                                  email: email.text,
                                  country: country.text,
                                  state: state.text,
                                  postalCode: postalCode.text,
                                  phone: phone.text,
                                  code:
                                      (orderIdProvider.isSameAsShippingAddress)
                                          ? shippingAddressHolder?.code ?? ''
                                          : (widget
                                                      .productDetailAndAddress
                                                      ?.billingAddressHolder
                                                      ?.code !=
                                                  null)
                                              ? widget
                                                      .productDetailAndAddress
                                                      ?.billingAddressHolder
                                                      ?.code ??
                                                  ''
                                              : (itemEntryProvider
                                                      .phoneNumList[0]
                                                      .countryCodeController
                                                      .text
                                                      .isEmpty)
                                                  ? '+95'
                                                  : itemEntryProvider
                                                      .phoneNumList[0]
                                                      .countryCodeController
                                                      .text),
                            ));
                      }
                    },
                    titleText:
                        // 'Save'
                        'shipping_address_save'.tr,
                  ),
                )
              ],
            );
          });
        });
  }
}
