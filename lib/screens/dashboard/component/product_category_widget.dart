import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/product_module/models/product_category.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductCategoryWidget extends StatelessWidget {
  final ProductCategory categoryData;
  final double? width;
  final bool? isFromCategory;
  final bool isSelected;

  ProductCategoryWidget(
      {required this.categoryData,
      this.width,
      this.isFromCategory,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width() / 4 - 24,
      child: Column(
        children: [
          categoryData.image.validate().endsWith('.svg')
              ? Container(
                  width: CATEGORY_ICON_SIZE,
                  height: CATEGORY_ICON_SIZE,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: SvgPicture.network(
                    categoryData.image.validate(),
                    height: CATEGORY_ICON_SIZE,
                    width: CATEGORY_ICON_SIZE,
                    color:
                        appStore.isDarkMode ? Colors.white : context.cardColor,
                    placeholderBuilder: (context) => PlaceHolderWidget(
                      height: CATEGORY_ICON_SIZE,
                      width: CATEGORY_ICON_SIZE,
                      color: transparentColor,
                    ),
                  ).paddingAll(10),
                )
              : Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: isSelected
                          ? blueColor.withOpacity(0.2)
                          : appStore.isDarkMode
                              ? Colors.white24
                              : context.cardColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: CachedImageWidget(
                    url: categoryData.image.validate(),
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    circle: true,
                    placeHolderImage: '',
                  ),
                ),

          4.height,
          Text(
            '${categoryData.name.validate()}',
            style: primaryTextStyle(size: 12),
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
          // Marquee(
          //   directionMarguee: DirectionMarguee.oneDirection,
          //   child: Text(
          //     '${categoryData.name.validate()}',
          //     style: primaryTextStyle(size: 12),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ProductSubCategoryWidget extends StatelessWidget {
  final SubCategory categoryData;
  final double? width;
  final bool? isFromCategory;
  final bool isSelected;

  ProductSubCategoryWidget(
      {required this.categoryData,
      this.width,
      this.isFromCategory,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width() / 4 - 24,
      child: Column(
        children: [
          categoryData.image.validate().endsWith('.svg')
              ? Container(
                  width: CATEGORY_ICON_SIZE,
                  height: CATEGORY_ICON_SIZE,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: SvgPicture.network(
                    categoryData.image.validate(),
                    height: CATEGORY_ICON_SIZE,
                    width: CATEGORY_ICON_SIZE,
                    color:
                        appStore.isDarkMode ? Colors.white : context.cardColor,
                    placeholderBuilder: (context) => PlaceHolderWidget(
                      height: CATEGORY_ICON_SIZE,
                      width: CATEGORY_ICON_SIZE,
                      color: transparentColor,
                    ),
                  ).paddingAll(10),
                )
              : Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: isSelected
                          ? blueColor.withOpacity(0.2)
                          : appStore.isDarkMode
                              ? Colors.white24
                              : context.cardColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: CachedImageWidget(
                    url: categoryData.image.validate(),
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    circle: true,
                    placeHolderImage: '',
                  ),
                ),

          4.height,
          Text(
            '${categoryData.name.validate()}',
            style: primaryTextStyle(size: 12),
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
          // Marquee(
          //   directionMarguee: DirectionMarguee.oneDirection,
          //   child: Text(
          //     '${categoryData.name.validate()}',
          //     style: primaryTextStyle(size: 12),
          //   ),
          // ),
        ],
      ),
    );
  }
}
