import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:psxmpc/config/ps_colors.dart';
import 'package:psxmpc/config/route/route_paths.dart';
import 'package:psxmpc/core/vendor/constant/ps_dimens.dart';
import 'package:psxmpc/core/vendor/provider/entry/item_entry_provider.dart';
import 'package:psxmpc/core/vendor/provider/language/app_localization_provider.dart';
import 'package:psxmpc/core/vendor/repository/product_repository.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/viewobject/common/ps_value_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/product_detail_and_address_intent_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/shipping_address_holder.dart';
import 'package:psxmpc/ui/vendor_ui/checkout/component/shipping_address/widgets/save_address_next_time.dart';
import 'package:psxmpc/ui/vendor_ui/common/ps_button_widget_with_round_corner.dart';
import 'package:psxmpc/ui/vendor_ui/common/ps_textfield_widget.dart';

import '../../../../common/dialog/warning_dialog_view.dart';

class ShippingAddressWidget extends StatefulWidget {
  const ShippingAddressWidget({
    Key? key,
    this.productDetailAndAddress,
  }) : super(key: key);

  final ProductDetailAndAddress? productDetailAndAddress;

  @override
  State<ShippingAddressWidget> createState() => _ShippingAddressWidgetState();
}

class _ShippingAddressWidgetState extends State<ShippingAddressWidget> {
  late ItemEntryProvider _itemEntryProvider;

  PsValueHolder? valueHolder;

  ProductRepository? repo1;

  late TextEditingController phone;
  late TextEditingController state;
  late TextEditingController postalCode;
  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController email;
  late TextEditingController address;
  late TextEditingController city;
  late TextEditingController country;

  @override
  void initState() {
    phone = TextEditingController();
    state = TextEditingController();
    postalCode = TextEditingController();
    firstName = TextEditingController();
    lastName = TextEditingController();
    email = TextEditingController();
    address = TextEditingController();
    city = TextEditingController();
    country = TextEditingController();

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
    phone.text = shippingAddressHolder?.phone ?? '';
    state.text = shippingAddressHolder?.state ?? '';
    postalCode.text = shippingAddressHolder?.postalCode ?? '';
    firstName.text = shippingAddressHolder?.firstName ?? '';
    lastName.text = shippingAddressHolder?.lastName ?? '';
    email.text = shippingAddressHolder?.email ?? '';
    address.text = shippingAddressHolder?.address ?? '';
    city.text = shippingAddressHolder?.city ?? '';
    country.text = shippingAddressHolder?.country ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    bool shippingValid() {
      const bool isValid = true;
      if (firstName.text.isEmpty) {
        // showMandatoryAlert('First name is required');

        showMandatoryAlert('shipping_need_first_name'.tr);
        return false;
      }
      if (lastName.text.isEmpty) {
        // showMandatoryAlert('Last name is required');

        showMandatoryAlert('shipping_need_last_name'.tr);
        return false;
      }
      if (email.text.isEmpty) {
        // showMandatoryAlert('Email is required');

        showMandatoryAlert('shipping_need_email'.tr);
        return false;
      }
      if (phone.text.isEmpty) {
        // showMandatoryAlert('Phone Number is required');

        showMandatoryAlert('shipping_need_phone_number'.tr);

        return false;
      }
      if (widget
              .productDetailAndAddress?.shippingAddressHolder?.code?.isEmpty ==
          true)
      // .isEmpty)
      {
        // showMandatoryAlert('CountryCode code is required');

        showMandatoryAlert('shipping_need_country_code'.tr);
        return false;
      }

      if (address.text.isEmpty) {
        // showMandatoryAlert('Address is required');

        showMandatoryAlert('shipping_need_address'.tr);
        return false;
      }
      if (country.text.isEmpty) {
        // showMandatoryAlert('Country is required');

        showMandatoryAlert('shipping_need_country'.tr);
        return false;
      }
      if (state.text.isEmpty) {
        // showMandatoryAlert('State is required');

        showMandatoryAlert('shipping_need_state'.tr);
        return false;
      }
      if (city.text.isEmpty) {
        // showMandatoryAlert('City is required');

        showMandatoryAlert('shipping_need_city'.tr);
        return false;
      }
      if (postalCode.text.isEmpty) {
        // PostalCode is required
        // showMandatoryAlert('PostalCode is required');
        showMandatoryAlert('shipping_need_postal'.tr);
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
              })
        ],
        builder: (BuildContext context, Widget? child) {
          return Consumer<ItemEntryProvider>(builder: (BuildContext context,
              ItemEntryProvider itemEntryProvider, Widget? child) {
            itemEntryProvider
                    .shippingPhoneController.countryCodeController.text =
                widget.productDetailAndAddress?.shippingAddressHolder?.code ??
                    '';
            return ListView(
              children: <Widget>[
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

                          itemEntryProvider.shippingPhoneController
                                  .countryCodeController.text =
                              result.countryCode
                                  .toString()
                                  .replaceAll(RegExp(r'\s+'), '');
                          itemEntryProvider
                                  .phoneNumList[0].countryCodeController.text =
                              result.countryCode
                                  .toString()
                                  .replaceAll(RegExp(r'\s+'), '');
                          setState(() {
                            widget
                                .productDetailAndAddress
                                ?.shippingAddressHolder
                                ?.code = result.countryCode;
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
                                (widget.productDetailAndAddress
                                            ?.shippingAddressHolder?.code !=
                                        null)
                                    ? widget.productDetailAndAddress
                                            ?.shippingAddressHolder?.code ??
                                        '+95'
                                    : (itemEntryProvider.phoneNumList[0]
                                            .countryCodeController.text.isEmpty)
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
                      final bool isValid = shippingValid();
                      if (isValid) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RoutePaths.checkout, (Route route) => false,
                            arguments: ProductDetailAndAddress(
                                productDetailIntentHolder: widget
                                    .productDetailAndAddress
                                    ?.productDetailIntentHolder,
                                shippingAddressHolder: ShippingAddressHolder(
                                    city: city.text,
                                    address: address.text,
                                    firstName: firstName.text,
                                    lastName: lastName.text,
                                    email: email.text,
                                    country: country.text,
                                    state: state.text,
                                    postalCode: postalCode.text,
                                    phone: phone.text,
                                    code: (widget.productDetailAndAddress
                                                ?.shippingAddressHolder?.code !=
                                            null)
                                        ? widget.productDetailAndAddress
                                                ?.shippingAddressHolder?.code ??
                                            ''
                                        : (itemEntryProvider
                                                .phoneNumList[0]
                                                .countryCodeController
                                                .text
                                                .isEmpty)
                                            ? '+95'
                                            : itemEntryProvider.phoneNumList[0]
                                                .countryCodeController.text),
                                billingAddressHolder: widget
                                    .productDetailAndAddress
                                    ?.billingAddressHolder));
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
