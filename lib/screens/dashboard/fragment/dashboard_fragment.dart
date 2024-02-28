import 'dart:async';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/banner_ads_model.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/model/dashboard_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/product_module/models/product_category.dart';
import 'package:booking_system_flutter/product_module/models/product_data.dart';
import 'package:booking_system_flutter/product_module/screens/cart_screen.dart';
import 'package:booking_system_flutter/product_module/screens/view_all_products_screen.dart';
import 'package:booking_system_flutter/product_module/services/store_service.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/featured_service_list_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/horizontal_service_list_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/product_category_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/products_list_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/service_list_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/slider_and_location_component.dart';
import 'package:booking_system_flutter/screens/dashboard/shimmer/dashboard_shimmer.dart';
import 'package:booking_system_flutter/services/location_service.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../component/cached_image_widget.dart';
import '../../../component/empty_error_state_widget.dart';
import '../../../component/loader_widget.dart';
import '../../../component/shimmer_widget.dart';
import '../../../product_module/provider/wish_list_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/configs.dart';
import '../../../utils/images.dart';
import '../../../utils/services/ad_service/ad_helper.dart';
import '../../notification/notification_screen.dart';
import '../../service/view_all_service_screen.dart';
import '../component/booking_confirmed_component.dart';

class DashboardFragment extends StatefulWidget {
  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  Future<DashboardResponse>? future;
  Future<BannerAdsModel>? bannerFuture;

  int page = 1;
  ValueNotifier<BannerAd?> _bannerAd = ValueNotifier(null);

