import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/orders_module/screens/orders_main_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/fragment/booking_fragment.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/services/ad_service/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/base_scaffold_widget.dart';
import '../../utils/constant.dart';

class BookingOrdersSwitching extends StatefulWidget {
  const BookingOrdersSwitching({super.key, this.showBack = false});

  @override
  _BookingOrdersSwitchingState createState() => _BookingOrdersSwitchingState();
  final bool showBack;
}

class _BookingOrdersSwitchingState extends State<BookingOrdersSwitching> {
  // int page = 0;
  // bool isLastPage = false;
  // bool isApiCalled = false;
  BannerAd? _bannerAd;

  _initBanner() async {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          log('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    init();
    _initBanner();
  }

  Future<void> init() async {}

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    controller.dispose();
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  ValueNotifier<int> selectedPage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedPage,
        builder: (context, val, _) {
          return Scaffold(
            appBar: appBarWidget(
              val == 0 ? language.booking : language.lblOrders,
              textColor: context.primaryColor,
              showBack: false,
              textSize: APP_BAR_TEXT_SIZE,
              elevation: 3.0,
              color: context.scaffoldBackgroundColor,
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      val == 0 ? primaryColor : null),
                              child: Text(
                                language.booking,
                                style: boldTextStyle(
                                  color: val == 0 ? white : null,
                                ),
                              ),
                              onPressed: () {
                                controller.jumpToPage(0);
                                selectedPage.value = 0;
                              },
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      val == 1 ? primaryColor : null),
                              child: Text(
                                language.lblOrders,
                                style: boldTextStyle(
                                  color: val == 1 ? white : null,
                                ),
                              ),
                              onPressed: () {
                                selectedPage.value = 1;

                                controller.jumpToPage(1);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_bannerAd != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: _bannerAd!.size.width.toDouble(),
                              height: _bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd!),
                            ),
                          ),
                        ],
                      ),
                      16.height,
                    ],
                    Expanded(
                      child: PageView(
                        onPageChanged: (value) => selectedPage.value = value,
                        controller: controller,
                        children: [BookingFragment(), OrdersMainScreen()],
                      ),
                    ),
                  ],
                ),
                Observer(
                    builder: (context) =>
                        LoaderWidget().visible(appStore.isLoading))
              ],
            ),
          );
        });
  }
}
