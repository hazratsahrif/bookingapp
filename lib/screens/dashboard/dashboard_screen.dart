import 'dart:async';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/orders_module/screens/order_details_screen.dart';
import 'package:booking_system_flutter/orders_module/service/order_service.dart';
import 'package:booking_system_flutter/product_module/screens/add_product_screen.dart';
import 'package:booking_system_flutter/product_module/screens/my_product_screens.dart';
import 'package:booking_system_flutter/product_module/screens/product_details_screen.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/booking/booking_detail_screen.dart';
import 'package:booking_system_flutter/screens/category/category_screen.dart';
import 'package:booking_system_flutter/screens/chat/chat_list_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/booking_orders_switching.dart';
import 'package:booking_system_flutter/screens/dashboard/fragment/booking_fragment.dart';
import 'package:booking_system_flutter/screens/dashboard/fragment/dashboard_fragment.dart';
import 'package:booking_system_flutter/screens/dashboard/fragment/profile_fragment.dart';
import 'package:booking_system_flutter/screens/service/service_detail_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uni_links/uni_links.dart';

import '../../network/rest_apis.dart';
import '../../services/location_service.dart';
import '../../utils/services/ad_service/ad_helper.dart';
import '../jobRequest/create_post_request_screen.dart';
import '../jobRequest/my_post_request_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  final bool? redirectToBooking;

  DashboardScreen({this.redirectToBooking});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// uni links handled start

  uniLinkHandler(Uri? link) async {
    log('Got Link: $link');
    if (link == null) return;
    //for services
    if (link.toString().contains('service')) {
      int? id = int.tryParse(link.queryParameters['id'].toString());
      if (id == null) return;
      ServiceDetailScreen(
        serviceId: id,
      ).launch(navigatorKey.currentContext!);
    } else if (link.toString().contains('product')) {
      final String? id = link.queryParameters['product_id'].toString();
      if (id == null) return;
      ProductDetailsScreen(
        productId: id,
      ).launch(navigatorKey.currentContext!);
    }
  }

  _initUniLinks() async {
    try {
      final initialUri = await getInitialUri();
      uniLinkHandler(initialUri);
      // Use the uri and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on FormatException catch (e) {
      snackBar(context, title: 'Invalid url', backgroundColor: Colors.red);
    } catch (e) {
      log(e);
    }
  }

  late final StreamSubscription _sub;

  Future<void> _initUniLinksStream() async {
    _sub = uriLinkStream.listen((Uri? link) {
      uniLinkHandler(link);
    }, onError: (err) {
      snackBar(context, title: 'Invalid url', backgroundColor: Colors.red);
    });
  }

  /// uni links handled end

  int currentIndex = 0;

  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (_interstitialAd != null) {
            _interstitialAd?.dispose();
            _interstitialAd = null;
          }

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
            _interstitialAd = ad;
          });
          _interstitialAd?.show();
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    _initUniLinks();
    _initUniLinksStream();
    super.initState();
    if (widget.redirectToBooking.validate(value: false)) {
      currentIndex = 1;
    }
    Geolocator.requestPermission();

    afterBuildCreated(() async {
      /// Changes System theme when changed
      if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }

      View.of(context).platformDispatcher.onPlatformBrightnessChanged =
          () async {
        if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
          appStore.setDarkMode(
              MediaQuery.of(context).platformBrightness == Brightness.light);
        }
      };
    });

    init();
  }

  void init() async {
    if (isMobile) {
      /// Handle Notification click and redirect to that Service & BookDetail screen
      OneSignal.Notifications.addClickListener((notification) async {
        if (notification.notification.additionalData == null) return;
        if (((notification.notification.additionalData?['type'] as String?)
                    ?.toLowerCase() ??
                '') ==
            'order') {
          final id = notification.notification.additionalData?['id'] as int?;
          if (id != null) {
            final order = await OrderService.getOrderDetails(id);
            if (order != null)
              OrderDetailsScreen(
                orderModel: order,
                isMyOrders: order?.user?.email == appStore.userEmail,
              ).launch(context);
          }
          return;
        }
        if (((notification.notification.additionalData?['type'] as String?)
                    ?.toLowerCase() ??
                '') ==
            'bid') {
          final id = notification.notification.additionalData?['id'] as int?;
          if (id != null) {
            MyProductListScreen().launch(context);
          }

          return;
        }

        if (notification.notification.additionalData!.containsKey('id')) {
          String? notId =
              notification.notification.additionalData!["id"].toString();
          if (notId.validate().isNotEmpty) {
            BookingDetailScreen(bookingId: notId.toString().toInt())
                .launch(context);
          }
        } else if (notification.notification.additionalData!
            .containsKey('service_id')) {
          String? notId =
              notification.notification.additionalData!["service_id"];
          if (notId.validate().isNotEmpty) {
            ServiceDetailScreen(serviceId: notId.toInt()).launch(context);
          }
        } else if (notification.notification.additionalData!
            .containsKey('sender_uid')) {
          String? notId =
              notification.notification.additionalData!["sender_uid"];
          if (notId.validate().isNotEmpty) {
            currentIndex = 3;
            setState(() {});
          }
        }
      });
    }

    if (!appStore.isCurrentLocation) {
      appStore.setCurrentLocation(true);
      // _mangeInitialLocation();
    }

    await 3.seconds.delay;
    // showForceUpdateDialog(context);
  }

  Future<void> _mangeInitialLocation() async => await getUserLocationPosition()
      .then((value) async {
        await setValue(LATITUDE, value.latitude);
        await setValue(LONGITUDE, value.longitude);
        return getUserLocation();
      })
      .then((value) => setValue(CURRENT_ADDRESS, value))
      .then((value) => appStore.setCurrentLocation(true));

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _sub.cancel();

    super.dispose();
  }

  // String otp = "";
  // bool isVerified = false;
  // bool isOtpSent = false;
  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: language.lblBackPressMsg,
      child: // !appStore.verifyOTP
          // &&
          //  appStore.isLoggedIn
          //     ? Scaffold(
          //         body: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               // 8.height,
          //               // ...isOtpSent
          //               //     ? [
          //               //         OTPTextField(
          //               //           fieldWidth: 50,
          //               //           decoration: inputDecoration(
          //               //             context,
          //               //           ).copyWith(
          //               //               counter: SizedBox(),
          //               //               border: InputBorder.none,
          //               //               focusColor: Colors.transparent,
          //               //               focusedBorder: InputBorder.none),
          //               //           onChanged: (value) {
          //               //             otp = value;
          //               //             setState(() {});
          //               //             if (otp.length == 4) {}
          //               //           },
          //               //         ),
          //               //         8.height,
          //               //         otp.length >= 4
          //               //             ? Row(
          //               //                 children: [
          //               //                   Spacer(),
          //               //                   Expanded(
          //               //                     child: AppButton(
          //               //                       text: (language.confirm + " OTP"),
          //               //                       height: 40,
          //               //                       color: appStore.isDarkMode
          // ? primaryColorDark
          // : primaryColor,
          //               //                       textStyle:
          //               //                           primaryTextStyle(color: white),
          //               //                       width: context.width() -
          //               //                           context.navigationBarHeight,
          //               //                       onTap: () async {
          //               //                         appStore.setLoading(true);
          //               //                         try {
          //               //                           var res = await verifyOtp({
          //               //                             "contact_number": (appStore
          //               //                                 .userContactNumber),
          //               //                             "otp": otp,
          //               //                           });
          //               //                           if (res != null) {
          //               //                             if (res['status'] == 200) {
          //               //                               await appStore
          //               //                                   .setVerifyOTP(true);
          //               //                               isOtpSent = false;
          //               //                               setState(() {});
          //               //                               toast(
          //               //                                   res['message'] ??
          //               //                                       'Success',
          //               //                                   print: true);
          //               //                             } else {
          //               //                               toast(
          //               //                                   res['message'] ??
          //               //                                       'Error',
          //               //                                   print: true);
          //               //                             }
          //               //                           }
          //               //                         } catch (e) {
          //               //                           log(e);
          //               //                         }
          //               //                         appStore.setLoading(false);
          //               //                       },
          //               //                     ),
          //               //                   ),
          //               //                   Spacer(),
          //               //                 ],
          //               //               )
          //               //             : SizedBox(),
          //               //       ]
          //               //     : [
          //               //         Row(
          //               //           children: [
          //               //             Spacer(),
          //               //             Expanded(
          //               //               child: AppButton(
          //               //                 text: ("Send" + " OTP"),
          //               //                 height: 40,
          //               //                 color: appStore.isDarkMode
          // ? primaryColorDark
          // : primaryColor,
          //               //                 textStyle: primaryTextStyle(color: white),
          //               //                 width: context.width() -
          //               //                     context.navigationBarHeight,
          //               //                 onTap: () async {
          //               //                   appStore.setLoading(true);
          //               //                   try {
          //               //                     log(appStore.userContactNumber);
          //               //                     var res = await requestOtp({
          //               //                       "contact_number":
          //               //                           (appStore.userContactNumber)
          //               //                     });
          //               //                     log(res);

          //               //                     if (res != null) {
          //               //                       if (res['status'] == 200) {
          //               //                         setState(() {
          //               //                           isOtpSent = true;
          //               //                         });
          //               //                         toast(res['message'] ?? 'Success',
          //               //                             print: true);
          //               //                       } else {
          //               //                         toast(res['message'] ?? 'Error',
          //               //                             print: true);
          //               //                       }
          //               //                     }
          //               //                   } catch (e) {
          //               //                     log(e);
          //               //                   }
          //               //                   appStore.setLoading(false);
          //               //                 },
          //               //               ),
          //               //             ),
          //               //             Spacer(),
          //               //           ],
          //               //         )
          //               //       ],
          //               8.height,
          //               TextButton(
          //                 child: Text(language.logout,
          //                     style:
          // //                         boldTextStyle(color: appStore.isDarkMode
          //                     ? primaryColorDark
          //                     : primaryColor, size: 16)),
          //                 onPressed: () {
          //                   appStore.setLoading(false);
          //                   logout(context);
          //                 },
          //               ).center().visible(appStore.isLoggedIn),
          //             ]),
          //       )
          //     :
          Scaffold(
        floatingActionButton: Observer(
          builder: (context) => appStore.isLoggedIn
              ? InkWell(
                  onTap: () {
                    MyProductListScreen()
                        .launch(context)
                        .then((value) => _loadInterstitialAd());
                  },
                  child: IgnorePointer(
                    child: PopupMenuButton<String>(
                      color: white,
                      surfaceTintColor: Colors.transparent,
                      child: Container(
                          padding: EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.circular(6.0),
                              color: blueColor),
                          child: ic_post.iconImage(color: white)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onSelected: (value) {
                        switch (value) {
                          case 'service':
                            {
                              MyPostRequestListScreen()
                                  .launch(context)
                                  .then((value) => _loadInterstitialAd());
                              break;
                            }
                          case 'product':
                            {
                              MyProductListScreen()
                                  .launch(context)
                                  .then((value) => _loadInterstitialAd());
                              break;
                            }
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          // PopupMenuItem<String>(
                          //   child: Text(language.lblRequest),
                          //   value: 'service',
                          // ),
                          // PopupMenuItem<String>(
                          //   child: Text(language.lblSell),
                          //   value: 'product',
                          // ),
                        ];
                      },
                    ),
                  ),
                )
              : SizedBox(),
        ),
        body: [
          // !appStore.isCurrentLocation
          //     ? Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             language.lblLocationPermissionDenied,
          //             style: TextStyle(
          //                 color: appStore.isDarkMode ? white : black),
          //           ),
          //           const SizedBox(
          //             height: 10.0,
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               AppButton(
          //                 color: blueColor,
          //                 text: language.getLocation,
          //                 onTap: () {
          //                   locationWiseServiceForce(context, () {
          //                     appStore.setLoading(false);
          //                   });
          //                 },
          //               ),
          //             ],
          //           )
          //         ],
          //       )
          //     :
          DashboardFragment(),
          Observer(
              builder: (context) => appStore.isLoggedIn
                  // ? BookingFragment()
                  ? BookingOrdersSwitching()
                  : SignInScreen(isFromDashboard: true)),
          // Observer(
          //     builder: (context) => appStore.isLoggedIn
          //         ? MyPostRequestListScreen(
          //             showBack: false,
          //           )
          //         : SignInScreen(isFromDashboard: true)),
          CategoryScreen(),
          Observer(
              builder: (context) => appStore.isLoggedIn
                  ? ChatListScreen()
                  : SignInScreen(isFromDashboard: true)),
          ProfileFragment(),
        ][currentIndex],
        bottomNavigationBar: Blur(
          blur: 30,
          borderRadius: radius(0),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: context.primaryColor.withOpacity(0.02),
              indicatorColor: context.primaryColor.withOpacity(0.1),
              labelTextStyle:
                  MaterialStateProperty.all(primaryTextStyle(size: 12)),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: NavigationBar(
              selectedIndex: currentIndex,
              destinations: [
                NavigationDestination(
                  icon: ic_home.iconImage(color: appTextSecondaryColor),
                  selectedIcon: ic_home.iconImage(color: context.primaryColor),
                  label: language.home,
                ),
                NavigationDestination(
                  icon: ic_ticket.iconImage(color: appTextSecondaryColor),
                  selectedIcon:
                      ic_ticket.iconImage(color: context.primaryColor),
                  label: language.booking,
                ),
                // NavigationDestination(
                //   icon: ic_post.iconImage(color: appTextSecondaryColor),
                //   selectedIcon: ic_post.iconImage(color: context.primaryColor),
                //   label: 'My Post',
                // ),
                NavigationDestination(
                  icon: ic_category.iconImage(color: appTextSecondaryColor),
                  selectedIcon:
                      ic_category.iconImage(color: context.primaryColor),
                  label: language.category,
                ),
                NavigationDestination(
                  icon: ic_chat.iconImage(color: appTextSecondaryColor),
                  selectedIcon: ic_chat.iconImage(color: context.primaryColor),
                  label: language.lblChat,
                ),
                NavigationDestination(
                  icon: ic_profile2.iconImage(color: appTextSecondaryColor),
                  selectedIcon:
                      ic_profile2.iconImage(color: context.primaryColor),
                  label: language.profile,
                ),
              ],
              onDestinationSelected: (index) {
                currentIndex = index;
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