  Future<bool> _initBanner() async {
    Completer<bool> completer = Completer<bool>();
    await BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          completer.complete(true);

          // setState(() {
          _bannerAd.value = ad as BannerAd;
          _bannerAd;
          // });
        },
        onAdFailedToLoad: (ad, err) {
          log('Failed to load a banner ad: ${err.message}');
          ad.dispose();
          completer.complete(false);
        },
      ),
    ).load();
    return completer.future;
  }

  ValueNotifier<List<ProductCategory>> productCategories =
      ValueNotifier(cachedProductCategories ?? []);

  Future _getProductCategories() async {
    if (cachedServicesByCategory != null) return;
    try {
      productCategories.value = await StoreService.getProductCategories();
      if (productCategories.value.isNotEmpty) {
        // await _getPaginatedData();
      }
      cachedProductCategories = productCategories.value;
      productCategories;
    } catch (e) {
      print("Error product cat: $e");
    }
  }

  // ValueNotifier<List<ProductByCat>> productsByCategory =
  //     ValueNotifier<List<ProductByCat>>([]);

  // Future<void> _getPaginatedData() async {
  //   productsByCategory.value = [];
  //   final latLng = LatLng(getDoubleAsync(LATITUDE), getDoubleAsync(LONGITUDE));
  //   for (final e in productCategories.value) {
  //     await StoreService.getProducts(
  //             latLng: latLng, categoryId: e.id?.toString())
  //         .then((paginatedProducts) {
  //       if (!productsByCategory.value
  //           .map((e) => e.category.id ?? -1)
  //           .contains(e.id))
  //         productsByCategory.value.add(
  //             ProductByCat(category: e, paginatedProducts: paginatedProducts));
  //       productsByCategory;
  //     }).onError((error, stackTrace) {
  //       toast(error.toString());
  //     });
  //   }
  // }

  ValueNotifier<BannerAdsModel?> bannerModel = ValueNotifier(cachedBannerAds);
  _initServerBanners() {
    if (cachedBannerAds == null)
      getBannerAds().then((value) {
        bannerModel.value = value;
        cachedBannerAds = value;
        bannerModel;
      });
  }

  @override
  void initState() {
    // if (appStore.isDarkMode) {
    //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     systemNavigationBarColor: scaffoldColorDark,
    //     systemNavigationBarDividerColor: Colors.transparent,
    //     systemNavigationBarIconBrightness: Brightness.dark,
    //   ));
    // } else {
    //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     systemNavigationBarColor: Colors.white,
    //     systemNavigationBarDividerColor: Colors.transparent,
    //     systemNavigationBarIconBrightness: Brightness.light,
    //   ));
    // }
    if (appStore.isCurrentLocation == false) {
      appStore.setCurrentLocation(true);
    }

    super.initState();
    _initServerBanners();
    init();
    _initBanner();
    if (appStore.isLoggedIn && WishListProvider().wishList.value.isEmpty)
      StoreService.getWishList().then(
        (wishes) => WishListProvider().fillValue(wishes),
      );

    setStatusBarColor(transparentColor, delayInMilliSeconds: 800);

    LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      setState(() {});
    });
  }

  ValueNotifier<List<ServicesByCat>> servicesByCategory =
      ValueNotifier<List<ServicesByCat>>(cachedServicesByCategory ?? []);

  Future<void> _catsToServicesByCats(
      DashboardResponse value, LatLng latLng) async {
    final cats = value.category ?? [];
    List<ServicesByCat> _temp = [];
    if (cachedServicesByCategory != null) return;
    for (final e in cats) {
      await searchServiceAPI(
        page: page,
        list: [],
        categoryId: e.id?.toString() ?? '',
        latitude: latLng.latitude == -111 ? '' : latLng.latitude.toString(),
        longitude: latLng.longitude == -111 ? '' : latLng.longitude.toString(),
      ).then((servicesList) {
        if (!servicesByCategory.value
            .map((e) => e.category.id ?? -1)
            .contains(e.id))
          _temp.add(ServicesByCat(category: e, servicesList: servicesList));
      }).catchError(onError);
    }
    servicesByCategory.value = _temp;
    cachedServicesByCategory = _temp;
    servicesByCategory;
  }

  void init() async {
    future = userDashboard(
        isCurrentLocation: getDoubleAsync(LATITUDE, defaultValue: -111) == -111
            ? false
            : appStore.isCurrentLocation,
        lat: getDoubleAsync(LATITUDE),
        long: getDoubleAsync(LONGITUDE));

    // servicesByCategory.value = [];
    await _mangeInitialLocation().then((value) async {}).catchError((e) {
      toast(e);
    });
    if (cachedDashboardResponse == null && mounted) setState(() {});
    await _getProductCategories();
    // bannerFuture = getBannerAds();
  }

  Future<void> _mangeInitialLocation() async {
    final address = getStringAsync(CURRENT_ADDRESS);
    final lat = getDoubleAsync(LATITUDE, defaultValue: -1000);
    final long = getDoubleAsync(LONGITUDE, defaultValue: -1000);
    if (address.isEmpty || lat == -1000 || long == -1000) {
      await getUserLocationPosition().then((value) async {
        await setValue(LATITUDE, value.latitude);
        await setValue(LONGITUDE, value.longitude);
        return buildFullAddressFromLatLong(value.latitude, value.longitude);
      }).then((value) => setValue(CURRENT_ADDRESS, value));
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_DASHBOARD);
  }

  ValueNotifier<bool> showServices = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        actions: [
          Observer(builder: (context) {
            return !appStore.isLoggedIn
                ? const SizedBox()
                : Container(
                    decoration: boxDecorationDefault(
                        color: context.cardColor, shape: BoxShape.circle),
                    height: 36,
                    padding: EdgeInsets.all(8),
                    width: 36,
                    margin: EdgeInsets.only(right: 10.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ic_notification
                            .iconImage(
                                size: 24,
                                color: appStore.isDarkMode
                                    ? primaryColorDark
                                    : primaryColor)
                            .center(),
                        Observer(builder: (context) {
                          return Positioned(
                            top: -20,
                            right: -10,
                            child: appStore.unreadCount.validate() > 0
                                ? Container(
                                    padding: EdgeInsets.all(4),
                                    child: FittedBox(
                                      child: Text(
                                          appStore.unreadCount.toString(),
                                          style: primaryTextStyle(
                                              size: 12, color: Colors.white)),
                                    ),
                                    decoration: boxDecorationDefault(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                  )
                                : Offstage(),
                          );
                        })
                      ],
                    ),
                  ).onTap(() {
                    NotificationScreen().launch(context);
                  });
          }),
          Observer(builder: (context) {
            return !appStore.isLoggedIn
                ? const SizedBox()
                : FutureBuilder(
                    future:
                        StoreService.getCart().then((value) => value.length),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return Stack(
                        alignment: Alignment.topRight,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: boxDecorationDefault(
                                color: context.cardColor,
                                shape: BoxShape.circle),
                            height: 36,
                            padding: EdgeInsets.all(8),
                            width: 36,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.shopping_bag_outlined,
                                size: 20,
                                color: appStore.isDarkMode
                                    ? primaryColorDark
                                    : primaryColor),
                          ).onTap(() {
                            CartScreen().launch(context);
                          }),
                          if (count > 0)
                            Positioned(
                              top: -5,
                              child: Container(
                                decoration: boxDecorationDefault(
                                    color: redColor, shape: BoxShape.circle),
                                height: 16,
                                width: 16,
                                alignment: Alignment.center,
                                child: Marquee(
                                  child: Text(
                                    count.toString(),
                                    style: primaryTextStyle(size: 10),
                                  ),
                                ),
                              ),
                            )
                        ],
                      );
                    });
          }),
        ],
        title: Text(
          language.home,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: context.primaryColor),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // systemOverlayStyle: appStore.isDarkMode
        //     ? SystemUiOverlayStyle(
        //         systemNavigationBarColor: scaffoldColorDark,
        //         systemNavigationBarDividerColor: Colors.transparent,
        //         systemNavigationBarIconBrightness: Brightness.dark,
        //       )
        //     : SystemUiOverlayStyle(
        //         systemNavigationBarColor: Colors.white,
        //         systemNavigationBarDividerColor: Colors.transparent,
        //         systemNavigationBarIconBrightness: Brightness.light,
        //       ),
      ),
      body: Stack(
        children: [
          SnapHelperWidget<DashboardResponse>(
            initialData: cachedDashboardResponse,
            future: future?.then((value) {
              final latLng = LatLng(
                  getDoubleAsync(LATITUDE, defaultValue: -111),
                  getDoubleAsync(LONGITUDE, defaultValue: -111));
              _catsToServicesByCats(value, latLng);
              return value;
            }),
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: language.reload,
                onRetry: () {
                  appStore.setLoading(true);
                  init();

                  setState(() {});
                },
              );
            },
            loadingWidget: DashboardShimmer(),
            onSuccess: (snap) {
              return RefreshIndicator(
                  onRefresh: () async {
                    page = 1;
                    appStore.setLoading(true);

                    init();
                    setState(() {});

                    return await 2.seconds.delay;
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(children: [
                          SliderLocationComponent(
                            sliderList: snap.slider.validate(),
                            onTapSearch: () {
                              if (showServices.value) {
                                ViewAllServiceScreen().launch(context);
                              } else {
                                ViewAllProductsScreen().launch(context);
                              }
                            },
                            callback: () async {
                              appStore.setLoading(true);
                              init();
                              await 300.milliseconds.delay;
                              cachedServicesByCategory = null;
                              setState(() {});
                            },
                          ),
                          30.height,
                          PendingBookingComponent(
                              upcomingData: snap.upcomingData),

                          /// TabBar
                          ValueListenableBuilder(
                              valueListenable: showServices,
                              builder: (context, _, __) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, bottom: 16.0),
                                  child: Row(
                                    children: [
                                      TabButton(
                                        text: language.lblServices,
                                        isSelected: showServices.value,
                                        onTap: () {
                                          showServices.value = true;
                                          showServices;
                                        },
                                      ),
                                      12.width,
                                      TabButton(
                                        text: language.lblProducts,
                                        isSelected: !showServices.value,
                                        onTap: () {
                                          showServices.value = false;
                                          showServices;
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),

                          LayoutBuilder(builder: (context, constaints) {
                            final double height =
                                constaints.maxWidth > constaints.maxHeight
                                    ? 200
                                    : 100;
                            return ValueListenableBuilder(
                                valueListenable: bannerModel,
                                // errorBuilder: (error) {
                                //   // return NoDataWidget(
                                //   //   title: error,
                                //   //   imageWidget: ErrorStateWidget(),
                                //   //   retryText: language.reload,
                                //   //   onRetry: () {
                                //   //     appStore.setLoading(true);
                                //   //     init();

                                //   //     setState(() {});
                                //   //   },
                                //   // );
                                //   return const SizedBox();
                                // },
                                // loadingWidget: ShimmerWidget(
                                //         height: height, width: context.width())
                                //     .paddingSymmetric(horizontal: 20),
                                builder: (context, _, __) {
                                  return bannerModel.value == null
                                      ? ShimmerWidget(
                                              height: height,
                                              width: context.width())
                                          .paddingSymmetric(horizontal: 20)
                                      : (bannerModel.value?.ads ?? []).isEmpty
                                          ? const SizedBox()
                                          : BannerAdsSlider(
                                              height: height,
                                              sliderList:
                                                  bannerModel.value?.ads ?? [],
                                            );
                                });
                          }),
                          16.height,
                          ValueListenableBuilder(
                              valueListenable: _bannerAd,
                              builder: (context, _, __) {
                                return Column(
                                  children: [
                                    if (_bannerAd.value != null) ...[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: _bannerAd.value?.size.width
                                                  .toDouble(),
                                              height: _bannerAd
                                                  .value?.size.height
                                                  .toDouble(),
                                              child: AdWidget(
                                                  ad: _bannerAd.value!),
                                            ),
                                          ),
                                        ],
                                      ),
                                      16.height,
                                    ],
                                  ],
                                );
                              }),
                        ]),
                      ),
                      SliverList(
                          // listAnimationType: ListAnimationType.FadeIn,
                          // fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                          delegate: SliverChildListDelegate(
                        [
                          //switch for services and products
                          ValueListenableBuilder(
                              valueListenable: showServices,
                              builder: (context, _, __) {
                                return !showServices.value
                                    ? Column(
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable:
                                                  productCategories,
                                              builder: (context, _, __) {
                                                return productCategories
                                                        .value.isEmpty
                                                    ? const SizedBox()
                                                    : ProductCategoryComponent(
                                                        categoryList:
                                                            productCategories
                                                                .value,
                                                      );
                                              }),

                                          Column(
                                            children: [
                                              if (snap.featured_product
                                                      ?.isNotEmpty ??
                                                  false)
                                                ProductsListComponent(
                                                  productsList:
                                                      snap.featured_product ??
                                                          [],
                                                  categoryId: null,
                                                  categoryName:
                                                      language.lblFeatured,
                                                ),
                                              ...(snap.products_by_category ??
                                                      [])
                                                  .map(
                                                (e) {
                                                  final productsList =
                                                      e.products ?? [];

                                                  return ProductsListComponent(
                                                    productsList: productsList,
                                                    categoryId: e.id,
                                                    categoryName: e.name,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),

                                          // ValueListenableBuilder(
                                          //     valueListenable: productsByCategory,
                                          //     builder: (context, value, _) {
                                          //       return Column(
                                          //         children: [
                                          //           ...(snap.products_by_category ?? [])
                                          //               .map(
                                          //             (e) {
                                          //               final productsList =
                                          //                   e.products ?? [];

                                          //               return ProductsListComponent(
                                          //                 productsList: productsList,
                                          //                 categoryId: e.id,
                                          //                 categoryName: e.name,
                                          //               );
                                          //             },
                                          //           ),
                                          //         ],
                                          //       );
                                          //     }),
                                        ],
                                      )
                                    : Column(children: [
                                        CategoryComponent(
                                            categoryList:
                                                snap.category.validate()),
                                        FeaturedServiceListComponent(
                                            serviceList: snap.featuredServices
                                                .validate()),
                                        // Column(
                                        //   children: [
                                        //     if ((snap.service_by_category ?? [])
                                        //             .length >
                                        //         5)
                                        //       ...(snap.service_by_category ?? [])
                                        //           .sublist(0, 4)
                                        //           .map((e) {
                                        //         return (e.services ?? []).isEmpty
                                        //             ? SizedBox()
                                        //             : HorizontalServiceListComponent(
                                        //                 serviceList: e.services ?? [],
                                        //                 categoryData: CategoryData(
                                        //                     id: e.id, name: e.name));
                                        //       }),
                                        //     if ((snap.service_by_category ?? [])
                                        //             .length <=
                                        //         5)
                                        //       ...(snap.service_by_category ?? [])
                                        //           .map((e) {
                                        //         return (e.services ?? []).isEmpty
                                        //             ? SizedBox()
                                        //             : HorizontalServiceListComponent(
                                        //                 serviceList: e.services ?? [],
                                        //                 categoryData: CategoryData(
                                        //                     id: e.id, name: e.name));
                                        //       }),
                                        //   ],
                                        // ),

                                        ValueListenableBuilder(
                                            valueListenable: servicesByCategory,
                                            builder: (context, value, _) {
                                              return Column(
                                                children: [
                                                  ...(servicesByCategory
                                                              .value ??
                                                          [])
                                                      .map((e) {
                                                    return (e.servicesList ??
                                                                [])
                                                            .isEmpty
                                                        ? SizedBox()
                                                        : HorizontalServiceListComponent(
                                                            serviceList:
                                                                e.servicesList ??
                                                                    [],
                                                            categoryData:
                                                                CategoryData(
                                                                    id: e
                                                                        .category
                                                                        .id,
                                                                    name: e
                                                                        .category
                                                                        .name));
                                                  }),
                                                ],
                                              );
                                            }),

                                        // ServiceListComponent(
                                        //     serviceList:
                                        //         snap.service.validate().length >
                                        //                 100
                                        //             ? snap.service
                                        //                 .validate()
                                        //                 .sublist(0, 99)
                                        //             : snap.service.validate()),
                                      ]);
                              }),
                          16.height,
                          // NewJobRequestComponent(),
                        ],
                      )),
                    ],
                  ));
            },
          ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  const TabButton({
    super.key,
    required this.text,
    required this.isSelected,
    this.onTap,
  });
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: black.withOpacity(0.2),
                  blurRadius: 7)
            ],
            borderRadius: BorderRadius.circular(10.0),
            color: isSelected ? Theme.of(context).primaryColor : white,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: isSelected ? white : grey),
          ),
        ),
      ),
    );
  }
}

