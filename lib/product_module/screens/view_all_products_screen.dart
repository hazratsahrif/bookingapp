import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/product_module/models/product_category.dart';
import 'package:booking_system_flutter/product_module/services/store_service.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as pSDK;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/loader_widget.dart';
import '../../component/view_all_label_component.dart';
import '../../screens/dashboard/component/product_category_widget.dart';
import '../../screens/map/places_screen.dart';
import '../../screens/service/component/product_component.dart';
import '../../utils/colors.dart';
import '../../utils/configs.dart';
import '../../utils/images.dart';
import '../models/product_data.dart';

class ViewAllProductsScreen extends StatefulWidget {
  const ViewAllProductsScreen(
      {super.key, this.category, this.subCategory, this.isFeatured});
  final ProductCategory? category;
  final SubCategory? subCategory;
  final bool? isFeatured;

  @override
  State<ViewAllProductsScreen> createState() => _ViewAllProductsScreenState();
}

class _ViewAllProductsScreenState extends State<ViewAllProductsScreen> {
  int page = 1;
  bool isLastPage = false;
  List<ProductData> productsList = [];
  Data? paginatedData;
  List<ProductCategory> categories = [];
  late LatLng latLng;
  ProductCategory? category;
  SubCategory? subCategory;
  String? place;
  final TextEditingController searchC = TextEditingController();
  final TextEditingController minPriceC = TextEditingController();
  final TextEditingController maxPriceC = TextEditingController();
  @override
  void initState() {
    final val = getStringAsync(CURRENT_ADDRESS);
    if (val.isNotEmpty) {
      place = val;
    }
    latLng = LatLng(getDoubleAsync(LATITUDE), getDoubleAsync(LONGITUDE));
    category = widget.category;
    // searchC.addListener(() {
    //   _resetScreen();
    //   _fetchProducts();
    // });

    StoreService.getProductCategories().then((value) {
      categories = value;
      if (mounted) setState(() {});
      return value;
    }).catchError((e) => toast(e));
    _fetchProducts();

    super.initState();
  }

  _fetchProducts() async {
    log('Page $page');
    if (isLastPage) return;
    appStore.setLoading(true);
    await StoreService.getProducts(
      latLng: latLng,
      isFeatured: widget.isFeatured,
      page: page,
      minPrice: double.tryParse(minPriceC.text),
      maxPrice: double.tryParse(maxPriceC.text),
      searchText: searchC.text,
      categoryId: category?.id?.toString(),
    ).then((value) {
      paginatedData = value.data;
      isLastPage = (value.data?.data?.length ?? 0) < 10;
      productsList = <ProductData>[
        ...productsList,
        ...(value.data?.data ?? [])
      ];
      if (mounted) setState(() {});
    }).catchError((e) => toast(e?.toString()));
    appStore.setLoading(false);
  }

  _resetScreen() async {
    productsList = [];
    page = 1;
    isLastPage = false;
    await _fetchProducts();
  }

