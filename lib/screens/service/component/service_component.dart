import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/disabled_rating_bar_widget.dart';
import 'package:booking_system_flutter/component/image_border_component.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/package_data_model.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/screens/booking/provider_info_screen.dart';
import 'package:booking_system_flutter/screens/service/service_detail_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/configs.dart';

class ServiceComponent extends StatefulWidget {
  final ServiceData? serviceData;
  final BookingPackage? selectedPackage;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;

  ServiceComponent(
      {this.serviceData,
      this.width,
      this.isBorderEnabled,
      this.isFavouriteService = false,
      this.onUpdate,
      this.selectedPackage});

  @override
  ServiceComponentState createState() => ServiceComponentState();
}

class ServiceComponentState extends State<ServiceComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ServiceDetailScreen(
                serviceId: widget.isFavouriteService
                    ? widget.serviceData!.serviceId.validate().toInt()
                    : widget.serviceData!.id.validate())
            .launch(context)
            .then((value) {
          setStatusBarColor(context.primaryColor);
        });
      },
      child: Container(
        height: 240,
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          border: widget.isBorderEnabled.validate(value: false)
              ? appStore.isDarkMode
                  ? Border.all(color: context.dividerColor)
                  : null
              : null,
        ),
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 110,
              width: context.width(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CachedImageWidget(
                    url: widget.isFavouriteService
                        ? widget.serviceData!.serviceAttachments
                                .validate()
                                .isNotEmpty
                            ? widget.serviceData!.serviceAttachments!.first
                                .validate()
                            : ''
                        : widget.serviceData!.attachments.validate().isNotEmpty
                            ? widget.serviceData!.attachments!.first.validate()
                            : '',
                    fit: BoxFit.cover,
                    height: 180,
                    width: context.width(),
                    circle: false,
                  ).cornerRadiusWithClipRRectOnly(
                      topRight: defaultRadius.toInt(),
                      topLeft: defaultRadius.toInt()),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      constraints:
                          BoxConstraints(maxWidth: context.width() * 0.2),
                      decoration: boxDecorationWithShadow(
                        backgroundColor: context.cardColor.withOpacity(0.9),
                        borderRadius: radius(24),
                      ),
                      child: Marquee(
                        directionMarguee: DirectionMarguee.oneDirection,
                        child: Text(
                          "${widget.serviceData!.subCategoryName.validate().isNotEmpty ? widget.serviceData!.subCategoryName.validate() : widget.serviceData!.categoryName.validate()}"
                              .toUpperCase(),
                          maxLines: 1,
                          style: boldTextStyle(
                              color: appStore.isDarkMode ? white : primaryColor,
                              size: 8),
                        ).paddingSymmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  ),
                  // if (widget.isFavouriteService)
                  //   Positioned(
                  //     top: 8,
                  //     right: 0,
                  //     child: Container(
                  //       padding: EdgeInsets.all(8),
                  //       margin: EdgeInsets.only(right: 8),
                  //       decoration: boxDecorationWithShadow(
                  //           boxShape: BoxShape.circle,
                  //           backgroundColor: context.cardColor),
                  //       child: widget.serviceData!.isFavourite == 0
                  //           ? ic_fill_heart.iconImage(
                  //               color: favouriteColor, size: 18)
                  //           : ic_heart.iconImage(
                  //               color: unFavouriteColor, size: 18),
                  //     ).onTap(() async {
                  //       if (widget.serviceData!.isFavourite == 0) {
                  //         widget.serviceData!.isFavourite = 1;
                  //         setState(() {});

                  //         await removeToWishList(
                  //                 serviceId: widget.serviceData!.serviceId
                  //                     .validate()
                  //                     .toInt())
                  //             .then((value) {
                  //           if (!value) {
                  //             widget.serviceData!.isFavourite = 0;
                  //             setState(() {});
                  //           }
                  //         });
                  //       } else {
                  //         widget.serviceData!.isFavourite = 0;
                  //         setState(() {});

                  //         await addToWishList(
                  //                 serviceId: widget.serviceData!.serviceId
                  //                     .validate()
                  //                     .toInt())
                  //             .then((value) {
                  //           if (!value) {
                  //             widget.serviceData!.isFavourite = 1;
                  //             setState(() {});
                  //           }
                  //         });
                  //       }
                  //       widget.onUpdate?.call();
                  //     }),
                  //   ),

                  // Positioned(
                  //   bottom: 12,
                  //   right: 8,
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //     decoration: boxDecorationWithShadow(
                  //       backgroundColor: appStore.isDarkMode
                  //           ? primaryColorDark
                  //           : primaryColor,
                  //       borderRadius: radius(24),
                  //       border: Border.all(color: context.cardColor, width: 2),
                  //     ),
                  //     child: PriceWidget(
                  //       price: widget.serviceData!.price.validate(),
                  //       isHourlyService: widget.serviceData!.isHourlyService,
                  //       color: Colors.white,
                  //       hourlyTextColor: Colors.white,
                  //       size: 14,
                  //       isFreeService: widget.serviceData!.type.validate() ==
                  //           SERVICE_TYPE_FREE,
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: 0,
                  //   left: 16,
                  //   child: DisabledRatingBarWidget(
                  //       rating: widget.serviceData!.totalRating.validate(),
                  //       size: 14),
                  // ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                SizedBox(
                  height: 32,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Marquee(
                              child: Text(widget.serviceData!.name.validate(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: boldTextStyle(size: 10))
                                  .paddingOnly(right: 16),
                            ),
                          ],
                        ),
                      ),
                      8.width,
                      if (widget.isFavouriteService)
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(right: 8),
                          decoration: boxDecorationWithShadow(
                              boxShape: BoxShape.circle,
                              backgroundColor: context.cardColor),
                          child: widget.serviceData!.isFavourite == 0
                              ? ic_fill_heart.iconImage(
                                  color: favouriteColor, size: 18)
                              : ic_heart.iconImage(
                                  color: unFavouriteColor, size: 18),
                        ).onTap(() async {
                          if (widget.serviceData!.isFavourite == 0) {
                            widget.serviceData!.isFavourite = 1;
                            setState(() {});

                            await removeToWishList(
                                    serviceId: widget.serviceData!.serviceId
                                        .validate()
                                        .toInt())
                                .then((value) {
                              if (!value) {
                                widget.serviceData!.isFavourite = 0;
                                setState(() {});
                              }
                            });
                          } else {
                            widget.serviceData!.isFavourite = 0;
                            setState(() {});

                            await addToWishList(
                                    serviceId: widget.serviceData!.serviceId
                                        .validate()
                                        .toInt())
                                .then((value) {
                              if (!value) {
                                widget.serviceData!.isFavourite = 1;
                                setState(() {});
                              }
                            });
                          }
                          widget.onUpdate?.call();
                        }),
                    ],
                  ).paddingSymmetric(
                    horizontal: 10.0,
                  ),
                ),
                // Marquee(
                //   directionMarguee: DirectionMarguee.oneDirection,
                //   child: Text(widget.serviceData!.name.validate(),
                //           style: boldTextStyle())
                //       .paddingSymmetric(horizontal: 16),
                // ),
                8.height,
                Text.rich(
                  TextSpan(children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.location_on,
                        color: grey,
                        size: 12,
                      ),
                    ),
                    WidgetSpan(
                      child: 4.width,
                    ),
                    TextSpan(
                        text: widget.serviceData?.address ??
                            language.notAvailable,
                        style: TextStyle(color: gray, fontSize: 8)),
                  ]),
                  maxLines: 1,
                ).paddingSymmetric(horizontal: 10.0),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceWidget(
                      price: widget.serviceData?.price.validate() ?? 0,
                      size: 14,
                      color: context.primaryColor,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.yellow.shade700,
                          size: 10,
                        ),
                        4.width,
                        Text(
                          widget.serviceData!.totalRating.validate().toString(),
                          style: TextStyle(
                            color: gray,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                ).paddingSymmetric(horizontal: 10.0),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (false)
                      Container(
                        height: 20,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/ic_verified.png',
                              height: 14,
                              width: 14,
                            ),
                            4.width,
                            Text(
                              language.verified,
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      timeAgoSinceDate(widget.serviceData?.createdAt != null
                              ? DateTime.fromMicrosecondsSinceEpoch(
                                      int.tryParse(
                                              widget.serviceData?.createdAt ??
                                                  'N/A') ??
                                          DateTime.now().microsecondsSinceEpoch)
                                  .toString()
                              : DateTime.now().toString())
                          .validate(),
                      style: TextStyle(
                        fontSize: 9,
                        color: context.primaryColor,
                      ),
                    )
                  ],
                ).paddingSymmetric(horizontal: 10.0),
                8.height,
                // Row(
                //   children: [
                //     ImageBorder(
                //         src: widget.serviceData!.providerImage.validate(),
                //         height: 30),
                //     8.width,
                //     if (widget.serviceData!.providerName.validate().isNotEmpty)
                //       Text(
                //         widget.serviceData!.providerName.validate(),
                //         style: secondaryTextStyle(
                //             size: 12,
                //             color: appStore.isDarkMode
                //                 ? Colors.white
                //                 : appTextSecondaryColor),
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //       ).expand()
                //   ],
                // ).onTap(() async {
                //   if (widget.serviceData!.providerId !=
                //       appStore.userId.validate()) {
                //     await ProviderInfoScreen(
                //             providerId:
                //                 widget.serviceData!.providerId.validate())
                //         .launch(context);
                //     setStatusBarColor(Colors.transparent);
                //   } else {
                //     //
                //   }
                // }).paddingSymmetric(horizontal: 16),
                // 16.height,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
