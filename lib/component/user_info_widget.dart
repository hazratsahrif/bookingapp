import 'package:booking_system_flutter/component/disabled_rating_bar_widget.dart';
import 'package:booking_system_flutter/component/image_border_component.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/booking/provider_info_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../network/rest_apis.dart';
import '../screens/chat/user_chat_screen.dart';

class UserInfoWidget extends StatefulWidget {
  final UserData data;
  final bool? isOnTapEnabled;
  final bool forProvider;
  final VoidCallback? onUpdate;

  UserInfoWidget(
      {required this.data,
      this.isOnTapEnabled,
      this.forProvider = true,
      this.onUpdate});

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  void initState() {
    setStatusBarColor(primaryColor);
    super.initState();
  }

  ///TODO string translation providerAddedToFavourite, providerRemovedFromFavourite
  //Favourite provider
  Future<bool> addProviderToWishList({required int providerId}) async {
    Map req = {"id": "", "provider_id": providerId, "user_id": appStore.userId};
    return await addProviderWishList(req).then((res) {
      toast(language.providerAddedToFavourite);
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  Future<bool> removeProviderToWishList({required int providerId}) async {
    Map req = {"user_id": appStore.userId, 'provider_id': providerId};

    return await removeProviderWishList(req).then((res) {
      toast(language.providerRemovedFromFavourite);
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  Future<void> onTapFavouriteProvider() async {
    if (widget.data.isFavourite == 1) {
      widget.data.isFavourite = 0;
      setState(() {});

      await removeProviderToWishList(providerId: widget.data.id.validate())
          .then((value) {
        if (!value) {
          widget.data.isFavourite = 1;
          setState(() {});
          widget.onUpdate!.call();
        }
      });
    } else {
      widget.data.isFavourite = 1;
      setState(() {});

      await addProviderToWishList(providerId: widget.data.id.validate())
          .then((value) {
        if (!value) {
          widget.data.isFavourite = 0;
          setState(() {});
          widget.onUpdate!.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isOnTapEnabled.validate(value: false)
          ? null
          : () {
              ProviderInfoScreen(providerId: widget.data.id).launch(context);
            },
      child: SizedBox(
        width: context.width(),
        child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(
            top: 16,
            left: 8,
            right: 8,
          ),
          decoration: boxDecorationDefault(
            color: context.dividerColor,
            // border: Border.all(color: context.dividerColor, width: 1),
            borderRadius: radius(0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageBorder(
                    src: widget.data.profileImage.validate(),
                    height: 88,
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.data.displayName.validate(),
                                          style: boldTextStyle(size: 18))
                                      .expand(),
                                  Image.asset(ic_verified,
                                          height: 18,
                                          width: 18,
                                          color: verifyAcColor)
                                      .visible(
                                          widget.data.isVerifyProvider == 1),
                                  8.width,
                                ],
                              ),
                              if (widget.data.designation.validate().isNotEmpty)
                                Column(
                                  children: [
                                    4.height,
                                    Marquee(
                                        child: Text(
                                            widget.data.designation.validate(),
                                            style: secondaryTextStyle(
                                                size: 12,
                                                weight: FontWeight.bold))),
                                    // 4.height,
                                  ],
                                ),
                            ],
                          ).flexible(),
                        ],
                      ),
                      // 4.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language.lblMemberSince,
                              style: secondaryTextStyle(
                                  size: 12, weight: FontWeight.bold)),
                          Text(
                              " ${DateTime.tryParse(widget.data.createdAt.validate())?.year ?? ''}",
                              style: secondaryTextStyle(
                                  size: 12, weight: FontWeight.bold)),
                        ],
                      ),
                      // 8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DisabledRatingBarWidget(
                              rating: widget.forProvider
                                  ? widget.data.providersServiceRating
                                      .validate()
                                  : widget.data.handymanRating.validate()),
                        ],
                      ),
                    ],
                  ).expand(flex: 3),
                  16.width,
                  if (appStore.isLoggedIn) ...[
                    Flexible(
                      flex: 2,
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 8,
                        runSpacing: 8,
                        // direction: Axis.vertical,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithShadow(
                                boxShape: BoxShape.circle,
                                backgroundColor: context.cardColor),
                            child: Image.asset(
                              ic_whatsapp,
                              height: 20,
                              width: 20,
                            ).onTap(() async {
                              String phoneNumber = "";
                              if (widget.data.contactNumber
                                  .validate()
                                  .contains('+')) {
                                phoneNumber =
                                    "${widget.data.contactNumber.validate().replaceAll('-', '')}";
                              } else {
                                phoneNumber =
                                    "+${widget.data.contactNumber.validate().replaceAll('-', '')}";
                              }
                              launchUrl(
                                  Uri.parse(
                                      '${getSocialMediaLink(LinkProvider.WHATSAPP)}$phoneNumber'),
                                  mode: LaunchMode.externalApplication);
                            }),
                          ),
                          if (widget.data.contactNumber.validate().isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: boxDecorationWithShadow(
                                  boxShape: BoxShape.circle,
                                  backgroundColor: context.cardColor),
                              child: Image.asset(
                                ic_calling,
                                height: 20,
                                width: 20,
                              ).onTap(() async {
                                String phoneNumber = "";
                                if (widget.data.contactNumber
                                    .validate()
                                    .contains('+')) {
                                  phoneNumber =
                                      "${widget.data.contactNumber.validate().replaceAll('-', '')}";
                                } else {
                                  phoneNumber =
                                      "+${widget.data.contactNumber.validate().replaceAll('-', '')}";
                                }
                                launchCall(
                                    widget.data.contactNumber.validate());
                              }),
                            ),
                          // if (widget.data.contactNumber.validate().isNotEmpty)
                          //   Container(
                          //     padding: EdgeInsets.all(8),
                          //     decoration: boxDecorationWithShadow(
                          //         boxShape: BoxShape.circle,
                          //         backgroundColor: context.cardColor),
                          //     child: Image.asset(
                          //       ic_message,
                          //       height: 20,
                          //       width: 20,
                          //     ).onTap(() async {
                          //       if (widget.data != null) {
                          //         Fluttertoast.cancel();
                          //         UserChatScreen(receiverUser: widget.data!)
                          //             .launch(context);
                          //       } else {
                          //         Fluttertoast.cancel();
                          //         toast(
                          //             "${widget.data.firstName} ${language.isNotAvailableForChat}");
                          //       }
                          //     }),
                          //   ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
