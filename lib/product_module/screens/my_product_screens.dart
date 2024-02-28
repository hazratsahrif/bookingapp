import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/component/shimmer_widget.dart';
import 'package:booking_system_flutter/main.dart';

import 'package:booking_system_flutter/product_module/screens/add_product_screen.dart';
import 'package:booking_system_flutter/product_module/services/store_service.dart';
import 'package:booking_system_flutter/utils/colors.dart';

import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/base_scaffold_widget.dart';
import '../../screens/chat/user_chat_screen.dart';

class MyProductListScreen extends StatefulWidget {
  const MyProductListScreen({super.key, this.showBack = true});

  @override
  _MyProductListScreenState createState() => _MyProductListScreenState();
  final bool showBack;
}

class _MyProductListScreenState extends State<MyProductListScreen> {
  // int page = 0;
  // bool isLastPage = false;
  // bool isApiCalled = false;

  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {}

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    controller.dispose();
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
          return AppScaffold(
            appBarTitle:
                val == 0 ? language.lblMyBidProducts : language.lblMyProducts,
            showBack: widget.showBack,
            child: Stack(
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
                                language.lblMyBidProducts,
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
                                language.lblMyProducts,
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
                    Expanded(
                      child: PageView(
                        onPageChanged: (value) => selectedPage.value = value,
                        controller: controller,
                        children: [
                          MyBids(),
                          MyProducts(),
                        ],
                      ),
                    ),
                  ],
                ),
                Observer(
                    builder: (context) =>
                        LoaderWidget().visible(appStore.isLoading))
              ],
            ),
            bottomNavigationBar: AppButton(
              child: Text(language.lblAddProduct,
                  style: boldTextStyle(color: white)),
              color: context.primaryColor,
              width: context.width(),
              onTap: () async {
                AddEditProductScreen().launch(context);
              },
            ).paddingAll(16),
          );
        });
  }
}

class MyBids extends StatelessWidget {
  const MyBids({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SnapHelperWidget(
        future: StoreService.getBidList(),
        loadingWidget: ShimmerWidget(),
        onSuccess: (bidList) {
          return bidList.isEmpty
              ? Center(
                  child: Text(language.noDataAvailable),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final bidItem = bidList[index];
                    final images = bidItem.products?.productImages
                            ?.map((e) => e.images!)
                            .toList() ??
                        [];
                    return InkWell(
                      onTap: () {
                        AddEditProductScreen(
                          editableData: bidItem.products,
                        ).launch(context);
                      },
                      child: Stack(
                        alignment: appStore.selectedLanguageCode == 'ar'
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4),
                            decoration: boxDecorationDefault(boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: grey.withOpacity(0.3))
                            ], color: context.cardColor),
                            child: Row(
                              children: [
                                Container(
                                  height: 125,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color:
                                        context.primaryColor.withOpacity(0.3),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          images.isNotEmpty
                                              ? images.first
                                              : ''),
                                    ),
                                  ),
                                  // child: CachedImageWidget(
                                  //   url:
                                  //       // images.isNotEmpty
                                  //       //     ?
                                  //       images.first
                                  //   // : 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_light_color_92x30dp.png',
                                  //   ,
                                  //   radius: 8,
                                  //   height: 125,
                                  //   usePlaceholderIfUrlEmpty: true,
                                  //   fit: BoxFit.cover,
                                  //   width: 100,
                                  //   color: context.primaryColor.withOpacity(0.3),
                                  // )
                                ),
                                Expanded(
                                    child: Container(
                                  height: 125,
                                  width: 100,
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bidItem.products?.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: boldTextStyle(),
                                      ),
                                      PriceWidget(
                                          price: double.tryParse(
                                                  bidItem.bidPrice ?? '0') ??
                                              0),
                                      Text(
                                        formatDate(bidItem.createdAt,
                                            isLocal: true),
                                        style: secondaryTextStyle(),
                                      ),
                                      Row(
                                        children: [
                                          if (bidItem.buyerUser?.socialImage !=
                                              null)
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: context.primaryColor
                                                    .withOpacity(0.3),
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          bidItem.buyerUser
                                                                  ?.socialImage ??
                                                              ''),
                                                ),
                                              ),
                                            ),
                                          8.width,
                                          Text(
                                            bidItem.buyerUser?.displayName ??
                                                "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: boldTextStyle(size: 12),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    appStore.setLoading(true);
                                    final user = bidItem.buyerUser!;

                                    final data = await userService
                                        .singleUser(user?.uid)
                                        .first;
                                    appStore.setLoading(false);

                                    UserChatScreen(receiverUser: data).launch(
                                        context,
                                        pageRouteAnimation:
                                            PageRouteAnimation.Fade,
                                        duration: 300.milliseconds);
                                  },
                                  icon: ic_message.iconImage(
                                      color: context.primaryColor, size: 20)),
                              IconButton(
                                  onPressed: () async {
                                    appStore.setLoading(true);

                                    String phoneNumber = "";
                                    final user = bidItem.buyerUser;

                                    String? waN = user?.contactNumber;
                                    appStore.setLoading(false);

                                    if (waN == null) return;
                                    if (waN?.contains('+') ?? false) {
                                      phoneNumber = "${waN}";
                                    } else {
                                      phoneNumber = "+${waN}";
                                    }
                                    launchUrl(
                                        Uri.parse(
                                            '${getSocialMediaLink(LinkProvider.WHATSAPP)}$phoneNumber'),
                                        mode: LaunchMode.externalApplication);
                                  },
                                  icon: ic_whatsapp.iconImage(
                                      color: context.primaryColor, size: 20)),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 10.height,
                  itemCount: bidList.length);
        });
  }
}