  @override
  void dispose() {
    // searchC.removeListener(() {});
    searchC.dispose();
    minPriceC.dispose();
    maxPriceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AppScaffold(
            actions: [
              TextButton(
                onPressed: () {
                  searchC.value = TextEditingValue.empty;
                  minPriceC.value = TextEditingValue.empty;
                  maxPriceC.value = TextEditingValue.empty;
                  _resetScreen();
                },
                child: Text(
                  language.lblClearFilter,
                  style: boldTextStyle(
                      color: appStore.isDarkMode ? primaryColorDark : white),
                ),
              ),
            ],
            appBarTitle: category != null
                ? category!.name
                : language.lblAll + " " + language.lblProducts,
            child: RefreshIndicator(
              onRefresh: () async {
                await _resetScreen();
              },
              child: NestedScrollView(
                controller: ScrollController(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  textFieldType: TextFieldType.NAME,
                                  onChanged: (p0) {
                                    if (p0.isEmpty) _resetScreen();
                                  },
                                  decoration: inputDecoration(context,
                                      labelText: language.lblSearchFor +
                                          ' ' +
                                          (category != null
                                              ? category!.name!
                                              : language.lblAll +
                                                  " " +
                                                  language.lblProducts)),
                                  controller: searchC,
                                ).paddingSymmetric(horizontal: 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _resetScreen();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 16),
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 12.0, 16.0, 12.0),
                                  decoration: boxDecorationDefault(
                                      color: context.cardColor),
                                  child: ic_search.iconImage(
                                      color: appStore.isDarkMode
                                          ? primaryColorDark
                                          : primaryColor),
                                ),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            shape: RoundedRectangleBorder(),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: ViewAllLabel(
                              label: language.lblFilterBy,
                            ),
                            children: [
                              ExpansionTile(
                                shape: RoundedRectangleBorder(),
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,
                                title: ViewAllLabel(
                                  label: language.category,
                                ),
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      HorizontalList(
                                        itemCount: categories.validate().length,
                                        runSpacing: 8,
                                        spacing: 12,
                                        itemBuilder: (_, i) {
                                          final data = categories![i];
                                          return GestureDetector(
                                            onTap: () {
                                              if (category?.id == data.id) {
                                                category = null;
                                                subCategory = null;
                                              } else
                                                category = data;
                                              _resetScreen();
                                            },
                                            child: ProductCategoryWidget(
                                              categoryData: data,
                                              isSelected:
                                                  (category?.id ?? -1) ==
                                                      data.id,
                                            ),
                                          );
                                        },
                                      ),
                                      if ((category?.subCategory?.length ??
                                                  0) !=
                                              0 &&
                                          categories.isNotEmpty)
                                        ViewAllLabel(
                                          label: language.lblSubcategories,
                                        ),
                                      HorizontalList(
                                        itemCount:
                                            category?.subCategory?.length ?? 0,
                                        runSpacing: 8,
                                        spacing: 12,
                                        itemBuilder: (_, i) {
                                          final data =
                                              category!.subCategory![i];
                                          return GestureDetector(
                                            onTap: () {
                                              if (subCategory?.id == data.id)
                                                subCategory = null;
                                              else
                                                subCategory = data;
                                              _resetScreen();
                                            },
                                            child: ProductSubCategoryWidget(
                                              categoryData: data,
                                              isSelected:
                                                  (subCategory?.id ?? -1) ==
                                                      data.id,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ).paddingSymmetric(horizontal: 16),
                              ExpansionTile(
                                shape: RoundedRectangleBorder(),
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,
                                title: ViewAllLabel(
                                  label: language.price,
                                ),
                                children: [
                                  // AppTextField(
                                  //   textFieldType: TextFieldType.NUMBER,
                                  //   onChanged: (p0) {
                                  //     if (p0.isEmpty) _resetScreen();
                                  //   },
                                  //   decoration: inputDecoration(context,
                                  //       labelText: language.min),
                                  //   controller: minPriceC,
                                  // ),
                                  // 16.height,
                                  AppTextField(
                                    textFieldType: TextFieldType.NUMBER,
                                    onChanged: (p0) {
                                      if (p0.isEmpty) _resetScreen();
                                    },
                                    decoration: inputDecoration(context,
                                        labelText: language.price),
                                    controller: maxPriceC,
                                  ),
                                  16.height,
                                  AppButton(
                                    text: language.lblApply,
                                    width: double.infinity,
                                    margin: EdgeInsets.all(16),
                                    color: appStore.isDarkMode
                                        ? primaryColorDark
                                        : primaryColor,
                                    textColor: Colors.white,
                                    onTap: () async {
                                      _resetScreen();
                                    },
                                  )
                                ],
                              ).paddingSymmetric(horizontal: 16),
                              ExpansionTile(
                                shape: RoundedRectangleBorder(),
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,
                                title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ic_location.iconImage(
                                          color: appStore.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                      8.width,
                                      Text(
                                        appStore.isCurrentLocation
                                            ? place ?? language.getLocation
                                            : language.lblLocationOff,
                                        style: secondaryTextStyle(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ).expand(),
                                    ]),
                                children: [
                                  20.height,
                                  AppButton(
                                    padding: EdgeInsets.all(0),
                                    width: context.width(),
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // ic_location.iconImage(
                                          //     color: appStore.isDarkMode
                                          //         ? Colors.white
                                          //         : Colors.black),
                                          // 8.width,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                appStore.isCurrentLocation
                                                    ? language.getLocation
                                                    : language.lblLocationOff,
                                                style: secondaryTextStyle(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ).expand(),
                                          8.width,
                                          ic_active_location.iconImage(
                                              size: 24,
                                              color: appStore.isCurrentLocation
                                                  ? context.primaryColor
                                                  : grey),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      PlacesScreen()
                                          .launch<pSDK.FetchPlaceResponse?>(
                                              context)
                                          .then((prediction) async {
                                        if (prediction?.place?.address !=
                                                null &&
                                            prediction?.place?.latLng != null) {
                                          place = prediction?.place?.address ??
                                              place;
                                          final latitude =
                                              prediction?.place?.latLng?.lat ??
                                                  getDoubleAsync(LATITUDE);
                                          final longitude =
                                              prediction?.place?.latLng?.lng ??
                                                  getDoubleAsync(LONGITUDE);
                                          latLng = LatLng(latitude, longitude);
                                          setState(() {});
                                          await _resetScreen();
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: 16),
                            ],
                          ).paddingSymmetric(horizontal: 16),
                        ],
                      ),
                    ),
                  ];
                },
                body: Builder(
                  builder: (context) {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (appStore.isLoading) return appStore.isLoading;
                        if (scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent) {
                          if (!isLastPage) page++;
                          _fetchProducts();
                        }
                        return true;
                      },
                      child: productsList.isEmpty && appStore.isLoading
                          ? Offstage()
                          : productsList.isEmpty
                              ? Center(
                                  child: Text(language.noDataAvailable),
                                )
                              : GridView.builder(
                                  padding: EdgeInsets.all(20.0),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: productsList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 245,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  itemBuilder: (context, index) {
                                    return ProductComponent(
                                      productData: productsList[index],
                                    );
                                  },
                                ),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }
}
