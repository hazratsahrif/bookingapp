import 'package:booking_system_flutter/component/view_all_label_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/product_module/models/product_category.dart';
import 'package:booking_system_flutter/product_module/screens/choose_product_category_screen.dart';
import 'package:booking_system_flutter/product_module/screens/view_all_products_screen.dart';
import 'package:booking_system_flutter/screens/category/category_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/component/category_widget.dart';
import 'package:booking_system_flutter/screens/dashboard/component/product_category_widget.dart';
import 'package:booking_system_flutter/screens/service/view_all_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductCategoryComponent extends StatefulWidget {
  final List<ProductCategory>? categoryList;

  ProductCategoryComponent({this.categoryList});

  @override
  ProductCategoryComponentState createState() =>
      ProductCategoryComponentState();
}

class ProductCategoryComponentState extends State<ProductCategoryComponent> {
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
    if (widget.categoryList.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: language.category,
          list: widget.categoryList!,
          onTap: () {
            ChooseProductCategoryScreen(
              isChoosing: false,
            ).launch(context);
            // CategoryScreen().launch(context).then((value) {
            //   setStatusBarColor(Colors.transparent);
            // });
          },
        ).paddingSymmetric(horizontal: 16),
        HorizontalList(
          itemCount: widget.categoryList.validate().length,
          padding: EdgeInsets.only(left: 16, right: 16),
          runSpacing: 8,
          spacing: 12,
          itemBuilder: (_, i) {
            final data = widget.categoryList![i];
            return GestureDetector(
              onTap: () {
                ViewAllProductsScreen(
                  category: data,
                ).launch(context);
              },
              child: ProductCategoryWidget(categoryData: data),
            );
          },
        ),
        16.height,
      ],
    );
  }
}
