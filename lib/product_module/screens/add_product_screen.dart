import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/base_scaffold_widget.dart';
import '../../component/cached_image_widget.dart';
import '../../main.dart';
import '../../screens/map/map_screen.dart';
import '../../screens/map/places_screen.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';
import '../models/product_category.dart';
import '../models/product_data.dart';
import '../services/store_service.dart';
import 'choose_product_category_screen.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductData? editableData;
  const AddEditProductScreen({super.key, this.editableData});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleCont = TextEditingController();
  TextEditingController brandCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  TextEditingController quantityCont = TextEditingController(text: '1');
  // TextEditingController addressCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();

  FocusNode descriptionFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode quantityFocus = FocusNode();

  LocationWithAddress? locationWithAddress;
  List<XFile> images = [];
  List<ProductImages> existingImages = [];
  String type = 'Fixed';
  String condition = 'New';
  ProductCategory? category;
  SubCategory? subCategory;
  late bool isEditing;
  String _buildFixedAndBiddingText(String value) {
    switch (value) {
      case 'Fixed':
        {
          return 'سعر ثابت';
        }
      case 'Bidding':
        {
          return 'مزاد';
        }
      default:
        {
          return 'N/A';
        }
    }
  }

  String _buildNewUsedText(String value) {
    switch (value) {
      case 'Used':
        {
          return 'مستعمل';
        }
      case 'New':
        {
          return 'جديد';
        }
      default:
        {
          return 'N/A';
        }
    }
  }

  _fillEditableData() {
    if (!isEditing) return;
    final productData = widget.editableData!;
    try {
      locationWithAddress = LocationWithAddress(
          double.parse(productData.latitude!),
          double.parse(productData.longitude!),
          productData.address!);
      existingImages = productData.productImages ?? [];
      type = productData.type ?? type;
      condition = productData.condition ?? condition;
      category = productData.productCategory;
      subCategory = productData.productSubCategory;
      priceCont.value = TextEditingValue(text: productData.price ?? '');
      quantityCont.value = TextEditingValue(text: productData.quantity ?? '');
      descriptionCont.value =
          TextEditingValue(text: productData.description ?? '');
      brandCont.value = TextEditingValue(text: productData.brand ?? '');
      titleCont.value = TextEditingValue(text: productData.title ?? '');
    } catch (e) {
      log(e);
      isEditing = false;
      if (mounted) setState(() {});
    }
  }

  @override
  initState() {
    isEditing = widget.editableData != null;
    _fillEditableData();
    final address = getStringAsync(CURRENT_ADDRESS);
    final lat = getDoubleAsync(LATITUDE, defaultValue: -1000);
    final long = getDoubleAsync(LONGITUDE, defaultValue: -1000);
    if (address.isEmpty || lat == -1000 || long == -1000) {
      if (!isEditing) locationWithAddress = null;
    } else {
      locationWithAddress = LocationWithAddress(lat, long, address);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: appStore.isLoading,
          child: AppScaffold(
            appBarTitle: isEditing
                ? (language.lblUpdate + " " + language.lblProducts)
                : language.lblAddProduct,
            showBack: true,
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: AnimatedScrollView(
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                padding: EdgeInsets.only(bottom: 60),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: context.width(),
                        height: 120,
                        child: DottedBorderWidget(
                          color: appStore.isDarkMode
                              ? primaryColorDark
                              : primaryColor.withOpacity(0.6),
                          strokeWidth: 1,
                          gap: 6,
                          radius: 12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(ic_category,
                                  height: 25,
                                  width: 25,
                                  color: appStore.isDarkMode ? white : gray),
                              8.height,
                              Text(language.chooseImages,
                                  style: boldTextStyle()),
                            ],
                          ).center().onTap(borderRadius: radius(), () async {
                            ImagePicker().pickMultiImage().then((value) {
                              images = value;
                              setState(() {});
                            });
                          }),
                        ),
                      ),
                      16.height,
                      HorizontalList(
                        itemCount: images.length,
                        itemBuilder: (context, i) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              if (images[i].path.contains("https"))
                                CachedImageWidget(
                                        url: images[i].path,
                                        height: 90,
                                        fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRect(16)
                              else
                                Image.file(File(images[i].path),
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRect(16),
                              Container(
                                decoration: boxDecorationWithRoundedCorners(
                                    boxShape: BoxShape.circle,
                                    backgroundColor: appStore.isDarkMode
                                        ? primaryColorDark
                                        : primaryColor),
                                margin: EdgeInsets.only(right: 8, top: 4),
                                padding: EdgeInsets.all(4),
                                child:
                                    Icon(Icons.close, size: 16, color: white),
                              ).onTap(() {
                                images.removeAt(i);
                                setState(() {});
                              }),
                            ],
                          );
                        },
                      ).paddingBottom(16).visible(images.isNotEmpty),
                      HorizontalList(
                        itemCount: existingImages.length,
                        itemBuilder: (context, i) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              if (existingImages[i].images?.contains("https") ??
                                  false)
                                CachedImageWidget(
                                        url: existingImages[i].images!,
                                        height: 90,
                                        fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRect(16)
                              else
                                Container(
                                  color: primaryColor.withOpacity(0.1),
                                  width: 90,
                                  height: 90,
                                ).cornerRadiusWithClipRRect(16),
                              Container(
                                decoration: boxDecorationWithRoundedCorners(
                                    boxShape: BoxShape.circle,
                                    backgroundColor: appStore.isDarkMode
                                        ? primaryColorDark
                                        : primaryColor),
                                margin: EdgeInsets.only(right: 8, top: 4),
                                padding: EdgeInsets.all(4),
                                child:
                                    Icon(Icons.close, size: 16, color: white),
                              ).onTap(() {
                                existingImages.removeAt(i);
                                setState(() {});
                              }),
                            ],
                          );
                        },
                      ).paddingBottom(16).visible(existingImages.isNotEmpty),
                      AppTextField(
                        controller: titleCont,
                        textFieldType: TextFieldType.NAME,
                        errorThisFieldRequired: language.requiredText,
                        nextFocus: descriptionFocus,
                        decoration: inputDecoration(context,
                            labelText: language.lblTitle),
                      ),
                      16.height,
                      AppTextField(
                        controller: brandCont,
                        textFieldType: TextFieldType.NAME,
                        errorThisFieldRequired: language.requiredText,
                        nextFocus: descriptionFocus,
                        decoration: inputDecoration(context,
                            labelText: language.lblBrand),
                      ),
                      16.height,
                      AppTextField(
                        controller: descriptionCont,
                        textFieldType: TextFieldType.MULTILINE,
                        errorThisFieldRequired: language.requiredText,
                        minLines: 6,
                        maxLines: 6,
                        focus: descriptionFocus,
                        nextFocus: priceFocus,
                        decoration: inputDecoration(context,
                            labelText: language.lblDescription),
                      ),
                      16.height,
                      AppTextField(
                        textFieldType: TextFieldType.PHONE,
                        controller: priceCont,
                        focus: priceFocus,
                        nextFocus: quantityFocus,
                        errorThisFieldRequired: language.requiredText,
                        decoration:
                            inputDecoration(context, labelText: language.price),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        validator: (s) {
                          if (s!.isEmpty) return errorThisFieldRequired;

                          if (s.toInt() <= 0)
                            return language.priceAmountValidationMessage;
                          return null;
                        },
                      ),
                      16.height,
                      AppTextField(
                        textFieldType: TextFieldType.PHONE,
                        controller: quantityCont,
                        focus: quantityFocus,
                        errorThisFieldRequired: language.requiredText,
                        decoration: inputDecoration(context,
                            labelText: language.lblQuantity),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        validator: (s) {
                          if (s!.isEmpty) return errorThisFieldRequired;

                          if (s.toInt() <= 0)
                            return language.priceAmountValidationMessage;
                          return null;
                        },
                      ),
                      16.height,
                      DropdownButtonFormField<String>(
                          value: type,
                          style: primaryTextStyle(),
                          dropdownColor: context.cardColor,
                          decoration: inputDecoration(context,
                              labelText: language.lblPriceType),
                          items: ['Fixed', 'Bidding']
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(_buildFixedAndBiddingText(e))))
                              .toList(),
                          onChanged: (value) => setState(() {
                                type = value ?? type;
                              })),
                      16.height,
                      DropdownButtonFormField<String>(
                          value: condition,
                          dropdownColor: context.cardColor,
                          style: primaryTextStyle(),
                          decoration: inputDecoration(
                            context,
                            labelText: language.lblCondition,
                          ),
                          items: ['Used', 'New']
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(_buildNewUsedText(e))))
                              .toList(),
                          onChanged: (value) => setState(() {
                                condition = value ?? condition;
                              })),
                      16.height,
                      ListTile(
                        selected: category != null || subCategory != null,
                        selectedColor: blueColor,
                        subtitleTextStyle: inputDecoration(context).labelStyle,
                        titleTextStyle: inputDecoration(context).labelStyle,
                        title: Text(
                          category != null || subCategory != null
                              ? '${language.lblSelectedCategory}:'
                              : '${language.lblSelectCategory}',
                        ),
                        subtitle: category != null
                            ? Text(
                                "${category?.name ?? ''}${subCategory != null ? ' (${subCategory?.name})' : ''}",
                              )
                            : null,
                        trailing: Icon(Icons.category),
                        onTap: () {
                          ChooseProductCategoryScreen()
                              .launch<SelectionCategory?>(context)
                              .then((value) {
                            if (value == null) return;
                            setState(() {
                              category = value.category;
                              subCategory = value.subCategory;
                            });
                          });
                        },
                      ),
                      // if (locationWithAddress == null)
                      ListTile(
                        selected: locationWithAddress != null,
                        selectedColor: blueColor,
                        subtitleTextStyle: inputDecoration(context).labelStyle,
                        titleTextStyle: inputDecoration(context).labelStyle,
                        title: Text(
                          locationWithAddress != null
                              ? '${language.lblYourAddress}:'
                              : '${language.lblPickAddress}',
                        ),
                        subtitle: locationWithAddress != null
                            ? Text(
                                locationWithAddress!.address,
                              )
                            : null,
                        trailing: Icon(Icons.location_on),
                        onTap: () {
                          PlacesScreen()
                              .launch<FetchPlaceResponse?>(context)
                              .then((value) {
                            if (value == null) return;
                            setState(() {
                              if (value.place != null &&
                                  value.place!.latLng != null &&
                                  value.place!.address != null)
                                locationWithAddress = LocationWithAddress(
                                    value.place!.latLng!.lat,
                                    value.place!.latLng!.lng,
                                    value.place!.address!);
                            });
                          });
                        },
                      ),
                    ],
                  ).paddingAll(16.0),
                ],
              ),
            ),
            bottomNavigationBar: AppButton(
              text: isEditing ? language.lblUpdate : language.lblAddProduct,
              width: context.width(),
              margin: EdgeInsets.all(16),
              color: appStore.isDarkMode ? primaryColorDark : primaryColor,
              textColor: Colors.white,
              onTap: () async {
                if (!(formKey.currentState?.validate() ?? false)) return;
                if (locationWithAddress == null) return;
                if (isEditing) {
                  StoreService.editProduct(
                      existingImagesIds:
                          existingImages.map((e) => e.id!).toList(),
                      productId: widget.editableData!.id!,
                      images: images,
                      title: titleCont.text,
                      description: descriptionCont.text,
                      brand: brandCont.text,
                      lat: locationWithAddress!.lat.toString(),
                      long: locationWithAddress!.long.toString(),
                      quantity: quantityCont.text,
                      price: priceCont.text,
                      type: type,
                      condition: condition,
                      address: locationWithAddress!.address.toString(),
                      catId: category!.id!.toString(),
                      subCatId: subCategory!.id!.toString(),
                      context: context);
                  return;
                }
                StoreService.addProduct(
                    images: images,
                    title: titleCont.text,
                    description: descriptionCont.text,
                    brand: brandCont.text,
                    lat: locationWithAddress!.lat.toString(),
                    long: locationWithAddress!.long.toString(),
                    quantity: quantityCont.text,
                    price: priceCont.text,
                    type: type,
                    condition: condition,
                    address: locationWithAddress!.address.toString(),
                    catId: category!.id!.toString(),
                    subCatId: subCategory!.id!.toString(),
                    context: context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
