import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/product_module/models/product_category.dart';
import 'package:booking_system_flutter/product_module/screens/view_all_products_screen.dart';
import 'package:booking_system_flutter/product_module/services/store_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/cached_image_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/configs.dart';

class ChooseProductCategoryScreen extends StatefulWidget {
  final bool isChoosing;
  const ChooseProductCategoryScreen({super.key, this.isChoosing = true});

  @override
  State<ChooseProductCategoryScreen> createState() =>
      _ChooseProductCategoryScreenState();
}

class _ChooseProductCategoryScreenState
    extends State<ChooseProductCategoryScreen> {
  ProductCategory? cat;
  SubCategory? subCat;
  @override
  Widget build(BuildContext context) {
    final choosing = widget.isChoosing;
    return AppScaffold(
      appBarTitle:
          !choosing ? language.lblCategory : language.lblChooseCategory,
      showBack: true,
      child: SnapHelperWidget(
        future: StoreService.getProductCategories(),
        errorBuilder: (p0) {
          return Center(
            child: Text(p0),
          );
        },
        onSuccess: (data) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final category = data[index];
              return ExpansionTile(
                onExpansionChanged: (value) {
                  if (!choosing) return;

                  if (category.subCategory?.isEmpty ?? true) {
                    if (cat?.id != category.id) {
                      setState(() {
                        cat = category;
                      });
                    } else {
                      setState(() {
                        cat = null;
                      });
                    }
                  }
                },
                trailing: choosing
                    ? null
                    : TextButton(
                        onPressed: () {
                          ViewAllProductsScreen(
                            category: category,
                          ).launch(context);
                        },
                        child: Text(language.lblViewAll)),
                backgroundColor: cat?.id == category.id
                    ? context.primaryColor.withOpacity(0.1)
                    : null,
                leading: CachedImageWidget(
                  url: category.image.validate(),
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                  circle: true,
                  placeHolderImage: '',
                ),
                title: Text(
                  category.name ?? '',
                  style: TextStyle(
                      color: cat?.id == category.id
                          ? blueColor
                          : appStore.isDarkMode
                              ? white
                              : context.primaryColor),
                ),
                children: [
                  ...category.subCategory?.map(
                        (e) => ListTile(
                          onTap: () {
                            if (!choosing) {
                              ViewAllProductsScreen(
                                category: category,
                                subCategory: e,
                              ).launch(context);
                              return;
                            }
                            setState(() {
                              subCat = e;
                              cat = category;
                            });
                          },
                          selectedColor: blueColor,
                          selected: e.id == subCat?.id,
                          title: Text(
                            e.name ?? '',
                            style: secondaryTextStyle(),
                          ),
                          leading: CachedImageWidget(
                            url: e.image.validate(),
                            fit: BoxFit.cover,
                            width: 30,
                            height: 30,
                            circle: true,
                            placeHolderImage: '',
                          ),
                        ),
                      ) ??
                      [],
                ],
              );
            },
            itemCount: data.length,
          );
        },
      ),
      bottomNavigationBar: !choosing
          ? null
          : AppButton(
              text: language.lblOk,
              width: context.width(),
              margin: EdgeInsets.all(16),
              color: appStore.isDarkMode ? primaryColorDark : primaryColor,
              textColor: Colors.white,
              onTap: () async {
                if (cat != null && subCat != null)
                  finish(context, SelectionCategory(cat!, subCat!));
                else if (cat != null)
                  finish(context, SelectionCategory(cat!, subCat));
                else
                  finish(context);
              },
            ),
    );
  }
}