class MyProducts extends StatefulWidget {
  const MyProducts({
    super.key,
  });

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  @override
  Widget build(BuildContext context) {
    return SnapHelperWidget(
        future: StoreService.getMyProducts(),
        loadingWidget: ShimmerWidget(),
        onSuccess: (myProducts) {
          return myProducts.isEmpty
              ? Center(
                  child: Text(language.noDataAvailable),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final product = myProducts[index];

                    return InkWell(
                      onTap: () {
                        AddEditProductScreen(
                          editableData: product,
                        ).launch(context);
                      },
                      child: Stack(
                        alignment: appStore.selectedLanguageCode == 'ar'
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4),
                            decoration: boxDecorationDefault(boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: grey.withOpacity(0.3))
                            ], color: context.cardColor),
                            child: Row(
                              children: [
                                Container(
                                  height: 125,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color:
                                        context.primaryColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          (product.productImages?.isNotEmpty ??
                                                  false)
                                              ? product.productImages?.first
                                                      .images ??
                                                  ''
                                              : ''),
                                    ),
                                  ),
                                  // child: CachedImageWidget(
                                  //   url: (product.productImages?.isNotEmpty ?? false)
                                  //       ? product.productImages?.first.images ?? ''
                                  //       : '',
                                  //   radius: 8,
                                  //   height: 125,
                                  //   usePlaceholderIfUrlEmpty: true,
                                  //   fit: BoxFit.cover,
                                  //   width: 100,
                                  //   color: context.primaryColor.withOpacity(0.3),
                                  // ),
                                ),
                                Expanded(
                                    child: Container(
                                  height: 125,
                                  width: 100,
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: boldTextStyle(),
                                      ),
                                      PriceWidget(
                                          price: double.tryParse(
                                                  product.price ?? '0') ??
                                              0),
                                      Text(
                                        formatDate(product.createdAt,
                                            isLocal: true),
                                        style: secondaryTextStyle(),
                                      ),
                                      Row(
                                        children: [
                                          if (product.user?.socialImage != null)
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: context.primaryColor
                                                    .withOpacity(0.3),
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          product.user
                                                                  ?.socialImage ??
                                                              ''),
                                                ),
                                              ),
                                            ),
                                          8.width,
                                          Text(
                                            product.user?.displayName ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: boldTextStyle(size: 12),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle_rounded,
                              color: redColor,
                            ),
                            onPressed: () async {
                              final success = await StoreService.deleteProduct(
                                  productId: product.id!.toString());
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 10.height,
                  itemCount: myProducts.length);
        });
  }
}
