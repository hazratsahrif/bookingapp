import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/about_screen.dart';
import 'package:booking_system_flutter/screens/auth/change_password_screen.dart';
import 'package:booking_system_flutter/screens/auth/edit_profile_screen.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/blog/view/blog_list_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/customer_rating_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:booking_system_flutter/screens/service/favourite_service_screen.dart';
import 'package:booking_system_flutter/screens/setting_screen.dart';
import 'package:booking_system_flutter/screens/wallet/user_wallet_balance_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/services/ad_service/ad_helper.dart';
import '../../favourite_provider_screen.dart';
import '../component/my_setting_section.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _settingItemDecoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey.shade300)));
  Future<num>? futureWalletBalance;
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
    super.initState();
    _initBanner();
    init();
  }

  Future<void> init() async {
    if (appStore.isLoggedIn) appStore.setUserWalletAmount();

    afterBuildCreated(() {
      appStore.setLoading(false);
      setStatusBarColor(context.primaryColor);
    });
  }

  void loadBalance() {
    futureWalletBalance = getUserWalletBalance();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.profile,
        textColor: context.primaryColor,
        textSize: APP_BAR_TEXT_SIZE,
        elevation: 0.0,
        color: context.scaffoldBackgroundColor,
        showBack: false,
        actions: [
          IconButton(
            icon: ic_setting.iconImage(color: context.primaryColor, size: 20),
            onPressed: () async {
              _loadInterstitialAd();
              SettingScreen().launch(context);
            },
          ),
        ],
      ),
      body: Observer(
        builder: (BuildContext context) {
          return Stack(
            children: [
              AnimatedScrollView(
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                padding: EdgeInsets.only(bottom: 32),
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (appStore.isLoggedIn)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        24.height,
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: boxDecorationDefault(
                                border: Border.all(
                                    color: appStore.isDarkMode
                                        ? primaryColorDark
                                        : primaryColor,
                                    width: 3),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration: boxDecorationDefault(
                                  border: Border.all(
                                      color: context.scaffoldBackgroundColor,
                                      width: 4),
                                  shape: BoxShape.circle,
                                ),
                                child: CachedImageWidget(
                                  url: appStore.userProfileImage,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                  radius: 60,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 8,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(6),
                                decoration: boxDecorationDefault(
                                  shape: BoxShape.circle,
                                  color: appStore.isDarkMode
                                      ? primaryColorDark
                                      : primaryColor,
                                  border: Border.all(
                                      color: context.cardColor, width: 2),
                                ),
                                child: Icon(AntDesign.edit,
                                    color: white, size: 18),
                              ).onTap(() {
                                EditProfileScreen().launch(context);
                              }),
                            ),
                          ],
                        ),
                        16.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(appStore.userFullName,
                                style: primaryTextStyle(
                                    color: appStore.isDarkMode
                                        ? primaryColorDark
                                        : primaryColor,
                                    size: 16)),
                            Text(appStore.userEmail,
                                style: secondaryTextStyle()),
                          ],
                        ),
                        24.height,
                      ],
                    ).center(),
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

                  Observer(builder: (context) {
                    return MySettingSection(
                      headerPadding: EdgeInsets.symmetric(horizontal: 16),
                      divider: Offstage(),
                      title: Text(language.lblGENERAL,
                          style: primaryTextStyle(
                              color: appStore.isDarkMode
                                  ? primaryColorDark
                                  : primaryColor)),
                      headingDecoration: BoxDecoration(),
                      items: [
                        if (appStore.isLoggedIn && appStore.isEnableUserWallet)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: SettingItemWidget(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: _settingItemDecoration,
                              leading: ic_un_fill_wallet.iconImage(
                                  size: SETTING_ICON_SIZE),
                              title: language.walletBalance,
                              onTap: () {
                                UserWalletBalanceScreen().launch(context);
                              },
                              trailing: Text(
                                '${isCurrencyPositionLeft ? appStore.currencySymbol : ''}${appStore.userWalletAmount.toStringAsFixed(DECIMAL_POINT)}${isCurrencyPositionRight ? appStore.currencySymbol : ''}',
                                style: primaryTextStyle(color: Colors.green),
                              ),
                              /*trailing: SnapHelperWidget(
                                future: futureWalletBalance,
                                loadingWidget: Text(language.loading),
                                onSuccess: (balance) => Text(
                                  '${isCurrencyPositionLeft ? appStore.currencySymbol : ''}${balance.toStringAsFixed(DECIMAL_POINT)}${isCurrencyPositionRight ? appStore.currencySymbol : ''}',
                                  style: primaryTextStyle(color: Colors.green),
                                ),
                                errorWidget: IconButton(
                                  onPressed: () {
                                    loadBalance();
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.refresh_rounded),
                                ),
                              ),*/
                            ),
                          ),
                        16.height,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: SettingItemWidget(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: _settingItemDecoration,
                            leading:
                                ic_heart.iconImage(size: SETTING_ICON_SIZE),
                            title: language.lblFavorite,
                            trailing: trailing,
                            onTap: () {
                              doIfLoggedIn(context, () {
                                FavouriteServiceScreen().launch(context);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: SettingItemWidget(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: _settingItemDecoration,
                            leading:
                                ic_heart.iconImage(size: SETTING_ICON_SIZE),
                            title: language.favouriteProvider,
                            trailing: trailing,
                            onTap: () {
                              doIfLoggedIn(context, () {
                                FavouriteProviderScreen().launch(context);
                              });
                            },
                          ),
                        ),
                        if (isLoginTypeUser)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: SettingItemWidget(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: _settingItemDecoration,
                              leading:
                                  ic_lock.iconImage(size: SETTING_ICON_SIZE),
                              title: language.changePassword,
                              trailing: trailing,
                              onTap: () {
                                doIfLoggedIn(context, () {
                                  ChangePasswordScreen().launch(context);
                                });
                              },
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: SettingItemWidget(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: _settingItemDecoration,
                            leading:
                                ic_document.iconImage(size: SETTING_ICON_SIZE),
                            title: language.blogs,
                            trailing: trailing,
                            onTap: () {
                              BlogListScreen().launch(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: SettingItemWidget(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: _settingItemDecoration,
                            leading: ic_star.iconImage(size: SETTING_ICON_SIZE),
                            title: language.rateUs,
                            trailing: trailing,
                            onTap: () async {
                              if (isAndroid) {
                                if (getStringAsync(PLAY_STORE_URL).isNotEmpty) {
                                  commonLaunchUrl(
                                      getStringAsync(PLAY_STORE_URL),
                                      launchMode:
                                          LaunchMode.externalApplication);
                                } else {
                                  commonLaunchUrl(
                                      '${getSocialMediaLink(LinkProvider.PLAY_STORE)}${await getPackageName()}',
                                      launchMode:
                                          LaunchMode.externalApplication);
                                }
                              } else if (isIOS) {
                                if (getStringAsync(APPSTORE_URL).isNotEmpty) {
                                  commonLaunchUrl(getStringAsync(APPSTORE_URL),
                                      launchMode:
                                          LaunchMode.externalApplication);
                                } else {
                                  commonLaunchUrl(IOS_LINK_FOR_USER,
                                      launchMode:
                                          LaunchMode.externalApplication);
                                }
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: SettingItemWidget(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            // decoration: _settingItemDecoration,
                            leading: ic_star.iconImage(size: SETTING_ICON_SIZE),
                            title: language.myReviews,
                            trailing: trailing,
                            onTap: () async {
                              doIfLoggedIn(context, () {
                                CustomerRatingScreen().launch(context);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                  16.height,
                  MySettingSection(
                    headerPadding: EdgeInsets.symmetric(horizontal: 16),
                    title: Text(language.lblAboutApp.toUpperCase(),
                        style: primaryTextStyle(
                            color: appStore.isDarkMode
                                ? primaryColorDark
                                : primaryColor)),
                    headingDecoration: BoxDecoration(),
                    divider: Offstage(),
                    items: [
                      8.height,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: SettingItemWidget(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: _settingItemDecoration,
                          leading:
                              ic_about_us.iconImage(size: SETTING_ICON_SIZE),
                          title: language.lblAboutApp,
                          onTap: () {
                            AboutScreen().launch(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: SettingItemWidget(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: _settingItemDecoration,
                          leading:
                              ic_shield_done.iconImage(size: SETTING_ICON_SIZE),
                          title: language.privacyPolicy,
                          onTap: () {
                            checkIfLink(
                                context, appStore.privacyPolicy.validate(),
                                title: language.privacyPolicy);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: SettingItemWidget(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: _settingItemDecoration,
                          leading:
                              ic_document.iconImage(size: SETTING_ICON_SIZE),
                          title: language.termsCondition,
                          onTap: () {
                            checkIfLink(
                                context, appStore.termConditions.validate(),
                                title: language.termsCondition);
                          },
                        ),
                      ),
                      if (appStore.inquiryEmail.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: SettingItemWidget(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: _settingItemDecoration,
                            leading: ic_helpAndSupport.iconImage(
                                size: SETTING_ICON_SIZE),
                            title: language.helpSupport,
                            onTap: () {
                              checkIfLink(
                                  context, appStore.inquiryEmail.validate(),
                                  title: language.helpSupport);
                            },
                          ),
                        ),
                      if (appStore.helplineNumber.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: SettingItemWidget(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            // decoration: _settingItemDecoration,
                            leading:
                                ic_calling.iconImage(size: SETTING_ICON_SIZE),
                            title: language.lblHelplineNumber,
                            onTap: () async {
                              String phoneNumber = "+20 111 052 9199";
                              String waN = "+20 111 052 9199";

                              if (waN.contains('+')) {
                                phoneNumber = "${waN}";
                              } else {
                                phoneNumber = "+${waN}";
                              }
                              launchUrl(
                                  Uri.parse(
                                      '${getSocialMediaLink(LinkProvider.WHATSAPP)}$phoneNumber'),
                                  mode: LaunchMode.externalApplication);
                            },

                            // () {
                            //   launchCall(appStore.helplineNumber.validate());
                            // },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: SettingItemWidget(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: _settingItemDecoration,
                          leading: Icon(MaterialCommunityIcons.logout,
                              color: context.iconColor,
                              size: SETTING_ICON_SIZE),
                          title: language.signIn,
                          onTap: () {
                            SignInScreen().launch(context);
                          },
                        ).visible(!appStore.isLoggedIn),
                      ),
                    ],
                  ),
                  16.height,
                  MySettingSection(
                    headerPadding: EdgeInsets.symmetric(horizontal: 16),
                    divider: Offstage(),
                    title: Text(language.lblDangerZone.toUpperCase(),
                        style: primaryTextStyle(color: redColor)),
                    headingDecoration: BoxDecoration(),
                    items: [
                      8.height,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: SettingItemWidget(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          // decoration: _settingItemDecoration,
                          leading: ic_delete_account.iconImage(
                              size: SETTING_ICON_SIZE),
                          paddingBeforeTrailing: 4,
                          title: language.lblDeleteAccount,
                          onTap: () {
                            showConfirmDialogCustom(
                              context,
                              negativeText: language.lblCancel,
                              positiveText: language.lblDelete,
                              onAccept: (_) {
                                ifNotTester(() {
                                  appStore.setLoading(true);

                                  deleteAccountCompletely().then((value) async {
                                    await userService
                                        .removeDocument(appStore.uid);
                                    await userService.deleteUser();
                                    await clearPreferences();
                                    appStore.setLoading(false);

                                    toast(value.message);

                                    push(DashboardScreen(),
                                        isNewTask: true,
                                        pageRouteAnimation:
                                            PageRouteAnimation.Fade);
                                  }).catchError((e) {
                                    appStore.setLoading(false);
                                    toast(e.toString());
                                  });
                                });
                              },
                              dialogType: DialogType.DELETE,
                              title: language.lblDeleteAccountConformation,
                            );
                          },
                        ).paddingOnly(left: 4),
                      ),
                      64.height,
                      TextButton(
                        child: Text(language.logout,
                            style: primaryTextStyle(
                                color: appStore.isDarkMode
                                    ? primaryColorDark
                                    : primaryColor,
                                size: 16)),
                        onPressed: () {
                          logout(context);
                        },
                      ).center(),
                    ],
                  ).visible(appStore.isLoggedIn),
                  30.height.visible(!appStore.isLoggedIn),
                  // SnapHelperWidget<PackageInfoData>(
                  //   future: getPackageInfo(),
                  //   onSuccess: (data) {
                  //     return TextButton(
                  //       child: VersionInfoWidget(
                  //           prefixText: 'v', textStyle: secondaryTextStyle()),
                  //       onPressed: () {
                  //         showAboutDialog(
                  //           context: context,
                  //           applicationName: APP_NAME,
                  //           applicationVersion: data.versionName,
                  //           applicationIcon: Image.asset(appLogo, height: 50),
                  //         );
                  //       },
                  //     ).center();
                  //   },
                  // ),
                ],
              ),
              Observer(
                  builder: (context) =>
                      LoaderWidget().visible(appStore.isLoading)),
            ],
          );
        },
      ),
    );
  }
}
