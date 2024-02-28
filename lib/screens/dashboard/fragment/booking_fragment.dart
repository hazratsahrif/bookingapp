import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_data_model.dart';
import 'package:booking_system_flutter/model/booking_status_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/product_module/provider/wish_list_provider.dart';
import 'package:booking_system_flutter/product_module/services/store_service.dart';
import 'package:booking_system_flutter/screens/booking/booking_detail_screen.dart';
import 'package:booking_system_flutter/screens/booking/component/booking_item_component.dart';
import 'package:booking_system_flutter/screens/booking/component/status_dropdown_component.dart';
import 'package:booking_system_flutter/screens/booking/shimmer/booking_shimmer.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../utils/services/ad_service/ad_helper.dart';

class BookingFragment extends StatefulWidget {
  @override
  _BookingFragmentState createState() => _BookingFragmentState();
}

class _BookingFragmentState extends State<BookingFragment> {
  UniqueKey keyForStatus = UniqueKey();

  ScrollController scrollController = ScrollController();

  Future<List<BookingData>>? future;
  List<BookingData> bookings = [];

  int page = 1;
  bool isLastPage = false;

  String selectedValue = BOOKING_TYPE_ALL;
  // BannerAd? _bannerAd;

  // _initBanner() async {
  //   BannerAd(
  //     adUnitId: AdHelper.bannerAdUnitId,
  //     request: AdRequest(),
  //     size: AdSize.banner,
  //     listener: BannerAdListener(
  //       onAdLoaded: (ad) {
  //         setState(() {
  //           _bannerAd = ad as BannerAd;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, err) {
  //         log('Failed to load a banner ad: ${err.message}');
  //         ad.dispose();
  //       },
  //     ),
  //   ).load();
  // }

  @override
  void initState() {
    super.initState();
    init();
    // _initBanner();

    afterBuildCreated(() {
      if (appStore.isLoggedIn) {
        setStatusBarColor(context.primaryColor);
      }
    });

    LiveStream().on(LIVESTREAM_UPDATE_BOOKING_LIST, (p0) {
      page = 1;
      init();
      setState(() {});
    });
  }

  void init() async {
    future = getBookingList(page, status: selectedValue, bookings: bookings,
        lastPageCallback: (b) {
      isLastPage = b;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_BOOKING_LIST);
    //scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarWidget(
      //   language.booking,
      //   textColor: context.primaryColor,
      //   showBack: false,
      //   textSize: APP_BAR_TEXT_SIZE,
      //   elevation: 3.0,
      //   color: context.scaffoldBackgroundColor,
      // ),
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: Stack(
          children: [
            Column(
              children: [
                // if (_bannerAd != null) ...[
                //   Row(
                //     children: [
                //       Expanded(
                //         child: SizedBox(
                //           width: _bannerAd!.size.width.toDouble(),
                //           height: _bannerAd!.size.height.toDouble(),
                //           child: AdWidget(ad: _bannerAd!),
                //         ),
                //       ),
                //     ],
                //   ),
                //   16.height,
                // ],
                Expanded(
                  child: SnapHelperWidget<List<BookingData>>(
                    initialData: cachedBookingList,
                    future: future,
                    errorBuilder: (error) {
                      return NoDataWidget(
                        title: error,
                        imageWidget: ErrorStateWidget(),
                        retryText: language.reload,
                        onRetry: () {
                          keyForStatus = UniqueKey();
                          page = 1;
                          appStore.setLoading(true);

                          init();
                          setState(() {});
                        },
                      );
                    },
                    loadingWidget: BookingShimmer(),
                    onSuccess: (list) {
                      return AnimatedListView(
                        controller: scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                            bottom: 60, top: 8, right: 16, left: 16),
                        itemCount: list.length,
                        shrinkWrap: true,
                        listAnimationType: ListAnimationType.FadeIn,
                        fadeInConfiguration:
                            FadeInConfiguration(duration: 2.seconds),
                        slideConfiguration:
                            SlideConfiguration(verticalOffset: 400),
                        emptyWidget: NoDataWidget(
                          title: language.lblNoBookingsFound,
                          subTitle: language.noBookingSubTitle,
                          imageWidget: EmptyStateWidget(),
                        ),
                        itemBuilder: (_, index) {
                          BookingData? data = list[index];

                          return GestureDetector(
                            onTap: () {
                              BookingDetailScreen(bookingId: data.id.validate())
                                  .launch(context);
                            },
                            child: BookingItemComponent(bookingData: data),
                          );
                        },
                        onNextPage: () {
                          if (!isLastPage) {
                            page++;
                            appStore.setLoading(true);

                            init();
                            setState(() {});
                          }
                        },
                        onSwipeRefresh: () async {
                          page = 1;

                          init();
                          setState(() {});

                          return await 2.seconds.delay;
                        },
                      ).paddingOnly(left: 0, right: 0, bottom: 0, top: 76);
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              top: 16
              //  +(_bannerAd?.size.height.toDouble() ?? 0)
              ,
              child: StatusDropdownComponent(
                isValidate: false,
                key: keyForStatus,
                onValueChanged: (BookingStatusResponse value) {
                  selectedValue = value.value.toString();

                  page = 1;
                  appStore.setLoading(true);
                  init();

                  setState(() {});

                  if (bookings.isNotEmpty) {
                    scrollController.animateTo(0,
                        duration: 1.seconds, curve: Curves.easeOutQuart);
                  } else {
                    scrollController = ScrollController();
                  }
                },
              ),
            ),
            Observer(
                builder: (_) => LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
