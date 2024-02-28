import 'dart:async';

import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/dashboard_model.dart';
import 'package:booking_system_flutter/screens/map/places_screen.dart';
import 'package:booking_system_flutter/screens/notification/notification_screen.dart';
import 'package:booking_system_flutter/screens/service/service_detail_screen.dart';
import 'package:booking_system_flutter/screens/service/view_all_service_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common.dart';

class SliderLocationComponent extends StatefulWidget {
  final List<SliderModel> sliderList;
  final VoidCallback? callback;
  final VoidCallback? onTapSearch;

  SliderLocationComponent(
      {required this.sliderList, this.callback, this.onTapSearch});

  @override
  State<SliderLocationComponent> createState() =>
      _SliderLocationComponentState();
}

class _SliderLocationComponentState extends State<SliderLocationComponent> {
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

    final address = getStringAsync(CURRENT_ADDRESS);
    placesC.value = TextEditingValue(
        text: address.isNotEmpty
            ? address
            : language.lblLocationPermissionDenied);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    placesC.dispose();
    sliderPageController.dispose();
  }

  Widget getSliderWidget() {
    return SizedBox(
      // height: 325,
      width: context.width(),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 165,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
              child: Stack(
                children: [
                  widget.sliderList.isNotEmpty
                      ? PageView(
                          controller: sliderPageController,
                          children: List.generate(
                            widget.sliderList.length,
                            (index) {
                              SliderModel data = widget.sliderList[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: CachedImageWidget(
                                        url: data.sliderImage.validate(),
                                        height: 160,
                                        width: context.width(),
                                        fit: BoxFit.cover)
                                    .onTap(() {
                                  if (data.type == SERVICE) {
                                    ServiceDetailScreen(
                                            serviceId:
                                                data.typeId.validate().toInt())
                                        .launch(context,
                                            pageRouteAnimation:
                                                PageRouteAnimation.Fade);
                                  }
                                }),
                              );
                            },
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CachedImageWidget(
                              url: '', height: 160, width: context.width()),
                        ),
                  // if (appStore.isLoggedIn)
                  //   Positioned(
                  //     top: context.statusBarHeight + 16,
                  //     right: 16,
                  //     child: Container(
                  //       decoration: boxDecorationDefault(
                  //           color: context.cardColor, shape: BoxShape.circle),
                  //       height: 36,
                  //       padding: EdgeInsets.all(8),
                  //       width: 36,
                  //       child: Stack(
                  //         clipBehavior: Clip.none,
                  //         children: [
                  //           ic_notification
                  //               .iconImage(
                  //                   size: 24,
                  //                   color: appStore.isDarkMode
                  //                       ? primaryColorDark
                  //                       : primaryColor)
                  //               .center(),
                  //           Observer(builder: (context) {
                  //             return Positioned(
                  //               top: -20,
                  //               right: -10,
                  //               child: appStore.unreadCount.validate() > 0
                  //                   ? Container(
                  //                       padding: EdgeInsets.all(4),
                  //                       child: FittedBox(
                  //                         child: Text(
                  //                             appStore.unreadCount.toString(),
                  //                             style: primaryTextStyle(
                  //                                 size: 12,
                  //                                 color: Colors.white)),
                  //                       ),
                  //                       decoration: boxDecorationDefault(
                  //                           color: Colors.red,
                  //                           shape: BoxShape.circle),
                  //                     )
                  //                   : Offstage(),
                  //             );
                  //           })
                  //         ],
                  //       ),
                  //     ).onTap(() {
                  //       NotificationScreen().launch(context);
                  //     }),
                  //   ),

                  Positioned(
                    top: context.statusBarHeight + 8,
                    left: 16,
                    child: Container(
                      decoration: boxDecorationDefault(
                          color: context.cardColor,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('assets/ic_app_logo.png'))),
                      height: 50,
                      padding: EdgeInsets.all(8),
                      width: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.sliderList.length.validate() > 1)
            SizedBox(
              height: 18,
              child: DotIndicator(
                pageController: sliderPageController,
                pages: widget.sliderList,
                indicatorColor: Theme.of(context).primaryColor,
                unselectedIndicatorColor: grey,
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                borderRadius: radius(10),
                currentBorderRadius: radius(10),
                currentDotSize: 10,
                currentDotWidth: 10,
                dotSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  Decoration get commonDecoration {
    return boxDecorationDefault(
      color: context.cardColor,
      boxShadow: [
        BoxShadow(color: shadowColorGlobal, offset: Offset(1, 0)),
        BoxShadow(color: shadowColorGlobal, offset: Offset(0, 1)),
        BoxShadow(color: shadowColorGlobal, offset: Offset(-1, 0)),
      ],
    );
  }

  final TextEditingController placesC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      // clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Row(
            children: [
              Observer(
                builder: (context) {
                  // return GooglePlaceAutoCompleteTextField(
                  //   boxDecoration: boxDecorationDefault() as BoxDecoration,
                  //   textEditingController: placesC,
                  //   googleAPIKey: "AIzaSyADPPUrR0O7TGmWggwLh0GqRnat0T9Vbvc",
                  //   inputDecoration: inputDecoration(
                  //     context,

                  //     prefixIcon: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         ic_location.iconImage(
                  //             size: 24,
                  //             color: appStore.isDarkMode
                  //                 ? Colors.white
                  //                 : Colors.black),
                  //       ],
                  //     ),
                  //   ),
                  //   showError: false,

                  //   debounceTime: 800, // default 600 ms,
                  //   countries: [
                  //     defaultCountry().countryCode.toLowerCase()
                  //   ], // optional by default null is set
                  //   isLatLngRequired:
                  //       true, // if you required coordinates from place detail
                  //   getPlaceDetailWithLatLng: (Prediction prediction) async {
                  //     // this method will return latlng with place detail
                  //     if (prediction.description != null &&
                  //         prediction.lat != null &&
                  //         prediction.lng != null) {
                  //       placesC.value = TextEditingValue(
                  //           text: prediction.description ?? placesC.text);
                  //       await setValue(CURRENT_ADDRESS,
                  //           prediction.description ?? placesC.text);
                  //       await setValue(
                  //           LATITUDE,
                  //           double.tryParse(prediction.lat ?? '') ??
                  //               getDoubleAsync(LATITUDE));
                  //       await setValue(
                  //           LONGITUDE,
                  //           double.tryParse(prediction.lng ?? '') ??
                  //               getDoubleAsync(LONGITUDE));
                  //       widget.callback?.call();
                  //     }
                  //     print("placeDetails" + prediction.lng.toString());
                  //   }, // this callback is called when isLatLngRequired is true
                  //   itemClick: (Prediction prediction) async {
                  //     // print(prediction.lat);
                  //     // print(prediction.lng);

                  //     //   controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length));
                  //   },
                  //   // if we want to make custom list item builder
                  //   itemBuilder: (context, index, Prediction prediction) {
                  //     return Container(
                  //       decoration: boxDecorationDefault(),
                  //       padding: EdgeInsets.all(10),
                  //       child: Row(
                  //         children: [
                  //           Icon(Icons.location_on),
                  //           SizedBox(
                  //             width: 7,
                  //           ),
                  //           Expanded(
                  //               child: Text("${prediction.description ?? ""}"))
                  //         ],
                  //       ),
                  //     );
                  //   },
                  //   // if you want to add seperator between list items
                  //   seperatedBuilder: Divider(),
                  //   // want to show close icon
                  //   isCrossBtnShown: true,
                  // );

                  return AppButton(
                    padding: EdgeInsets.all(0),
                    width: context.width(),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: commonDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ic_location.iconImage(
                              color: appStore.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          8.width,
                          ValueListenableBuilder(
                              valueListenable: placesC,
                              builder: (context, value, _) {
                                return Text(
                                  appStore.isCurrentLocation
                                      ? value.text
                                      : language.lblLocationOff,
                                  style: secondaryTextStyle(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ).expand();
                              }),
                          8.width,
                          ic_active_location.iconImage(
                              size: 24,
                              color: appStore.isCurrentLocation
                                  ? primaryColor
                                  : grey),
                        ],
                      ),
                    ),
                    onTap: () async {
                      // locationWiseService(context, () {
                      //   widget.callback?.call();
                      // });

                      PlacesScreen()
                          .launch<FetchPlaceResponse?>(context)
                          .then((prediction) async {
                        if (prediction?.place?.address != null &&
                            prediction?.place?.latLng != null) {
                          placesC.value = TextEditingValue(
                              text: prediction?.place?.address ?? placesC.text);
                          await setValue(CURRENT_ADDRESS,
                              prediction?.place?.address ?? placesC.text);
                          await setValue(
                              LATITUDE,
                              prediction?.place?.latLng?.lat ??
                                  getDoubleAsync(LATITUDE));
                          await setValue(
                              LONGITUDE,
                              prediction?.place?.latLng?.lng ??
                                  getDoubleAsync(LONGITUDE));
                          setState(() {});
                          widget.callback?.call();
                        }
                      });
                    },
                  );
                },
              ).expand(),
              16.width,
              GestureDetector(
                onTap: widget.onTapSearch,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  decoration: commonDecoration,
                  child: ic_search.iconImage(
                      color: appStore.isDarkMode
                          ? primaryColorDark
                          : primaryColor),
                ),
              ),
            ],
          ),
        ),
        getSliderWidget(),
      ],
    );
  }
}
