import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/shimmer_widget.dart';
import 'package:booking_system_flutter/component/user_info_widget.dart';
import 'package:booking_system_flutter/network/network_utils.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/product_module/models/order_product_model.dart';
import 'package:booking_system_flutter/product_module/models/product_data.dart';
import 'package:booking_system_flutter/product_module/screens/place_order.dart';
import 'package:booking_system_flutter/product_module/services/store_service.dart';
import 'package:booking_system_flutter/product_module/widgets/image_slider.dart';
import 'package:booking_system_flutter/screens/booking/provider_info_screen.dart';
import 'package:booking_system_flutter/screens/service/component/product_component.dart';
import 'package:booking_system_flutter/services/user_services.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/back_widget.dart';
import '../../component/disabled_rating_bar_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/configs.dart';
import '../../utils/constant.dart';
import '../provider/wish_list_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 0;
  ProductData? product;
  @override
  void initState() {
    StoreService.getProductById(widget.productId)
        .then((value) => product = value)
        .then((value) {
      if (mounted) setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isBidding = product?.type == 'Bidding';
    if (isBidding) quantity = 1;
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          appBar: appBarWidget(
            "",
            textColor: context.primaryColor,
            textSize: APP_BAR_TEXT_SIZE,
            color: context.scaffoldBackgroundColor,
            systemUiOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness:
                    appStore.isDarkMode ? Brightness.light : Brightness.light,
                statusBarColor: context.scaffoldBackgroundColor),
            showBack: Navigator.canPop(context),
            backWidget: BackWidget(
              iconColor: context.primaryColor,
            ),
            actions: [
              ValueListenableBuilder(
                  valueListenable: WishListProvider().wishList,
                  builder: (context, value, _) {
                    final isFav = value
                        .map(
                          (e) => e.productId ?? -1,
                        )
                        .contains(int.tryParse(widget.productId));
                    return IconButton(
                      onPressed: () async {
                        appStore.setLoading(true);
                        await StoreService.toogleItem(
                            int.parse(widget.productId));
                        appStore.setLoading(false);
                      },
                      icon: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        color: isFav ? Colors.pink : grey,
                        size: 24,
                      ),
                    );
                  }),
              IconButton(
                onPressed: () async {
                  appStore.setLoading(true);
                  await Share.share(
                      buildBaseUrl('product?product_id=${product?.id}')
                          .toString());
                  appStore.setLoading(false);
                },
                icon: Icon(
                  Icons.share_outlined,
                  color: grey,
                  size: 24,
                ),
              )
            ],
          ),
          body: product == null
              ? SizedBox()
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(16.0),
                      children: [
                        ImageSlider(
                            sliderList: product?.productImages
                                    ?.map((e) => e.images!)
                                    ?.toList() ??
                                [],
                            height: 257),
                        16.height,
                        Text(
                          product?.title ?? '',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        14.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  language.lblPrice,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text:
                                          "${product!.price.validate().formatNumberWithComma()}${isCurrencyPositionRight ? appStore.currencySymbol : ''}",
                                    ),
                                  ]),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  language.lblRating,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: Colors.yellow.shade700,
                                    )),
                                    TextSpan(
                                      text: '3.4',
                                    ),
                                  ]),
                                  style: TextStyle(
                                      color: gray,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            isBidding
                                ? SizedBox()
                                : product?.quantity == '1'
                                    ? SizedBox()
                                    : Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.amber.shade50,
                                        ),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (quantity >= 1) {
                                                  quantity--;
                                                  setState(() {});
                                                }
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(500),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: white,
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            12.width,
                                            Text(
                                              quantity.toString(),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 24,
                                              ),
                                            ),
                                            12.width,
                                            InkWell(
                                              onTap: () {
                                                if (quantity <
                                                    int.parse(
                                                        product?.quantity ??
                                                            '0')) {
                                                  quantity++;
                                                  setState(() {});
                                                }
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(500),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.add,
                                                  color: white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                          ],
                        ),
                        14.height,

                        Text(
                          language.lblDescription,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        10.height,
                        Linkify(
                          onOpen: (link) async {
                            if (!await launchUrl(Uri.parse(link.url))) {
                              throw Exception('Could not launch ${link.url}');
                            }
                          },
                          text: product?.description ?? '',
                          style: TextStyle(
                            color: gray,
                            fontSize: 14,
                          ),
                          linkStyle: TextStyle(color: blueColor),
                        ),

                        14.height,
                        Text(
                          language.lblAboutProvider,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        16.height,
                        // product?.user != null
                        //     ? UserInfoWidget(
                        //         data: product!.user!,
                        //       )
                        //     : SizedBox(),
                        if (product?.user != null)
                          ListTile(
                            onTap: () {
                              ProviderInfoScreen(providerId: product?.user!.id)
                                  .launch(context);
                            },
                            trailing: Container(
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
                                if (product?.user?.contactNumber
                                        .validate()
                                        .contains('+') ??
                                    false) {
                                  phoneNumber =
                                      "${product!.user!.contactNumber.validate().replaceAll('-', '')}";
                                } else {
                                  phoneNumber =
                                      "+${product!.user!.contactNumber.validate().replaceAll('-', '')}";
                                }
                                launchUrl(
                                    Uri.parse(
                                        '${getSocialMediaLink(LinkProvider.WHATSAPP)}$phoneNumber'),
                                    mode: LaunchMode.externalApplication);
                              }),
                            ),
                            tileColor: gray.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                            leading: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    colorFilter:
                                        product?.user?.profileImage != null
                                            ? null
                                            : ColorFilter.mode(
                                                primaryColor, BlendMode.dstIn),
                                    image: product?.user?.profileImage != null
                                        ? CachedNetworkImageProvider(
                                            product!.user!.profileImage!)
                                        : AssetImage(ic_profile2)
                                            as ImageProvider),
                                shape: BoxShape.circle,
                                // color: context.primaryColor,
                              ),
                            ),
                            title: Text(
                              product?.user?.displayName ?? '',
                              style: primaryTextStyle(),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DisabledRatingBarWidget(
                                  rating: product?.user?.providersServiceRating
                                          .validate() ??
                                      0,
                                ),
                              ],
                            ),
                            // subtitle: RatingBarWidget(
                            //   onRatingChanged: (_) {},
                            //   rating: product.user?.,
                            //   size: 15,
                            // ),
                          ),

                        8.height,
                        Text(
                          language.lblRelatedProducts,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        16.height,
                        SnapHelperWidget(
                            loadingWidget: ShimmerWidget(
                              height: context.height() * 0.3,
                            ),
                            future: StoreService.getProducts(
                                categoryId: product?.categoryId?.toString()),
                            onSuccess: (paginatedProducts) {
                              final productsList =
                                  paginatedProducts.data?.data ?? [];
                              return GridView.builder(
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
                              );
                            }),
                      ],
                    ),
                    if (product?.productCategory?.orderButton == 'Enable')
                      Observer(builder: (context) {
                        return appStore.userId == product?.id
                            ? SizedBox()
                            : AppButton(
                                text: isBidding
                                    ? language.lblBidOnProduct
                                    : product?.quantity == '1'
                                        ? language.lblBuyNow
                                        : language.addToCart,
                                width: context.width(),
                                margin: EdgeInsets.all(16),
                                color: appStore.isDarkMode
                                    ? primaryColorDark
                                    : primaryColor,
                                textColor: product?.quantity == '1'
                                    ? Colors.white
                                    : quantity < 1
                                        ? Colors.transparent
                                        : isBidding
                                            ? Colors.white
                                            : Colors.white,
                                onTap: isBidding
                                    ? () => _bidOnProduct(product)
                                    : product?.quantity == '1'
                                        ? () async {
                                            final success =
                                                await PlaceOrderScreen(
                                                      orderProducts: [
                                                        OrderProductModel(
                                                            product!.id!
                                                                .toString(),
                                                            product!.price!,
                                                            product!.quantity!)
                                                      ],
                                                    ).launch<bool>(context) ??
                                                    false;
                                            if (success) {
                                              finish(context);
                                            }
                                          }
                                        : quantity < 1
                                            ? null
                                            : isBidding
                                                ? () => _bidOnProduct(product)
                                                : () async {
                                                    if (quantity < 1) return;
                                                    appStore.setLoading(true);
                                                    await StoreService
                                                        .addToCart(
                                                            productId: product!
                                                                .id!
                                                                .toString(),
                                                            status: 'Active',
                                                            quantity: quantity
                                                                .toString(),
                                                            price:
                                                                product!.price!,
                                                            context: context);
                                                    appStore.setLoading(true);
                                                  },
                              );
                      })
                  ],
                ),
        ),
        Observer(
            builder: (context) => LoaderWidget().visible(appStore.isLoading))
      ],
    );
  }

  _bidOnProduct(ProductData? product) async {
    final productId = product?.id?.toString() ?? '';
    final bidPrice = await showDialog<String?>(
      context: context,
      builder: (context) => ConfirmBidDialog(
        productId: productId,
      ),
    );
    final bid = double.tryParse(bidPrice ?? 'nan');
    // && bid >= (double.tryParse(product?.price ?? 'nan') ?? 0)
    if (bid != null) {
      final success = await StoreService.bidOnProduct(
          productId: productId, bidPrice: bid.toString());
      if (success) finish(context);
    }
  }
}

class ConfirmBidDialog extends StatefulWidget {
  const ConfirmBidDialog({
    super.key,
    required this.productId,
  });
  final String productId;

  @override
  State<ConfirmBidDialog> createState() => _ConfirmBidDialogState();
}

class _ConfirmBidDialogState extends State<ConfirmBidDialog> {
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.grey.shade400,
      insetPadding: EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () => context.unFocus(FocusNode()),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    language.lblGiveYourEstimatedPriceHere,
                    style: boldTextStyle(),
                  ),
                ],
              ),
              34.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: AppTextField(
                  controller: controller,
                  decoration: inputDecoration(context),
                  textFieldType: TextFieldType.NUMBER,
                ),
              ),
              22.height,
              AppButton(
                text: language.lblOk,
                width: context.width(),
                margin: EdgeInsets.all(16),
                color: appStore.isDarkMode ? primaryColorDark : primaryColor,
                textColor: Colors.white,
                onTap: () {
                  final text = controller.text;
                  if (text.isEmpty) Navigator.pop(context);
                  Navigator.pop(context, text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