class BannerAdsSlider extends StatefulWidget {
  final double height;
  const BannerAdsSlider({
    super.key,
    required this.sliderList,
    required this.height,
  });
  final List<Ads> sliderList;

  @override
  State<BannerAdsSlider> createState() => _BannerAdsSliderState();
}

class _BannerAdsSliderState extends State<BannerAdsSlider> {
  PageController sliderPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (getBoolAsync(AUTO_SLIDER_STATUS, defaultValue: true) &&
        widget.sliderList.length >= 2) {
      _timer = Timer.periodic(Duration(seconds: DASHBOARD_AUTO_SLIDER_SECOND),
          (Timer timer) {
        if (_currentPage < widget.sliderList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        sliderPageController.animateToPage(_currentPage,
            duration: Duration(milliseconds: 950), curve: Curves.easeOutQuart);
      });

      sliderPageController.addListener(() {
        _currentPage = sliderPageController.page!.toInt();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    sliderPageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: height,
      child: Stack(
        children: [
          PageView(
            controller: sliderPageController,
            children: List.generate(
              widget.sliderList.length,
              (index) {
                Ads data = widget.sliderList[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Material(
                    elevation: 7,
                    child: CachedImageWidget(
                            url: DOMAIN_URL + '/' + data.banner.validate(),
                            height: height,
                            width: context.width(),
                            fit: BoxFit.cover)
                        .onTap(() async {
                      if (await canLaunchUrl(Uri.parse(data.webUrl ?? ''))) {
                        launchUrl(
                          Uri.parse(data.webUrl ?? ''),
                        );
                      }
                    }),
                  ),
                );
              },
            ),
          ),
          if (widget.sliderList.length.validate() > 1)
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: DotIndicator(
                pageController: sliderPageController,
                pages: widget.sliderList,
                indicatorColor: white,
                unselectedIndicatorColor: white,
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                borderRadius: radius(2),
                currentBorderRadius: radius(3),
                currentDotSize: 18,
                currentDotWidth: 6,
                dotSize: 6,
              ),
            ),
        ],
      ),
    );
  }
}

class ProductByCat {
  final ProductCategory category;
  final ProductsPaginationModel paginatedProducts;
  ProductByCat({required this.category, required this.paginatedProducts});
}

class ServicesByCat {
  final CategoryData category;
  final List<ServiceData> servicesList;
  ServicesByCat({required this.category, required this.servicesList});
}
