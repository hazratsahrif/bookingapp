import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/product_module/models/order_product_model.dart';
import 'package:booking_system_flutter/product_module/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../app_theme.dart';
import '../../main.dart';
import '../../screens/map/places_screen.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key, required this.orderProducts});
  final List<OrderProductModel> orderProducts;

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController addressC = TextEditingController();
  final TextEditingController noteC = TextEditingController();
  final TextEditingController dateTimeCont = TextEditingController();
  LatLng? latLng;
  DateTime? date = DateTime.now();
  TimeOfDay? time;
  late final double total;
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    if (getDoubleAsync(LONGITUDE, defaultValue: -1111) != -1111)
      latLng = LatLng(
        lng: getDoubleAsync(LONGITUDE),
        lat: getDoubleAsync(LATITUDE),
      );
    final address = getStringAsync(CURRENT_ADDRESS);
    addressC.value = TextEditingValue(text: address);
    final calTotal = widget.orderProducts
        .map((e) =>
            (int.tryParse(e.quantity) ?? 0).toDouble() *
            (double.tryParse(e.price) ?? 0))
        .reduce((value, element) => value + element);
    total = calTotal;
    if (mounted) setState(() {});
  }

  Future<bool> placeOrder() async {
    if (formKey.currentState?.validate() ?? false) {
      // if (date == null) {
      //   toast(language.lblSelectDate);
      //   return false;
      // }
      // if (time == null) {
      //   toast(language.lblTime);
      //   return false;
      // }
      if (latLng == null) {
        toast(language.lblPickAddress);
        return false;
      }
      date ??= DateTime.now();
      time ??= TimeOfDay.now();
      return StoreService.placeOrder(
          note: noteC.text,
          date: DateFormat('yyyy-MM-dd').format(date ?? DateTime.now()),
          lat: latLng!.lat.toString(),
          long: latLng!.lng.toString(),
          time: '${time?.hour ?? 00}:${time?.minute ?? 00}',
          total: total.toString(),
          address: addressC.text,
          orderProducts: widget.orderProducts);
    }
    return false;
  }

  void selectDateAndTime(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(30.days),
      locale: Locale(appStore.selectedLanguageCode),
      cancelText: language.lblCancel,
      confirmText: language.lblOk,
      helpText: language.lblSelectDate,
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
          child: child!,
        );
      },
    ).then((pickedDate) async {
      if (pickedDate != null) {
        await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
          cancelText: language.lblCancel,
          confirmText: language.lblOk,
          builder: (_, child) {
            return Theme(
              data: appStore.isDarkMode
                  ? ThemeData.dark()
                  : AppTheme.lightTheme(),
              child: child!,
            );
          },
        ).then((pickedTIme) {
          if (pickedTIme != null) {
            date = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
                pickedTIme.hour, pickedTIme.minute);

            DateTime now = DateTime.now().subtract(1.minutes);
            if (pickedDate.isToday &&
                date!.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
              return toast(language.selectedOtherBookingTime);
            }
            time = pickedTIme;

            dateTimeCont.text =
                "${formatDate(date.toString(), format: DATE_FORMAT_3)} ${pickedTIme.format(context).toString() ?? ''}";
          }
        }).catchError((e) {
          toast(e.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblPlaceOrder,
      showBack: true,
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AnimatedScrollView(
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          padding: EdgeInsets.only(bottom: 60, left: 20, right: 20, top: 20),
          children: [
            AppTextField(
              // onTap: () {
              //   PlacesScreen()
              //       .launch<FetchPlaceResponse?>(context)
              //       .then((prediction) async {
              //     if (prediction?.place?.address != null &&
              //         prediction?.place?.latLng != null) {
              //       addressC.value = TextEditingValue(
              //           text: prediction?.place?.address ?? addressC.text);
              //       latLng = prediction!.place!.latLng!;
              //       setState(() {});
              //     }
              //   });
              // },
              controller: addressC,
              textFieldType: TextFieldType.NAME,
              errorThisFieldRequired: language.requiredText,
              decoration:
                  inputDecoration(context, labelText: language.lblYourAddress),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(language.setAddress),
                  onPressed: () {
                    PlacesScreen()
                        .launch<FetchPlaceResponse?>(context)
                        .then((prediction) async {
                      if (prediction?.place?.address != null &&
                          prediction?.place?.latLng != null) {
                        addressC.value = TextEditingValue(
                            text: prediction?.place?.address ?? addressC.text);
                        latLng = prediction!.place!.latLng!;
                        setState(() {});
                      }
                    });
                  },
                ),
              ],
            ),
            16.height,
            AppTextField(
              controller: noteC,
              textFieldType: TextFieldType.MULTILINE,
              isValidationRequired: false,
              minLines: 6,
              maxLines: 6,
              decoration: inputDecoration(context, labelText: language.lblNote),
            ),
            16.height,
            // AppTextField(
            //   readOnly: true,
            //   onTap: () => selectDateAndTime(context),
            //   controller: dateTimeCont,
            //   textFieldType: TextFieldType.MULTILINE,
            //   isValidationRequired: false,
            //   decoration:
            //       inputDecoration(context, labelText: language.lblSelectDate),
            // ),
            // 16.height,
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.lblTotal,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                PriceWidget(
                  price: total,
                  color: context.primaryColor,
                ),
              ],
            ),
          ),
          8.width,
          AppButton(
            text: language.lblPlaceOrder,
            width: context.width(),
            margin: EdgeInsets.all(16),
            color: appStore.isDarkMode ? primaryColorDark : primaryColor,
            textColor: Colors.white,
            onTap: () async {
              final success = await placeOrder();
              if (success) finish(context, success);
            },
          ),
        ],
      ),
    );
  }
}
